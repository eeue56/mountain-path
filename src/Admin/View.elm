module Admin.View exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Collage
import Element
import Admin.Model exposing (Player, worldSize)
import Data.Tile exposing (Tile)
import Admin.Update exposing (Msg(..))


viewPlayer : Float -> Player -> Collage.Form
viewPlayer scale player =
    let
        width =
            scale * player.size.width

        height =
            (scale * player.size.height)
    in
        Collage.rect width height
            |> Collage.filled player.color
            |> Collage.move ( player.position.x - (worldSize.width / 2) + (width / 2), (player.position.y - (worldSize.height / 2)) + (height / 2) )


viewTile : Float -> Tile -> Collage.Form
viewTile scale tile =
    let
        width =
            scale * tile.size.width

        height =
            (scale * tile.size.height)
    in
        Collage.rect width height
            |> Collage.filled tile.color
            |> Collage.move ( tile.position.x - (worldSize.width / 2) + (width / 2), (tile.position.y - (worldSize.height / 2)) + (height / 2) )


viewOutline : Float -> Tile -> Collage.Form
viewOutline scale tile =
    let
        worldXAdjustment =
            (worldSize.width / 2)

        worldYAdjustment =
            (worldSize.height / 2)

        width =
            scale * tile.size.width

        height =
            (scale * tile.size.height)
    in
        Collage.path
            [ ( tile.position.x - worldXAdjustment, tile.position.y - worldYAdjustment )
            , ( tile.position.x + width - worldXAdjustment, tile.position.y - worldYAdjustment )
            , ( tile.position.x + width - worldXAdjustment, tile.position.y + height - worldYAdjustment )
            , ( tile.position.x - worldXAdjustment, tile.position.y + height - worldYAdjustment )
            , ( tile.position.x - worldXAdjustment, tile.position.y - worldYAdjustment )
            ]
            |> Collage.traced (Collage.dashed tile.color)


viewWorld : Float -> List Tile -> List Collage.Form
viewWorld scale tiles =
    List.map (viewTile scale) tiles


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


viewScalePicker : Float -> Html.Html Msg
viewScalePicker scale =
    Html.div
        []
        [ Html.button [ Html.Events.onClick IncreaseScale ] [ Html.text "Zoom in" ]
        , Html.button [ Html.Events.onClick DecreaseScale ] [ Html.text "Zoom out" ]
        ]


viewSizePicker : Html.Html Msg
viewSizePicker =
    Html.div
        []
        [ Html.button [ Html.Events.onClick IncreaseSize ] [ Html.text "Make square bigger" ]
        , Html.button [ Html.Events.onClick DecreaseSize ] [ Html.text "Make square smaller" ]
        ]


viewSaveButton : Html.Html Msg
viewSaveButton =
    Html.div
        []
        [ Html.button [ Html.Events.onClick Save ] [ Html.text "Save your player" ]
        ]


view : Admin.Model.Model -> Html.Html Msg
view model =
    [ viewWorld model.scale model.tiles
    , [ viewPlayer model.scale model.player, viewOutline model.scale model.outline ]
    ]
        |> List.concat
        |> Collage.collage (round worldSize.width) (round worldSize.height)
        |> Element.toHtml
        |> (\x -> Html.div [] [ viewColorPicker, viewScalePicker model.scale, viewSizePicker, viewSaveButton, x ])
