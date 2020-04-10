port module Main exposing (main)

import Browser
import Card exposing (Card(..))
import Dict as Dict
import Game exposing (DiscardMode(..), GameState(..), create, endTurn, play, start)
import Games.Battle as Battle
import Html exposing (Html, br, button, div, img, input, label, li, text, ul, fieldset)
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
    | UpdateGame Encode.Value
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
                    Game.init EachPlayer cards model.playerName model.gameState |> start 26
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
                    model.gameState |> endTurn Battle.endTurn
            in
            ( { model | gameState = m }, sendData (Game.toJson m) )

        UpdateGame encoded ->
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


view : Model -> Html Msg
view model =
    case model.gameState of
        NotStarted ->
            div []
                [ label [] [ text "Your name " ]
                , input [ placeholder "name", onInput SetName ] []
                , button [ onClick Create ] [ text "Start now" ]
                ]

        WaitingForOpponent name ->
            if name == model.playerName then
                div [] [ text " wait for opponent" ]

            else
                div []
                    [ name ++ " wait for opponent " |> text
                    , input [ placeholder "name", onInput SetName ] []
                    , button [ onClick Init ] [ text "Start now" ]
                    ]

        Finished winner ->
            div [] [ "Winner is " ++ winner |> text, button [ onClick Init ] [ text "replay" ] ]

        Started game ->
            div []
                [ Html.node "link" [ Attrs.rel "stylesheet", Attrs.href "style.css" ] []
                , game.playerTurn |> String.fromInt |> text
                , game.players
                    |> Dict.toList
                    |> List.map
                        (\( index, player ) ->
                            div []
                                [ if index == 0 then
                                    fieldset [ disabled <| not <| model.playerIndex == index]
                                        [ div [] [ text player.name ]
                                        , div [ class "board"  ] 
                                            [ let
                                                topCard =
                                                    List.head player.discard
                                              in
                                              li [] [ topCard |> Maybe.map Card.svg |> Maybe.withDefault (text ""), player.hand |> List.length |> String.fromInt |> text ]
                                            , let
                                                topCard =
                                                    List.head player.hand
                                              in
                                              button [ onClick (Play index topCard) ] [ topCard |> Maybe.map Card.top |> Maybe.withDefault (text ""), player.hand |> List.length |> String.fromInt |> text ]
                                            , div [ onClick EndTurn ] [ player.currentCard |> Maybe.map Card.svg |> Maybe.withDefault (text "") ]
                                            ]
                                        ]

                                  else
                                    fieldset [ disabled <| not <| model.playerIndex == index]
                                        [ div [] [ text player.name ]
                                        , div
                                            [ class "board"  ] 
                                            [ div [ onClick EndTurn ] [ player.currentCard |> Maybe.map Card.svg |> Maybe.withDefault (text "") ]
                                            , let
                                                topCard =
                                                    List.head player.hand
                                              in
                                              button [ onClick (Play index topCard) ] [ topCard |> Maybe.map Card.top |> Maybe.withDefault (text ""), player.hand |> List.length |> String.fromInt |> text ]
                                            , let
                                                topCard =
                                                    List.head player.discard
                                              in
                                              li [] [ topCard |> Maybe.map Card.svg |> Maybe.withDefault (text ""), player.hand |> List.length |> String.fromInt |> text ]
                                            ]
                                        ]
                                ]
                        )
                    |> ul [ class "board" ]
                ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ updateGame UpdateGame ]


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
