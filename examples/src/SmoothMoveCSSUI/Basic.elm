module SmoothMoveCSSUI.Basic exposing (main)

{-| 
SmoothMoveCSS Basic Example using ElmUI - Native browser CSS transitions for optimal performance

This approach uses browser-native CSS transitions for hardware acceleration and battery efficiency.
Perfect for simple transitions where you want maximum performance with minimal JavaScript overhead.

BENEFITS:
- ✅ Hardware acceleration via native CSS transitions
- ✅ Battery efficient (browser optimizes automatically)
- ✅ Simple API - just apply CSS styles directly
- ✅ No animation frame subscriptions needed
- ✅ Smooth 60fps animations with browser optimization
- ✅ Automatic performance scaling based on device capabilities

USAGE:
- Call SmoothMoveCSS.animateTo to get transition styles
- Apply the returned CSS directly to elements
- Browser handles all animation timing and optimization
-}

import Browser exposing (Document)
import Element exposing (Element, column, el, layout, paddingXY, rgb255, spacing, text, width, fill, centerX, htmlAttribute, height, px, row, link, alignLeft, padding)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import SmoothMoveCSS


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
    { animations : SmoothMoveCSS.Model
    }


-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    let
        -- Initialize with starting position to prevent jump to (0,0)
        initialAnimations =
            SmoothMoveCSS.init
                |> SmoothMoveCSS.setInitialPosition "moving-box" 0 0
    in
    ( { animations = initialAnimations }
    , Cmd.none
    )


-- UPDATE


type Msg
    = MoveToCorner
    | MoveToCenter
    | StopAnimation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MoveToCorner ->
            ( { model | animations = SmoothMoveCSS.animateTo "moving-box" 100 100 model.animations }
            , Cmd.none
            )

        MoveToCenter ->
            ( { model | animations = SmoothMoveCSS.animateTo "moving-box" 300 200 model.animations }
            , Cmd.none
            )

        StopAnimation ->
            ( { model | animations = SmoothMoveCSS.animateTo "moving-box" 0 0 model.animations }
            , Cmd.none
            )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none  -- No subscriptions needed for CSS transitions!


-- VIEW


view : Model -> Document Msg
view model =
    { title = "SmoothMoveCSS Basic ElmUI Example"
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
        position = SmoothMoveCSS.getPosition "moving-box" model.animations
                  |> Maybe.withDefault { x = 0, y = 0 }
        cssStyles = SmoothMoveCSS.cssTransitionStyle "moving-box" model.animations
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
            (text "SmoothMoveCSS Basic Example")

        , el
            [ Font.size 18
            , Font.color (rgb255 71 85 105)
            , centerX
            ]
            (text "ElmUI Version - Use buttons to move the blue box")

        , -- Status
          el
            [ Font.size 16
            , Font.color (rgb255 16 185 129)
            , centerX
            ]
            (text "🚀 Hardware Accelerated")

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
                -- Apply CSS transition styles directly - browser handles the animation!
                , htmlAttribute (Html.Attributes.style "transform" ("translate(" ++ String.fromFloat position.x ++ "px, " ++ String.fromFloat position.y ++ "px)"))
                , htmlAttribute (Html.Attributes.style "transition" cssStyles)
                ]
                (text "")
            )


        ]