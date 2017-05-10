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


isOutside : BoundingBox -> BoundingBox -> Bool
isOutside playerBox otherBox =
    ((playerBox.startX > otherBox.endX)
        -- ends before the player
        ||
            (playerBox.endX < otherBox.startX)
        -- starts after the player
        ||
            (playerBox.startY > otherBox.endY)
        -- ends before the player
        ||
            (playerBox.endY < otherBox.startY)
     -- starts after the player
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
