module SmoothMoveSub.Basic exposing (main)

{-| 
This example demonstrate        AnimationFrame deltaMs ->
            let
                updatedSmoothMove =
                    SmoothMoveSub.step deltaMs model.smoothMovee fully managed approach - no position tracking needed!

BENEFITS:
- ✅ No need to track AnimationState in your model
- ✅ No need to track element positions in your model  
- ✅ No need to handle animation completion manually
- ✅ No need to pass Position data around in messages
- ✅ Library manages ALL state automatically
- ✅ Simple animateTo and subscriptions calls
- ✅ Get positions with transform when needed

DEVELOPER EXPERIENCE:
- Keep only a SmoothMoveSub.Model in your model
- Call animateTo to begin animations (automatic current position)
- Subscribe with SmoothMoveSub.subscriptions for smooth updates (just deltaMs!)
- Use transform for CSS transforms with getPosition!
- Use getPosition when you need the actual position values
- Library handles everything else automatically!
-}

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import SmoothMoveSub exposing (defaultConfig, transform, isAnimating, getPosition, animateTo, setInitialPosition)


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { smoothMove : SmoothMoveSub.Model
    }


type Msg
    = StartMove Float Float
    | AnimationFrame Float
    | NoOp


init : () -> ( Model, Cmd Msg )
init _ =
    let
        -- Initialize with starting position to prevent jump to (0,0)
        initialSmoothMove =
            SmoothMoveSub.init
                |> setInitialPosition "moving-element" 200 150
    in
    ( { smoothMove = initialSmoothMove }
    , Cmd.none
    )

elementId = "moving-element"

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartMove targetX targetY ->
            let
                newSmoothMove =
                    animateTo elementId targetX targetY model.smoothMove
            in
            ( { model | smoothMove = newSmoothMove }, Cmd.none )

        AnimationFrame deltaMs ->
            let
                newSmoothMove =
                    SmoothMoveSub.step deltaMs model.smoothMove
            in
            ( { model | smoothMove = newSmoothMove }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    SmoothMoveSub.subscriptions model.smoothMove AnimationFrame


view : Model -> Document Msg
view model =
    let
        currentPos =
            getPosition "moving-element" model.smoothMove
                |> Maybe.withDefault { x = 200, y = 150 }
    in
    { title = "SmoothMoveSub Basic Example"
    , body =
        [ a [ href "index.html", style "position" "fixed", style "top" "10px", style "left" "10px", style "background" "#666", style "color" "white", style "padding" "10px 15px", style "text-decoration" "none", style "border-radius" "5px", style "font-size" "14px", style "z-index" "1000" ] [ text "← Back" ]
        , div [ style "position" "relative", style "width" "100vw", style "height" "100vh", style "padding-top" "60px", style "box-sizing" "border-box" ]
            [ div
                [ id "moving-element"
                , style "position" "absolute"
                , style "width" "50px"
                , style "height" "50px"
                , style "background-color" "blue"
                , style "border-radius" "50%"
                , style "transform" (transform currentPos.x currentPos.y)
                , style "transition" "none"
                ]
                [ div [ style "color" "white", style "text-align" "center", style "line-height" "50px", style "font-size" "12px" ]
                    [ text "Element" ]
                ]
            , div [ style "margin" "20px" ]
                [ button [ onClick (StartMove 100 100) ] [ text "Move to (100, 100)" ]
                , button [ onClick (StartMove 300 150) ] [ text "Move to (300, 150)" ]
                , button [ onClick (StartMove 500 300) ] [ text "Move to (500, 300)" ]
                , button [ onClick (StartMove 0 0) ] [ text "Move to (0, 0)" ]
                ]
            , div [ style "margin" "20px" ]
                [ text
                      ("Current position: ("
                          ++ String.fromFloat (toFloat (round (currentPos.x * 10)) / 10)
                          ++ ", "
                          ++ String.fromFloat (toFloat (round (currentPos.y * 10)) / 10)
                          ++ ")"
                      )
                , br [] []
                , text
                    (if isAnimating model.smoothMove then
                        "Animation: Running"

                     else
                        "Animation: Stopped"
                    )
                , br [] []
                , text "Blue circle: Animated element using transform with getPosition"
                ]
            ]
        ]
    }