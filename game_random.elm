module Main exposing (Action(..), Model, getPanel, init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Random
import Random.List exposing (..)
import Task
import Time


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


subscriptions : Model -> Sub Action
subscriptions model =
    if model.tick == 0 then
        if model.number == 3 then
            --点击次数等于3时
            Time.every 1 FoxedTime
            --重置时间

        else
            Sub.none

    else
        Time.every 1 Tick


type alias Model =
    { -- color:List String,
      targetWord : Words --目标单词，定义列表String类型
    , originalWord : Words --基础单词

    -- 目标单词是否显示
    , tick : Float --记号
    , clickItems : Words
    , number : Int
    , foxedTime : Int
    , fullWord : Words
    , start : Bool
    , setTime : Float
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
      , start = True --开始
      , setTime = 0
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
    | Start
    | SetTime String



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
            ( { model | tick = model.tick - 1 }, Cmd.none )

        FoxedTime newtime ->
            if model.foxedTime == 0 then
                --刷新时间为0时自动刷新
                ( { model
                    | targetWord = [] --目标单词
                    , originalWord = [] --被选单词
                    , tick = model.setTime --目标单词隐藏时间
                    , clickItems = []
                    , number = 0 --单词点选次数
                    , foxedTime = 1000 --多长时间重置
                    , fullWord = [] --全部单词
                    , start = False --开始
                  }
                , Http.get
                    { url = "word.txt" --读取文件的路径
                    , expect = Http.expectString GotWords
                    }
                )

            else
                --更新刷新时间
                ( { model | foxedTime = model.foxedTime - 1 }, Cmd.none )

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
                      --shuffle : List a -> Generator (List a)
                    )

                Err _ ->
                    ( model, Cmd.none )

        Twenty words ->
            let
                originalWords =
                    List.take 20 words

                --取words中的前20个
            in
            ( { model | originalWord = originalWords }, Random.generate Three (Random.List.shuffle originalWords) )

        Three words ->
            ( { model | targetWord = List.take 3 words }, Cmd.none )

        Start ->
            ( { model | start = False, tick = model.setTime }, Cmd.none )

        SetTime newTick ->
            ( { model
                | setTime = Maybe.withDefault 100.0 (String.toFloat newTick) * 1000
              }
            , Cmd.none
            )



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
                [ class "chooseButton"
                , onClick (ChangeColor x 1)
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
    --List.member找出列表中是否包含值
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
    if model.start then
        div [ class "contain" ]
            [ input [ placeholder "Please enter the word display time （seconds）", onInput SetTime, class "input-s" ] []
            , button [ onClick Start, class "begin" ] [ text "Play Games" ]
            ]

    else
        div [ class "contain" ]
            [ --left side
              div [ class "left-side" ]
                (if model.tick > 0 then
                    getPanel_ model

                 else
                    []
                )
            , --right side
              if model.tick > 0 then
                div [ class "right-side" ] []

              else
                div [ class "right-side" ] (getPanel model)
            ]



-- TODO 时间
