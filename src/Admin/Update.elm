module Admin.Update exposing (..)

import Time exposing (Time)
import Keyboard.Extra exposing (Key, wasd)
import AnimationFrame
import Color
import LocalStorage
import Admin.Model exposing (Model, Player, SavableField(..))
import Data.Position exposing (Position)
import Data.BoundingBox exposing (BoundingBox, boundingBox, anyCollides, isOutside, isInside)
import Data.Tile exposing (Tile)
import Data.Size as Size


type Msg
    = KeyMsg Keyboard.Extra.Msg
    | Tick Time
    | SetColor Int Int Int Float
    | IncreaseScale
    | DecreaseScale
    | IncreaseSize
    | DecreaseSize
    | Save


maxLoopValue : Float
maxLoopValue =
    60


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyMsg keyMsg ->
            ( { model
                | pressedKeys = Keyboard.Extra.update keyMsg model.pressedKeys
              }
            , Cmd.none
            )

        Tick time ->
            ( tick time model, Cmd.none )

        SetColor r g b a ->
            let
                newColor =
                    Color.rgba r g b a

                player =
                    model.player
            in
                ( { model
                    | currentColor = newColor
                    , player = { player | color = newColor }
                  }
                , Cmd.none
                )

        DecreaseScale ->
            ( { model | scale = model.scale - 1.0 }, Cmd.none )

        IncreaseScale ->
            ( { model | scale = model.scale + 1.0 }, Cmd.none )

        DecreaseSize ->
            ( { model | player = resizePlayer (-1.0) model.player }, Cmd.none )

        IncreaseSize ->
            ( { model | player = resizePlayer (1.0) model.player }, Cmd.none )

        Save ->
            ( { model | tileSaveState = Saving }, Cmd.none )


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
                , tiles =
                    if List.member Keyboard.Extra.Space model.pressedKeys then
                        addTile model.currentColor model.player model.outline model.tiles
                    else
                        model.tiles
            }
        else
            { model | cycleCount = nextTime }


addTile : Color.Color -> Player -> Tile -> List Tile -> List Tile
addTile color player outline tiles =
    if canPlace player outline then
        tiles
            ++ [ { color =
                    color
                 , position = player.position
                 , size = player.size
                 , isCollidable = False
                 }
               ]
    else
        tiles


joinPosition : Position -> Position -> Position
joinPosition first second =
    { x = second.x + first.x, y = second.y + first.y }


multiplyPosition : Float -> { x : Int, y : Int } -> Position
multiplyPosition n { x, y } =
    { x = toFloat <| round <| n * (toFloat x), y = toFloat <| round <| n * (toFloat y) }


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


resizePlayer : Float -> Player -> Player
resizePlayer diff player =
    { player | size = Size.resize diff player.size }


collidableTiles : List Tile -> List Tile
collidableTiles tiles =
    List.filter (.isCollidable) tiles


boxedTiles : List Tile -> List BoundingBox
boxedTiles tiles =
    List.map (\x -> boundingBox x.size x.position) tiles


canPlace : Player -> Tile -> Bool
canPlace player outline =
    let
        playerBoundingBox : BoundingBox
        playerBoundingBox =
            boundingBox player.size player.position
    in
        isInside playerBoundingBox (boundingBox outline.size outline.position)


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
