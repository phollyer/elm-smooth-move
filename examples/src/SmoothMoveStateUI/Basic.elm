module SmoothMoveStateUI.Basic exposing (main)

{-| 
SmoothMoveState Basic Example using ElmUI - State-based convenience wrapper around subscription approach.

This is a simplified version of SmoothMoveSub that provides convenient state management
without requiring manual subscription handling in your main application.

BENEFITS:
- ✅ Simple state management with helper functions  
- ✅ No need to handle subscriptions manually
- ✅ Built-in animation frame stepping
- ✅ Easy position tracking and transforms
- ✅ Clean API for basic animation needs

USAGE:
- Keep SmoothMoveState.State in your model
- Use SmoothMoveState.step in AnimationFrame messages
- Call SmoothMoveState.animateTo to start animations
- Use transform and getPosition helper functions
-}

import Browser exposing (Document)
import Element exposing (Element, column, el, layout, paddingXY, rgb255, spacing, text, width, fill, centerX, htmlAttribute, height, px, row, link, alignLeft, padding)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import SmoothMoveState


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
    { animationState : SmoothMoveState.State
    }


-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    let
        -- Initialize with starting position to prevent jump to (0,0)
        initialState =
            SmoothMoveState.init
                |> SmoothMoveState.setInitialPosition "moving-box" 0 0
    in
    ( { animationState = initialState }
    , Cmd.none
    )


-- UPDATE


type Msg
    = AnimationFrame Float
    | MoveToCorner
    | MoveToCenter
    | StopAnimation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame deltaMs ->
            ( { model | animationState = SmoothMoveState.step deltaMs model.animationState }
            , Cmd.none
            )

        MoveToCorner ->
            ( { model | animationState = SmoothMoveState.animateTo "moving-box" 100 100 model.animationState }
            , Cmd.none
            )

        MoveToCenter ->
            ( { model | animationState = SmoothMoveState.animateTo "moving-box" 300 200 model.animationState }
            , Cmd.none
            )

        StopAnimation ->
            ( { model | animationState = SmoothMoveState.animateTo "moving-box" 0 0 model.animationState }
            , Cmd.none
            )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    SmoothMoveState.subscriptions model.animationState AnimationFrame


-- VIEW


view : Model -> Document Msg
view model =
    { title = "SmoothMoveState Basic ElmUI Example"
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
        position = SmoothMoveState.getPosition "moving-box" model.animationState
                  |> Maybe.withDefault { x = 0, y = 0 }
        isMoving = SmoothMoveState.isAnimating model.animationState
    in
    column
        [ width fill
        , spacing 40
        , centerX
        ]
        [ -- Back Button
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
            (text "SmoothMoveState Basic Example")

        , el
            [ Font.size 18
            , Font.color (rgb255 71 85 105)
            , centerX
            ]
            (text "ElmUI Version - State wrapper for subscription-based animations")



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
                , htmlAttribute (Html.Attributes.style "transform" (SmoothMoveState.transform position.x position.y))
                , htmlAttribute (Html.Attributes.style "transition" "none")
                ]
                (text "")
            )

        , -- Footer with technical information
          column
            [ spacing 16
            , width fill
            , paddingXY 32 24
            , Background.color (rgb255 248 250 252)
            , Border.rounded 8
            , Border.solid
            , Border.width 1
            , Border.color (rgb255 226 232 240)
            ]
            [ el
                [ Font.size 20
                , Font.semiBold
                , Font.color (rgb255 30 41 59)
                , centerX
                ]
                (text "🧩 SmoothMoveState - Convenience Wrapper")

            , paragraph
                [ Font.size 14
                , Font.color (rgb255 71 85 105)
                , width fill
                ]
                [ text "This example demonstrates the SmoothMoveState module, which provides a "
                , el [ Font.semiBold ] (text "convenience wrapper")
                , text " around the subscription-based animation system. It offers "
                , el [ Font.semiBold ] (text "simplified state management")
                , text " with helper functions while maintaining frame-rate independent positioning and smooth element transitions."
                ]

            , paragraph
                [ Font.size 14
                , Font.color (rgb255 71 85 105)
                , width fill
                ]
                [ text "Perfect for developers who want the power of subscription-based animations with "
                , el [ Font.semiBold ] (text "reduced boilerplate")
                , text " and easier integration into existing Elm applications."
                ]
            ]
        ]