module TextRev exposing (..)

import Browser
import Html exposing (Html, Attribute, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (on, keyCode, onInput)
import Json.Decode as Json


-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { content : String, counter : Int }


init : Model
init =
    { content = "", counter = 0 }



-- UPDATE


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


type Msg
    = Change String
    | KeyDown Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        KeyDown key ->
            if key == 8 && model.counter > 0 then
                { model | counter = model.counter - 1 }
            else
                model

        Change newContent ->
            { model | content = newContent, counter = model.counter + 1 }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to be reversed", value model.content, onInput Change, onKeyDown KeyDown ] []
        , div [] [ text (String.reverse model.content) ]
        , div [] [ text (String.fromInt model.counter) ]
        ]
