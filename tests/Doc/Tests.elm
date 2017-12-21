module Doc.Tests exposing (..)

import Test exposing (..)
import Expect
import Doc.Data.BoundingBoxSpec


all : Test
all =
    describe "DocTests"
    [

        Doc.Data.BoundingBoxSpec.spec    ]