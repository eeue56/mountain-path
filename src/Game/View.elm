module Game.View exposing (..)

import Html exposing (Html)
import Collage
import Element
import Data.Tile exposing (Tile)
import Game.Model exposing (Player, worldSize)
import Game.Update exposing (Msg)


viewPlayer : Player -> Collage.Form
viewPlayer player =
    Collage.rect (player.size.width) (player.size.height)
        |> Collage.filled player.color
        |> Collage.move ( player.position.x - 1000 + (player.size.width / 2), (player.position.y - 500) + (player.size.height / 2) )


viewTile : Tile -> Collage.Form
viewTile tile =
    Collage.rect tile.size.width tile.size.height
        |> Collage.filled tile.color
        |> Collage.move ( tile.position.x - 1000 + (tile.size.width / 2), (tile.position.y - 500) + (tile.size.height / 2) )


viewWorld : List Tile -> List Collage.Form
viewWorld tiles =
    List.map viewTile tiles


view : Game.Model.Model -> Html.Html Msg
view model =
    [ viewWorld model.tiles
    , [ viewPlayer model.player ]
    ]
        |> List.concat
        |> Collage.collage (round worldSize.width) (round worldSize.height)
        |> Element.toHtml
