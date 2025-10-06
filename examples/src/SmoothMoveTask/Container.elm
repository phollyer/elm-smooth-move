module SmoothMoveTask.Container exposing (main)

import Browser exposing (Document)
import Browser.Dom as Dom
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import SmoothMoveTask exposing (containerElement, defaultConfig, animateToWithConfig)
import Task exposing (Task)


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { foo = "bar" }, Cmd.none )


type alias Model =
    { foo : String }


type Msg
    = NoOp
    | SmoothScroll String String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SmoothScroll containerId targetId ->
            ( model
            , containerElement containerId targetId
                |> Cmd.map (always NoOp)
            )


view : Model -> Document Msg
view model =
    { title = "SmoothMoveTask Container Example"
    , body =
        [ a [ href "index.html", style "position" "fixed", style "top" "10px", style "left" "10px", style "background" "#666", style "color" "white", style "padding" "10px 15px", style "text-decoration" "none", style "border-radius" "5px", style "font-size" "14px", style "z-index" "1000" ] [ text "← Back" ]
        , div (style "padding-top" "60px" :: topBarStyles)
            [ button [ onClick (SmoothScroll "left-half" "anchor-left-100") ] [ text "100" ]
            , button [ onClick (SmoothScroll "left-half" "anchor-left-25") ] [ text "25" ]
            , button [ onClick (SmoothScroll "left-half" "anchor-left-1") ] [ text "1" ]
            ]
        , div []
            [ button [ onClick (SmoothScroll "right-half" "anchor-right-100") ] [ text "100" ]
            , button [ onClick (SmoothScroll "right-half" "anchor-right-25") ] [ text "25" ]
            , button [ onClick (SmoothScroll "right-half" "anchor-right-1") ] [ text "1" ]
            ]
        , div rowStyles
            [ div ([ id "left-half", style "background" "cornflowerblue" ] ++ columnStyles)
                [ ul []
                    (List.range 1 100 |> List.map (anchorView "left"))
                ]
            , div ([ id "right-half", style "background" "wheat" ] ++ columnStyles)
                [ ul []
                    (List.range 1 100 |> List.map (anchorView "right"))
                ]
            ]
        ]
    }


anchorView side num =
    li [ String.fromInt num |> String.append ("anchor-" ++ side ++ "-") |> id ]
        [ text <| String.fromInt num ]


topBarStyles =
    [ style "position" "fixed", style "top" "0", style "height" "40px", style "left" "0", style "right" "0", style "display" "flex", style "justify-content" "space-around" ]


rowStyles =
    [ style "font-size" "18px", style "font-family" "sans-serif", style "position" "fixed", style "top" "40px", style "bottom" "0", style "left" "0", style "right" "0", style "display" "flex" ]


columnStyles =
    [ style "flex-grow" "1", style "overflow-y" "scroll", style "border" "1px solid #ccc" ]
