module SmoothMoveScrollUI.Container exposing (main)

import Browser exposing (Document)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import SmoothMoveScroll exposing (animateToCmdWithConfig, containerElement, defaultConfig, setContainer)
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
        , subscriptions = \_ -> Sub.none
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
    | ScrollToTop
    | ScrollToMiddle
    | ScrollToBottom


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ScrollToTop ->
            ( model
            , animateToCmdWithConfig NoOp (setContainer "scroll-container" { defaultConfig | speed = 20 }) "top-element"
            )

        ScrollToMiddle ->
            ( model
            , animateToCmdWithConfig NoOp { defaultConfig | container = containerElement "scroll-container", speed = 20 } "middle-element"
            )

        ScrollToBottom ->
            ( model
            , animateToCmdWithConfig NoOp (setContainer "scroll-container" { defaultConfig | speed = 20 }) "bottom-element"
            )



-- VIEW


view : Model -> Document Msg
view model =
    UI.createDocument "SmoothMoveScroll - Container Scrolling (ElmUI)" UI.Container (viewContent model)
                

viewContent : Model -> List (Element Msg)
viewContent model =
    [ UI.backButton
                , UI.pageHeader "SmoothMoveScroll - Container Example"

                , UI.techInfo
                    [ UI.techParagraph
                        [ text "This example demonstrates the SmoothMoveScroll module handling "
                        , UI.highlight "container-specific scrolling"
                        , text " with boundary detection and viewport calculations. It provides "
                        , UI.highlight "precise element positioning"
                        , text " within scrollable containers while respecting container bounds and scroll limits."
                        ]
                    , UI.techParagraph
                        [ text "Perfect for applications with "
                        , UI.highlight "nested scrollable content"
                        , text " requiring smooth navigation within constrained viewport areas and complex layout hierarchies."
                        ]
                    ]

                , row
                    [ centerX
                    , spacing 20
                    , htmlAttribute (Html.Attributes.class "responsive-buttons")
                    ]
                    [ UI.actionButton UI.Primary ScrollToTop "Scroll to Top"
                    , UI.actionButton UI.Success ScrollToMiddle "Scroll to Middle"
                    , UI.actionButton UI.Purple ScrollToBottom "Scroll to Bottom"
                    ]

                , -- The scrollable container
                  el [ width fill, htmlAttribute (Html.Attributes.class "scroll-container-wrapper") ] <|
                            el
                                [ htmlAttribute (Html.Attributes.id "scroll-container")
                                , width fill
                                , height (px 600)
                                , Border.width 2
                                , Border.color Colors.borderMedium
                                , Border.rounded 12
                                , Background.color Colors.backgroundWhite
                                , Border.shadow
                                    { offset = ( 0, 4 )
                                    , size = 0
                                    , blur = 20
                                    , color = rgba255 0 0 0 0.1
                                    }
                                , scrollbarY
                                , clipY
                                ]
                                (Element.column
                                    [ width fill
                                    , spacing 30
                                    , paddingXY 30 30
                                    ]
                                    [ -- Top element
                                      el
                                        [ htmlAttribute (Html.Attributes.id "top-element")
                                        , width fill
                                        , Background.gradient
                                            { angle = 180
                                            , steps =
                                                [ Colors.backgroundWhite
                                                , Colors.primaryLight
                                                ]
                                            }
                                        , Border.color Colors.primary
                                        , Border.width 2
                                        , Border.rounded 12
                                        , padding 25
                                        , spacing 15
                                        ]
                                        (Element.column
                                            [ spacing 15 ]
                                            [ el
                                                [ Font.size 24
                                                , Font.bold
                                                 , Font.color Colors.primary
                                                , htmlAttribute (Html.Attributes.class "responsive-content-title")
                                                ]
                                                (text "🔝 Top of Container")
                                            , paragraph
                                                [ Font.size 16
                                                 , Font.color Colors.primary
                                                , spacing 6
                                                , width fill
                                                , htmlAttribute (Html.Attributes.class "responsive-content-description")
                                                ]
                                                [ text "This is the top of the scrollable container content. The background gradient helps visualize scroll position." ]
                                            , paragraph
                                                [ Font.size 16
                                                 , Font.color Colors.primary
                                                , spacing 6
                                                , width fill
                                                , htmlAttribute (Html.Attributes.class "responsive-content-description")
                                                ]
                                                [ text "Click 'Scroll to Top' to smoothly scroll to this position using ElmUI." ]
                                            ]
                                        )

                                    -- Content blocks 1-3
                                    , contentBlock 1 "This is content block 1. Each block adds to the scrollable height and demonstrates ElmUI styling."
                                    , contentBlock 2 "Content block 2 continues the gradient transition from white to dark with ElmUI elements."
                                    , contentBlock 3 "Content block 3 shows the middle section of our scrollable content using ElmUI layout."

                                    -- Middle element
                                    , el
                                        [ htmlAttribute (Html.Attributes.id "middle-element")
                                        , width fill
                                        , Background.gradient
                                            { angle = 180
                                            , steps =
                                                 [ Colors.backgroundWhite
                                                 , Colors.primaryLight
                                                ]
                                            }
                                        , Border.color Colors.success
                                        , Border.width 2
                                        , Border.rounded 12
                                        , padding 25
                                        , spacing 15
                                        ]
                                        (Element.column
                                            [ spacing 15 ]
                                            [ el
                                                [ Font.size 24
                                                , Font.bold
                                                , Font.color Colors.successDark
                                                , htmlAttribute (Html.Attributes.class "responsive-content-title")
                                                ]
                                                (text "🎯 Content Block 4 - Middle Target")
                                            , paragraph
                                                [ Font.size 16
                                                , Font.color Colors.successDark
                                                , spacing 6
                                                , width fill
                                                , htmlAttribute (Html.Attributes.class "responsive-content-description")
                                                ]
                                                [ text "This is the middle target of our scrollable content - Content block 4 demonstrates the progression through the gradient with ElmUI styling." ]
                                             , paragraph
                                                [ Font.size 16
                                                , Font.color Colors.successDark
                                                , spacing 6
                                                , width fill
                                                , htmlAttribute (Html.Attributes.class "responsive-content-description")
                                                ]
                                                [ text "Click 'Scroll to Middle' to smoothly scroll to this position." ]
                                            , Element.column
                                                [ spacing 8 ]
                                                [ bulletPoint "This block serves as the middle anchor point"
                                                , bulletPoint "The gradient background shows scroll position"
                                                , bulletPoint "Smooth scrolling animates between positions"
                                                ]
                                            ]
                                        )

                                    -- Content blocks 5-8
                                    , contentBlock 5 "Content block 5 continues toward the bottom of the container with ElmUI."
                                    , contentBlock 6 "Content block 6 shows we're getting closer to the bottom using ElmUI layout."
                                    , contentBlock 7 "Content block 7 is near the end with darker background colors in ElmUI."
                                    , contentBlock 8 "Content block 8 is almost at the bottom of the scrollable ElmUI content."

                                    -- Bottom element
                                    , el
                                        [ htmlAttribute (Html.Attributes.id "bottom-element")
                                        , width fill
                                         , Background.gradient
                                             { angle = 180
                                             , steps =
                                                 [ Colors.backgroundWhite
                                                 , Colors.warning
                                                 ]
                                             }
                                         , Border.color Colors.warningDark
                                        , Border.width 2
                                        , Border.rounded 12
                                        , padding 25
                                        , spacing 15
                                        ]
                                        (Element.column
                                            [ spacing 15 ]
                                            [ el
                                                [ Font.size 24
                                                , Font.bold
                                                 , Font.color Colors.warningDark
                                                , htmlAttribute (Html.Attributes.class "responsive-content-title")
                                                ]
                                                (text "🔻 Bottom of Container")
                                            , paragraph
                                                [ Font.size 16
                                                 , Font.color Colors.warningDark
                                                , spacing 6
                                                , width fill
                                                , htmlAttribute (Html.Attributes.class "responsive-content-description")
                                                ]
                                                [ text "This is the bottom of the scrollable container content. Notice the dark background created with ElmUI gradients." ]
                                            , paragraph
                                                [ Font.size 16
                                                 , Font.color Colors.warningDark
                                                , spacing 6
                                                , width fill
                                                , htmlAttribute (Html.Attributes.class "responsive-content-description")
                                                ]
                                                [ text "Click 'Scroll to Bottom' to smoothly scroll to this position." ]
                                            , paragraph
                                                [ Font.size 16
                                                , Font.color (rgb255 153 27 27)
                                                , spacing 6
                                                , width fill
                                                , htmlAttribute (Html.Attributes.class "responsive-content-description")
                                                ]
                                                [ text "The smooth animation works reliably using the new SmoothMoveScroll API with ElmUI." ]
                                            ]
                                        )
                                    ]
                                )
                ]



-- HELPER FUNCTIONS


contentBlock : Int -> String -> Element Msg
contentBlock num description =
    el
        [ width fill
        , Background.gradient
            { angle = 180
            , steps =
                [ Colors.backgroundWhite
                , Colors.backgroundLight
                ]
            }
        , Border.color Colors.borderMedium
        , Border.width 1
        , Border.rounded 8
        , padding 20
        , spacing 15
        ]
        (Element.column
            [ spacing 12
            , width fill
            , htmlAttribute (Html.Attributes.class "responsive-content-block")
            ]
            [ el
                [ Font.size 20
                , Font.semiBold
                , Font.color Colors.textDark
                , htmlAttribute (Html.Attributes.class "responsive-content-title")
                ]
                (text ("Content Block " ++ String.fromInt num))
            , paragraph
                [ Font.size 16
                , Font.color Colors.textMedium
                , spacing 6
                , width fill
                , htmlAttribute (Html.Attributes.class "responsive-content-description")
                ]
                [ text description ]
            , Element.column
                [ spacing 6
                , width fill
                , htmlAttribute (Html.Attributes.class "responsive-bullet-list")
                ]
                [ bulletPoint "Each block adds to the scrollable height"
                , bulletPoint "The gradient background shows scroll position"
                , bulletPoint "Smooth scrolling animates between positions"
                ]
            ]
        )


bulletPoint : String -> Element msg
bulletPoint text_ =
    row
        [ spacing 8
        , width fill
        , htmlAttribute (Html.Attributes.class "responsive-bullet-point")
        ]
        [ el
            [ Font.size 16
            , Font.color Colors.warning
            , alignTop
            ]
            (text "•")
        , paragraph
            [ Font.size 16
            , Font.color Colors.textMedium
            , width fill
            ]
            [ text text_ ]
        ]



-- RESPONSIVE CSS


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
        font-size: 32px !important;
        line-height: 1.2;
        margin-bottom: 30px;
        text-align: center;
    }
    
    .responsive-tech-info {
        padding: 24px !important;
        margin-bottom: 30px;
        border-radius: 8px;
    }
    
    .responsive-buttons {
        margin-bottom: 30px;
        display: flex !important;
        flex-direction: row !important;
        align-items: center !important;
        gap: 15px !important;
    }
    
    .button-responsive {
        min-height: 48px !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        text-align: center !important;
        box-sizing: border-box !important;
        white-space: nowrap !important;
    }
    
    /* Content block responsiveness */
    .responsive-content-block {
        width: 100%;
        box-sizing: border-box;
    }
    
    .responsive-content-title {
        font-size: 20px;
        line-height: 1.3;
        margin-bottom: 8px;
    }
    
    .responsive-content-description {
        font-size: 16px;
        line-height: 1.5;
        margin-bottom: 12px;
        word-wrap: break-word;
        overflow-wrap: break-word;
        hyphens: auto;
    }
    
    .responsive-bullet-list {
        width: 100%;
    }
    
    .responsive-bullet-point {
        width: 100%;
        margin-bottom: 4px;
        display: flex;
        align-items: flex-start;
    }
    
    .responsive-bullet-point p {
        margin: 0;
        word-wrap: break-word;
        overflow-wrap: break-word;
        hyphens: auto;
        line-height: 1.4;
    }
    
    .responsive-paragraph {
        line-height: 1.6 !important;
        margin-bottom: 16px;
        word-wrap: break-word;
        overflow-wrap: break-word;
        hyphens: auto;
    }
    
    /* Main content centering */
    .main-content {
        margin: 0 auto;
        max-width: 1200px;
    }
    
    /* Ensure scroll container maintains proper scroll behavior */
    #scroll-container {
        overflow-y: auto !important;
        max-height: 600px !important;
    }
    
    /* Ensure scroll container wrapper is properly centered */
    .scroll-container-wrapper {
        width: 100%;
        max-width: 1200px;
        margin: 0 auto;
    }
    
    /* Medium screens - switch buttons to column when they would wrap */
    @media (max-width: 900px) {
        .responsive-buttons {
            flex-direction: column !important;
            gap: 12px !important;
        }
        
        .button-responsive {
            width: 100% !important;
            max-width: 280px !important;
        }
    }
    
    /* Tablet breakpoint */
    @media (max-width: 768px) {
        .responsive-layout {
            padding: 16px !important;
        }
        
        .responsive-header {
            font-size: 24px !important;
            margin-bottom: 24px;
        }
        
        .responsive-tech-info {
            padding: 16px !important;
            margin-bottom: 24px;
        }
        
        .responsive-buttons {
            margin-bottom: 24px;
        }
        
        .button-responsive {
            min-height: 50px !important;
            font-size: 16px !important;
        }
        
        .responsive-paragraph {
            margin-bottom: 14px;
            font-size: 15px !important;
        }
        
        .responsive-content-title {
            font-size: 18px !important;
        }
        
        .responsive-content-description {
            font-size: 15px !important;
        }
        
        .responsive-bullet-point {
            margin-bottom: 6px;
        }
        
        .main-content {
            padding-left: 16px !important;
            padding-right: 16px !important;
        }
    }
    
    /* Mobile breakpoint */
    @media (max-width: 480px) {
        .responsive-layout {
            padding: 12px !important;
        }
        
        .responsive-header {
            font-size: 20px !important;
            margin-bottom: 20px;
        }
        
        .responsive-tech-info {
            padding: 12px !important;
            margin-bottom: 20px;
        }
        
        .responsive-buttons {
            margin-bottom: 20px;
            gap: 10px !important;
        }
        
        .button-responsive {
            min-height: 52px !important;
            max-width: 100% !important;
            font-size: 16px !important;
            padding: 16px 20px !important;
        }
        
        .responsive-paragraph {
            margin-bottom: 12px;
            font-size: 14px !important;
            line-height: 1.5 !important;
        }
        
        .responsive-content-title {
            font-size: 16px !important;
            margin-bottom: 6px;
        }
        
        .responsive-content-description {
            font-size: 14px !important;
            margin-bottom: 10px;
        }
        
        .responsive-bullet-point {
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .responsive-bullet-list {
            gap: 4px;
        }
        
        .main-content {
            padding-left: 12px !important;
            padding-right: 12px !important;
        }
    }
    </style>
    """
