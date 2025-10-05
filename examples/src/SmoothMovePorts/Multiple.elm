port module SmoothMovePorts.Multiple exposing (main)

import Browser
import Dict
import Html exposing (Html, button, div, h1, h2, text)
import Html.Attributes exposing (style, id)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import SmoothMovePorts


-- PORTS --

port animateElement : String -> Cmd msg
port stopElementAnimation : String -> Cmd msg
port positionUpdates : (Decode.Value -> msg) -> Sub msg


-- MODEL --

type alias Model =
    { animations : SmoothMovePorts.Model
    }


type Msg
    = AnimateToCorners
    | AnimateToCenter
    | AnimateInSequence
    | StopAll
    | PositionUpdateMsg Decode.Value
    | AnimationCompleteMsg Decode.Value


init : () -> ( Model, Cmd Msg )
init _ =
    ( { animations = SmoothMovePorts.init
      }
    , Cmd.none
    )


-- UPDATE --

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimateToCorners ->
            let
                -- Animate multiple boxes to different corners simultaneously
                config1 = { axis = SmoothMovePorts.Both, duration = 800, easing = "ease-in-out" }
                config2 = { axis = SmoothMovePorts.Both, duration = 600, easing = "cubic-bezier(0.68, -0.55, 0.265, 1.55)" }
                config3 = { axis = SmoothMovePorts.Both, duration = 1000, easing = "ease-out" }
                config4 = { axis = SmoothMovePorts.Both, duration = 700, easing = "ease-in-out" }

                ( animations1, command1 ) = SmoothMovePorts.animateToWithConfig config1 "box1" 50 50 model.animations
                ( animations2, command2 ) = SmoothMovePorts.animateToWithConfig config2 "box2" 450 50 animations1
                ( animations3, command3 ) = SmoothMovePorts.animateToWithConfig config3 "box3" 450 350 animations2
                ( finalAnimations, command4 ) = SmoothMovePorts.animateToWithConfig config4 "box4" 50 350 animations3
                
                cmd1 = animateElement (SmoothMovePorts.encodeAnimationCommand command1)
                cmd2 = animateElement (SmoothMovePorts.encodeAnimationCommand command2)
                cmd3 = animateElement (SmoothMovePorts.encodeAnimationCommand command3)
                cmd4 = animateElement (SmoothMovePorts.encodeAnimationCommand command4)
            in
            ( { model | animations = finalAnimations }
            , Cmd.batch [ cmd1, cmd2, cmd3, cmd4 ]
            )

        AnimateToCenter ->
            let
                -- All boxes animate to center with different timings
                centerX = 250
                centerY = 200

                config1 = { axis = SmoothMovePorts.Both, duration = 500, easing = "ease-out" }
                config2 = { axis = SmoothMovePorts.Both, duration = 750, easing = "ease-out" }
                config3 = { axis = SmoothMovePorts.Both, duration = 600, easing = "ease-out" }
                config4 = { axis = SmoothMovePorts.Both, duration = 900, easing = "ease-out" }

                ( animations1, command1 ) = SmoothMovePorts.animateToWithConfig config1 "box1" centerX centerY model.animations
                ( animations2, command2 ) = SmoothMovePorts.animateToWithConfig config2 "box2" (centerX + 60) centerY animations1
                ( animations3, command3 ) = SmoothMovePorts.animateToWithConfig config3 "box3" centerX (centerY + 60) animations2
                ( finalAnimations, command4 ) = SmoothMovePorts.animateToWithConfig config4 "box4" (centerX + 60) (centerY + 60) animations3
                
                cmd1 = animateElement (SmoothMovePorts.encodeAnimationCommand command1)
                cmd2 = animateElement (SmoothMovePorts.encodeAnimationCommand command2)
                cmd3 = animateElement (SmoothMovePorts.encodeAnimationCommand command3)
                cmd4 = animateElement (SmoothMovePorts.encodeAnimationCommand command4)
            in
            ( { model | animations = finalAnimations }
            , Cmd.batch [ cmd1, cmd2, cmd3, cmd4 ]
            )

        AnimateInSequence ->
            let
                -- Sequential animation with staggered delays using different durations
                config1 = { axis = SmoothMovePorts.Both, duration = 400, easing = "ease-in-out" }
                config2 = { axis = SmoothMovePorts.Both, duration = 600, easing = "ease-in-out" }
                config3 = { axis = SmoothMovePorts.Both, duration = 800, easing = "ease-in-out" }
                config4 = { axis = SmoothMovePorts.Both, duration = 1000, easing = "ease-in-out" }

                ( animations1, command1 ) = SmoothMovePorts.animateToWithConfig config1 "box1" 100 100 model.animations
                ( animations2, command2 ) = SmoothMovePorts.animateToWithConfig config2 "box2" 200 150 animations1
                ( animations3, command3 ) = SmoothMovePorts.animateToWithConfig config3 "box3" 300 200 animations2
                ( finalAnimations, command4 ) = SmoothMovePorts.animateToWithConfig config4 "box4" 400 250 animations3
                
                cmd1 = animateElement (SmoothMovePorts.encodeAnimationCommand command1)
                cmd2 = animateElement (SmoothMovePorts.encodeAnimationCommand command2)
                cmd3 = animateElement (SmoothMovePorts.encodeAnimationCommand command3)
                cmd4 = animateElement (SmoothMovePorts.encodeAnimationCommand command4)
            in
            ( { model | animations = finalAnimations }
            , Cmd.batch [ cmd1, cmd2, cmd3, cmd4 ]
            )

        StopAll ->
            let
                ( animations1, _ ) = SmoothMovePorts.stopAnimation "box1" model.animations
                ( animations2, _ ) = SmoothMovePorts.stopAnimation "box2" animations1
                ( animations3, _ ) = SmoothMovePorts.stopAnimation "box3" animations2
                ( finalAnimations, _ ) = SmoothMovePorts.stopAnimation "box4" animations3
                
                cmd1 = stopElementAnimation (SmoothMovePorts.encodeStopCommand "box1")
                cmd2 = stopElementAnimation (SmoothMovePorts.encodeStopCommand "box2")
                cmd3 = stopElementAnimation (SmoothMovePorts.encodeStopCommand "box3")
                cmd4 = stopElementAnimation (SmoothMovePorts.encodeStopCommand "box4")
            in
            ( { model | animations = finalAnimations }
            , Cmd.batch [ cmd1, cmd2, cmd3, cmd4 ]
            )

        PositionUpdateMsg _ ->
            -- For simplicity, not handling position updates in this example
            ( model, Cmd.none )

        AnimationCompleteMsg _ ->
            -- For simplicity, not handling animation completion in this example  
            ( model, Cmd.none )


-- SUBSCRIPTIONS --

subscriptions : Model -> Sub Msg
subscriptions _ =
    positionUpdates PositionUpdateMsg


-- VIEW --

view : Model -> Html Msg
view model =
    div
        [ style "padding" "20px"
        , style "font-family" "Arial, sans-serif"
        ]
        [ h1 [] [ text "SmoothMovePorts - Multiple Animations" ]
        , h2 [] [ text "JavaScript Web Animations API Integration" ]
        
        , div
            [ style "margin" "20px 0" ]
            [ button
                [ onClick AnimateToCorners
                , style "margin-right" "10px"
                , style "padding" "10px 15px"
                , style "background-color" "#4CAF50"
                , style "color" "white"
                , style "border" "none"
                , style "border-radius" "4px"
                , style "cursor" "pointer"
                ]
                [ text "Animate to Corners" ]
            
            , button
                [ onClick AnimateToCenter
                , style "margin-right" "10px"
                , style "padding" "10px 15px"
                , style "background-color" "#2196F3"
                , style "color" "white"
                , style "border" "none"
                , style "border-radius" "4px"
                , style "cursor" "pointer"
                ]
                [ text "Animate to Center" ]
            
            , button
                [ onClick AnimateInSequence
                , style "margin-right" "10px"
                , style "padding" "10px 15px"
                , style "background-color" "#FF9800"
                , style "color" "white"
                , style "border" "none"
                , style "border-radius" "4px"
                , style "cursor" "pointer"
                ]
                [ text "Sequential Animation" ]
            
            , button
                [ onClick StopAll
                , style "padding" "10px 15px"
                , style "background-color" "#f44336"
                , style "color" "white"
                , style "border" "none"
                , style "border-radius" "4px"
                , style "cursor" "pointer"
                ]
                [ text "Stop All" ]
            ]
        
        , div
            [ style "position" "relative"
            , style "width" "600px"
            , style "height" "400px"
            , style "border" "2px solid #ddd"
            , style "margin" "20px 0"
            , style "background-color" "#f9f9f9"
            ]
            [ animatedBox "box1" "#FF6B6B" model.animations  -- Red
            , animatedBox "box2" "#4ECDC4" model.animations  -- Teal
            , animatedBox "box3" "#45B7D1" model.animations  -- Blue
            , animatedBox "box4" "#96CEB4" model.animations  -- Green
            ]
        
        , div
            [ style "margin-top" "20px"
            , style "font-size" "14px"
            , style "color" "#666"
            ]
            [ text "This example demonstrates multiple simultaneous animations using the Web Animations API."
            , div [] [ text "• Different easing functions and durations for each element" ]
            , div [] [ text "• Hardware-accelerated performance via JavaScript" ]
            , div [] [ text "• Requires smooth-move-ports.js to be included in your HTML" ]
            ]
        ]


animatedBox : String -> String -> SmoothMovePorts.Model -> Html Msg
animatedBox elementId color animations =
    let
        position = SmoothMovePorts.getPosition elementId animations
        isAnimating = SmoothMovePorts.isAnimating animations
        
        borderStyle = 
            if isAnimating then
                "3px solid #FFD700"  -- Gold border when animating
            else
                "2px solid " ++ color
    in
    div
        [ id elementId
        , style "position" "absolute"
        , style "width" "40px"
        , style "height" "40px"
        , style "background-color" color
        , style "border" borderStyle
        , style "border-radius" "8px"
        , style "display" "flex"
        , style "align-items" "center"
        , style "justify-content" "center"
        , style "color" "white"
        , style "font-weight" "bold"
        , style "font-size" "12px"
        , style "box-shadow" "0 2px 4px rgba(0,0,0,0.2)"
        , style "transform" (SmoothMovePorts.transformElement elementId animations)
        ]
        [ text (String.right 1 elementId) ]  -- Show box number


-- MAIN --

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }