module SmoothMoveScrollUI.HorizontalContainer exposing (main)

import Browser exposing (Document)
import Element exposing (Element, row, column, el, paddingXY, paddingEach, rgb255, spacing, text, width, fill, centerX, htmlAttribute, height, px, padding, paragraph, scrollbarX, clipX)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import SmoothMoveScroll exposing (animateToCmdWithConfig, containerElement, defaultConfig, Axis(..))
import Common.UI as UI
import Common.Colors as Colors


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
    UI.createDocument "SmoothMoveScroll Horizontal Container ElmUI Example" UI.HorizontalContainer (viewContent model)


viewContent : Model -> List (Element Msg)
viewContent model =
    [ -- Header Section
      column
        [ width fill
        , spacing 20
        , centerX
        ]
        [ UI.backButton
        , UI.pageHeader "Horizontal Container Scrolling"
        , UI.techInfo 
            [ paragraph []
                [ text "This example demonstrates "
                , el [ Font.semiBold ] (text "horizontal container scrolling")
                , text " using "
                , el [ Font.semiBold ] (text "{ axis = X, container = containerElement \"scroll-container\" }")
                , text ". The scrolling is constrained to a specific container element rather than the entire document."
                ]
            , paragraph []
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
                                [ UI.getCardColor i
                                , UI.darkenColor (UI.getCardColor i)
                                ]
                            }
                        , Font.color Colors.backgroundWhite
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

        , UI.actionButton UI.Primary ScrollToStart "← Back to Start"
        ]

    , -- Horizontal Scroll Container
      el
        [ width fill
        , height (px 400)
        , Background.color Colors.backgroundWhite
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
        , Background.color (UI.getCardColor cardNum)
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
            , Font.color Colors.backgroundWhite
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
                , Font.color Colors.backgroundWhite
                , width fill
                ]
                [ text ("This is card number " ++ String.fromInt cardNum ++ ". ") 
                , text "Each card demonstrates horizontal scrolling within a constrained container element."
                ]

            , paragraph
                [ Font.size 14
                , Font.color Colors.backgroundWhite
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
                        , Font.color Colors.backgroundWhite
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
                        , Font.color Colors.backgroundWhite
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

