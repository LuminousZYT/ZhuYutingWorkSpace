module Main exposing (Model, Msg(..), init, main, todoItem, todoList, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



--model


type alias Model =
    { todo : String
    , todos : List String
    }


init : Model
init =
    { todo = ""
    , todos = []
    }



--update


type Msg
    = UpdateTodo String
    | AddTodo
    | RemoveAll
    | RemoveItem String


update : Msg -> Model -> Model
update msg model1 =
    case msg of
        UpdateTodo text ->
            { model1 | todo = text }

        AddTodo ->
            --这里没有懂
            { model1 | todos = model1.todo :: model1.todos }

        RemoveAll ->
            { model1 | todos = [] }

        RemoveItem text ->
            { model1 | todos = List.filter (\x -> x /= text) model1.todos }



--view


todoItem : String -> Html Msg
todoItem todo =
    li [] [ text todo, button [ onClick (RemoveItem todo) ] [ text "X" ] ]


todoList : List String -> Html Msg
todoList todos =
    let
        child =
            List.map todoItem todos
    in
    ul [] child


view : Model -> Html Msg
view model2 =
    div []
        [ input
            [ onInput UpdateTodo
            , value model2.todo
            ]
            []
        , button [ onClick AddTodo ] [ text "Submit" ]
        , button [ onClick RemoveAll ] [ text "Remove All" ]

        -- 这里不懂
        , div [] [ todoList model2.todos ]
        ]
