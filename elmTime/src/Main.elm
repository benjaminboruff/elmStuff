module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Task
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , pause : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0) False
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | Pause


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        Pause ->
            ( { model | pause = not model.pause }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    if not model.pause then
        Time.every 1000 Tick

    else
        Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            if Time.toHour model.zone model.time < 10 then
                "0" ++ String.fromInt (Time.toHour model.zone model.time)

            else
                String.fromInt (Time.toHour model.zone model.time)

        minute =
            if Time.toMinute model.zone model.time < 10 then
                "0" ++ String.fromInt (Time.toMinute model.zone model.time)

            else
                String.fromInt (Time.toMinute model.zone model.time)

        second =
            if Time.toSecond model.zone model.time < 10 then
                "0" ++ String.fromInt (Time.toSecond model.zone model.time)

            else
                String.fromInt (Time.toSecond model.zone model.time)
    in
    div []
        [ h1 []
            [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
        , h1
            []
            [ text (String.fromInt (Time.posixToMillis model.time // 1000)) ]
        , button [ onClick Pause ] [ text "pause" ]
        ]
