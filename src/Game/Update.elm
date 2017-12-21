module Game.Update exposing (..)

import Time exposing (Time)
import Keyboard.Extra exposing (Key, wasd)
import Game.Model exposing (Model, Player)
import Data.Tile exposing (Tile)
import Data.Position exposing (Position)
import Data.BoundingBox exposing (BoundingBox, boundingBox, anyCollides)
import AnimationFrame


type Msg
    = Msg
    | KeyMsg Keyboard.Extra.Msg
    | Tick Time


maxLoopValue : Float
maxLoopValue =
    60


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg ->
            ( model, Cmd.none )

        KeyMsg keyMsg ->
            ( { model
                | pressedKeys = Keyboard.Extra.update keyMsg model.pressedKeys
              }
            , Cmd.none
            )

        Tick time ->
            ( tick time model, Cmd.none )


tick : Time -> Model -> Model
tick time model =
    let
        nextTime =
            time
                + model.cycleCount
    in
        if nextTime > maxLoopValue then
            { model
                | cycleCount = nextTime - maxLoopValue
                , player = movePlayer model.pressedKeys model.tiles model.player
            }
        else
            { model | cycleCount = nextTime }


joinPosition : Position -> Position -> Position
joinPosition first second =
    { x = second.x + first.x, y = second.y + first.y }


multiplyPosition : Float -> { x : Int, y : Int } -> Position
multiplyPosition n { x, y } =
    { x = toFloat <| round <| n * (toFloat x), y = n * (toFloat y) }


movePlayer : List Key -> List Tile -> Player -> Player
movePlayer keysDown tiles player =
    let
        movement =
            wasd keysDown |> multiplyPosition player.speed

        newPlayer =
            { player
                | position =
                    joinPosition movement player.position
            }
    in
        if canMove newPlayer tiles then
            newPlayer
        else
            player


collidableTiles : List Tile -> List Tile
collidableTiles tiles =
    List.filter (.isCollidable) tiles


boxedTiles : List Tile -> List BoundingBox
boxedTiles tiles =
    List.map (\x -> boundingBox x.size x.position) tiles


canMove : Player -> List Tile -> Bool
canMove player tiles =
    let
        collidingTiles : List BoundingBox
        collidingTiles =
            collidableTiles tiles
                |> boxedTiles

        playerBoundingBox : BoundingBox
        playerBoundingBox =
            boundingBox player.size player.position
    in
        if anyCollides playerBoundingBox collidingTiles then
            False
        else
            True


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyMsg Keyboard.Extra.subscriptions
        , AnimationFrame.diffs Tick
        ]
