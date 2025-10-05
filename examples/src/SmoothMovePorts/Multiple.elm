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
    let
        -- Initialize with starting positions to prevent jump to (0,0)
        initialAnimations =
            SmoothMovePorts.init
                |> SmoothMovePorts.setInitialPosition "element-a" 100 100
                |> Tuple.first
                |> SmoothMovePorts.setInitialPosition "element-b" 200 150
                |> Tuple.first
                |> SmoothMovePorts.setInitialPosition "element-c" 150 200
                |> Tuple.first
    in
    ( { animations = initialAnimations
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
                -- All boxes animate to center as a 2x2 grid with proper centering within each quadrant
                -- Mathematical calculation: Container(600×400) → Grid(160×160) centered → 4 quadrants(80×80) → center 50×50 boxes
                containerWidth = 600
                containerHeight = 400
                gridSize = 160  -- Total grid area (2×80px quadrants)
                quadrantSize = 80  -- Each quadrant size
                boxSize = 50
                
                -- Grid top-left position (centered in container)
                gridStartX = (containerWidth - gridSize) // 2   -- (600-160)/2 = 220
                gridStartY = (containerHeight - gridSize) // 2  -- (400-160)/2 = 120
                
                -- Offset to center box within quadrant
                centerOffset = (quadrantSize - boxSize) // 2    -- (80-50)/2 = 15
                
                -- Actual animated box size is 40x40, target outlines are 50x50
                actualBoxSize = 40
                targetBoxSize = 50
                boxCenteringOffset = (targetBoxSize - actualBoxSize) // 4  -- (50-40)/4 = 2.5 ≈ 2
                
                -- Box positions (accounting for size difference between animated boxes and target outlines)
                box1X = gridStartX + centerOffset + boxCenteringOffset                    -- 220 + 15 + 5 = 240
                box1Y = gridStartY + centerOffset + boxCenteringOffset                    -- 120 + 15 + 5 = 140
                box2X = gridStartX + quadrantSize + centerOffset + boxCenteringOffset     -- 220 + 80 + 15 + 5 = 320
                box2Y = gridStartY + centerOffset + boxCenteringOffset                    -- 120 + 15 + 5 = 140
                box3X = gridStartX + centerOffset + boxCenteringOffset                    -- 220 + 15 + 5 = 240
                box3Y = gridStartY + quadrantSize + centerOffset + boxCenteringOffset     -- 120 + 80 + 15 + 5 = 220
                box4X = gridStartX + quadrantSize + centerOffset + boxCenteringOffset     -- 220 + 80 + 15 + 5 = 320
                box4Y = gridStartY + quadrantSize + centerOffset + boxCenteringOffset     -- 120 + 80 + 15 + 5 = 220

                config1 = { axis = SmoothMovePorts.Both, duration = 500, easing = "ease-out" }
                config2 = { axis = SmoothMovePorts.Both, duration = 750, easing = "ease-out" }
                config3 = { axis = SmoothMovePorts.Both, duration = 600, easing = "ease-out" }
                config4 = { axis = SmoothMovePorts.Both, duration = 900, easing = "ease-out" }

                ( animations1, command1 ) = SmoothMovePorts.animateToWithConfig config1 "box1" (toFloat box1X) (toFloat box1Y) model.animations
                ( animations2, command2 ) = SmoothMovePorts.animateToWithConfig config2 "box2" (toFloat box2X) (toFloat box2Y) animations1
                ( animations3, command3 ) = SmoothMovePorts.animateToWithConfig config3 "box3" (toFloat box3X) (toFloat box3Y) animations2
                ( finalAnimations, command4 ) = SmoothMovePorts.animateToWithConfig config4 "box4" (toFloat box4X) (toFloat box4Y) animations3
                
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
            [ -- Center guidelines (temporary for debugging)
              div
                [ style "position" "absolute"
                , style "left" "299px"  -- Vertical center line
                , style "top" "0"
                , style "width" "2px"
                , style "height" "100%"
                , style "background-color" "rgba(255, 0, 0, 0.3)"
                , style "pointer-events" "none"
                ] []
            , div
                [ style "position" "absolute"
                , style "left" "0"
                , style "top" "199px"  -- Horizontal center line
                , style "width" "100%"
                , style "height" "2px"
                , style "background-color" "rgba(255, 0, 0, 0.3)"
                , style "pointer-events" "none"
                ] []
            
            -- Grid target area (where the 2x2 should be centered)
            , div
                [ style "position" "absolute"
                , style "left" "220px"  -- Grid start X
                , style "top" "120px"   -- Grid start Y
                , style "width" "160px" -- Grid total width (50+60+50)
                , style "height" "160px" -- Grid total height (50+60+50)
                , style "border" "2px dashed rgba(0, 0, 255, 0.5)"
                , style "background-color" "rgba(0, 0, 255, 0.1)"
                , style "pointer-events" "none"
                ] []
            
            -- Individual box target positions (centered within each 80x80 quadrant)
            , div
                [ style "position" "absolute"
                , style "left" "235px"  -- box1 target: 220 + (80-50)/2 = 235
                , style "top" "135px"   -- 120 + (80-50)/2 = 135
                , style "width" "50px"
                , style "height" "50px"
                , style "border" "1px solid rgba(255, 0, 0, 0.7)"
                , style "background-color" "rgba(255, 0, 0, 0.1)"
                , style "pointer-events" "none"
                ] []
            , div
                [ style "position" "absolute"
                , style "left" "315px"  -- box2 target: 220 + 80 + (80-50)/2 = 315
                , style "top" "135px"
                , style "width" "50px"
                , style "height" "50px"
                , style "border" "1px solid rgba(0, 255, 0, 0.7)"
                , style "background-color" "rgba(0, 255, 0, 0.1)"
                , style "pointer-events" "none"
                ] []
            , div
                [ style "position" "absolute"
                , style "left" "235px"  -- box3 target: 220 + (80-50)/2 = 235
                , style "top" "215px"   -- 120 + 80 + (80-50)/2 = 215
                , style "width" "50px"
                , style "height" "50px"
                , style "border" "1px solid rgba(0, 0, 255, 0.7)"
                , style "background-color" "rgba(0, 0, 255, 0.1)"
                , style "pointer-events" "none"
                ] []
            , div
                [ style "position" "absolute"
                , style "left" "315px"  -- box4 target: 220 + 80 + (80-50)/2 = 315
                , style "top" "215px"   -- 120 + 80 + (80-50)/2 = 215
                , style "width" "50px"
                , style "height" "50px"
                , style "border" "1px solid rgba(255, 165, 0, 0.7)"
                , style "background-color" "rgba(255, 165, 0, 0.1)"
                , style "pointer-events" "none"
                ] []
            
            -- The actual animated boxes
            , animatedBox "box1" "#FF6B6B" model.animations  -- Red
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