module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (requiredAt)
import Url.Builder as Url



-- MAIN


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { topic : String
    , url : String
    , title : String
    }


type alias HttpData =
    { url : String
    , title : String
    }


init : () -> ( Model, Cmd Msg )
init stuff =
    ( Model "lebowski" "waiting.gif" "lebowski"
    , getRandomGif "lebowski"
    )



-- UPDATE


type Msg
    = MorePlease
    | SetTopic String
    | NewGif (Result Http.Error HttpData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model
            , getRandomGif model.topic
            )

        SetTopic newTopic ->
            ( { model | topic = newTopic }
            , Cmd.none
            )

        NewGif result ->
            case result of
                Ok newHttpData ->
                    ( { model | url = newHttpData.url, title = newHttpData.title }
                    , Cmd.none
                    )

                Err _ ->
                    ( model
                    , Cmd.none
                    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


view : Model -> Document Msg
view model =
    { title = model.topic
    , body =
        [ div []
            [ h2 [] [ text model.title ]
            , button [ style "margin" "10px 0 10px", onClick MorePlease ] [ text "More Please!" ]
            , br [] []
            , video
                [ src model.url
                , Html.Attributes.attribute "autoplay" "true"
                , Html.Attributes.attribute "loop" "true"
                , Html.Attributes.attribute "controls" "true"
                ]
                []
            , br [] []
            , label [ style "margin" "10px 20px" ] [ text "Topic" ]
            , input [ type_ "text", onInput SetTopic, value model.topic ] []
            ]
        ]
    }



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    Http.send NewGif (Http.get (toGiphyUrl topic) dataDecoder)


toGiphyUrl : String -> String
toGiphyUrl topic =
    Url.crossOrigin "https://api.giphy.com"
        [ "v1", "gifs", "random" ]
        [ Url.string "api_key" "dc6zaTOxFJmzC"
        , Url.string "tag" topic
        ]


dataDecoder : Decode.Decoder HttpData
dataDecoder =
    Decode.succeed HttpData
        |> requiredAt [ "data", "image_mp4_url" ] Decode.string
        |> requiredAt [ "data", "title" ] Decode.string
