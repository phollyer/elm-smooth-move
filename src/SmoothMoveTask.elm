module SmoothMoveTask exposing
    ( Axis(..)
    , Config
    , animateTo
    , animateToCmd
    , animateToCmdWithConfig
    , animateToTask
    , animateToTaskWithConfig
    , animateToWithConfig
    , containerElement
    , containerElementCmd
    , containerElementCmdWithConfig
    , containerElementTask
    , containerElementTaskWithConfig
    , containerElementWithConfig
    , defaultConfig
    )

import Browser.Dom as Dom
import Ease
import Internal.AnimationSteps as Internal
import Process
import Task exposing (Task)


{-| Configuration for scrolling animations

This module provides both simple Cmd-based functions (recommended for most users)
and advanced Task-based functions (for composition and custom error handling).

  - speed: Animation frames to generate (higher = smoother but more steps)
  - offset: Vertical offset in pixels from the target position
  - easing: Easing function from elm-community/easing-functions
  - axis: Movement axis (Y for scrolling, X for horizontal, Both for diagonal)

-}
type alias Config =
    { speed : Float
    , offset : Float
    , easing : Ease.Easing
    , axis : Axis
    }


type Axis
    = X
    | Y
    | Both


defaultConfig : Config
defaultConfig =
    { speed = 400.0
    , offset = 0
    , easing = Ease.outCubic
    , axis = Y -- Task-based animations are primarily for scrolling (Y-axis)
    }


{-| Simple scrolling to an element. Returns a Cmd that produces no meaningful messages.

    ScrollTo elementId ->
        ( model, animateTo elementId )

-}
animateTo : String -> Cmd ()
animateTo elementId =
    animateToTaskWithConfig defaultConfig elementId
        |> Task.attempt (always ())


{-| Simple scrolling with configuration. Returns a Cmd that produces no meaningful messages.

    ScrollTo elementId ->
        ( model, animateToWithConfig { defaultConfig | offset = 100 } elementId )

-}
animateToWithConfig : Config -> String -> Cmd ()
animateToWithConfig config elementId =
    animateToTaskWithConfig config elementId
        |> Task.attempt (always ())


{-| Cmd-based scrolling with custom completion message.

    ScrollTo elementId ->
        ( model, animateToCmd ScrollComplete elementId )

-}
animateToCmd : msg -> String -> Cmd msg
animateToCmd msg elementId =
    animateToCmdWithConfig msg defaultConfig elementId


{-| Cmd-based scrolling with configuration and custom completion message.

    ScrollTo elementId ->
        ( model, animateToCmdWithConfig ScrollComplete { defaultConfig | offset = 100 } elementId )

-}
animateToCmdWithConfig : msg -> Config -> String -> Cmd msg
animateToCmdWithConfig msg config elementId =
    animateToTaskWithConfig config elementId
        |> Task.attempt (always msg)


{-| Task-based scrolling for advanced users who need error handling or composition.

    ScrollTo elementId ->
        ( model, Task.attempt HandleScrollError (animateToTask elementId) )

-}
animateToTask : String -> Task Dom.Error (List ())
animateToTask elementId =
    animateToTaskWithConfig defaultConfig elementId


{-| Task-based scrolling with configuration for advanced users.

    ScrollTo elementId ->
        ( model, Task.attempt HandleScrollError (animateToTaskWithConfig config elementId) )

-}
animateToTaskWithConfig : Config -> String -> Task Dom.Error (List ())
animateToTaskWithConfig config elementId =
    Task.map2 Tuple.pair Dom.getViewport (Dom.getElement elementId)
        |> Task.andThen
            (\( viewport, element ) ->
                case config.axis of
                    Y ->
                        let
                            targetY =
                                element.element.y + element.element.height / 2 - viewport.viewport.height / 2 + config.offset

                            clampedY =
                                clamp 0 (viewport.scene.height - viewport.viewport.height) targetY

                            steps =
                                Internal.interpolate (round config.speed) config.easing viewport.viewport.y clampedY
                        in
                        animateSteps steps

                    X ->
                        let
                            targetX =
                                element.element.x + element.element.width / 2 - viewport.viewport.width / 2 + config.offset

                            clampedX =
                                clamp 0 (viewport.scene.width - viewport.viewport.width) targetX

                            steps =
                                Internal.interpolate (round config.speed) config.easing viewport.viewport.x clampedX
                        in
                        animateStepsX steps

                    Both ->
                        let
                            targetY =
                                element.element.y + element.element.height / 2 - viewport.viewport.height / 2 + config.offset

                            targetX =
                                element.element.x + element.element.width / 2 - viewport.viewport.width / 2 + config.offset

                            clampedY =
                                clamp 0 (viewport.scene.height - viewport.viewport.height) targetY

                            clampedX =
                                clamp 0 (viewport.scene.width - viewport.viewport.width) targetX

                            stepsY =
                                Internal.interpolate (round config.speed) config.easing viewport.viewport.y clampedY

                            stepsX =
                                Internal.interpolate (round config.speed) config.easing viewport.viewport.x clampedX
                        in
                        animateStepsBoth stepsX stepsY
            )


{-| Simple container scrolling. Returns a Cmd that produces no meaningful messages.

    ScrollInContainer containerId elementId ->
        ( model, containerElement containerId elementId )

-}
containerElement : String -> String -> Cmd ()
containerElement containerId elementId =
    containerElementTaskWithConfig defaultConfig containerId elementId
        |> Task.attempt (always ())


{-| Simple container scrolling with configuration. Returns a Cmd that produces no meaningful messages.

    ScrollInContainer containerId elementId ->
        ( model, containerElementWithConfig config containerId elementId )

-}
containerElementWithConfig : Config -> String -> String -> Cmd ()
containerElementWithConfig config containerId elementId =
    containerElementTaskWithConfig config containerId elementId
        |> Task.attempt (always ())


{-| Cmd-based container scrolling with custom completion message.

    ScrollInContainer containerId elementId ->
        ( model, containerElementCmd ScrollComplete containerId elementId )

-}
containerElementCmd : msg -> String -> String -> Cmd msg
containerElementCmd msg containerId elementId =
    containerElementCmdWithConfig msg defaultConfig containerId elementId


{-| Cmd-based container scrolling with configuration and custom completion message.

    ScrollInContainer containerId elementId ->
        ( model, containerElementCmdWithConfig ScrollComplete config containerId elementId )

-}
containerElementCmdWithConfig : msg -> Config -> String -> String -> Cmd msg
containerElementCmdWithConfig msg config containerId elementId =
    containerElementTaskWithConfig config containerId elementId
        |> Task.attempt (always msg)


{-| Task-based container scrolling for advanced users.

    ScrollInContainer containerId elementId ->
        ( model, Task.attempt HandleScrollError (containerElementTask containerId elementId) )

-}
containerElementTask : String -> String -> Task Dom.Error (List ())
containerElementTask containerId elementId =
    containerElementTaskWithConfig defaultConfig containerId elementId


{-| Task-based container scrolling with configuration for advanced users.

    ScrollInContainer containerId elementId ->
        ( model, Task.attempt HandleScrollError (containerElementTaskWithConfig config containerId elementId) )

-}
containerElementTaskWithConfig : Config -> String -> String -> Task Dom.Error (List ())
containerElementTaskWithConfig config containerId elementId =
    Task.map2 Tuple.pair (Dom.getElement containerId) (Dom.getElement elementId)
        |> Task.andThen
            (\( container, element ) ->
                let
                    containerTop =
                        container.element.y

                    elementTop =
                        element.element.y

                    relativePosition =
                        elementTop - containerTop

                    targetY =
                        relativePosition - container.element.height / 2

                    clampedY =
                        clamp 0 (container.element.height - container.viewport.height) targetY

                    steps =
                        Internal.interpolate (round config.speed) config.easing container.viewport.y clampedY
                in
                animateContainerSteps containerId steps
            )


animateSteps : List Float -> Task Dom.Error (List ())
animateSteps steps =
    steps
        |> List.map (\y -> Process.sleep 16 |> Task.andThen (\_ -> Dom.setViewport 0 y))
        |> Task.sequence


animateStepsX : List Float -> Task Dom.Error (List ())
animateStepsX steps =
    steps
        |> List.map (\x -> Process.sleep 16 |> Task.andThen (\_ -> Dom.setViewport x 0))
        |> Task.sequence


animateStepsBoth : List Float -> List Float -> Task Dom.Error (List ())
animateStepsBoth stepsX stepsY =
    let
        -- Zip the two step lists together, taking the minimum length
        combinedSteps =
            List.map2 Tuple.pair stepsX stepsY
    in
    combinedSteps
        |> List.map (\( x, y ) -> Process.sleep 16 |> Task.andThen (\_ -> Dom.setViewport x y))
        |> Task.sequence


animateContainerSteps : String -> List Float -> Task Dom.Error (List ())
animateContainerSteps containerId steps =
    steps
        |> List.map (\y -> Process.sleep 16 |> Task.andThen (\_ -> Dom.setViewportOf containerId 0 y))
        |> Task.sequence
