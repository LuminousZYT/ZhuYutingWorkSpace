module Main exposing (ButtonModel, Contrast, Msg(..), TextList, duibi, init, main, transitionListHtml, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias TextList =
    List String


type alias Contrast =
    String



--Model


type alias ButtonModel =
    { buttonText : TextList
    , buttonStatus : String
    , contrast : Contrast
    }


init : ButtonModel
init =
    { buttonText = [ "hello", "word", "insetall", "command", "pat", "cat" ], buttonStatus = "black", contrast = "hello" }



--UPDATE


type Msg
    = Transition
    | UnTransition


update : Msg -> ButtonModel -> ButtonModel
update msg buttonModel =
    case msg of
        Transition ->
            if duibi buttonModel.buttonText buttonModel.contrast then
                { buttonModel | buttonStatus = "green" }

            else
                { buttonModel | buttonStatus = "red" }

        UnTransition ->
            { buttonModel | buttonStatus = "black" }


view : ButtonModel -> Html Msg
view buttonModel =
    div []
        [ button [ onClick UnTransition ] [ text "还原" ]
        , div [] (transitionListHtml buttonModel.buttonText Transition buttonModel)
        , div [] [ text buttonModel.contrast ]
        ]



--为update服务用TextList中的元素对比Contranst只要有一个正确就返回True


duibi : TextList -> Contrast -> Bool
duibi textList contrast =
    case textList of
        [] ->
            False

        head :: tail ->
            head == contrast || duibi tail contrast



--把TextList中的各个String元素转换成List (Html Msg )


transitionListHtml : TextList -> Msg -> ButtonModel -> List (Html Msg)
transitionListHtml textList msg buttonModel =
    List.map
        (\x ->
            button
                [ onClick Transition
                , if List.isEmpty buttonModel.buttonText then
                    style "color" "black"

                  else
                    style "color" buttonModel.buttonStatus
                ]
                [ text x ]
        )
        textList



--choose : List (Html Msg) ->
