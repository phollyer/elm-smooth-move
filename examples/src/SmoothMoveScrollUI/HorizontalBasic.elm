module SmoothMoveScrollUI.HorizontalBasic exposing (main)

import Browser exposing (Document)
import Browser.Dom
import Element exposing (Element, row, column, el, layout, maximum, paddingXY, paddingEach, rgb255, spacing, text, width, fill, centerX, centerY, htmlAttribute, height, px, link, alignLeft, padding, paragraph)
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
    | ScrollToSectionOne
    | ScrollToSectionTwo
    | ScrollToSectionThree
    | ScrollToStart


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ScrollToSectionOne ->
            ( model, animateToCmdWithConfig NoOp { defaultConfig | speed = 30, axis = X } "section-one" )

        ScrollToSectionTwo ->
            ( model, animateToCmdWithConfig NoOp { defaultConfig | speed = 30, axis = X } "section-two" )

        ScrollToSectionThree ->
            ( model, animateToCmdWithConfig NoOp { defaultConfig | speed = 30, axis = X } "section-three" )

        ScrollToStart ->
            ( model, animateToCmdWithConfig NoOp { defaultConfig | speed = 30, axis = X } "start" )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


-- VIEW


view : Model -> Document Msg
view model =
    { title = "SmoothMoveScroll Horizontal ElmUI Example"
    , body = 
        [ Html.node "style" [] [ Html.text horizontalCSS ]
        , layout
            [ Background.gradient
                { angle = 0
                , steps = 
                    [ rgb255 248 250 252
                    , rgb255 226 232 240
                    ]
                }
            , width fill
            , height fill
            , htmlAttribute (Html.Attributes.class "horizontal-layout responsive-layout")
            ]
            (viewContent model)
        ]
    }


viewContent : Model -> Element Msg
viewContent model =
    column
        [ width fill
        , spacing 40
        , centerX
        , paddingEach { top = 20, right = 0, bottom = 100, left = 0 }
        , htmlAttribute (Html.Attributes.class "responsive-container")
        ]
        [ -- Header and Controls
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
                , htmlAttribute (Html.Attributes.id "start")
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
                (text "Horizontal X Axis Scrolling")

            , -- Technical Info
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
                    , el [ Font.semiBold ] (text "X axis scrolling")
                    , text " using "
                    , el [ Font.semiBold ] (text "{ axis = X }")
                    , text " configuration. The sections scroll horizontally instead of vertically, creating a smooth left-to-right navigation experience."
                    ]

                , paragraph
                    [ Font.size 16
                    , Font.color (rgb255 71 85 105)
                    , width fill
                    ]
                    [ text "Perfect for horizontal layouts, carousels, and side-scrolling interfaces where content flows naturally from left to right."
                    ]
                ]

            , -- Navigation Buttons
              column
                [ spacing 20
                , centerX
                , htmlAttribute (Html.Attributes.class "responsive-buttons")
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
                    , paddingXY 20 10
                    , Border.rounded 6
                    ]
                    { onPress = Just ScrollToSectionOne
                    , label = text "Section 1 →"
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
                    , paddingXY 20 10
                    , Border.rounded 6
                    ]
                    { onPress = Just ScrollToSectionTwo
                    , label = text "Section 2 →"
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
                    , paddingXY 20 10
                    , Border.rounded 6
                    ]
                    { onPress = Just ScrollToSectionThree
                    , label = text "Section 3 →"
                    }

                , Input.button
                    [ Background.color (rgb255 107 114 128)
                    , Font.color (rgb255 255 255 255)
                    , Font.medium
                    , paddingXY 20 10
                    , Border.rounded 6
                    ]
                    { onPress = Just ScrollToStart
                    , label = text "← Back to Start"
                    }
                ]
            ]

        , -- Horizontal Content Container (move scrolling to document level)
          row
            [ spacing 40
            , paddingXY 20 20
            , htmlAttribute (Html.Attributes.style "width" "300vw")
            , htmlAttribute (Html.Attributes.class "horizontal-content-row")
            ]
                [ -- Start Section
                  viewSection "start" "🚀 Start Here" (rgb255 99 102 241) ScrollToSectionOne "Begin Journey →"
                    [ "Welcome to the horizontal scrolling demonstration!"
                    , "This is the starting point of our X axis scrolling example."
                    , "Click the button below to begin the horizontal journey through the sections."
                    ]

                , -- Section One
                  viewSection "section-one" "Section One" (rgb255 59 130 246) ScrollToSectionTwo "Continue to Section Two →"
                    [ "This is the first section of our horizontal scrolling example."
                    , "Notice how the scroll animation moves left-to-right instead of up-and-down."
                    , "The X axis configuration makes this possible with smooth horizontal movement."
                    ]

                , -- Section Two  
                  viewSection "section-two" "Section Two" (rgb255 16 185 129) ScrollToSectionThree "Continue to Section Three →"
                    [ "Welcome to the second section! The horizontal scrolling continues smoothly."
                    , "Each section is positioned side-by-side in a horizontal layout."
                    , "The animation automatically calculates the correct X position for each target."
                    ]

                , -- Section Three
                  viewSection "section-three" "Section Three" (rgb255 168 85 247) ScrollToStart "Back to Start ←"
                    [ "This is the final section of our horizontal scrolling demonstration."
                    , "You can navigate back to any previous section using the buttons above."
                    , "The SmoothMoveScroll module handles all the complex scroll calculations automatically."
                    ]
                ]
        ]


viewSection : String -> String -> Element.Color -> Msg -> String -> List String -> Element Msg
viewSection sectionId title color nextAction buttonText contentLines =
    column
        [ width  (px 300)
        , height (px 300)
        , spacing 20
        , htmlAttribute (Html.Attributes.id sectionId)
        , htmlAttribute (Html.Attributes.class "responsive-paragraph")
        , Background.color (rgb255 255 255 255)
        , paddingXY 32 24
        , Border.rounded 12
        , Border.shadow
            { offset = (0, 4)
            , size = 0
            , blur = 8
            , color = Element.rgba 0 0 0 0.1
            }
        ]
        [ -- Section Title
          el
            [ Font.size 24
            , Font.semiBold
            , Font.color color
            , centerX
            ]
            (text title)

        , -- Content
          column
            [ spacing 16
            , width fill
            ]
            (List.map (\line ->
                paragraph
                    [ Font.size 16
                    , Font.color (rgb255 71 85 105)
                    , width fill
                    ]
                    [ text line ]
            ) contentLines)

        , -- Navigation Button
          Input.button
            [ Font.size 14
            , Font.color color
            , Font.medium
            , paddingXY 16 12
            , Border.rounded 6
            , Background.color (Element.rgba 255 255 255 0.2)
            , Border.width 1
            , Border.color (Element.rgba 255 255 255 0.3)
            , centerX
            ]
            { onPress = Just nextAction
            , label = text buttonText
            }
        ]


horizontalCSS : String
horizontalCSS =
    """
    body {
        overflow-x: auto !important;
        overflow-y: auto !important;
    }

    .horizontal-layout {
        min-height: 100vh;
        height: auto;
        width: 500vw;
        padding: 16px 12px !important;
    }

    .horizontal-content-row {
        min-width: 500vw;
    }

    body::-webkit-scrollbar:horizontal {
        height: 12px;
    }

    body::-webkit-scrollbar-track:horizontal {
        background: #F7FAFC;
        border-radius: 6px;
    }

    body::-webkit-scrollbar-thumb:horizontal {
        background: #CBD5E0;
        border-radius: 6px;
    }

    body::-webkit-scrollbar-thumb:horizontal:hover {
        background: #A0AEC0;
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
        
        .horizontal-layout {
            width: 400vw;
        }
        
        .horizontal-content-row {
            min-width: 400vw;
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
        
        .horizontal-layout {
            padding: 16px 12px !important;
            width: 500vw;
        }
        
        .horizontal-content-row {
            min-width: 500vw;
        }
    }
    """