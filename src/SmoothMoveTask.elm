module SmoothMoveTask exposing
    ( Config
    , containerElement
    , defaultConfig
    , scrollTo
    , scrollToWithOptions
    )

import Browser.Dom as Dom
import Ease
import Internal.AnimationSteps as Internal
import Process
import Task exposing (Task)


type alias Config =
    { speed : Int
    , offset : Float
    , easing : Ease.Easing
    }


defaultConfig : Config
defaultConfig =
    { speed = 10
    , offset = 0
    , easing = Ease.linear
    }


scrollTo : String -> Task Dom.Error (List ())
scrollTo elementId =
    scrollToWithOptions defaultConfig elementId


scrollToWithOptions : Config -> String -> Task Dom.Error (List ())
scrollToWithOptions config elementId =
    Task.map2 Tuple.pair Dom.getViewport (Dom.getElement elementId)
        |> Task.andThen
            (\( viewport, element ) ->
                let
                    targetY =
                        element.element.y + element.element.height / 2 - viewport.viewport.height / 2 + config.offset

                    clampedY =
                        clamp 0 (viewport.scene.height - viewport.viewport.height) targetY

                    steps =
                        Internal.interpolate config.speed config.easing viewport.viewport.y clampedY
                in
                animateSteps steps
            )


containerElement : String -> String -> Task Dom.Error (List ())
containerElement containerId elementId =
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
                        Internal.interpolate defaultConfig.speed defaultConfig.easing container.viewport.y clampedY
                in
                animateContainerSteps containerId steps
            )


animateSteps : List Float -> Task Dom.Error (List ())
animateSteps steps =
    steps
        |> List.map (\y -> Process.sleep 16 |> Task.andThen (\_ -> Dom.setViewport 0 y))
        |> Task.sequence


animateContainerSteps : String -> List Float -> Task Dom.Error (List ())
animateContainerSteps containerId steps =
    steps
        |> List.map (\y -> Process.sleep 16 |> Task.andThen (\_ -> Dom.setViewportOf containerId 0 y))
        |> Task.sequence
