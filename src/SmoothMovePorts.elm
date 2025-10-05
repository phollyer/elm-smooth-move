module SmoothMovePorts exposing
    ( Config
    , defaultConfig
    , Axis(..)
    , Model
    , init
    , animateTo
    , animateToWithConfig
    , stopAnimation
    , isAnimating
    , getPosition
    , getAllPositions
    , transform
    , transformElement
    , handlePositionUpdate
    , handleAnimationComplete
    , encodeAnimationCommand
    , encodeStopCommand
    , AnimationCommand
    , PositionUpdate
    )

{-| A port-based animation library helper that works with JavaScript's Web Animations API for high-performance element movement.

Since Elm packages cannot contain ports, this module provides helper functions and data types
to make it easy to implement your own ports for JavaScript-based animations.

This approach provides:

  - Access to Web Animations API for optimal performance
  - Hardware acceleration when available
  - Native JavaScript easing functions
  - Ability to leverage future browser animation improvements

See the accompanying `smooth-move-ports.js` file for the JavaScript implementation.


# Configuration

@docs Config
@docs defaultConfig
@docs Axis


# State Management

@docs Model
@docs init


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


# Port Integration Helpers

@docs handlePositionUpdate
@docs handleAnimationComplete
@docs encodeAnimationCommand
@docs encodeStopCommand
@docs positionUpdateDecoder
@docs AnimationCommand
@docs PositionUpdate

-}

import Dict exposing (Dict)


{-| Configuration for port-based animations

  - axis: Movement axis (X, Y, or Both)
  - duration: Animation duration in milliseconds
  - easing: Web Animations API easing ("ease-out", "cubic-bezier(0.4, 0.0, 0.2, 1)", etc.)

-}
type alias Config =
    { axis : Axis
    , duration : Float
    , easing : String
    }


{-| Animation axis constraint
-}
type Axis
    = X
    | Y
    | Both


{-| Default configuration using Web Animations API
-}
defaultConfig : Config
defaultConfig =
    { axis = Both
    , duration = 400
    , easing = "ease-out" -- Standard Web Animations API easing
    }


{-| Element state for port-based animations
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


{-| Animation command data to send to JavaScript

Use this with your own port:

    port animateElement : AnimationCommand -> Cmd msg

-}
type alias AnimationCommand =
    { elementId : String
    , targetX : Float
    , targetY : Float
    , duration : Float
    , easing : String
    , axis : String
    }


{-| Position update data received from JavaScript

Use this with your own port:

    port positionUpdates : (Decode.Value -> msg) -> Sub msg

-}
type alias PositionUpdate =
    { elementId : String
    , x : Float
    , y : Float
    , isAnimating : Bool
    }



-- PUBLIC API --


{-| Start animating an element to a target position using default config

Returns the updated model and an animation command for your port.

-}
animateTo : String -> Float -> Float -> Model -> ( Model, AnimationCommand )
animateTo elementId targetX targetY model =
    animateToWithConfig defaultConfig elementId targetX targetY model


{-| Start animating an element to a target position with custom configuration

Returns the updated model and an animation command for your port.

-}
animateToWithConfig : Config -> String -> Float -> Float -> Model -> ( Model, AnimationCommand )
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

        axisString =
            case config.axis of
                X ->
                    "x"

                Y ->
                    "y"

                Both ->
                    "both"

        command =
            { elementId = elementId
            , targetX = targetX
            , targetY = targetY
            , duration = config.duration
            , easing = config.easing
            , axis = axisString
            }
    in
    ( Model updatedElements, command )


{-| Stop animation for a specific element

Returns the updated model and the element ID to stop (for your port).

-}
stopAnimation : String -> Model -> ( Model, Maybe String )
stopAnimation elementId (Model elements) =
    case Dict.get elementId elements of
        Just elementData ->
            let
                updatedElementData =
                    { elementData | isAnimating = False }

                updatedElements =
                    Dict.insert elementId updatedElementData elements
            in
            ( Model updatedElements, Just elementId )

        Nothing ->
            ( Model elements, Nothing )


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
                { x = elementData.currentX, y = elementData.currentY }
            )


{-| Get all current element positions
-}
getAllPositions : Model -> Dict String { x : Float, y : Float }
getAllPositions (Model elements) =
    Dict.map
        (\_ elementData ->
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


{-| Handle position updates from JavaScript

Call this from your update function when receiving position updates:

    updatePosition : String -> Float -> Float -> Bool -> Model -> Model
    updatePosition elementId x y isAnimating model =
        SmoothMovePorts.handlePositionUpdate elementId x y isAnimating model

-}
handlePositionUpdate : String -> Float -> Float -> Bool -> Model -> Model
handlePositionUpdate elementId x y animating (Model elements) =
    case Dict.get elementId elements of
        Just elementData ->
            let
                updatedElementData =
                    { elementData
                        | currentX = x
                        , currentY = y
                        , isAnimating = animating
                    }

                updatedElements =
                    Dict.insert elementId updatedElementData elements
            in
            Model updatedElements

        Nothing ->
            -- Create new element data if it doesn't exist
            let
                newElementData =
                    { currentX = x
                    , currentY = y
                    , targetX = x
                    , targetY = y
                    , isAnimating = animating
                    , config = defaultConfig
                    }

                updatedElements =
                    Dict.insert elementId newElementData elements
            in
            Model updatedElements


{-| Handle animation completion from JavaScript
-}
handleAnimationComplete : String -> Model -> Model
handleAnimationComplete elementId (Model elements) =
    case Dict.get elementId elements of
        Just elementData ->
            let
                updatedElementData =
                    { elementData
                        | currentX = elementData.targetX
                        , currentY = elementData.targetY
                        , isAnimating = False
                    }

                updatedElements =
                    Dict.insert elementId updatedElementData elements
            in
            Model updatedElements

        Nothing ->
            Model elements


{-| Create a string representation of an animation command for easy port integration

This creates a simple format that's easy to parse in JavaScript:
"elementId:targetX:targetY:duration:easing:axis"

-}
encodeAnimationCommand : AnimationCommand -> String
encodeAnimationCommand cmd =
    String.join ":"
        [ cmd.elementId
        , String.fromFloat cmd.targetX
        , String.fromFloat cmd.targetY
        , String.fromFloat cmd.duration
        , cmd.easing
        , cmd.axis
        ]


{-| Create a string representation of a stop command
-}
encodeStopCommand : String -> String
encodeStopCommand elementId =
    elementId
