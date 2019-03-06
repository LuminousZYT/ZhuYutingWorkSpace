module Main exposing (Model, main)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random



--Main


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



--Model


type alias Model =
    { dieFace : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1
    , Cmd.none
    )



--Update


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace (Random.int 1 100)
            )

        NewFace newFace ->
            ( Model newFace
            , Cmd.none
            )



--Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--View


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick Roll ] [ text "Role" ]
        ]
