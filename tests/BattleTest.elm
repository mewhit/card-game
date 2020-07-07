module BattleTest exposing (..)

import Card exposing (Card(..))
import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Game exposing (Game, Player)
import Games.Battle exposing (endGame)
import Test exposing (..)


suite : Test
suite =
    describe "Batte module"
        [ describe "the end game"
            [ test "should be only when one player have no cards" <|
                \() -> endGame game |> Expect.equal (Just winner)
            ]
        ]


game : Game
game =
    { discard = []
    , cards = []
    , playerTurn = 1
    , players = [ ( 0, winner ) , (1, player)] |> Dict.fromList
    }


player : Player
player =
    { name = "p1"
    , hand = [OneClubs 1]
    , discard = []
    , position = 1
    , currentCard =
        Nothing
    }


winner : Player
winner =
    { name = "winner"
    , hand = [  ]
    , discard = []
    , position = 1
    , currentCard =
        Nothing
    }
