module Main exposing (Action(..), Model, getPanel, init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



--main


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { -- color:List String,
      targetWord : List String
    , originalWord : List String
    , flag : Bool
    }


init : Model
init =
    { targetWord = [ "hello", "elm", "world" ]
    , originalWord = [ "hello", "elm", "hellot", "hellot", "world", "hellot", "hellot", "hellot", "hellot", "hellot", "hellot", "hellot", "hellot", "hellot", "hellot", "hellot", "hellot", "hellot", "hellot", "hellot" ]
    , flag = False
    }



-- update


type Action
    = ChangeColor


update : Action -> Model -> Model
update action model =
    case action of
        ChangeColor ->
            if model.flag then
                { model | flag = False }

            else
                { model | flag = True }


getPanel : Model -> List (Html Action)
getPanel model =
    List.map
        (\x ->
            div
                (if model.flag then
                    if List.member x model.targetWord then
                        [ style "color" "green" ]

                    else
                        [ style "color" "red" ]

                 else
                    [ style "color" "black" ]
                )
                [ text x ]
        )
        model.originalWord


getPanel_ : Model -> List (Html Action)
getPanel_ model =
    List.map (\x -> div [] [ text x ]) model.targetWord


view : Model -> Html Action
view model =
    div []
        [ --left side
          div [] (getPanel_ model)
        , button [ onClick ChangeColor ] [ text "开始/重置" ]
        , --right side
          div [] (getPanel model)
        ]
