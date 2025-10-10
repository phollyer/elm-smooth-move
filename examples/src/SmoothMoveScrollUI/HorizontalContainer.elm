module SmoothMoveScrollUI.HorizontalContainer exposing (main)

import Browser exposing (Document)
import Browser.Dom
import Element exposing (Element, row, column, el, layout, maximum, paddingXY, paddingEach, rgb255, spacing, text, width, fill, centerX, centerY, htmlAttribute, height, px, link, alignLeft, padding, paragraph, scrollbarX, clipX)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import SmoothMoveScroll exposing (animateToCmdWithConfig, containerElement, defaultConfig, setContainer, Axis(..))
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
    | ScrollToCard Int
    | ScrollToStart


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ScrollToCard cardNum ->
            ( model
            , animateToCmdWithConfig NoOp 
                { defaultConfig 
                | speed = 25
                , axis = X 
                , container = containerElement "horizontal-scroll-container"
                } 
                ("card-" ++ String.fromInt cardNum)
            )

        ScrollToStart ->
            ( model
            , animateToCmdWithConfig NoOp 
                { defaultConfig 
                | speed = 25
                , axis = X 
                , container = containerElement "horizontal-scroll-container"
                } 
                "card-1"
            )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


-- VIEW


view : Model -> Document Msg
view model =
    { title = "SmoothMoveScroll Horizontal Container ElmUI Example"
    , body = 
        [ Html.node "style" [] [ Html.text containerCSS ]
        , layout
            [ Background.gradient
                { angle = 0
                , steps = 
                    [ rgb255 248 250 252
                    , rgb255 226 232 240
                    ]
                }
            , paddingXY 40 20
            , width fill
            , htmlAttribute (Html.Attributes.class "container-layout responsive-layout")
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
        , paddingEach { top = 0, right = 0, bottom = 100, left = 0 }
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
                [ Font.size 28
                , Font.semiBold
                , Font.color (rgb255 30 41 59)
                , centerX
                ]
                (text "Horizontal Container Scrolling")

            , -- Description
              column
                [ spacing 16
                , width (maximum 900 fill)
                , centerX
                , paddingXY 24 20
                , Background.color (rgb255 248 250 252)
                , Border.rounded 8
                , Border.solid
                , Border.width 1
                , Border.color (rgb255 226 232 240)
                ]
                [ paragraph
                    [ Font.size 16
                    , Font.color (rgb255 71 85 105)
                    , width fill
                    ]
                    [ text "This example demonstrates "
                    , el [ Font.semiBold ] (text "horizontal container scrolling")
                    , text " using "
                    , el [ Font.semiBold ] (text "{ axis = X, container = containerElement \"scroll-container\" }")
                    , text ". The scrolling is constrained to a specific container element rather than the entire document."
                    ]

                , paragraph
                    [ Font.size 16
                    , Font.color (rgb255 71 85 105)
                    , width fill
                    ]
                    [ text "The smooth animation works reliably using the new SmoothMoveScroll API with ElmUI. "
                    , text "Each card scrolls smoothly into view within the horizontal container."
                    ]
                ]
            ]

        , -- Navigation Buttons
          column
            [ spacing 16
            , centerX
            ]
            [ row
                [ spacing 12
                , centerX
                , htmlAttribute (Html.Attributes.class "nav-buttons-row")
                ]
                (List.range 1 8
                    |> List.map (\i ->
                        Input.button
                            [ Background.gradient
                                { angle = 0
                                , steps = 
                                    [ getCardColor i
                                    , darkenColor (getCardColor i)
                                    ]
                                }
                            , Font.color (rgb255 255 255 255)
                            , Font.medium
                            , paddingXY 16 8
                            , Border.rounded 6
                            , Font.size 14
                            ]
                            { onPress = Just (ScrollToCard i)
                            , label = text ("Card " ++ String.fromInt i)
                            }
                    )
                )

            , Input.button
                [ Background.color (rgb255 107 114 128)
                , Font.color (rgb255 255 255 255)
                , Font.medium
                , paddingXY 20 12
                , Border.rounded 6
                , centerX
                ]
                { onPress = Just ScrollToStart
                , label = text "← Back to Start"
                }
            ]

        , -- Horizontal Scroll Container
          el
            [ width fill
            , height (px 400)
            , Background.color (rgb255 255 255 255)
            , Border.rounded 12
            , Border.shadow
                { offset = (0, 4)
                , size = 0
                , blur = 8
                , color = Element.rgba 0 0 0 0.15
                }
            , htmlAttribute (Html.Attributes.id "horizontal-scroll-container")
            , htmlAttribute (Html.Attributes.class "scroll-container")
            , scrollbarX
            , clipX
            ]
            (row
                [ spacing 20
                , paddingXY 30 30
                , htmlAttribute (Html.Attributes.style "width" "2000px")
                ]
                (List.range 1 10
                    |> List.map viewCard
                )
            )
        ]


viewCard : Int -> Element Msg
viewCard cardNum =
    column
        [ width (px 280)
        , height (px 320)
        , spacing 16
        , htmlAttribute (Html.Attributes.id ("card-" ++ String.fromInt cardNum))
        , Background.color (getCardColor cardNum)
        , paddingXY 24 20
        , Border.rounded 12
        , Border.shadow
            { offset = (0, 2)
            , size = 0
            , blur = 4
            , color = Element.rgba 0 0 0 0.1
            }
        ]
        [ -- Card Header
          el
            [ Font.size 20
            , Font.semiBold
            , Font.color (rgb255 255 255 255)
            , centerX
            ]
            (text ("Card " ++ String.fromInt cardNum))

        , -- Card Content
          column
            [ spacing 12
            , width fill
            , height fill
            ]
            [ paragraph
                [ Font.size 14
                , Font.color (rgb255 255 255 255)
                , width fill
                ]
                [ text ("This is card number " ++ String.fromInt cardNum ++ ". ") 
                , text "Each card demonstrates horizontal scrolling within a constrained container element."
                ]

            , paragraph
                [ Font.size 14
                , Font.color (rgb255 255 255 255)
                , width fill
                ]
                [ text "The X axis scrolling smoothly navigates between cards using precise positioning calculations."
                ]

            , -- Navigation buttons within card
            row
                [ spacing 8
                , centerX
                ]
                [ if cardNum > 1 then
                    Input.button
                        [ Font.size 12
                        , Font.color (rgb255 255 255 255)
                        , Font.medium
                        , paddingXY 12 6
                        , Border.rounded 4
                        , Background.color (Element.rgba 255 255 255 0.2)
                        , Border.width 1
                        , Border.color (Element.rgba 255 255 255 0.3)
                        ]
                        { onPress = Just (ScrollToCard (cardNum - 1))
                        , label = text "← Prev"
                        }
                  else
                    el [] (text "")

                , if cardNum < 10 then
                    Input.button
                        [ Font.size 12
                        , Font.color (rgb255 255 255 255)
                        , Font.medium
                        , paddingXY 12 6
                        , Border.rounded 4
                        , Background.color (Element.rgba 255 255 255 0.2)
                        , Border.width 1
                        , Border.color (Element.rgba 255 255 255 0.3)
                        ]
                        { onPress = Just (ScrollToCard (cardNum + 1))
                        , label = text "Next →"
                        }
                  else
                    el [] (text "")
                ]
            ]
        ]


getCardColor : Int -> Element.Color
getCardColor cardNum =
    case modBy 8 cardNum + 1 of
        1 -> rgb255 59 130 246   -- Blue
        2 -> rgb255 16 185 129   -- Green
        3 -> rgb255 168 85 247   -- Purple
        4 -> rgb255 245 101 101  -- Red
        5 -> rgb255 251 146 60   -- Orange
        6 -> rgb255 14 165 233   -- Sky Blue
        7 -> rgb255 139 92 246   -- Violet
        _ -> rgb255 34 197 94    -- Emerald


darkenColor : Element.Color -> Element.Color
darkenColor color =
    let
        rgb = Element.toRgb color
    in
    rgb255 
        (round (rgb.red * 255 * 0.8))
        (round (rgb.green * 255 * 0.8))
        (round (rgb.blue * 255 * 0.8))


containerCSS : String
containerCSS =
    """
    .container-layout {
        min-height: 100vh;
    }

    .scroll-container {
        overflow-x: auto !important;
        overflow-y: auto !important;
        scrollbar-width: thin;
        scrollbar-color: #CBD5E0 #F7FAFC;
    }

    .scroll-container::-webkit-scrollbar {
        height: 10px;
    }

    .scroll-container::-webkit-scrollbar-track {
        background: #F7FAFC;
        border-radius: 5px;
    }

    .scroll-container::-webkit-scrollbar-thumb {
        background: #CBD5E0;
        border-radius: 5px;
    }

    .scroll-container::-webkit-scrollbar-thumb:hover {
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
        
        .container-layout {
            padding: 10px 15px;
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
        
        .container-layout {
            padding: 10px;
        }
    }
    """