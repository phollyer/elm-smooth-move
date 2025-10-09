module SmoothMoveScrollUI.Basic exposing (main)

import Browser exposing (Document)
import Browser.Dom
import Element exposing (Element, column, el, layout, maximum, paddingXY, rgb255, spacing, text, width, fill, centerX, htmlAttribute, height, px, link, alignLeft, padding, paragraph)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import SmoothMoveScroll exposing (animateToCmd, animateToTask, animateToCmdWithConfig, defaultConfig)
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
    | ScrollToParagraphOne
    | ScrollToParagraphTwo
    | ScrollToParagraphThree
    | ScrollToTop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ScrollToParagraphOne ->
            ( model, animateToCmdWithConfig NoOp { defaultConfig | speed = 20 } "paragraph-one" )

        ScrollToParagraphTwo ->
            ( model, animateToCmdWithConfig NoOp { defaultConfig | speed = 20 } "paragraph-two" )

        ScrollToParagraphThree ->
            ( model, animateToCmdWithConfig NoOp { defaultConfig | speed = 20 } "paragraph-three" )

        ScrollToTop ->
            ( model, animateToCmdWithConfig NoOp { defaultConfig | speed = 20 } "top" )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


-- VIEW


view : Model -> Document Msg
view model =
    { title = "SmoothMoveScroll Basic ElmUI Example"
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
            , htmlAttribute (Html.Attributes.class "responsive-header")
            ]
            (text "SmoothMoveScroll Document Example")

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
                [ text "This example demonstrates the SmoothMoveScroll module, which provides "
                , el [ Font.semiBold ] (text "task-based scrolling animations")
                , text " with composable error handling. It offers "
                , el [ Font.semiBold ] (text "smooth document navigation")
                , text " using the browser's native scrolling capabilities with customizable easing and timing controls."
                ]

            , paragraph
                [ Font.size 16
                , Font.color (rgb255 71 85 105)
                , width fill
                ]
                [ text "Perfect for applications requiring "
                , el [ Font.semiBold ] (text "sequential animations")
                , text " and reliable scrolling operations with comprehensive error handling and task composition."
                ]

            , paragraph
                [ Font.size 16
                , Font.color (rgb255 71 85 105)
                , width fill
                ]
                [ text "For beginners, this module provides an easy-to-use, fully managed approach that returns "
                , el [ Font.semiBold ] (text "Cmds")
                , text " rather than "
                , el [ Font.semiBold ] (text "Tasks")
                , text "."
                ]
            ]

        , -- Buttons
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
                , paddingXY 24 12
                , Border.rounded 8
                , centerX
                ]
                { onPress = Just ScrollToParagraphOne
                , label = text "Scroll to Paragraph One ↓"
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
                { onPress = Just ScrollToParagraphTwo
                , label = text "Scroll to Paragraph Two ↓"
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
                { onPress = Just ScrollToParagraphThree
                , label = text "Scroll to Paragraph Three ↓"
                }
            ]

        , -- Add some space before content
          el [ height (px 100) ] (text "")

        , -- Paragraph One
          column
            [ spacing 20
            , htmlAttribute (Html.Attributes.id "paragraph-one")
            , htmlAttribute (Html.Attributes.class "responsive-paragraph")
            , Background.color (rgb255 255 255 255)
            , centerX
            , paddingXY 32 24
            , Border.rounded 12
            , Border.shadow
                { offset = (0, 4)
                , size = 0
                , blur = 8
                , color = Element.rgba 0 0 0 0.1
                }
            ]
            [ el
                [ Font.size 24
                , Font.semiBold
                , Font.color (rgb255 30 41 59)
                ]
                (text "Paragraph One")

            , paragraph
                [ spacing 16
                , Font.size 16
                , Font.color (rgb255 71 85 105)
                , width <|
                    maximum 1200 fill
                ]
                [ el [] (text "This is the first paragraph of our example. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ")
                , el [] (text "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ")
                , el [] (text "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.")
                ]

            , Input.button
                [ Font.size 14
                , Font.color (rgb255 16 185 129)
                , Font.medium
                , paddingXY 12 8
                , Border.rounded 6
                , Background.color (rgb255 240 253 244)
                , Border.width 1
                , Border.color (rgb255 209 250 229)
                ]
                { onPress = Just ScrollToParagraphTwo
                , label = text "Continue to Paragraph Two ↓"
                }
            ]

        , -- Add space between paragraphs
          el [ height (px 200) ] (text "")

        , -- Paragraph Two  
          column
            [ spacing 20
            , htmlAttribute (Html.Attributes.id "paragraph-two")
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
            , centerX
            ]
            [ el
                [ Font.size 24
                , Font.semiBold
                , Font.color (rgb255 30 41 59)
                ]
                (text "Paragraph Two")

            , paragraph
                [ spacing 16
                , Font.size 16
                , Font.color (rgb255 71 85 105)
                , width <|
                    maximum 1200 fill
                ]
                [ el [] (text "This is the second paragraph. Totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.")
                , el [] (text "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.")
                , el [] (text "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.")
                ]

            , Input.button
                [ Font.size 14
                , Font.color (rgb255 168 85 247)
                , Font.medium
                , paddingXY 12 8
                , Border.rounded 6
                , Background.color (rgb255 250 245 255)
                , Border.width 1
                , Border.color (rgb255 233 213 255)
                ]
                { onPress = Just ScrollToParagraphThree
                , label = text "Continue to Paragraph Three ↓"
                }
            ]

        , -- Add space between paragraphs
          el [ height (px 100) ] (text "")

        , -- Paragraph Three
          column
            [ spacing 20
            , htmlAttribute (Html.Attributes.id "paragraph-three")
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
            , centerX
            ]
            [ el
                [ Font.size 24
                , Font.semiBold
                , Font.color (rgb255 30 41 59)
                ]
                (text "Paragraph Three")

            , paragraph
                [ spacing 16
                , Font.size 16
                , Font.color (rgb255 71 85 105)
                , width <|
                    maximum 1200 fill
                ]
                [ el [] (text "This is the third and final paragraph. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam.")
                , el [] (text "Nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur.")
                , el [] (text "Vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti.")
                ]

            , Input.button
                [ Font.size 14
                , Font.color (rgb255 34 197 94)
                , Font.medium
                , paddingXY 12 8
                , Border.rounded 6
                , Background.color (rgb255 240 253 244)
                , Border.width 1
                , Border.color (rgb255 220 252 231)
                ]
                { onPress = Just ScrollToTop
                , label = text "Click me to scroll back to Top ↑"
                }
            ]
        , -- Add some space after content
          el [ height (px 500)
          , centerX ] 
          (text "...")
        ]


-- RESPONSIVE CSS


responsiveCSS : String
responsiveCSS =
    """
    /* Mobile-first responsive design */
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
    }
    """