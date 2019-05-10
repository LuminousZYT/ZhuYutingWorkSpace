module Hello exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Encode as Encode


step : String -> Attribute msg
step name =
    attribute "step" name


intro : String -> Attribute msg
intro name =
    attribute "intro" name


position : String -> Attribute msg
position name =
    attribute "position" name


main : Html.Html msg
main =
    div
        []
        [ div
            [ step "1", intro "<div class='step1'><div class='title'>Welcome to the onboarding</div><p class='title_detail'>CodinGame lets you improve your coding skills with games. It all starts in the IDE, where you will code and test new ideas.</p></div>", position "right" ]
            [ text "123fasfgd" ]
        , div
            [ step "2", intro "<div class='step2'><div class='title'>Welcome to the onboarding</div><p class='title_detail'>CodinGame lets you improve your coding skills with games. It all starts in the IDE, where you will code and test new ideas.</p></div>", position "middle" ]
            [ text "jhkjhkjhk" ]
        , div
            [ step "3", intro "<div class='step3'><div class='title'>Welcome to the onboarding</div><p class='title_detail'>CodinGame lets you improve your coding skills with games. It all starts in the IDE, where you will code and test new ideas.</p></div>", position "middle" ]
            [ text "ututrrt" ]
        ]
