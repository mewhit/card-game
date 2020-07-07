port module Main exposing (main)

import Browser
import Card exposing (Card(..))
import Dict as Dict
import Game exposing (DiscardMode(..), GameState(..), create, endTurn, play, start, endGame, redistribute)
import Games.Battle as Battle
import Html exposing (Html, br, button, div, fieldset, footer, img, input, label, li, text, ul, p)
import Html.Attributes as Attrs exposing (class, classList, disabled, placeholder, src)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode
import Json.Encode as Encode
import List.Extra as List
import Random as Random
import Random.List exposing (shuffle)


initialModel : Model
initialModel =
    { gameState = NotStarted, playerName = "", playerIndex = 0 }


type alias Model =
    { gameState : GameState
    , playerName : String
    , playerIndex : Int
    }


port sendData : Encode.Value -> Cmd msg


port updateGame : (Encode.Value -> msg) -> Sub msg


type Msg
    = Start (List Card)
    | Play Int (Maybe Card)
    | Create
    | Init
    | SetName String
    | SyncGame Encode.Value
    | EndTurn


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetName name ->
            ( { model | playerName = name }, Cmd.none )

        Create ->
            let
                m =
                    Game.create model.playerName
            in
            ( { model | gameState = m, playerIndex = 0 }, sendData (Game.toJson m) )

        Init ->
            ( model, shuffle Battle.battleCard |> Random.generate Start )

        Start cards ->
            let
                m =
                    Game.init EachPlayer cards model.playerName model.gameState |> start 2
            in
            ( { model | gameState = m, playerIndex = 1 }, sendData (Game.toJson m) )

        Play index card ->
            case card of
                Just c ->
                    let
                        m =
                            model.gameState
                                |> play Battle.endGame index c
                    in
                    ( { model | gameState = m }
                    , sendData (Game.toJson m)
                    )

                Nothing ->
                    ( model, Cmd.none )

        EndTurn ->
            let
                m =
                    model.gameState 
                        |> endTurn Battle.endTurn 
                        |> redistribute Battle.redistribute
                        |> endGame Battle.endGame 
            in
            ( { model | gameState = m }, sendData (Game.toJson m) )

        SyncGame encoded ->
            let
                gameState =
                    Decode.decodeValue Game.decoder encoded
            in
            case gameState of
                Ok v ->
                    ( { model | gameState = v }, Cmd.none )

                Err err ->
                    let
                        _ =
                            Debug.log "error from decode" err
                    in
                    ( model, Cmd.none )



-- -- player.hand
-- -- |> List.map (\s -> li [] [ button [ onClick (Play index s) ] [ Card.svg s ] ])
-- -- |> (::) ( li [] [ player.currentCard |>  Maybe.map Card.svg |> Maybe.withDefault (text "")  ] )
-- -- |> (::) (case game.discardMode of
-- --             EachPlayer ->
-- --
-- --             _ -> li [] []
-- --         )


lobbyForm : String -> (String -> Msg) -> Msg -> Html Msg
lobbyForm labelText setName onCreate =
    div [ class "lobby" ]
        [ div [ class "lobby__form" ]
            [ label [ class "lobby__label" ] [ text labelText ]
            , input [ class "lobby__box", placeholder "Name", onInput setName ] []
            , button [ onClick onCreate ] [ text "Start now" ]
            ]
        ]


view : Model -> Html Msg
view model =
    case model.gameState of
        NotStarted ->
            lobbyForm "Your name " SetName Create

        WaitingForOpponent name ->
            if name == model.playerName then
                div [ class "lobby" ] [ text "Waiting for opponent" ]

            else
                lobbyForm (name ++ " wait for opponent ") SetName Init

        Finished winner ->
            div [ class "game game__winner"] [ p [] ["Winner is " ++ winner |> text], button [ onClick Init ] [ text "Replay" ] ]

        Started game ->
            div [ class "game" ]
                [ Html.node "link" [ Attrs.rel "stylesheet", Attrs.href "style.css" ] []
                , game.players
                    |> Dict.toList
                    |> List.map
                        (\( index, player ) ->
                            [ if index == 0 then
                                let
                                    topCard =
                                        List.head player.hand
                                in
                                fieldset [ class "game__player", disabled <| not <| model.playerIndex == index ]
                                    [ div [] [ text player.name ]
                                    , div [ class "game__hand" ]
                                        [ button [ onClick (Play index topCard) ] [ topCard |> Maybe.map Card.top |> Maybe.withDefault (text "") ]
                                        , div [ onClick EndTurn ] [ player.currentCard |> Maybe.map Card.svg |> Maybe.withDefault (text "") ]
                                        ]
                                    ]

                              else
                                text ""
                            , if index == 1 then
                                let
                                    topCard =
                                        List.head player.hand
                                in
                                fieldset [ class "game__player", disabled <| not <| model.playerIndex == index ]
                                    [ div [] [ text player.name ]
                                    , div [ class "game__hand" ]
                                        [ div [ onClick EndTurn ] [ player.currentCard |> Maybe.map Card.svg |> Maybe.withDefault (text "") ]
                                        , button [ onClick (Play index topCard) ] [ topCard |> Maybe.map Card.top |> Maybe.withDefault (text "") ]
                                        ]
                                    ]

                              else
                                text ""
                            ]
                        )
                    |> List.concat
                    |> ul [ class "game__board" ]
                , let
                    mSelf =
                        Game.player model.playerIndex game
                  in
                  case mSelf of
                    Just self ->
                        footer [ class "game__summary" ]
                            [ p [] [text <| "Your remaining cards: " ++ String.fromInt (List.length self.hand)]
                            , p [] [text <| "In your discards: " ++ String.fromInt (List.length self.discard)]
                            ]

                    Nothing ->
                        text ""
                ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ updateGame SyncGame ]


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
