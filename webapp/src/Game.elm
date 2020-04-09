module Game exposing (DiscardMode(..), GameState(..), create,  play, start, Game, Player, setDiscard, endTurn)

import Card exposing (Card, value)
import Dict exposing (Dict)
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
    , discardMode : DiscardMode
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
    {player | currentCard = Just card}

type GameState
    = NotStarted
    | Started Game
    | Finished String


map : (Game -> Game) -> GameState -> GameState
map fn gameState =
    case gameState of
        Started a ->
            Started (fn a)

        _ ->
            gameState


play : (Game -> Maybe Player ) -> Int -> Card -> GameState -> GameState
play  endGame playerIndex card gameState =
    case gameState of
        Started game ->
            case endGame game of
                Just p -> 
                    Finished p.name
                Nothing ->  
                    if (Dict.get playerIndex game.players |> Maybe.andThen .currentCard |> Maybe.isNothing) then
                        Started
                            (game
                                |> playCard card
                            )
                        

                    else
                        gameState
        _ ->
            gameState


endTurn : (Game -> Game) -> GameState -> GameState
endTurn fn state = 
    map fn state

  
playCard : Card -> Game -> Game
playCard card game =
    { game | players = game.players |> addCurrentCard game.playerTurn card |> removeCardFromPlayerHand game.playerTurn card }

  


discard : Card -> Game -> Game
discard card game =
    case game.discardMode of
        EachPlayer ->
            { game | players = game.players |> addCardToPlayerDiscard game.playerTurn card |> removeCardFromPlayerHand game.playerTurn card }

        One ->
            { game | discard = card :: game.discard }

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

start : Int ->  GameState -> GameState
start x gameState =
    map (distribute x) gameState

next : Game -> Game
next game =
    if game.playerTurn == (Dict.size game.players - 1) then
        { game | playerTurn = 0 }

    else
        { game | playerTurn = game.playerTurn + 1 }


create : DiscardMode -> List Card -> List String -> GameState
create discardMode cards names =
    Started
        { players = names |> List.indexedMap (\i -> \n -> ( i, { position = i, name = n, hand = [], discard = [] ,  currentCard = Nothing} )) |> Dict.fromList
        , discard = []
        , cards = cards
        , playerTurn = 0
        , discardMode = discardMode
        }
