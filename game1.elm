module Main exposing (Action(..), Model, getPanel, init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Random
import Random.List exposing (..)
import Task
import Time



-- import Time exposing (Time)


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscription }


subscription : Model -> Sub Action
subscription model =
    if model.tick == 0 then
        if model.number == 3 then
            --点击次数等于3时
            Time.every 1000 FoxedTime
            --重置时间

        else
            Sub.none

    else
        Time.every 1000 Tick


type alias Model =
    { -- color:List String,
      targetWord : Words --目标单词，定义列表String类型
    , originalWord : Words --基础单词

    -- 目标单词是否显示
    , tick : Int --记号
    , clickItems : Words
    , number : Int
    , foxedTime : Int
    , fullWord : Words
    }



--定义一个字的类型是String


type alias Word =
    String



--定义列表Words类型


type alias Words =
    List Word


init : () -> ( Model, Cmd Action )
init _ =
    ( { targetWord = [] --目标单词
      , originalWord = [] --被选单词
      , tick = 3000 --目标单词隐藏时间
      , clickItems = []
      , number = 0 --单词点选次数
      , foxedTime = 1000 --多长时间重置
      , fullWord = [] --全部单词
      }
    , Http.get
        { url = "word.txt" --读取文件的路径
        , expect = Http.expectString GotWords
        }
    )



--事件


type Action
    = ChangeColor String Int --给这个事件传个String类型的参数
    | Tick Time.Posix --隐藏时间
    | FoxedTime Time.Posix --刷新时间
    | GotWords (Result Http.Error String) --发起请求，获得本地的txt文件
    | Twenty Words --20个被选单词
    | Three Words --3个目标单词



-- | AdjustTimeZone Time.Zone


update : Action -> Model -> ( Model, Cmd Action )
update msg model =
    case msg of
        ChangeColor word num ->
            if model.number /= 3 then
                --点击次数不等于3时
                ( { model | clickItems = word :: model.clickItems, number = model.number + num }, Cmd.none )

            else
                ( model, Cmd.none )

        --：：表示append
        Tick newtime ->
            ( { model | tick = model.tick - 1000 }, Cmd.none )

        FoxedTime newtime ->
            if model.foxedTime == 0 then
                --刷新时间为0时自动刷新
                init ()

            else
                --更新刷新时间
                ( { model | foxedTime = model.foxedTime - 1000 }, Cmd.none )

        --随机获取单词
        GotWords result ->
            case result of
                Ok fullText ->
                    let
                        fullWords =
                            --调用下面截取“，”获得单词的方法（getWords），然后赋予fullWords
                            getWords fullText
                    in
                    ( { model | fullWord = fullWords }
                    , Random.generate Twenty (Random.List.shuffle fullWords)
                      --随机生成20个
                    )

                Err _ ->
                    ( model, Cmd.none )

        Twenty words ->
            let
                originalWords =
                    List.take 20 words
            in
            ( { model | originalWord = originalWords }, Random.generate Three (Random.List.shuffle originalWords) )

        Three words ->
            ( { model | targetWord = List.take 3 words }, Cmd.none )



--截取“，”获得单词方法


getWords : String -> List String
getWords fullText =
    String.split "," fullText


getPanel : Model -> List (Html Action)
getPanel model =
    --匿名函数
    List.map
        (\x ->
            --\参数 ->返回值表达式 \a -> b
            button
                -- TODO 点击判断
                [ onClick (ChangeColor x 1)
                , style "color"
                    (getColor model x)

                -- , onClick (correct model)
                --调用下面那个方法
                ]
                [ text x ]
        )
        model.originalWord



--另写一个方法：


getColor model x =
    if List.member x model.clickItems then
        if List.member x model.targetWord then
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
        ]



-- TODO 时间
