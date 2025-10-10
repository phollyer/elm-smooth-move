module SmoothMoveScrollUI.DiagonalBoth exposing (main)

import Browser exposing (Document)
import Browser.Dom
import Element exposing (Element, row, column, el, layout, maximum, paddingXY, rgb255, spacing, text, width, fill, centerX, centerY, htmlAttribute, height, px, link, alignLeft, padding, paragraph)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import SmoothMoveScroll exposing (animateToCmdWithConfig, defaultConfig, Axis(..))
import Task


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
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )


-- UPDATE


type Msg
    = NoOp
    | ScrollToTopLeft
    | ScrollToTopRight
    | ScrollToBottomLeft
    | ScrollToBottomRight
    | ScrollToCenter


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ScrollToTopLeft ->
            ( model
            , animateToCmdWithConfig NoOp 
                { defaultConfig 
                | speed = 25
                , axis = Both
                , offsetX = 20
                , offsetY = 20
                } 
                "top-left"
            )

        ScrollToTopRight ->
            ( model
            , animateToCmdWithConfig NoOp 
                { defaultConfig 
                | speed = 25
                , axis = Both
                , offsetX = 20
                , offsetY = 20
                } 
                "top-right"
            )

        ScrollToBottomLeft ->
            ( model
            , animateToCmdWithConfig NoOp 
                { defaultConfig 
                | speed = 25
                , axis = Both
                , offsetX = 20
                , offsetY = 20
                } 
                "bottom-left"
            )

        ScrollToBottomRight ->
            ( model
            , animateToCmdWithConfig NoOp 
                { defaultConfig 
                | speed = 25
                , axis = Both
                , offsetX = 20
                , offsetY = 20
                } 
                "bottom-right"
            )

        ScrollToCenter ->
            ( model
            , animateToCmdWithConfig NoOp 
                { defaultConfig 
                | speed = 25
                , axis = Both
                , offsetX = 20
                , offsetY = 20
                } 
                "center"
            )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


-- VIEW


view : Model -> Document Msg
view model =
    { title = "SmoothMoveScroll Diagonal Both Axis - ElmUI Example"
    , body = 
        [ Html.node "style" [] [ Html.text diagonalCSS ]
        , layout
            [ Background.gradient
                { angle = 0
                , steps = 
                    [ rgb255 248 250 252
                    , rgb255 226 232 240
                    ]
                }
            , paddingXY 40 20
            , width (px 2000)
            , htmlAttribute (Html.Attributes.class "diagonal-layout responsive-layout")
            ]
            (viewContent model)
        ]
    }


viewContent : Model -> Element Msg
viewContent model =
    column
        [ width (px 2000)
        , spacing 40
        , centerX
        , htmlAttribute (Html.Attributes.class "responsive-container")
        ]
        [ -- Header Section
          column
            [ width fill
            , spacing 20
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

            , -- Title
              el
                [ Font.size 32
                , Font.semiBold
                , Font.color (rgb255 30 41 59)
                , centerX
                , htmlAttribute (Html.Attributes.class "responsive-header")
                ]
                (text "Diagonal Both Axis Scrolling")

            , -- Description
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
                    [ text "This example demonstrates "
                    , el [ Font.semiBold ] (text "diagonal scrolling")
                    , text " using "
                    , el [ Font.semiBold ] (text "{ axis = Both }")
                    , text ". Click any corner or center button to see smooth diagonal movement that combines X and Y axis scrolling."
                    ]

                , paragraph
                    [ Font.size 16
                    , Font.color (rgb255 71 85 105)
                    , width fill
                    ]
                    [ text "Perfect for layouts with both horizontal and vertical navigation, creating natural diagonal paths between any two points on the page."
                    ]
                ]
            ]

        , -- Simple Navigation Buttons
          column
            [ spacing 20
            , centerX
            , htmlAttribute (Html.Attributes.class "responsive-buttons")
            , centerX
            ]
            [ el
                [ Font.size 18
                , Font.semiBold
                , Font.color (rgb255 71 85 105)
                , centerX
                ]
                (text "Navigate Diagonally:")

            , row
                [ spacing 16
                , centerX
                ]
                [ Input.button
                    [ Background.gradient { angle = 0, steps = [ rgb255 59 130 246, rgb255 37 99 235 ] }
                    , Font.color (rgb255 255 255 255)
                    , Font.medium
                    , paddingXY 20 12
                    , Border.rounded 8
                    ]
                    { onPress = Just ScrollToTopLeft
                    , label = text "↖ Top Left"
                    }

                , Input.button
                    [ Background.gradient { angle = 0, steps = [ rgb255 16 185 129, rgb255 5 150 105 ] }
                    , Font.color (rgb255 255 255 255)  
                    , Font.medium
                    , paddingXY 20 12
                    , Border.rounded 8
                    ]
                    { onPress = Just ScrollToTopRight
                    , label = text "↗ Top Right"
                    }

                , Input.button
                    [ Background.gradient { angle = 0, steps = [ rgb255 168 85 247, rgb255 139 92 246 ] }
                    , Font.color (rgb255 255 255 255)
                    , Font.medium
                    , paddingXY 20 12
                    , Border.rounded 8
                    ]
                    { onPress = Just ScrollToCenter
                    , label = text "🎯 Center"
                    }

                , Input.button
                    [ Background.gradient { angle = 0, steps = [ rgb255 245 101 101, rgb255 220 38 38 ] }
                    , Font.color (rgb255 255 255 255)
                    , Font.medium
                    , paddingXY 20 12
                    , Border.rounded 8
                    ]
                    { onPress = Just ScrollToBottomLeft
                    , label = text "↙ Bottom Left"
                    }

                , Input.button
                    [ Background.gradient { angle = 0, steps = [ rgb255 251 146 60, rgb255 249 115 22 ] }
                    , Font.color (rgb255 255 255 255)
                    , Font.medium
                    , paddingXY 20 12
                    , Border.rounded 8
                    ]
                    { onPress = Just ScrollToBottomRight
                    , label = text "↘ Bottom Right"
                    }
                ]
            ]

        , -- Simple 2x2 Grid Layout
          viewSimpleGrid
        ]


viewSimpleGrid : Element Msg
viewSimpleGrid =
    column
        [ width (px 1800)
        , spacing 100
        , paddingXY 40 80
        , htmlAttribute (Html.Attributes.class "simple-grid")
        ]
        [ -- Top Row
          row
            [ width fill
            , spacing 100
            ]
            [ viewCorner "top-left" "↖ TOP LEFT" (rgb255 59 130 246) 
                [ "This is the top-left corner of our diagonal scrolling demonstration."
                , "Click the '↖ Top Left' button to animate diagonally to this position."
                , "The Both axis scrolling moves smoothly in X and Y directions simultaneously."
                ]

            , el [ width (px 600) ] (text "")  -- Spacer

            , viewCorner "top-right" "↗ TOP RIGHT" (rgb255 16 185 129)
                [ "Welcome to the top-right corner!"
                , "Notice how the diagonal animation moves both horizontally and vertically."
                , "This demonstrates the power of Both axis configuration."
                ]
            ]

        , -- Center Row
          row
            [ width fill
            , spacing 100
            ]
            [ el [ width (px 400) ] (text "")  -- Spacer

            , viewCorner "center" "🎯 CENTER" (rgb255 168 85 247)
                [ "This is the center position of our layout."
                , "From any corner, clicking 'Center' creates a perfect diagonal scroll."
                , "The center demonstrates Both axis interpolation at its finest."
                ]

            , el [ width (px 400) ] (text "")  -- Spacer
            ]

        , -- Bottom Row  
          row
            [ width fill
            , spacing 100
            ]
            [ viewCorner "bottom-left" "↙ BOTTOM LEFT" (rgb255 245 101 101)
                [ "You've reached the bottom-left corner."
                , "Try navigating to different corners to see diagonal movement."
                , "Each animation smoothly interpolates between start and end positions."
                ]

            , el [ width (px 600) ] (text "")  -- Spacer

            , viewCorner "bottom-right" "↘ BOTTOM RIGHT" (rgb255 251 146 60)
                [ "This is the bottom-right corner, the final destination."
                , "The diagonal scrolling works perfectly in all directions!"
                , "Both axis scrolling makes complex layouts easy to navigate."
                ]
            ]
        ]


viewCorner : String -> String -> Element.Color -> List String -> Element Msg
viewCorner targetId title color contentLines =
    column
        [ width (px 400)
        , height (px 300)
        , spacing 16
        , htmlAttribute (Html.Attributes.id targetId)
        , htmlAttribute (Html.Attributes.class "responsive-paragraph")
        , Background.color color
        , paddingXY 24 20
        , Border.rounded 12
        , Border.shadow
            { offset = (0, 4)
            , size = 0
            , blur = 12
            , color = Element.rgba 0 0 0 0.15
            }
        ]
        [ -- Corner Title
          el
            [ Font.size 20
            , Font.semiBold
            , Font.color (rgb255 255 255 255)
            , centerX
            ]
            (text title)

        , -- Corner Content
          column
            [ spacing 12
            , width fill
            ]
            (List.map (\line ->
                paragraph
                    [ Font.size 14
                    , Font.color (rgb255 255 255 255)
                    , width fill
                    ]
                    [ text line ]
            ) contentLines)
        ]


diagonalCSS : String
diagonalCSS =
    """
    body {
        overflow: auto !important;
    }

    .diagonal-layout {
        min-height: 150vh;
        min-width: 200vw;
    }

    .simple-grid {
        padding-bottom: 300px;
        padding-right: 300px;
    }

    /* Mobile-first responsive design matching Basic example */
    @media (max-width: 768px) {
        .responsive-layout {
            padding: 20px 16px !important;
        }
        
        .responsive-container {
            gap: 20px !important;
        }
        
        .responsive-header {
            font-size: 24px !important;
            text-align: center;
            padding: 0 16px;
        }
        
        .responsive-tech-info {
            padding: 16px 20px !important;
            margin: 0 16px;
        }
        
        .responsive-buttons {
            gap: 16px !important;
            padding: 0 16px;
        }
        
        .responsive-buttons button {
            width: 100%;
            min-height: 44px;
            padding: 12px 20px !important;
        }
        
        .responsive-paragraph {
            padding: 20px 16px !important;
            margin: 0 16px;
        }
        
        .responsive-paragraph h1,
        .responsive-paragraph h2,
        .responsive-paragraph h3 {
            font-size: 20px !important;
        }
        
        .diagonal-layout {
            padding: 10px 15px;
            min-width: 250vw;
        }
        
        .simple-grid {
            padding-bottom: 200px;  
            padding-right: 200px;
        }
    }

    @media (max-width: 480px) {
        .responsive-layout {
            padding: 16px 12px !important;
        }
        
        .responsive-header {
            font-size: 20px !important;
        }
        
        .responsive-tech-info {
            padding: 12px 16px !important;
            margin: 0 12px;
        }
        
        .responsive-paragraph {
            padding: 16px 12px !important;
            margin: 0 12px;
        }
        
        .responsive-buttons {
            padding: 0 12px;
        }
        
        .diagonal-layout {
            padding: 10px;
            min-width: 300vw;
        }
        
        .simple-grid {
            padding-bottom: 150px;
            padding-right: 150px;
        }
    }
    """