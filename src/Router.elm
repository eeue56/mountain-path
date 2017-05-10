module Router exposing (..)

import UrlParser exposing (Parser, (</>), s, int, string, map, oneOf, parseHash)


type Route
    = AdminPage
    | GamePage


route : Parser (Route -> a) a
route =
    oneOf
        [ map AdminPage (s "admin")
        , map GamePage (s "game")
        ]
