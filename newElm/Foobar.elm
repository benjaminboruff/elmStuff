module Foobar exposing (..)

import Html exposing (Html, Attribute, text, h1)
import Html.Attributes exposing (style)


myStyle : List (Attribute msg)
myStyle =
    [ style "backgroundColor" "blue"
    , style "color" "red"
    ]


myContent : List (Html msg)
myContent =
    [ text "Yo, Dude!" ]


main : Html msg
main =
    h1 myStyle myContent
