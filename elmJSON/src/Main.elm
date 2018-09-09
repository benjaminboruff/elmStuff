module Main exposing (Model, Msg(..), dataToggle, incomingData, init, main, modelDecoder, update, view)

import Browser
import Html exposing (Html, button, div, h1, h3, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, decodeString, field, int, string)
import Json.Decode.Pipeline exposing (optional, required)


incomingData : String
incomingData =
    """
        {"age": 49, "name": "Ben"}
    """


modelDecoder : Decoder Model
modelDecoder =
    Decode.succeed Model
        |> required "name" Decode.string
        |> required "age" Decode.int
        |> optional "display" Decode.string "name"


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { name : String
    , age : Int
    , display : String
    }


init : Model
init =
    Result.withDefault (Model "None" 0 "name") (Decode.decodeString modelDecoder incomingData)


type Msg
    = Name
    | Age


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name ->
            { model | display = "name" }

        Age ->
            { model | display = "age" }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Name ] [ text "Name" ]
        , dataToggle model
        , button [ onClick Age ] [ text "Age" ]
        ]


dataToggle : Model -> Html Msg
dataToggle model =
    if model.display == "name" then
        div [ style "min-height" "50px", style "text-align" "center" ]
            [ h1 [ style "color" "blue", style "margin" "auto" ] [ text ("Name: " ++ model.name) ]
            ]

    else
        div [ style "min-height" "50px", style "text-align" "center" ]
            [ h1 [ style "color" "red", style "margin" "auto" ] [ text ("Age: " ++ String.fromInt model.age) ]
            ]
