module Update exposing (..)

import Game.Update
import Admin.Update
import Model exposing (Model(..))
import Navigation
import Router exposing (Route(..))
import UrlParser exposing (parseHash)


type Msg
    = GameMsg Game.Update.Msg
    | AdminMsg Admin.Update.Msg
    | UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GameMsg gameMsg, Game gameModel ) ->
            let
                ( newModel, newCmd ) =
                    Game.Update.update gameMsg gameModel
            in
                ( Game newModel, Cmd.map GameMsg newCmd )

        ( AdminMsg adminMsg, Admin adminModel ) ->
            let
                ( newModel, newCmd ) =
                    Admin.Update.update adminMsg adminModel
            in
                ( Admin newModel, Cmd.map AdminMsg newCmd )

        ( UrlChange location, _ ) ->
            case parseHash Router.route location of
                Just AdminPage ->
                    ( model, Cmd.none )

                Just GamePage ->
                    ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
