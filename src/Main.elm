module Main exposing (..)

import Model exposing (..)
import Update exposing (Msg(..))
import View
import Game.Model
import Game.Update
import Admin.Update
import Admin.Model
import Navigation
import Router exposing (Route(..))
import UrlParser exposing (parseHash)


main : Program Never Model Update.Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = Update.update
        , view = View.view
        , subscriptions = subscriptions
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    case parseHash Router.route location of
        Just AdminPage ->
            ( Admin Admin.Model.defaultModel, Cmd.none )

        Just GamePage ->
            ( Game Game.Model.defaultModel
            , Cmd.none
            )

        Nothing ->
            ( Game Game.Model.defaultModel
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Game gameModel ->
            Game.Update.subscriptions gameModel
                |> Sub.map GameMsg

        Admin adminModel ->
            Admin.Update.subscriptions adminModel
                |> Sub.map AdminMsg
