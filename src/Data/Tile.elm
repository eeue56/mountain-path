module Data.Tile exposing (..)

import Color
import Data.Position exposing (Position)
import Data.Size exposing (Size)


type alias Tile =
    { color : Color.Color
    , position : Position
    , size : Size
    , isCollidable : Bool
    }
