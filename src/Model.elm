module Model exposing (..)

import Game.Model
import Admin.Model


type Model
    = Game Game.Model.Model
    | Admin Admin.Model.Model
