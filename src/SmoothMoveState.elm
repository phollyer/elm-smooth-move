module SmoothMoveState exposing
    ( Config
    , defaultConfig
    , Axis(..)
    , State
    , init
    , step
    , subscriptions
    , animateTo
    , animateToWithConfig
    , stopAnimation
    , isAnimating
    , getPosition
    , getAllPositions
    , transform
    , transformElement
    )

{-| A clean state-based animation library for smooth element movement.

This module provides a simplified state-based approach where you manage animation
state explicitly in your model and call `step` on each animation frame.


# Configuration

@docs Config
@docs defaultConfig
@docs Axis


# State Management

@docs State
@docs init
@docs step
@docs subscriptions


# Animation Control

@docs animateTo
@docs animateToWithConfig
@docs stopAnimation


# State Queries

@docs isAnimating
@docs getPosition
@docs getAllPositions


# Styling Helper

@docs transform
@docs transformElement

-}

import Browser.Events
import Dict exposing (Dict)
import Ease


{-| Configuration for animations

  - speed: Animation speed in pixels per second
  - easing: Easing function from elm-community/easing-functions
  - axis: Which axis to animate (X, Y, or Both)

-}
type alias Config =
    { speed : Float
    , easing : Ease.Easing
    , axis : Axis
    }


{-| Animation axis constraint
-}
type Axis
    = X
    | Y
    | Both


{-| Animation state for a single element
-}
type alias Animation =
    { startX : Float
    , startY : Float
    , targetX : Float
    , targetY : Float
    , currentX : Float
    , currentY : Float
    , elapsedTime : Float
    , duration : Float
    , config : Config
    }


type alias ElementData =
    { lastX : Float
    , lastY : Float
    , animation : Maybe Animation
    }


{-| Main state container for all animations
-}
type State
    = State (Dict String ElementData)


{-| Initialize empty animation state

    init : State
    init =
        SmoothMoveState.init

-}
init : State
init =
    State Dict.empty


{-| Default configuration with sensible defaults

    { speed = 400.0 -- 400 pixels per second
    , easing = Ease.outCubic
    , axis = Both
    }

-}
defaultConfig : Config
defaultConfig =
    { speed = 400.0
    , easing = Ease.outCubic
    , axis = Both
    }


{-| Step animations forward by the given time delta (in milliseconds)

Call this function on each animation frame with the time delta.

    type Msg
        = AnimationFrame Float
        | StartAnimation String Float Float

    update : Msg -> Model -> Model
    update msg model =
        case msg of
            AnimationFrame deltaMs ->
                { model | animationState = SmoothMoveState.step deltaMs model.animationState }

            StartAnimation elementId targetX targetY ->
                { model | animationState = SmoothMoveState.animateTo elementId targetX targetY model.animationState }

-}
step : Float -> State -> State
step deltaMs (State elements) =
    let
        updateElementData _ elementData =
            case elementData.animation of
                Nothing ->
                    -- No animation, keep element data as is
                    elementData

                Just animation ->
                    let
                        newElapsedTime =
                            animation.elapsedTime + deltaMs

                        progress =
                            min 1.0 (newElapsedTime / animation.duration)

                        easedProgress =
                            animation.config.easing progress

                        newCurrentX =
                            case animation.config.axis of
                                Y ->
                                    animation.startX

                                _ ->
                                    animation.startX + (animation.targetX - animation.startX) * easedProgress

                        newCurrentY =
                            case animation.config.axis of
                                X ->
                                    animation.startY

                                _ ->
                                    animation.startY + (animation.targetY - animation.startY) * easedProgress

                        updatedAnimation =
                            { animation
                                | elapsedTime = newElapsedTime
                                , currentX = newCurrentX
                                , currentY = newCurrentY
                            }
                    in
                    if isAnimationComplete updatedAnimation then
                        -- Animation complete, store final position and remove animation
                        { elementData
                            | lastX = updatedAnimation.currentX
                            , lastY = updatedAnimation.currentY
                            , animation = Nothing
                        }

                    else
                        -- Animation continues
                        { elementData | animation = Just updatedAnimation }

        updatedElements =
            Dict.map updateElementData elements
    in
    State updatedElements


{-| Check if an animation is complete based on position comparison
-}
isAnimationComplete : Animation -> Bool
isAnimationComplete animation =
    let
        tolerance =
            0.1

        xComplete =
            case animation.config.axis of
                Y ->
                    True

                _ ->
                    abs (animation.currentX - animation.targetX) < tolerance

        yComplete =
            case animation.config.axis of
                X ->
                    True

                _ ->
                    abs (animation.currentY - animation.targetY) < tolerance
    in
    xComplete && yComplete


{-| Start animating an element to a target position using default config

If the element is already animating, it will smoothly transition to the new target.
If the element has no current position, it starts from (0, 0).

    newState =
        SmoothMoveState.animateTo "my-element" 200 300 currentState

-}
animateTo : String -> Float -> Float -> State -> State
animateTo elementId targetX targetY state =
    animateToWithConfig defaultConfig elementId targetX targetY state


{-| Start animating an element to a target position with custom configuration

    config =
        { defaultConfig | speed = 600.0, easing = Ease.outQuint }

    newState =
        SmoothMoveState.animateToWithConfig config "my-element" 100 150 currentState

-}
animateToWithConfig : Config -> String -> Float -> Float -> State -> State
animateToWithConfig config elementId targetX targetY (State elements) =
    let
        currentPos =
            getPosition elementId (State elements)
                |> Maybe.withDefault { x = 0, y = 0 }

        distance =
            case config.axis of
                X ->
                    abs (targetX - currentPos.x)

                Y ->
                    abs (targetY - currentPos.y)

                Both ->
                    sqrt ((targetX - currentPos.x) ^ 2 + (targetY - currentPos.y) ^ 2)

        duration =
            max 100 (distance * 1000 / config.speed)

        animation =
            { startX = currentPos.x
            , startY = currentPos.y
            , targetX = targetX
            , targetY = targetY
            , currentX = currentPos.x
            , currentY = currentPos.y
            , elapsedTime = 0
            , duration = duration
            , config = config
            }

        elementData =
            { lastX = currentPos.x
            , lastY = currentPos.y
            , animation = Just animation
            }

        updatedElements =
            Dict.insert elementId elementData elements
    in
    State updatedElements


{-| Stop animation for a specific element

The element will remain at its current position.

    newState =
        SmoothMoveState.stopAnimation "my-element" currentState

-}
stopAnimation : String -> State -> State
stopAnimation elementId (State elements) =
    case Dict.get elementId elements of
        Just elementData ->
            let
                currentPos =
                    case elementData.animation of
                        Just animation ->
                            { x = animation.currentX, y = animation.currentY }

                        Nothing ->
                            { x = elementData.lastX, y = elementData.lastY }

                updatedElementData =
                    { elementData
                        | lastX = currentPos.x
                        , lastY = currentPos.y
                        , animation = Nothing
                    }
            in
            State (Dict.insert elementId updatedElementData elements)

        Nothing ->
            State elements


{-| Check if any animations are currently running

    if SmoothMoveState.isAnimating state then
        text "Animations running"

    else
        text "All animations complete"

-}
isAnimating : State -> Bool
isAnimating (State elements) =
    Dict.values elements
        |> List.any (\elementData -> elementData.animation /= Nothing)


{-| Get the current position of a specific element

Returns Nothing if the element has never been animated.

    case SmoothMoveState.getPosition "my-element" state of
        Just { x, y } ->
            div [ style "transform" (SmoothMoveState.transform x y) ] [ text "Element" ]

        Nothing ->
            text "Element not found"

-}
getPosition : String -> State -> Maybe { x : Float, y : Float }
getPosition elementId (State elements) =
    Dict.get elementId elements
        |> Maybe.map
            (\elementData ->
                case elementData.animation of
                    Just animation ->
                        { x = animation.currentX, y = animation.currentY }

                    Nothing ->
                        { x = elementData.lastX, y = elementData.lastY }
            )


{-| Get all current element positions

Returns a dictionary mapping element IDs to their current positions.

    positions =
        SmoothMoveState.getAllPositions state

-}
getAllPositions : State -> Dict String { x : Float, y : Float }
getAllPositions (State elements) =
    Dict.map
        (\_ elementData ->
            case elementData.animation of
                Just animation ->
                    { x = animation.currentX, y = animation.currentY }

                Nothing ->
                    { x = elementData.lastX, y = elementData.lastY }
        )
        elements


{-| Subscribe to animation frames when animations are running

This function automatically handles the logic of subscribing to animation frames
only when there are active animations, and unsubscribing when idle.

    subscriptions : Model -> Sub Msg
    subscriptions model =
        SmoothMoveState.subscriptions model.animationState AnimationFrame

-}
subscriptions : State -> (Float -> msg) -> Sub msg
subscriptions state toMsg =
    if isAnimating state then
        Browser.Events.onAnimationFrameDelta toMsg

    else
        Sub.none


{-| Create a CSS transform string for positioning

    div [ style "transform" (SmoothMoveState.transform 100 200) ] [ text "Moving element" ]

-}
transform : Float -> Float -> String
transform x y =
    "translate(" ++ String.fromFloat x ++ "px, " ++ String.fromFloat y ++ "px)"


{-| Create a CSS transform string by looking up the element's current position

This convenience function eliminates the need to manually call getPosition and handle Maybe values.
If the element is not found, it defaults to (0, 0).

    div [ style "transform" (SmoothMoveState.transformElement "my-element" state) ] [ text "Moving element" ]

-}
transformElement : String -> State -> String
transformElement elementId state =
    case getPosition elementId state of
        Just position ->
            transform position.x position.y

        Nothing ->
            transform 0 0
