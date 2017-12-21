module Data.BoundingBox exposing (..)

import Data.Position exposing (Position)
import Data.Size exposing (Size)


type alias BoundingBox =
    { startX : Float, startY : Float, endX : Float, endY : Float }


boundingBox : Size -> Position -> BoundingBox
boundingBox size pos =
    { startX = pos.x, startY = pos.y, endX = pos.x + size.width, endY = pos.y + size.height }


doesCollide : BoundingBox -> BoundingBox -> Bool
doesCollide playerBox otherBox =
    not
        ((otherBox.startX + 0.5 > playerBox.endX)
            -- starts after the player
            ||
                (otherBox.endX - 0.5 < playerBox.startX)
            -- ends before the player
            ||
                (otherBox.endY - 0.5 < playerBox.startY)
            -- ends before the player
            ||
                (otherBox.startY + 0.5 > playerBox.endY)
         -- starts before the player
        )


{-|
Two boxes the same place are not outside each other
    >>> isOutside
    ... { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 }
    ... { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 }
    False

One box inside the other is not outside
    >>> isOutside
    ... { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 }
    ... { startX = 0.0, startY = 0.0, endX = 2.0, endY = 5.0 }
    False

One box inside another is not outside
    >>> isOutside
    ... { startX = 0.0, startY = 0.0, endX = 2.0, endY = 5.0 }
    ... { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 }
    False

A box that starts at the corner of another is outside
    >>> isOutside
    ... { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 }
    ... { startX = 5.0, startY = 5.0, endX = 10.0, endY = 10.0 }
    True

A box that ends at the corner of another is outside
    >>> isOutside
    ... { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 }
    ... { startX = -1.0, startY = -1.0, endX = 0.0, endY = 0.0 }
    True

A box that ends at the start of another is outside
    >>> isOutside
    ... { startX = -1.0, startY = -1.0, endX = 0.0, endY = 0.0 }
    ... { startX = 0.0, startY = 0.0, endX = 5.0, endY = 5.0 }
    True

A box that shares the left edge is not outside
    >>> isOutside
    ... { startX = 0.0, startY = 0.0, endX = 10.0, endY = 10.0 }
    ... { startX = 2.0, startY = 2.0, endX = 5.0, endY = 5.0 }
    False


    >>> isOutside
    ... { startX = 175, startY = 195, endX = 200, endY = 220 }
    ... { startX = 200, startY = 200, endX = 250, endY = 250 }
    True

-}
isOutside : BoundingBox -> BoundingBox -> Bool
isOutside playerBox otherBox =
    doesCollide playerBox otherBox
        |> not


{-|

    >>> isInside
    ... { startX = 205, startY = 205, endX = 210, endY = 210 }
    ... { startX = 200, startY = 200, endX = 250, endY = 250 }
    True

    >>> isInside
    ... { startX = 195, startY = 205, endX = 210, endY = 220 }
    ... { startX = 200, startY = 200, endX = 250, endY = 250 }
    False
-}
isInside : BoundingBox -> BoundingBox -> Bool
isInside playerBox otherBox =
    ((playerBox.startX >= otherBox.startX && playerBox.endX <= otherBox.endX)
        && (playerBox.startY >= otherBox.startY && playerBox.endY <= otherBox.endY)
    )


anyOutside : BoundingBox -> List BoundingBox -> Bool
anyOutside playerBox boxes =
    List.filter (isOutside playerBox) boxes
        |> List.isEmpty
        |> not


anyCollides : BoundingBox -> List BoundingBox -> Bool
anyCollides playerBox boxes =
    List.filter (doesCollide playerBox) boxes
        |> List.isEmpty
        |> not
