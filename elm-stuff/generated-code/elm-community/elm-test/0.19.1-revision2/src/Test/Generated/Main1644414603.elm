module Test.Generated.Main1644414603 exposing (main)

import BattleTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "BattleTest" [BattleTest.suite] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 219046413517763, processes = 16, paths = ["C:\\dev\\card-game\\tests\\BattleTest.elm"]}