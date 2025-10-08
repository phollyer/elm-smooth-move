module SmoothMoveTaskUI.Container exposing (main)

import Browser exposing (Document)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import SmoothMoveTask exposing (animateToCmdWithConfig, setContainer, containerElement, defaultConfig)


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { message : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { message = "Ready to scroll within the container" }, Cmd.none )


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
            ( { model | message = "Scrolling to top of container..." }
            , animateToCmdWithConfig NoOp (setContainer "scroll-container" { defaultConfig | speed = 20 }) "top-element"
            )

        ScrollToMiddle ->
            ( { model | message = "Scrolling to middle of container..." }
            , animateToCmdWithConfig NoOp { defaultConfig | container = containerElement "scroll-container", speed = 20 } "middle-element"
            )

        ScrollToBottom ->
            ( { model | message = "Scrolling to bottom of container..." }
            , animateToCmdWithConfig NoOp (setContainer "scroll-container" { defaultConfig | speed = 20 }) "bottom-element"
            )


view : Model -> Document Msg
view model =
    { title = "SmoothMoveTask - Container Scrolling (ElmUI)"
    , body =
        [ Element.layout
            [ Font.family
                [ Font.external
                    { name = "Inter"
                    , url = "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    }
                , Font.sansSerif
                ]
            , Background.color (rgb255 248 250 252)
            , width fill
            , height fill
            ]
            (Element.column
                [ width fill
                , height fill
                , spacing 0
                ]
                [ -- Back button
                  el 
                    [paddingXY 40 20
                    , alignLeft
                    ]
                    <| 
                        link
                            [ padding 12
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
                , -- Main content
                  Element.column
                    [ width fill
                    , height fill
                    , paddingXY 40 20
                    , spacing 30
                    ]
                    [ el
                        [ Font.size 32
                        , Font.bold
                        , Font.color (rgb255 30 41 59)
                        ]
                        (text "Container Scrolling Example")
                    , paragraph
                        [ Font.size 18
                        , Font.color (rgb255 71 85 105)
                        , spacing 8
                        ]
                        [ text "This demonstrates smooth scrolling within a scrollable container (not the document itself) using ElmUI." ]
                    , el
                        [ Font.size 16
                        , Font.color (rgb255 139 69 19)
                        , Font.medium
                        , paddingXY 20 12
                        , Background.color (rgb255 254 243 199)
                        , Border.color (rgb255 245 158 11)
                        , Border.width 1
                        , Border.rounded 8
                        ]
                        (text model.message)

                    -- Control buttons
                    , row
                        [ spacing 15 ]
                        [ Input.button
                            [ Background.gradient
                                { angle = 135
                                , steps =
                                    [ rgb255 116 185 255
                                    , rgb255 9 132 227
                                    ]
                                }
                            , Font.color (rgb255 255 255 255)
                            , Font.semiBold
                            , paddingXY 30 15
                            , Border.rounded 8
                            , mouseOver
                                [ moveUp 2
                                , Border.shadow
                                    { offset = ( 0, 4 )
                                    , size = 0
                                    , blur = 15
                                    , color = rgba255 116 185 255 0.4
                                    }
                                ]
                            ]
                            { onPress = Just ScrollToTop
                            , label = text "Scroll to Top"
                            }
                        , Input.button
                            [ Background.gradient
                                { angle = 135
                                , steps =
                                    [ rgb255 0 184 148
                                    , rgb255 0 160 133
                                    ]
                                }
                            , Font.color (rgb255 255 255 255)
                            , Font.semiBold
                            , paddingXY 30 15
                            , Border.rounded 8
                            , mouseOver
                                [ moveUp 2
                                , Border.shadow
                                    { offset = ( 0, 4 )
                                    , size = 0
                                    , blur = 15
                                    , color = rgba255 0 184 148 0.4
                                    }
                                ]
                            ]
                            { onPress = Just ScrollToMiddle
                            , label = text "Scroll to Middle"
                            }
                        , Input.button
                            [ Background.gradient
                                { angle = 135
                                , steps =
                                    [ rgb255 253 121 168
                                    , rgb255 232 67 147
                                    ]
                                }
                            , Font.color (rgb255 255 255 255)
                            , Font.semiBold
                            , paddingXY 30 15
                            , Border.rounded 8
                            , mouseOver
                                [ moveUp 2
                                , Border.shadow
                                    { offset = ( 0, 4 )
                                    , size = 0
                                    , blur = 15
                                    , color = rgba255 253 121 168 0.4
                                    }
                                ]
                            ]
                            { onPress = Just ScrollToBottom
                            , label = text "Scroll to Bottom"
                            }
                        ]

                    -- The scrollable container
                    , el [ width fill ] <|
                        el
                            [ htmlAttribute (Html.Attributes.id "scroll-container")
                            , width fill
                            , height (px 600)
                            , Border.width 2
                            , Border.color (rgb255 222 226 230)
                            , Border.rounded 12
                            , Background.color (rgb255 255 255 255)
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
                                , spacing 0
                                , paddingXY 30 30
                                ]
                                [ -- Top element
                                  el
                                    [ htmlAttribute (Html.Attributes.id "top-element")
                                    , width fill
                                    , Background.gradient
                                        { angle = 180
                                        , steps =
                                            [ rgb255 255 255 255
                                            , rgb255 240 249 255
                                            ]
                                        }
                                    , Border.color (rgb255 59 130 246)
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
                                            , Font.color (rgb255 30 64 175)
                                            ]
                                            (text "🔝 Top of Container")
                                        , paragraph
                                            [ Font.size 16
                                            , Font.color (rgb255 30 58 138)
                                            , spacing 6
                                            ]
                                            [ text "This is the top of the scrollable container content. The background gradient helps visualize scroll position." ]
                                        , paragraph
                                            [ Font.size 16
                                            , Font.color (rgb255 30 58 138)
                                            , spacing 6
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
                                            [ rgb255 240 253 250
                                            , rgb255 209 250 229
                                            ]
                                        }
                                    , Border.color (rgb255 0 184 148)
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
                                            , Font.color (rgb255 6 95 70)
                                            ]
                                            (text "🎯 Content Block 4 - Middle Target")
                                        , paragraph
                                            [ Font.size 16
                                            , Font.color (rgb255 6 95 70)
                                            , spacing 6
                                            ]
                                            [ text "This is the middle target of our scrollable content - Content block 4 demonstrates the progression through the gradient with ElmUI styling." ]
                                        , paragraph
                                            [ Font.size 16
                                            , Font.color (rgb255 6 95 70)
                                            , spacing 6
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
                                            [ rgb255 254 242 242
                                            , rgb255 239 68 68
                                            ]
                                        }
                                    , Border.color (rgb255 220 38 38)
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
                                            , Font.color (rgb255 153 27 27)
                                            ]
                                            (text "🔻 Bottom of Container")
                                        , paragraph
                                            [ Font.size 16
                                            , Font.color (rgb255 153 27 27)
                                            , spacing 6
                                            ]
                                            [ text "This is the bottom of the scrollable container content. Notice the dark background created with ElmUI gradients." ]
                                        , paragraph
                                            [ Font.size 16
                                            , Font.color (rgb255 153 27 27)
                                            , spacing 6
                                            ]
                                            [ text "Click 'Scroll to Bottom' to smoothly scroll to this position." ]
                                        , paragraph
                                            [ Font.size 16
                                            , Font.color (rgb255 153 27 27)
                                            , spacing 6
                                            ]
                                            [ text "The smooth animation works reliably using the new SmoothMoveTask API with ElmUI." ]
                                        ]
                                    )
                                ]
                            )
                    ]
                ]
            )
        ]
    }


contentBlock : Int -> String -> Element Msg
contentBlock num description =
    el
        [ width fill
        , Background.gradient
            { angle = 180
            , steps =
                [ rgb255 255 255 255
                , rgb255 243 244 246
                ]
            }
        , Border.color (rgb255 209 213 219)
        , Border.width 1
        , Border.rounded 8
        , padding 20
        , spacing 15
        ]
        (Element.column
            [ spacing 12 ]
            [ el
                [ Font.size 20
                , Font.semiBold
                , Font.color (rgb255 55 65 81)
                ]
                (text ("Content Block " ++ String.fromInt num))
            , paragraph
                [ Font.size 16
                , Font.color (rgb255 75 85 99)
                , spacing 6
                ]
                [ text description ]
            , Element.column
                [ spacing 6 ]
                [ bulletPoint "Each block adds to the scrollable height"
                , bulletPoint "The gradient background shows scroll position"
                , bulletPoint "Smooth scrolling animates between positions"
                ]
            ]
        )


bulletPoint : String -> Element msg
bulletPoint text_ =
    row
        [ spacing 8 ]
        [ el
            [ Font.size 14
            , Font.color (rgb255 139 69 19)
            ]
            (text "•")
        , el
            [ Font.size 14
            , Font.color (rgb255 107 114 128)
            ]
            (text text_)
        ]
