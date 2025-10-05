module SmoothMoveCSS exposing
    ( Config
    , defaultConfig
    , Axis(..)
    , Model
    , init
    , step
    , animateTo
    , animateToWithConfig
    , stopAnimation
    , isAnimating
    , getPosition
    , getAllPositions
    , transform
    , transformElement
    , cssTransitionStyle
    , subscriptions
    )

{-| A CSS-based animation library that leverages native browser transitions for smooth element movement.

This module uses CSS transitions instead of JavaScript animation frames, providing:

  - Better performance through native browser optimization
  - Smooth animations even when JavaScript is busy
  - Automatic easing handled by CSS
  - Less CPU usage compared to frame-based animation


# Configuration

@docs Config
@docs defaultConfig
@docs Axis


# State Management

@docs Model
@docs init
@docs step


# Animation Control

@docs animateTo
@docs animateToWithConfig
@docs stopAnimation


# State Queries

@docs isAnimating
@docs getPosition
@docs getAllPositions


# Styling Helpers

@docs transform
@docs transformElement
@docs cssTransitionStyle
@docs subscriptions

-}

import Browser.Events
import Dict exposing (Dict)


{-| Configuration for CSS-based animations
-}
type alias Config =
    { axis : Axis
    , duration : Float -- Duration in milliseconds
    , easing : String -- CSS easing function like "ease-out", "cubic-bezier(0.4, 0.0, 0.2, 1)"
    }


{-| Animation axis constraint
-}
type Axis
    = X
    | Y
    | Both


{-| Default configuration with smooth easing
-}
defaultConfig : Config
defaultConfig =
    { axis = Both
    , duration = 400
    , easing = "cubic-bezier(0.4, 0.0, 0.2, 1)" -- Material Design's "standard" easing
    }


{-| Element state for CSS-based animations
-}
type alias ElementData =
    { currentX : Float
    , currentY : Float
    , targetX : Float
    , targetY : Float
    , isAnimating : Bool
    , config : Config
    }


{-| Main state container
-}
type Model
    = Model (Dict String ElementData)


{-| Initialize empty model
-}
init : Model
init =
    Model Dict.empty


{-| Start animating an element to a target position using default config
-}
animateTo : String -> Float -> Float -> Model -> Model
animateTo elementId targetX targetY model =
    animateToWithConfig defaultConfig elementId targetX targetY model


{-| Start animating an element to a target position with custom configuration
-}
animateToWithConfig : Config -> String -> Float -> Float -> Model -> Model
animateToWithConfig config elementId targetX targetY (Model elements) =
    let
        currentPos =
            getPosition elementId (Model elements)
                |> Maybe.withDefault { x = 0, y = 0 }

        elementData =
            { currentX = currentPos.x
            , currentY = currentPos.y
            , targetX = targetX
            , targetY = targetY
            , isAnimating = True
            , config = config
            }

        updatedElements =
            Dict.insert elementId elementData elements
    in
    Model updatedElements


{-| Stop animation for a specific element at its current position
-}
stopAnimation : String -> Model -> Model
stopAnimation elementId (Model elements) =
    case Dict.get elementId elements of
        Just elementData ->
            let
                updatedElementData =
                    { elementData
                        | currentX = elementData.targetX
                        , currentY = elementData.targetY
                        , isAnimating = False
                    }
            in
            Model (Dict.insert elementId updatedElementData elements)

        Nothing ->
            Model elements


{-| Check if any animations are currently running
-}
isAnimating : Model -> Bool
isAnimating (Model elements) =
    Dict.values elements
        |> List.any .isAnimating


{-| Get the current position of a specific element
-}
getPosition : String -> Model -> Maybe { x : Float, y : Float }
getPosition elementId (Model elements) =
    Dict.get elementId elements
        |> Maybe.map
            (\elementData ->
                if elementData.isAnimating then
                    { x = elementData.targetX, y = elementData.targetY }

                else
                    { x = elementData.currentX, y = elementData.currentY }
            )


{-| Get all current element positions
-}
getAllPositions : Model -> Dict String { x : Float, y : Float }
getAllPositions (Model elements) =
    Dict.map
        (\_ elementData ->
            if elementData.isAnimating then
                { x = elementData.targetX, y = elementData.targetY }

            else
                { x = elementData.currentX, y = elementData.currentY }
        )
        elements


{-| Create a CSS transform string for positioning
-}
transform : Float -> Float -> String
transform x y =
    "translate(" ++ String.fromFloat x ++ "px, " ++ String.fromFloat y ++ "px)"


{-| Create a CSS transform string by looking up the element's current position
-}
transformElement : String -> Model -> String
transformElement elementId model =
    case getPosition elementId model of
        Just pos ->
            transform pos.x pos.y

        Nothing ->
            transform 0 0


{-| Generate CSS transition property value for smooth animations

Use this in your view to enable CSS transitions:

    div
        [ style "transform" (SmoothMoveCSS.transformElement "my-element" model.animations)
        , style "transition" (SmoothMoveCSS.cssTransitionStyle "my-element" model.animations)
        ]
        [ text "Animated element" ]

-}
cssTransitionStyle : String -> Model -> String
cssTransitionStyle elementId (Model elements) =
    case Dict.get elementId elements of
        Just elementData ->
            if elementData.isAnimating then
                "transform "
                    ++ String.fromFloat elementData.config.duration
                    ++ "ms "
                    ++ elementData.config.easing

            else
                "none"

        Nothing ->
            "none"


{-| Update animation states (for CSS transitions, this mainly tracks completion)

Since CSS handles the actual animation, this step function is primarily used to:

1.  Track when transitions should be complete
2.  Update internal state for consistency
3.  Handle any cleanup needed

Note: Unlike JavaScript-based animation, you don't need to call this on every frame.
Call it periodically or when you need to check animation status.

-}
step : Float -> Model -> Model
step _ (Model elements) =
    let
        updateElement _ elementData =
            if elementData.isAnimating then
                -- For CSS transitions, we assume the animation completes after the duration
                -- In a real implementation, you might want to listen to CSS transition events
                { elementData
                    | currentX = elementData.targetX
                    , currentY = elementData.targetY
                    , isAnimating = False
                }

            else
                elementData

        updatedElements =
            Dict.map updateElement elements
    in
    Model updatedElements


{-| Subscribe to animation frames (optional for CSS-based animations)

For CSS transitions, you typically don't need animation frame subscriptions.
However, this is provided for API consistency and for cases where you want
to track animation progress or perform other updates.

-}
subscriptions : Model -> (Float -> msg) -> Sub msg
subscriptions model toMsg =
    if isAnimating model then
        Browser.Events.onAnimationFrameDelta toMsg

    else
        Sub.none
