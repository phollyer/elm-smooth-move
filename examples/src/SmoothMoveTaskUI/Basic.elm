module SmoothMoveTaskUI.Basic exposing (main)

import Browser exposing (Document)
import Browser.Dom
import Element exposing (Element, column, el, layout, paddingXY, rgb255, spacing, text, width, fill, centerX, htmlAttribute, height, px, link, alignLeft, padding)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import SmoothMoveTask exposing (animateToCmd, animateToTask, animateToCmdWithConfig, defaultConfig)
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

        ScrollToTop ->
            ( model, animateToCmdWithConfig NoOp { defaultConfig | speed = 20 } "top" )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


-- VIEW


view : Model -> Document Msg
view model =
    { title = "SmoothMoveTask Basic ElmUI Example"
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
            (text "SmoothMoveTask Basic Example")

        , el
            [ Font.size 18
            , Font.color (rgb255 71 85 105)
            , centerX
            ]
            (text "ElmUI Version - Task-based scrolling with composable error handling")

        , -- Buttons
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
            ]

        , -- Add some space before content
          el [ height (px 100) ] (text "")

        , -- Paragraph One
          column
            [ spacing 20
            , htmlAttribute (Html.Attributes.id "paragraph-one")
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
            [ el
                [ Font.size 24
                , Font.semiBold
                , Font.color (rgb255 30 41 59)
                ]
                (text "Paragraph One")

            , column
                [ spacing 16
                , Font.size 16
                , Font.color (rgb255 71 85 105)
                ]
                [ el [] (text "This is the first paragraph of our example. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                , el [] (text "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")
                , el [] (text "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.")
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
                , label = text "Scroll to Top ↑"
                }
            ]

        , -- Add space between paragraphs
          el [ height (px 200) ] (text "")

        , -- Paragraph Two  
          column
            [ spacing 20
            , htmlAttribute (Html.Attributes.id "paragraph-two")
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
            [ el
                [ Font.size 24
                , Font.semiBold
                , Font.color (rgb255 30 41 59)
                ]
                (text "Paragraph Two")

            , column
                [ spacing 16
                , Font.size 16
                , Font.color (rgb255 71 85 105)
                ]
                [ el [] (text "This is the second paragraph. Totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.")
                , el [] (text "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.")
                , el [] (text "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.")
                ]

            , Input.button
                [ Font.size 14
                , Font.color (rgb255 220 38 38)
                , Font.medium
                , paddingXY 12 8
                , Border.rounded 6
                , Background.color (rgb255 254 242 242)
                , Border.width 1
                , Border.color (rgb255 254 226 226)
                ]
                { onPress = Just ScrollToParagraphOne
                , label = text "Click me to scroll back to Paragraph One ↑"
                }
            ]

        , -- Add space at the bottom
          el [ height (px 400) ] (text "")
        ]