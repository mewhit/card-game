module Game exposing (DiscardMode(..), Game, GameState(..), Player, create, endTurn, init,decoder, play, setDiscard, start, toJson)

import Card as Card exposing (Card, value)
import Dict exposing (Dict)
import Json.Decode as Decode
import Json.Encode as Encode
import List.Extra as List
import Maybe.Extra as Maybe
import Random.List exposing (shuffle)


type DiscardMode
    = EachPlayer
    | One


type alias Game =
    { discard : List Card
    , cards : List Card
    , playerTurn : Int
    , players : Dict Int Player
    }


type alias Player =
    { name : String
    , hand : List Card
    , discard : List Card
    , position : Int
    , currentCard : Maybe Card
    }


setName : String -> Player -> Player
setName name player =
    { player | name = name }


setHand : List Card -> Player -> Player
setHand cards player =
    { player | hand = cards }


setDiscard : List Card -> Player -> Player
setDiscard cards player =
    { player | discard = cards }


setCurrentCard : Card -> Player -> Player
setCurrentCard card player =
    { player | currentCard = Just card }


type GameState
    = NotStarted
    | Started Game
    | WaitingForOpponent String
    | Finished String


map : (Game -> Game) -> GameState -> GameState
map fn gameState =
    case gameState of
        Started a ->
            Started (fn a)

        _ ->
            gameState


play : (Game -> Maybe Player) -> Int -> Card -> GameState -> GameState
play endGame playerIndex card gameState =
    case gameState of
        Started game ->
            case endGame game of
                Just p ->
                    Finished p.name

                Nothing ->
                    if Dict.get playerIndex game.players |> Maybe.andThen .currentCard |> Maybe.isNothing then
                        Started
                            (game
                                |> playCard playerIndex card
                            )

                    else
                        gameState

        _ ->
            gameState


endTurn : (Game -> Game) -> GameState -> GameState
endTurn fn state =
    map fn state


playCard : Int -> Card -> Game -> Game
playCard playBy card game =
    { game | players = game.players |> addCurrentCard playBy card |> removeCardFromPlayerHand playBy card }


discard : Card -> Game -> Game
discard card game =
    { game | players = game.players |> addCardToPlayerDiscard game.playerTurn card |> removeCardFromPlayerHand game.playerTurn card }


addCurrentCard : Int -> Card -> Dict Int Player -> Dict Int Player
addCurrentCard id card players =
    Dict.update id (\mPlayer -> mPlayer |> Maybe.map (\player -> player |> setCurrentCard card)) players


addCardToPlayerDiscard : Int -> Card -> Dict Int Player -> Dict Int Player
addCardToPlayerDiscard id card players =
    Dict.update id (\mPlayer -> mPlayer |> Maybe.map (\player -> player |> setDiscard (card :: player.discard))) players


playerCards : Int -> List Card -> Dict Int Player -> Dict Int Player
playerCards id cards players =
    Dict.update id (\mPlayer -> mPlayer |> Maybe.map (\player -> player |> setHand cards)) players


removeCardFromPlayerHand : Int -> Card -> Dict Int Player -> Dict Int Player
removeCardFromPlayerHand id card players =
    Dict.update id (\mPlayer -> mPlayer |> Maybe.map (\player -> player |> setHand (List.remove card player.hand))) players


distribute : Int -> Game -> Game
distribute numberOfCards game =
    let
        ( pCards, rest ) =
            List.splitAt numberOfCards game.cards
    in
    if List.isEmpty rest then
        { game | players = playerCards game.playerTurn pCards game.players, cards = rest }
            |> next

    else
        { game | players = playerCards game.playerTurn pCards game.players, cards = rest }
            |> next
            |> distribute numberOfCards


start : Int -> GameState -> GameState
start x gameState =
    map (distribute x) gameState


next : Game -> Game
next game =
    if game.playerTurn == (Dict.size game.players - 1) then
        { game | playerTurn = 0 }

    else
        { game | playerTurn = game.playerTurn + 1 }


create : String -> GameState
create name =
    WaitingForOpponent name


init : DiscardMode -> List Card -> String -> GameState -> GameState
init discardMode cards name state =
    case state of
        WaitingForOpponent opponentName ->
            Started
                { players = [ opponentName, name ] |> List.indexedMap (\i -> \n -> ( i, { position = i, name = n, hand = [], discard = [], currentCard = Nothing } )) |> Dict.fromList
                , discard = []
                , cards = cards
                , playerTurn = 0
                }

        _ ->
            state


toJson : GameState -> Encode.Value
toJson state =
    case state of
        Finished name ->
            Encode.object [ ( "state", Encode.string "finished" ), ( "winner", Encode.string name ) ]

        Started game ->
            Encode.object
                [ ( "state", Encode.string "started" )
                , ( "game"
                  , Encode.object
                        [ ( "discard", Encode.list Card.encode game.discard )
                        , ( "cards", Encode.list Card.encode game.cards )
                        , ( "playerTurn", Encode.int game.playerTurn )
                        , ( "players"
                          , game.players
                                |> Dict.values
                                |> Encode.list
                                    (\player ->
                                        Encode.object
                                            [ ( "name", Encode.string player.name )
                                            , ( "hand", Encode.list Card.encode player.hand   )
                                            , ( "discard", Encode.list Card.encode player.discard  )
                                            , ( "position", Encode.int player.position )
                                            , ( "currentCard", player.currentCard |> Maybe.map  Card.encode |> Maybe.withDefault Encode.null )
                                            ]
                                    )
                          )
                        ]
                  )
                ]

        WaitingForOpponent name ->
            Encode.object [ ( "state", Encode.string "waitingForOpponent" ), ( "name", Encode.string name ) ]

        NotStarted ->
            Encode.object [ ( "state", Encode.string "notStarted" ) ]


decoder : Decode.Decoder GameState
decoder =
    Decode.field "state" Decode.string
        |> Decode.andThen
            (\s ->
                case s of
                    "started" ->
                        Decode.map Started <|
                            Decode.field "game" <| 
                            Decode.map4 Game
                                (Decode.field "discard" <| Decode.list Card.decoder)
                                (Decode.field "cards" <| Decode.list Card.decoder)
                                (Decode.field "playerTurn" Decode.int)
                                (Decode.field "players" <|
                                    (Decode.list
                                        (Decode.map5 Player
                                            (Decode.field "name" Decode.string)
                                            (Decode.field "hand" <| Decode.list Card.decoder)
                                            (Decode.field "discard" <| Decode.list Card.decoder)
                                            (Decode.field "position" Decode.int)
                                            (Decode.field "currentCard" <| Decode.nullable Card.decoder)
                                        )
                                        |> Decode.map (\players -> List.map (\p -> ( p.position, p )) players  |> Dict.fromList)
                                    )
                                )

                    "waitingForOpponent" ->
                        Decode.map WaitingForOpponent
                            (Decode.field "name" Decode.string)

                    "notStarted" ->
                        Decode.succeed NotStarted

                    "finished" ->
                        Decode.map WaitingForOpponent
                            (Decode.field "winner" Decode.string)

                    _ ->
                        Decode.fail ("Invalide state" ++ s)
            )
