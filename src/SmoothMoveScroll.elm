module SmoothMoveScroll exposing
    ( Config
    , defaultConfig
    , Axis(..)
    , Container
    , containerElement
    , setContainer
    , setDocumentBody
    , animateToCmd
    , animateToCmdWithConfig
    , animateToTask
    , animateToTaskWithConfig
    )

{-| Smooth scrolling animations for precise DOM element targeting.

This module provides both simple Cmd-based functions (recommended for most users)
and Task-based functions for more complex control flow and error handling.

Key features:

  - Smooth scrolling to specific DOM elements
  - Support for both document body and container element scrolling
  - Configurable animation parameters (speed, easing, axis)
  - Task-based API for composable operations
  - Error handling for missing DOM elements


# Configuration

@docs Config
@docs defaultConfig
@docs Axis
@docs Container
@docs containerElement
@docs setContainer
@docs setDocumentBody


# Simple Commands (Recommended)

@docs animateToCmd
@docs animateToCmdWithConfig


# Task-based API (Advanced)

@docs animateToTask
@docs animateToTaskWithConfig

-}

import Browser.Dom as Dom
import Ease
import Internal.SmoothScroll exposing (animationSteps)
import Task exposing (Task)


{-| Configuration for scrolling animations

This module provides both simple Cmd-based functions (recommended for most users)
and advanced Task-based functions (for composition and custom error handling).

  - speed: Animation speed divider (lower = faster, higher = slower)
  - offset: Vertical offset in pixels from the target position
  - easing: Easing function from [elm-community/easing-functions](https://package.elm-lang.org/packages/elm-community/easing-functions/latest/)
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


{-| Axis configuration for animation movement direction.

Use this to control whether your animation moves horizontally or vertically:

  - `Y` - Vertical scrolling (most common, default for page scrolling)
  - `X` - Horizontal scrolling (for sideways carousels or horizontal content)

Examples:

    -- Vertical scrolling to an element (default behavior)
    animateToCmdWithConfig
        { defaultConfig | axis = Y }
        "my-section"

    -- Horizontal scrolling within a carousel container
    animateToCmdWithConfig
        { defaultConfig
            | axis = X
            , container = containerElement "carousel-container"
        }
        "slide-3"

-}
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
    import SmoothMoveScroll exposing (defaultConfig)

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


{-| Set the container to scroll within to a specific DOM element by ID.

    import SmoothMoveScroll exposing (setContainer, animateToCmdWithConfig, defaultConfig)

    animateToCmdWithConfig NoOp (setContainer "article-list" defaultConfig) "article-42"

-}
setContainer : String -> Config -> Config
setContainer elementId config =
    { config | container = InnerNode elementId }


{-| Set the container to scroll within to the document body (default behavior).

    import SmoothMoveScroll exposing (setDocumentBody, animateToCmdWithConfig, defaultConfig)

    animateToCmdWithConfig NoOp (setDocumentBody defaultConfig) "article-42"

-}
setDocumentBody : Config -> Config
setDocumentBody config =
    { config | container = DocumentBody }


{-| Create a container reference for use with record update syntax.
Provides an alternative coding style for developers who prefer this approach.

    import SmoothMoveScroll exposing (containerElement, animateToCmdWithConfig, defaultConfig)

    animateToCmdWithConfig NoOp { defaultConfig | container = containerElement "article-list" } "article-42"

-}
containerElement : String -> Container
containerElement elementId =
    InnerNode elementId


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
