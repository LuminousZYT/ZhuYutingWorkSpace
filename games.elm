module Main exposing (Action(..), Model, getPanel, init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Task
import Time



-- import Time exposing (Time)


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscription }


subscription : Model -> Sub Action
subscription model =
    Time.every 1000 Tick


type alias Model =
    { -- color:List String,
      targetWord : List String --目标单词，定义列表String类型
    , originalWord : OriginalWord --基础单词

    -- 目标单词是否显示
    , tick : Int --记号
    , clickItems : List String
    }


type alias OriginalWord =
    List Words



--定义列表Words类型


type alias Words =
    { index : String --单词索引
    , word : String --单词
    }



-- type clickItems=List


init : () -> ( Model, Cmd Action )
init _ =
    ( { targetWord = [ "plan", "car", "bus" ]
      , originalWord = [ { index = "1", word = "plan" }, { index = "2", word = "cat" }, { index = "3", word = "bus" }, { index = "4", word = "car" }, { index = "5", word = "dog" }, { index = "6", word = "rabbit" } ]
      , tick = 3000
      , clickItems = []
      }
    , Cmd.none
    )



--事件


type Action
    = ChangeColor String --给这个事件传个String类型的参数
    | Tick Time.Posix
    | Reset


update : Action -> Model -> ( Model, Cmd Action )
update msg model =
    case msg of
        ChangeColor word ->
            ( { model | clickItems = word :: model.clickItems }, Cmd.none )

        --：：表示append
        Tick newtime ->
            ( { model | tick = model.tick - 1000 }, Cmd.none )

        Reset ->
            init ()



--基础单词


getPanel : Model -> List (Html Action)
getPanel model =
    --匿名函数
    List.map
        (\x ->
            --\参数 ->返回值表达式 \a -> b
            button
                -- TODO 点击判断
                [ onClick (ChangeColor x.index)
                , style "color"
                    (a model x)

                --调用下面那个方法
                ]
                [ text x.word ]
        )
        model.originalWord



--另写一个方法：


a model x =
    if List.member x.index model.clickItems then
        if List.member x.word model.targetWord then
            "green"

        else
            "red"

    else
        "black"



--left
--目标单词


getPanel_ : Model -> List (Html Action)
getPanel_ model =
    List.map (\x -> button [ class "targetWord" ] [ text x ]) model.targetWord


view : Model -> Html Action
view model =
    div [ class "contain" ]
        [ --left side
          div [ class "left-side" ]
            (if model.tick > 0 then
                getPanel_ model

             else
                []
            )
        , --right side
          div [ class "right-side" ] (getPanel model)
        , button [ onClick Reset ] [ text "Reset(重置)" ]
        ]



-- TODO 时间
