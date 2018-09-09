module Form exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)


-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { name : String
    , age : String
    , password : String
    , passwordAgain : String
    , submitted : Bool
    }


init : Model
init =
    Model "" "" "" "" False



-- UPDATE


type Msg
    = Name String
    | Age String
    | Password String
    | PasswordAgain String
    | Submit
    | ClearSubmit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Age age ->
            { model | age = age }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Submit ->
            { model | submitted = True }

        ClearSubmit ->
            { model | submitted = False }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name ClearSubmit
        , viewInput "text" "Age" model.age Age ClearSubmit
        , viewInput "password" "Password" model.password Password ClearSubmit
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain ClearSubmit
        , div []
            [ button [ onClick Submit ] [ text "submit" ] ]
        , viewValidation model
        ]


viewInput : String -> String -> String -> (String -> msg) -> msg -> Html msg
viewInput t p v toMsg clearSubmit =
    input [ type_ t, placeholder p, value v, onInput toMsg, onClick clearSubmit ] []


viewValidation : Model -> Html msg
viewValidation model =
    if model.submitted then
        if not (String.isEmpty model.age) && not (String.all Char.isDigit model.age) then
            div [ style "color" "red" ] [ text "Age must be a number!" ]
        else if String.isEmpty model.password then
            div [ style "color" "red" ] [ text "Please enter a password!" ]
        else if not (String.length model.password >= 8) then
            div [ style "color" "red" ] [ text "Password must be at least 8 chars!" ]
        else if not (String.any Char.isUpper model.password) then
            div [ style "color" "red" ] [ text "Password must contain an uppercase letter" ]
        else if not (String.any Char.isLower model.password) then
            div [ style "color" "red" ] [ text "Password must contain a lowercase letter" ]
        else if not (String.any Char.isDigit model.password) then
            div [ style "color" "red" ] [ text "Password must contain a number" ]
        else if not (model.password == model.passwordAgain) then
            div [ style "color" "red" ] [ text "Passwords do not match!" ]
        else
            div [ style "color" "green" ] [ text "OK" ]
    else
        div [] []
