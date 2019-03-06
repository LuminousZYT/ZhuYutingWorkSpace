module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    Int



--type alias类型别名


init : Model



--init初始化


init =
    0


type Msg
    = Increment
    | Decrement
    | Reboot


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 10

        Decrement ->
            model - 5

        Reboot ->
            init


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick Reboot ] [ text "重启" ] --重启功能
        ]
