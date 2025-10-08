port module SmoothMovePortsUI.Basic exposing (main)

{-| 
SmoothMovePorts Basic Example using ElmUI - Web Animations API integration via JavaScript

This approach uses Elm ports to communicate with JavaScript's Web Animations API,
providing access to advanced animation features and platform-specific optimizations.

BENEFITS:  
- ✅ Access to Web Animations API features
- ✅ Platform-specific optimizations via JavaScript
- ✅ Complex animation composition capabilities
- ✅ Fine-grained animation control and timing
- ✅ Support for advanced easing functions
- ✅ Real-time position feedback via ports

REQUIREMENTS:
- Requires companion JavaScript file (smooth-move-ports.js)
- Needs port definitions for Elm-JavaScript communication
- Web Animations API support (modern browsers)
-}

import Browser exposing (Document)
import Element exposing (Element, column, el, layout, paddingXY, rgb255, spacing, text, width, fill, centerX, htmlAttribute, height, px, row, link, alignLeft, padding)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import Json.Decode as Decode
import SmoothMovePorts


-- PORTS


port animateElement : String -> Cmd msg
port stopElementAnimation : String -> Cmd msg
port positionUpdates : (Decode.Value -> msg) -> Sub msg


-- TYPES


type alias PositionUpdate =
    { elementId : String
    , x : Float
    , y : Float
    , isAnimating : Bool
    }


{-| Decoder for position updates from JavaScript
-}
positionDecoder : Decode.Decoder PositionUpdate
positionDecoder =
    Decode.map4 PositionUpdate
        (Decode.field "elementId" Decode.string)
        (Decode.field "x" Decode.float)
        (Decode.field "y" Decode.float)
        (Decode.field "isAnimating" Decode.bool)


-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- MODEL


type alias Model =
    { animations : SmoothMovePorts.Model
    }


-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    let
        -- Initialize with starting position
        initialAnimations =
            SmoothMovePorts.init
                |> SmoothMovePorts.setInitialPosition "moving-box" 0 0
    in
    ( { animations = initialAnimations }
    , Cmd.none
    )


-- UPDATE


type Msg
    = MoveToCorner
    | MoveToCenter
    | StopAnimation
    | PositionUpdateMsg Decode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MoveToCorner ->
            let
                ( newAnimations, command ) =
                    SmoothMovePorts.animateTo "moving-box" 100 100 model.animations
            in
            ( { model | animations = newAnimations }
            , animateElement (SmoothMovePorts.encodeAnimationCommand command)
            )

        MoveToCenter ->
            let
                ( newAnimations, command ) =
                    SmoothMovePorts.animateTo "moving-box" 300 200 model.animations
            in
            ( { model | animations = newAnimations }
            , animateElement (SmoothMovePorts.encodeAnimationCommand command)
            )

        StopAnimation ->
            let
                ( newAnimations, command ) =
                    SmoothMovePorts.animateTo "moving-box" 0 0 model.animations
            in
            ( { model | animations = newAnimations }
            , animateElement (SmoothMovePorts.encodeAnimationCommand command)
            )

        PositionUpdateMsg value ->
            -- Parse the position update from JavaScript
            case Decode.decodeValue positionDecoder value of
                Ok posUpdate ->
                    let
                        newAnimations =
                            SmoothMovePorts.handlePositionUpdate
                                posUpdate.elementId
                                posUpdate.x
                                posUpdate.y
                                posUpdate.isAnimating
                                model.animations
                    in
                    ( { model | animations = newAnimations }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    positionUpdates PositionUpdateMsg


-- VIEW


view : Model -> Document Msg
view model =
    { title = "SmoothMovePorts Basic ElmUI Example"
    , body = 
        [ layout
            [ Background.gradient
                { angle = 0
                , steps = 
                    [ rgb255 248 250 252
                    , rgb255 226 232 240
                    ]
                }
            , paddingXY 40 20
            ]
            (viewContent model)
        ]
    }


viewContent : Model -> Element Msg
viewContent model =
    let
        position = SmoothMovePorts.getPosition "moving-box" model.animations
                  |> Maybe.withDefault { x = 0, y = 0 }
        isAnimating = SmoothMovePorts.isAnimating model.animations
    in
    column
        [ width fill
        , spacing 40
        , centerX
        ]
        [ -- Back button
          link
            [ alignLeft
            , padding 12
            , Background.gradient
                { angle = 0
                , steps = [ rgb255 59 130 246, rgb255 147 197 253 ]
                }
            , Font.color (rgb255 255 255 255)  
            , Font.semiBold
            , Border.rounded 8
            , htmlAttribute (Html.Attributes.id "top")
            ]
            { url = "../../elmui-examples.html"
            , label = text "← Back to Examples"
            }
        
        , -- Header
          el
            [ Font.size 32
            , Font.semiBold
            , Font.color (rgb255 30 41 59)
            , centerX
            ]
            (text "SmoothMovePorts Basic Example")

        , el
            [ Font.size 18
            , Font.color (rgb255 71 85 105)
            , centerX
            ]
            (text "ElmUI Version - Use buttons to move the blue box")

        , -- Status
          el
            [ Font.size 16
            , Font.color (if isAnimating then rgb255 16 185 129 else rgb255 71 85 105)
            , centerX
            ]
            (text (if isAnimating then "Animating..." else "Ready"))

        , -- Position display
          el
            [ Font.size 14
            , Font.color (rgb255 107 114 128)
            , centerX
            ]
            (text ("Position: (" ++ String.fromInt (round position.x) ++ ", " ++ String.fromInt (round position.y) ++ ")"))

        , -- Buttons for predefined moves
          column
            [ spacing 20
            , centerX
            ]
            [ Input.button
                [ Background.gradient
                    { angle = 0
                    , steps = 
                        [ rgb255 59 130 246
                        , rgb255 37 99 235
                        ]
                    }
                , Font.color (rgb255 255 255 255)
                , Font.medium
                , paddingXY 24 12
                , Border.rounded 8
                , centerX
                ]
                { onPress = Just MoveToCorner
                , label = text "Move to (100, 100)"
                }

            , Input.button
                [ Background.gradient
                    { angle = 0
                    , steps = 
                        [ rgb255 16 185 129
                        , rgb255 5 150 105
                        ]
                    }
                , Font.color (rgb255 255 255 255)
                , Font.medium
                , paddingXY 24 12
                , Border.rounded 8
                , centerX
                ]
                { onPress = Just MoveToCenter
                , label = text "Move to (300, 200)"
                }

            , Input.button
                [ Background.gradient
                    { angle = 0
                    , steps = 
                        [ rgb255 168 85 247
                        , rgb255 147 51 234
                        ]
                    }
                , Font.color (rgb255 255 255 255)
                , Font.medium
                , paddingXY 24 12
                , Border.rounded 8
                , centerX
                ]
                { onPress = Just StopAnimation
                , label = text "Return to Origin"
                }
            ]

        , -- Animation area with moving box
          el
            [ width (px 500)
            , height (px 400)
            , Background.color (rgb255 255 255 255)
            , Border.rounded 12
            , Border.shadow
                { offset = (0, 4)
                , size = 0
                , blur = 8
                , color = Element.rgba 0 0 0 0.1
                }
            , centerX
            , htmlAttribute (Html.Attributes.style "position" "relative")
            , htmlAttribute (Html.Attributes.style "overflow" "hidden")
            ]
            (el
                [ width (px 50)
                , height (px 50)
                , Background.color (rgb255 59 130 246)
                , Border.rounded 8
                , htmlAttribute (Html.Attributes.id "moving-box")
                , htmlAttribute (Html.Attributes.style "position" "absolute")
                , htmlAttribute (Html.Attributes.style "left" (String.fromFloat position.x ++ "px"))
                , htmlAttribute (Html.Attributes.style "top" (String.fromFloat position.y ++ "px"))
                ]
                (text "")
            )


        ]