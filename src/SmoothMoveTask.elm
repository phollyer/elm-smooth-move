module SmoothMoveTask exposing
    ( Axis(..)
    , Config
    , Container(..)
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
import Task exposing (Task)


{-| Configuration for scrolling animations

This module provides both simple Cmd-based functions (recommended for most users)
and advanced Task-based functions (for composition and custom error handling).

  - speed: Animation speed divider (lower = faster, higher = slower)
  - offset: Vertical offset in pixels from the target position
  - easing: Easing function from elm-community/easing-functions
  - axis: Movement axis (Y for scrolling, X for horizontal)
  - container: Which element to scroll within (document body or container)
  - scrollBar: Whether to show scrollbar during animation

-}
type alias Config =
    { speed : Int
    , offset : Int
    , easing : Ease.Easing
    , axis : Axis
    , container : Container
    , scrollBar : Bool
    }


type Axis
    = X
    | Y


{-| An internal type for configuring which element to scroll within.
-}
type Container
    = DocumentBody
    | InnerNode String


{-| The default configuration which can be modified

    import Ease
    import SmoothMoveTask exposing (defaultConfig)

    defaultConfig : Config
    defaultConfig =
        { speed = 200
        , offset = 12
        , easing = Ease.outQuint
        , container = DocumentBody
        , axis = Y
        , scrollBar = True
        }

-}
defaultConfig : Config
defaultConfig =
    { speed = 200
    , offset = 12
    , easing = Ease.outQuint
    , container = DocumentBody
    , axis = Y
    , scrollBar = True
    }


{-| Configure which DOM node to scroll inside of

    import SmoothMoveTask exposing (containerElement, animateToWithConfig, defaultConfig)

    animateToWithConfig { defaultConfig | container = containerElement "article-list" } "article-42"

-}
containerElement : String -> Container
containerElement elementId =
    InnerNode elementId


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
animateToTaskWithConfig config id =
    let
        ( getViewport, setViewport ) =
            case config.container of
                DocumentBody ->
                    ( Dom.getViewport
                    , case config.axis of
                        Y ->
                            Dom.setViewport 0

                        X ->
                            \i -> Dom.setViewport i 0
                    )

                InnerNode containerNodeId ->
                    ( Dom.getViewportOf containerNodeId
                    , case config.axis of
                        Y ->
                            Dom.setViewportOf containerNodeId 0

                        X ->
                            \i -> Dom.setViewportOf containerNodeId i 0
                    )

        getContainerInfo =
            case config.container of
                DocumentBody ->
                    Task.succeed Nothing

                InnerNode containerNodeId ->
                    Task.map Just (Dom.getElement containerNodeId)

        scrollTask { scene, viewport } { element } container =
            let
                destination =
                    case container of
                        Nothing ->
                            element.y - toFloat config.offset

                        Just containerInfo ->
                            viewport.y + element.y - toFloat config.offset - containerInfo.element.y

                clamped =
                    destination
                        |> min (scene.height - viewport.height)
                        |> Basics.max 0
            in
            animationSteps config.speed config.easing viewport.y clamped
                |> List.map setViewport
                |> Task.sequence
    in
    Task.map3 scrollTask getViewport (Dom.getElement id) getContainerInfo
        |> Task.andThen identity


{-| Simple container scrolling. Returns a Cmd that produces no meaningful messages.

    ScrollInContainer containerId elementId ->
        ( model, containerElementWithConfig (containerElement containerId) elementId )

-}
containerElementWithConfig : Container -> String -> Cmd ()
containerElementWithConfig container elementId =
    animateToTaskWithConfig { defaultConfig | container = container } elementId
        |> Task.attempt (always ())


{-| Cmd-based container scrolling with custom completion message.

    ScrollInContainer containerId elementId ->
        ( model, containerElementCmd ScrollComplete (containerElement containerId) elementId )

-}
containerElementCmd : msg -> Container -> String -> Cmd msg
containerElementCmd msg container elementId =
    containerElementCmdWithConfig msg defaultConfig container elementId


{-| Cmd-based container scrolling with configuration and custom completion message.

    ScrollInContainer containerId elementId ->
        ( model, containerElementCmdWithConfig ScrollComplete config (containerElement containerId) elementId )

-}
containerElementCmdWithConfig : msg -> Config -> Container -> String -> Cmd msg
containerElementCmdWithConfig msg config container elementId =
    animateToTaskWithConfig { config | container = container } elementId
        |> Task.attempt (always msg)


{-| Task-based container scrolling for advanced users.

    ScrollInContainer containerId elementId ->
        ( model, Task.attempt HandleScrollError (containerElementTask (containerElement containerId) elementId) )

-}
containerElementTask : Container -> String -> Task Dom.Error (List ())
containerElementTask container elementId =
    containerElementTaskWithConfig defaultConfig container elementId


{-| Task-based container scrolling with configuration for advanced users.

    ScrollInContainer containerId elementId ->
        ( model, Task.attempt HandleScrollError (containerElementTaskWithConfig config (containerElement containerId) elementId) )

-}
containerElementTaskWithConfig : Config -> Container -> String -> Task Dom.Error (List ())
containerElementTaskWithConfig config container elementId =
    animateToTaskWithConfig { config | container = container } elementId


{-| Internal animation steps function - matches SmoothScroll.elm implementation
-}
animationSteps : Int -> Ease.Easing -> Float -> Float -> List Float
animationSteps speed easing start stop =
    let
        diff =
            abs <| start - stop

        frames =
            Basics.max 1 <| round diff // speed

        framesFloat =
            toFloat frames

        weights =
            List.map (\i -> easing (toFloat i / framesFloat)) (List.range 0 frames)

        operator =
            if start > stop then
                (-)

            else
                (+)
    in
    if speed <= 0 || start == stop then
        []

    else
        List.map (\weight -> operator start (weight * diff)) weights
