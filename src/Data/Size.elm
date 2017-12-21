module Data.Size exposing (..)


type alias Size =
    { width : Float
    , height : Float
    }


resize : Float -> Size -> Size
resize diff size =
    { width = size.width + diff
    , height = size.height + diff
    }
