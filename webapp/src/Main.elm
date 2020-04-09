module Main exposing (main)

import Browser
import Card exposing (Card(..))
import Html exposing (Html, br, button, div, li, text, ul, img)
import Html.Attributes as Attrs exposing (class, disabled, src)
import Html.Events exposing (onClick)
import List.Extra as List
import Random as Random
import Dict as Dict
import Random.List exposing (shuffle)
import Game exposing (GameState(..), DiscardMode(..), play, start, create, endTurn)
import Games.Battle as Battle



initialModel : Model
initialModel =
    NotStarted
type alias Model =
    GameState


type Msg
    = Start (List Card)
    | Play Int (Maybe Card)
    | Init 
    | EndTurn 


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Init  ->
            (model, shuffle Battle.battleCard |> Random.generate Start) 

        Start cards -> 
            (create EachPlayer cards ["Mike", "Marye"] |> start 26, Cmd.none)

        Play index card ->
            case card of 
               Just c ->  ( model
                        |> play Battle.endGame index c
                    , Cmd.none
                )
               Nothing -> 
                (model, Cmd.none)

        EndTurn -> 
            (model |> endTurn Battle.endTurn, Cmd.none )


                                        
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
    case model of
        NotStarted ->
            button [ onClick Init ] [ text "Start" ]

        Finished winner ->
            div [] ["Winner is " ++ winner |> text, button [ onClick Init ] [ text "replay" ]]

        Started game ->
            div []
                [ Html.node "link" [ Attrs.rel "stylesheet", Attrs.href "style.css" ] []
                , game.playerTurn |> String.fromInt |> text
                , game.players
                    |> Dict.toList
                    |> List.map
                        (\(index ,player) ->
                                div []
                                    [   
                                        if index == 0 then 
                                            div [ class "board" ] [  
                                                let
                                                    topCard = List.head player.hand
                                                in
                                                    li [ onClick (Play index topCard ) ] [ topCard |> Maybe.map Card.top |> Maybe.withDefault (text ""), player.hand |> List.length |> String.fromInt |> text] 
                                                , div [onClick EndTurn] [player.currentCard |> Maybe.map Card.svg |> Maybe.withDefault (text "") ]
                                                ]
                                           
                                        else 
                                            div [ class "board" ] [  

                           
                                                div [onClick EndTurn] [ player.currentCard |> Maybe.map Card.svg |> Maybe.withDefault (text "") ] 
                                                , 
                                                let
                                                    topCard = List.head player.hand
                                                in
                                                    li [ onClick (Play index topCard ) ] [ topCard |> Maybe.map Card.top |> Maybe.withDefault (text ""), player.hand |> List.length |> String.fromInt |> text] 
                                                ]

                                    ]
                        )
                    |> ul [ class "board" ]
                , case game.discardMode of
                    One ->
                        game.discard |> List.head |> Maybe.map Card.toString |> Maybe.withDefault "" |> text
                    EachPlayer ->
                        text ""
                ]    


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
