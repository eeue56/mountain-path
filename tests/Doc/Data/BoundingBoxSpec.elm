module Doc.Data.BoundingBoxSpec exposing (spec)

import Test
import Expect
import Data.BoundingBox exposing(..)

spec : Test.Test
spec =
    Test.describe "Data.BoundingBox"
        [
        Test.test ">>> isOutside { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 } { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 }" <|
            \() ->
                (isOutside { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 } { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 })
                |> Expect.equal (False),
        Test.test ">>> isOutside { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 } { startX = 0.0, startY = 0.0, endX = 2.0, endY = 5.0 }" <|
            \() ->
                (isOutside { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 } { startX = 0.0, startY = 0.0, endX = 2.0, endY = 5.0 })
                |> Expect.equal (False),
        Test.test ">>> isOutside { startX = 0.0, startY = 0.0, endX = 2.0, endY = 5.0 } { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 }" <|
            \() ->
                (isOutside { startX = 0.0, startY = 0.0, endX = 2.0, endY = 5.0 } { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 })
                |> Expect.equal (False),
        Test.test ">>> isOutside { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 } { startX = 5.0, startY = 5.0, endX = 10.0, endY = 10.0 }" <|
            \() ->
                (isOutside { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 } { startX = 5.0, startY = 5.0, endX = 10.0, endY = 10.0 })
                |> Expect.equal (True),
        Test.test ">>> isOutside { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 } { startX = -1.0, startY = -1.0, endX = 0.0, endY = 0.0 }" <|
            \() ->
                (isOutside { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 } { startX = -1.0, startY = -1.0, endX = 0.0, endY = 0.0 })
                |> Expect.equal (True),
        Test.test ">>> isOutside { startX = -1.0, startY = -1.0, endX = 0.0, endY = 0.0 } { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 }" <|
            \() ->
                (isOutside { startX = -1.0, startY = -1.0, endX = 0.0, endY = 0.0 } { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 })
                |> Expect.equal (True),
        Test.test ">>> isOutside { startX = 0.0, startY = 0.0, endX = 10.0, endY = 10.0 } { startX = 2.0, startY = 2.0, endX = 5.0, endY = 5.0 }" <|
            \() ->
                (isOutside { startX = 0.0, startY = 0.0, endX = 10.0, endY = 10.0 } { startX = 2.0, startY = 2.0, endX = 5.0, endY = 5.0 })
                |> Expect.equal (False),
        Test.test ">>> isOutside { startX = 175, startY = 195, endX = 200, endY = 220 } { startX = 200, startY = 200, endX = 250, endY = 250 }" <|
            \() ->
                (isOutside { startX = 175, startY = 195, endX = 200, endY = 220 } { startX = 200, startY = 200, endX = 250, endY = 250 })
                |> Expect.equal (True),
        Test.test ">>> isInside { startX = 205, startY = 205, endX = 210, endY = 210 } { startX = 200, startY = 200, endX = 250, endY = 250 }" <|
            \() ->
                (isInside { startX = 205, startY = 205, endX = 210, endY = 210 } { startX = 200, startY = 200, endX = 250, endY = 250 })
                |> Expect.equal (True),
        Test.test ">>> isInside { startX = 195, startY = 205, endX = 210, endY = 220 } { startX = 200, startY = 200, endX = 250, endY = 250 }" <|
            \() ->
                (isInside { startX = 195, startY = 205, endX = 210, endY = 220 } { startX = 200, startY = 200, endX = 250, endY = 250 })
                |> Expect.equal (False)
        ]