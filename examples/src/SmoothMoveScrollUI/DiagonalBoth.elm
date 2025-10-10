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
import Common.UI as UI
import Common.Colors as Colors
import Common.Styles as Styles


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
    UI.createDocument "SmoothMoveScroll Diagonal Both Axis - ElmUI Example" UI.Diagonal (viewContent model)


viewContent : Model -> List (Element Msg)
viewContent model =
        [ -- Back Button
          UI.backButton

        , -- Title
          UI.pageHeader "Diagonal Both Axis Scrolling"

        , -- Technical Info
          UI.techInfo
            [ UI.techParagraph
                [ text "This example demonstrates "
                , UI.highlight "diagonal scrolling"
                , text " using "
                , UI.highlight "{ axis = Both }"
                , text ". Click any corner or center button to see smooth diagonal movement that combines X and Y axis scrolling."
                ]

            , UI.techParagraph
                [ text "Perfect for layouts with both horizontal and vertical navigation, creating natural diagonal paths between any two points on the page."
                ]
            ]

        , -- Navigation Buttons
          column
            [ spacing 20
            , centerX
            ]
            [ el
                [ Font.size 18
                , Font.semiBold
                , Font.color Colors.textMedium
                , centerX
                ]
                (text "Navigate Diagonally:")

            , row
                [ spacing 16
                , centerX
                , htmlAttribute (Html.Attributes.class "responsive-buttons")
                ]
                [ UI.actionButton UI.Primary ScrollToTopLeft "↖ Top Left"
                , UI.actionButton UI.Success ScrollToTopRight "↗ Top Right" 
                , UI.actionButton UI.Purple ScrollToCenter "🎯 Center"
                , UI.actionButton UI.Warning ScrollToBottomLeft "↙ Bottom Left"
                , UI.actionButton UI.Warning ScrollToBottomRight "↘ Bottom Right"
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


