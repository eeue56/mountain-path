module Admin.Model exposing (..)

import Keyboard.Extra exposing (Key)
import Time exposing (Time)
import Color
import Data.Position exposing (Position)
import Data.Size exposing (Size)
import Data.Tile exposing (Tile)


worldSize : Size
worldSize =
    { width = 1000
    , height = 500
    }


type SavableField
    = Unsaved
    | Saving
    | Saved


type alias Player =
    { position : Position
    , speed : Float
    , size : Size
    , color : Color.Color
    }


type alias Model =
    { player : Player
    , pressedKeys : List Key
    , cycleCount : Time
    , tiles : List Tile
    , tileSaveState : SavableField
    , outline : Tile
    , currentColor : Color.Color
    , scale : Float
    }


defaultPlayer : Player
defaultPlayer =
    { position = { x = 200, y = 200 }
    , speed = 5
    , size = { width = 25, height = 25 }
    , color = Color.red
    }


defaultModel : Model
defaultModel =
    { player = defaultPlayer
    , pressedKeys = []
    , cycleCount = 0
    , tiles = []
    , tileSaveState = Unsaved
    , outline = { color = Color.black, position = { x = 200, y = 200 }, size = { width = 50, height = 50 }, isCollidable = False }
    , currentColor = Color.red
    , scale = 1.0
    }
