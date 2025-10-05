module SmoothMoveTask exposing
    ( Axis(..)
    , Config
    , animateTo
    , animateToWithConfig
    , containerElement
    , containerElementWithConfig
    , defaultConfig
    )

import Browser.Dom as Dom
import Ease
import Internal.AnimationSteps as Internal
import Process
import Task exposing (Task)


{-| Configuration for task-based animations

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


animateTo : String -> Task Dom.Error (List ())
animateTo elementId =
    animateToWithConfig defaultConfig elementId


animateToWithConfig : Config -> String -> Task Dom.Error (List ())
animateToWithConfig config elementId =
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


containerElement : String -> String -> Task Dom.Error (List ())
containerElement containerId elementId =
    containerElementWithConfig defaultConfig containerId elementId


containerElementWithConfig : Config -> String -> String -> Task Dom.Error (List ())
containerElementWithConfig config containerId elementId =
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
