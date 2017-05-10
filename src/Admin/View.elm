module Admin.View exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Collage
import Element
import Admin.Model exposing (Player, Tile, worldSize)
import Admin.Update exposing (Msg(..))


viewPlayer : Player -> Collage.Form
viewPlayer player =
    Collage.rect (player.size.width) (player.size.height)
        |> Collage.filled player.color
        |> Collage.move ( player.position.x - (worldSize.width / 2) + (player.size.width / 2), (player.position.y - (worldSize.height / 2)) + (player.size.height / 2) )


viewTile : Tile -> Collage.Form
viewTile tile =
    Collage.rect tile.size.width tile.size.height
        |> Collage.filled tile.color
        |> Collage.move ( tile.position.x - (worldSize.width / 2) + (tile.size.width / 2), (tile.position.y - (worldSize.height / 2)) + (tile.size.height / 2) )


viewOutline : Tile -> Collage.Form
viewOutline tile =
    let
        worldXAdjustment =
            (worldSize.width / 2) + (tile.size.width / 2)

        worldYAdjustment =
            (worldSize.height / 2)
    in
        Collage.path
            [ ( tile.position.x - worldXAdjustment, tile.position.y - worldYAdjustment )
            , ( tile.position.x + tile.size.width - worldXAdjustment, tile.position.y - worldYAdjustment )
            , ( tile.position.x + tile.size.width - worldXAdjustment, tile.position.y + tile.size.height - worldYAdjustment )
            , ( tile.position.x - worldXAdjustment, tile.position.y + tile.size.height - worldYAdjustment )
            , ( tile.position.x - worldXAdjustment, tile.position.y - worldYAdjustment )
            ]
            |> Collage.traced (Collage.dashed tile.color)


viewWorld : List Tile -> List Collage.Form
viewWorld tiles =
    List.map viewTile tiles


viewColorGrid : Int -> Int -> Int -> Float -> Html.Html Msg
viewColorGrid r g b a =
    Html.div
        [ style
            [ ( "backgroundColor", "rgba(" ++ toString r ++ "," ++ toString g ++ ", " ++ toString b ++ "," ++ toString a ++ ")" )
            , ( "height", "50px" )
            , ( "width", "50px" )
            ]
        , onClick (SetColor r g b a)
        ]
        []


viewColorPicker : Html.Html Msg
viewColorPicker =
    Html.div
        []
        [ viewColorGrid 255 0 0 1
        , viewColorGrid 0 255 0 1
        , viewColorGrid 0 0 255 1
        ]


view : Admin.Model.Model -> Html.Html Msg
view model =
    [ viewWorld model.tiles
    , [ viewPlayer model.player, viewOutline model.outline ]
    ]
        |> List.concat
        |> Collage.collage (round worldSize.width) (round worldSize.height)
        |> Element.toHtml
        |> (\x -> Html.div [] [ viewColorPicker, x ])
