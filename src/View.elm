module View exposing (..)

import Html exposing (Html)
import Model exposing (Model(..))
import Update exposing (Msg(..))
import Game.View
import Admin.View


view : Model -> Html.Html Msg
view model =
    case model of
        Game gameModel ->
            Game.View.view gameModel
                |> Html.map GameMsg

        Admin adminModel ->
            Admin.View.view adminModel
                |> Html.map AdminMsg
