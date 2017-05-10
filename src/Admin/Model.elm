module Admin.Model exposing (..)

import Keyboard.Extra exposing (Key)
import Time exposing (Time)
import Color
import Data.Position exposing (Position)
import Data.Size exposing (Size)


worldSize : Size
worldSize =
    { width = 1000
    , height = 500
    }


type alias Player =
    { position : Position
    , speed : Float
    , size : Size
    , color : Color.Color
    }


type alias Tile =
    { color : Color.Color
    , position : Position
    , size : Size
    , isCollidable : Bool
    }


type alias Model =
    { player : Player
    , pressedKeys : List Key
    , cycleCount : Time
    , tiles : List Tile
    , outline : Tile
    , currentColor : Color.Color
    }


defaultPlayer : Player
defaultPlayer =
    { position = { x = 205, y = 205 }
    , speed = 1
    , size = { width = 5, height = 5 }
    , color = Color.red
    }


defaultModel : Model
defaultModel =
    { player = defaultPlayer
    , pressedKeys = []
    , cycleCount = 0
    , tiles = []
    , outline = { color = Color.black, position = { x = 200, y = 200 }, size = { width = 50, height = 50 }, isCollidable = False }
    , currentColor = Color.red
    }
