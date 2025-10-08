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
import Element exposing (Element, column, el, maximum, layout, paddingXY, rgb255, spacing, text, width, fill, centerX, htmlAttribute, height, px, row, link, alignLeft, padding, paragraph)
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
        [ Html.node "style" [] [ Html.text responsiveCSS ]
        , layout
            [ Background.gradient
                { angle = 0
                , steps = 
                    [ rgb255 248 250 252
                    , rgb255 226 232 240
                    ]
                }
            , paddingXY 40 20
            , htmlAttribute (Html.Attributes.class "responsive-layout")
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
        , htmlAttribute (Html.Attributes.class "responsive-container")
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
            , htmlAttribute (Html.Attributes.class "responsive-header")
            ]
            (text "SmoothMoveCSS Basic Example")

        , -- Technical information
          column
            [ spacing 16
            , width (maximum 1200 fill)
            , centerX
            , paddingXY 32 24
            , Background.color (rgb255 248 250 252)
            , Border.rounded 8
            , Border.solid
            , Border.width 1
            , Border.color (rgb255 226 232 240)
            , htmlAttribute (Html.Attributes.class "responsive-tech-info")
            ]
            [ paragraph
                [ Font.size 16
                , Font.color (rgb255 71 85 105)
                , width fill
                ]
                [ text "This example demonstrates the SmoothMoveCSS module, which leverages "
                , el [ Font.semiBold ] (text "native CSS transitions")
                , text " for optimal performance. The browser handles all animation calculations using "
                , el [ Font.semiBold ] (text "hardware acceleration")
                , text ", resulting in smooth, efficient animations with minimal JavaScript overhead."
                ]

            , paragraph
                [ Font.size 16
                , Font.color (rgb255 71 85 105)
                , width fill
                ]
                [ text "Perfect for battery-efficient mobile animations and high-performance transitions where "
                , el [ Font.semiBold ] (text "native browser optimization")
                , text " provides the best user experience."
                ]
            ]

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


responsiveCSS : String
responsiveCSS =
    """
    <style>
    .responsive-layout {
        min-height: 100vh;
        padding: 20px;
        box-sizing: border-box;
    }
    
    .responsive-container {
        max-width: 1200px;
        width: 100%;
        margin: 0 auto;
    }
    
    .responsive-header {
        font-size: 32px;
        line-height: 1.2;
        margin-bottom: 30px;
    }
    
    .responsive-tech-info {
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 16px;
        margin-bottom: 30px;
    }
    
    .responsive-buttons {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-bottom: 30px;
    }
    
    .responsive-buttons > * {
        min-height: 44px;
        min-width: 44px;
    }
    
    .responsive-paragraph {
        line-height: 1.6;
        margin-bottom: 20px;
    }
    
    /* Tablet breakpoint */
    @media (max-width: 768px) {
        .responsive-layout {
            padding: 16px;
        }
        
        .responsive-header {
            font-size: 24px;
            margin-bottom: 24px;
        }
        
        .responsive-tech-info {
            padding: 12px;
            margin-bottom: 24px;
        }
        
        .responsive-buttons {
            margin-bottom: 24px;
        }
        
        .responsive-paragraph {
            margin-bottom: 16px;
        }
    }
    
    /* Mobile breakpoint */
    @media (max-width: 480px) {
        .responsive-layout {
            padding: 12px;
        }
        
        .responsive-header {
            font-size: 20px;
            margin-bottom: 20px;
        }
        
        .responsive-tech-info {
            padding: 10px;
            margin-bottom: 20px;
        }
        
        .responsive-buttons {
            margin-bottom: 20px;
        }
        
        .responsive-paragraph {
            margin-bottom: 14px;
        }
    }
    </style>
    """