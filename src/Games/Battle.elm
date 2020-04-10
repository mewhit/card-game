module Games.Battle exposing (battleCard, endTurn, endGame)

import Card exposing (Card(..))
import Dict exposing (Dict)
import Game exposing (Game, Player)
import List.Extra as List
import Maybe.Extra as Maybe


battleCard : List Card
battleCard =
    [ OneClubs 14
    , TwoClubs 2
    , ThreeClubs 3
    , FourClubs 4
    , FiveClubs 5
    , SixClubs 6
    , SevenClubs 7
    , HeightClubs 8
    , NineClubs 9
    , TenClubs 10
    , ValetClubs 11
    , ReineClubs 12
    , RoiClubs 13
    , OneDiamond 14
    , TwoDiamond 2
    , ThreeDiamond 3
    , FourDiamond 4
    , FiveDiamond 5
    , SixDiamond 6
    , SevenDiamond 7
    , HeightDiamond 8
    , NineDiamond 9
    , TenDiamond 10
    , ValetDiamond 11
    , ReineDiamond 12
    , RoiDiamond 13
    , OneHearts 14
    , TwoHearts 2
    , ThreeHearts 3
    , FourHearts 4
    , FiveHearts 5
    , SixHearts 6
    , SevenHearts 7
    , HeightHearts 8
    , NineHearts 9
    , TenHearts 10
    , ValetHearts 11
    , ReineHearts 12
    , RoiHearts 13
    , OneSpades 14
    , TwoSpades 2
    , ThreeSpades 3
    , FourSpades 4
    , FiveSpades 5
    , SixSpades 6
    , SevenSpades 7
    , HeightSpades 8
    , NineSpades 9
    , TenSpades 10
    , ValetSpades 11
    , ReineSpades 12
    , RoiSpades 13
    ]


endTurn : Game -> Game
endTurn game =
    if game.players |> Dict.values |> List.map .currentCard |> List.all Maybe.isJust then
        let
            ( roundWinner, others ) =
                game.players
                    |> Dict.values
                    |> List.map (\s -> s.currentCard |> Maybe.map (\a -> { lastCard = a, position = s.position }))
                    |> Maybe.values
                    |> List.sortBy (\s -> Card.value s.lastCard)
                    |> List.reverse
                    |> List.splitAt 1

            -- players = List.foldl (\{position , lastCard} -> \dict -> removeFromPlayerDiscard position lastCard dict ) game.players others
            -- _ = Debug.log "othe" players
        in
        case roundWinner |> List.head of
            Just { position, lastCard } ->
                { game
                    | players =
                        game.players
                            |> addCardsToPlayerDiscard position (others  |> List.map .lastCard |> (::) lastCard)
                            |> Dict.map (\_ -> \player -> { player | currentCard = Nothing })
                }
                    |> next

            Nothing ->
                game

    else
        game
next : Game -> Game
next game =
    if game.playerTurn == (Dict.size game.players - 1) then
        { game | playerTurn = 0 }

    else
        { game | playerTurn = game.playerTurn + 1 }


endGame: Game -> Maybe Player
endGame game = 
    let
        isEmpty = \p -> List.isEmpty p.hand && List.isEmpty p.discard && (Maybe.isJust p.currentCard)
    in
    if game.players |> Dict.values |> List.any isEmpty then
        game.players |> Dict.values |> List.filter (\s -> not <|  isEmpty s) |> List.head
    else
        Nothing

removeFromPlayerDiscard : Int -> Card -> Dict Int Player -> Dict Int Player
removeFromPlayerDiscard id card players =
    Dict.update id (\mPlayer -> mPlayer |> Maybe.map (\player -> player |> Game.setDiscard (List.remove card player.discard))) players


addCardsToPlayerDiscard : Int -> List Card -> Dict Int Player -> Dict Int Player
addCardsToPlayerDiscard id cards players =
    Dict.update id (\mPlayer -> mPlayer |> Maybe.map (\player -> player |> Game.setDiscard (cards ++ player.discard))) players
