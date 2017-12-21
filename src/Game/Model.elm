module Game.Model exposing (..)

import Keyboard.Extra exposing (Key)
import Time exposing (Time)
import Color
import Data.Position exposing (Position)
import Data.Size exposing (Size)
import Data.Tile exposing (Tile)


worldSize : Size
worldSize =
    { width = 2000
    , height = 1000
    }


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
    }


defaultPlayer : Player
defaultPlayer =
    { position = { x = 150, y = 500 }
    , speed = 50
    , size = { width = 50, height = 50 }
    , color = Color.red
    }


defaultModel : Model
defaultModel =
    { player = defaultPlayer
    , pressedKeys = []
    , cycleCount = 0
    , tiles = canyon
    }


canyonTile : Float -> Float -> Float -> Float -> Tile
canyonTile x y width height =
    { position = { x = x, y = y }
    , color = Color.brown
    , size = { width = width, height = height }
    , isCollidable = True
    }


grassTile : Float -> Float -> Float -> Float -> Tile
grassTile x y width height =
    { position = { x = x, y = y }
    , color = Color.green
    , size = { width = width, height = height }
    , isCollidable = False
    }


step : Float -> Float -> Float -> List Float
step start end step_ =
    if end <= start then
        []
    else
        start :: (step (start + step_) end step_)


canyon : List Tile
canyon =
    [ canyonTile 0 0 worldSize.width 100
    , grassTile 0 100 worldSize.width 800
    , canyonTile 0 0 100 worldSize.height
    , canyonTile 0 900 worldSize.width 100
    ]
