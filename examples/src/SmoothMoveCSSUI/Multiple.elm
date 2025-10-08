module SmoothMoveCSSUI.Multiple exposing (main)

{-| 
SmoothMoveCSS Multiple Example using ElmUI - Multiple elements with native CSS transitions

This demonstrates hardware-accelerated animations for multiple elements simultaneously
using browser-native CSS transitions for optimal performance and battery efficiency.

FEATURES:
- ✅ Multiple hardware-accelerated animations
- ✅ Native browser optimization for each element
- ✅ Battery efficient simultaneous transitions
- ✅ Formation patterns with CSS-native easing
- ✅ Zero JavaScript animation overhead
- ✅ Auto-scaling based on device performance
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
        -- Initialize with starting positions to prevent jump to (0,0)
        initialAnimations =
            SmoothMoveCSS.init
                |> SmoothMoveCSS.setInitialPosition "element-a" 150 100
                |> SmoothMoveCSS.setInitialPosition "element-b" 200 150
                |> SmoothMoveCSS.setInitialPosition "element-c" 100 200
                |> SmoothMoveCSS.setInitialPosition "element-d" 250 200
                |> SmoothMoveCSS.setInitialPosition "element-e" 300 100
                |> SmoothMoveCSS.setInitialPosition "element-f" 180 50
    in
    ( { animations = initialAnimations }
    , Cmd.none
    )


-- UPDATE


type Msg
    = ScatterElements
    | ResetPositions
    | CircleFormation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ScatterElements ->
            let
                newAnimations =
                    model.animations
                        |> SmoothMoveCSS.animateTo "element-a" 320 80
                        |> SmoothMoveCSS.animateTo "element-b" 80 280
                        |> SmoothMoveCSS.animateTo "element-c" 280 220
                        |> SmoothMoveCSS.animateTo "element-d" 400 180
                        |> SmoothMoveCSS.animateTo "element-e" 60 120
                        |> SmoothMoveCSS.animateTo "element-f" 350 320
            in
            ( { model | animations = newAnimations }, Cmd.none )

        ResetPositions ->
            let
                newAnimations =
                    model.animations
                        |> SmoothMoveCSS.animateTo "element-a" 150 100
                        |> SmoothMoveCSS.animateTo "element-b" 200 150
                        |> SmoothMoveCSS.animateTo "element-c" 100 200
                        |> SmoothMoveCSS.animateTo "element-d" 250 200
                        |> SmoothMoveCSS.animateTo "element-e" 300 100
                        |> SmoothMoveCSS.animateTo "element-f" 180 50
            in
            ( { model | animations = newAnimations }, Cmd.none )

        CircleFormation ->
            let
                centerX = 225
                centerY = 180
                radius = 90
                -- 6 elements evenly spaced around circle (60 degrees apart)
                newAnimations =
                    model.animations
                        |> SmoothMoveCSS.animateTo "element-a" (centerX + radius) centerY  -- 0°
                        |> SmoothMoveCSS.animateTo "element-b" (centerX + radius * 0.5) (centerY + radius * 0.866)  -- 60°
                        |> SmoothMoveCSS.animateTo "element-c" (centerX - radius * 0.5) (centerY + radius * 0.866)  -- 120°
                        |> SmoothMoveCSS.animateTo "element-d" (centerX - radius) centerY  -- 180°
                        |> SmoothMoveCSS.animateTo "element-e" (centerX - radius * 0.5) (centerY - radius * 0.866)  -- 240°
                        |> SmoothMoveCSS.animateTo "element-f" (centerX + radius * 0.5) (centerY - radius * 0.866)  -- 300°
            in
            ( { model | animations = newAnimations }, Cmd.none )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none  -- No subscriptions needed for CSS transitions!


-- VIEW


view : Model -> Document Msg
view model =
    { title = "SmoothMoveCSS Multiple ElmUI Example"
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
    let
        positionA = SmoothMoveCSS.getPosition "element-a" model.animations
                   |> Maybe.withDefault { x = 150, y = 100 }
        positionB = SmoothMoveCSS.getPosition "element-b" model.animations
                   |> Maybe.withDefault { x = 200, y = 150 }
        positionC = SmoothMoveCSS.getPosition "element-c" model.animations
                   |> Maybe.withDefault { x = 100, y = 200 }
        positionD = SmoothMoveCSS.getPosition "element-d" model.animations
                   |> Maybe.withDefault { x = 250, y = 200 }
        positionE = SmoothMoveCSS.getPosition "element-e" model.animations
                   |> Maybe.withDefault { x = 300, y = 100 }
        positionF = SmoothMoveCSS.getPosition "element-f" model.animations
                   |> Maybe.withDefault { x = 180, y = 50 }

        cssStylesA = SmoothMoveCSS.cssTransitionStyle "element-a" model.animations
        cssStylesB = SmoothMoveCSS.cssTransitionStyle "element-b" model.animations
        cssStylesC = SmoothMoveCSS.cssTransitionStyle "element-c" model.animations
        cssStylesD = SmoothMoveCSS.cssTransitionStyle "element-d" model.animations
        cssStylesE = SmoothMoveCSS.cssTransitionStyle "element-e" model.animations
        cssStylesF = SmoothMoveCSS.cssTransitionStyle "element-f" model.animations
    in
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
            (text "SmoothMoveCSS Multiple Example")

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
            ]
            [ paragraph
                [ Font.size 16
                , Font.color (rgb255 71 85 105)
                , width fill
                ]
                [ text "This example demonstrates the SmoothMoveCSS module coordinating "
                , el [ Font.semiBold ] (text "multiple CSS transitions")
                , text " simultaneously. Each element uses native browser optimization with "
                , el [ Font.semiBold ] (text "hardware acceleration")
                , text ", eliminating animation frame subscriptions while maintaining smooth formation control."
                ]

            , paragraph
                [ Font.size 16
                , Font.color (rgb255 71 85 105)
                , width fill
                ]
                [ text "Perfect for complex multi-element choreography where "
                , el [ Font.semiBold ] (text "battery efficiency")
                , text " and native performance are critical requirements."
                ]
            ]

        , -- Element status and positions (6 elements in 2 rows)
          column
            [ spacing 20
            , centerX
            ]
            [ row
                [ spacing 25
                , centerX
                ]
                [ column
                    [ spacing 6 ]
                    [ el [ Font.size 14, Font.medium, Font.color (rgb255 59 130 246) ] (text "A")
                    , el [ Font.size 10, Font.color (rgb255 107 114 128) ]
                        (text ("(" ++ String.fromInt (round positionA.x) ++ "," ++ String.fromInt (round positionA.y) ++ ")"))
                    ]

                , column
                    [ spacing 6 ]
                    [ el [ Font.size 14, Font.medium, Font.color (rgb255 16 185 129) ] (text "B")
                    , el [ Font.size 10, Font.color (rgb255 107 114 128) ]
                        (text ("(" ++ String.fromInt (round positionB.x) ++ "," ++ String.fromInt (round positionB.y) ++ ")"))
                    ]

                , column
                    [ spacing 6 ]
                    [ el [ Font.size 14, Font.medium, Font.color (rgb255 168 85 247) ] (text "C")
                    , el [ Font.size 10, Font.color (rgb255 107 114 128) ]
                        (text ("(" ++ String.fromInt (round positionC.x) ++ "," ++ String.fromInt (round positionC.y) ++ ")"))
                    ]
                ]

            , row
                [ spacing 25
                , centerX
                ]
                [ column
                    [ spacing 6 ]
                    [ el [ Font.size 14, Font.medium, Font.color (rgb255 245 101 101) ] (text "D")
                    , el [ Font.size 10, Font.color (rgb255 107 114 128) ]
                        (text ("(" ++ String.fromInt (round positionD.x) ++ "," ++ String.fromInt (round positionD.y) ++ ")"))
                    ]

                , column
                    [ spacing 6 ]
                    [ el [ Font.size 14, Font.medium, Font.color (rgb255 251 146 60) ] (text "E")
                    , el [ Font.size 10, Font.color (rgb255 107 114 128) ]
                        (text ("(" ++ String.fromInt (round positionE.x) ++ "," ++ String.fromInt (round positionE.y) ++ ")"))
                    ]

                , column
                    [ spacing 6 ]
                    [ el [ Font.size 14, Font.medium, Font.color (rgb255 34 197 94) ] (text "F")
                    , el [ Font.size 10, Font.color (rgb255 107 114 128) ]
                        (text ("(" ++ String.fromInt (round positionF.x) ++ "," ++ String.fromInt (round positionF.y) ++ ")"))
                    ]
                ]
            ]

        , -- Control buttons
          row
            [ spacing 15
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
                , paddingXY 20 12
                , Border.rounded 8
                ]
                { onPress = Just ScatterElements
                , label = text "Scatter"
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
                , paddingXY 20 12
                , Border.rounded 8
                ]
                { onPress = Just CircleFormation
                , label = text "Circle Formation"
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
                , paddingXY 20 12
                , Border.rounded 8
                ]
                { onPress = Just ResetPositions
                , label = text "Reset"
                }
            ]

        , -- Animation area with moving elements
          el
            [ width (px 500)
            , height (px 400)
            , centerX
            , Background.color (rgb255 255 255 255)
            , Border.rounded 12
            , Border.shadow
                { offset = (0, 4)
                , size = 0
                , blur = 8
                , color = Element.rgba 0 0 0 0.1
                }
            , htmlAttribute (Html.Attributes.style "position" "relative")
            , htmlAttribute (Html.Attributes.style "overflow" "hidden")
            ]
            (Element.html
                (Html.div
                    [ Html.Attributes.style "position" "relative"
                    , Html.Attributes.style "width" "100%"
                    , Html.Attributes.style "height" "100%"
                    ]
                    [ -- Element A (Blue) - CSS transition managed
                      Html.div
                        [ Html.Attributes.id "element-a"
                        , Html.Attributes.style "position" "absolute"
                        , Html.Attributes.style "width" "50px"
                        , Html.Attributes.style "height" "50px"
                        , Html.Attributes.style "background" "linear-gradient(135deg, #3B82F6, #2563EB)"
                        , Html.Attributes.style "border-radius" "12px"
                        , Html.Attributes.style "transform" ("translate(" ++ String.fromFloat positionA.x ++ "px, " ++ String.fromFloat positionA.y ++ "px)")
                        , Html.Attributes.style "transition" cssStylesA
                        , Html.Attributes.style "display" "flex"
                        , Html.Attributes.style "align-items" "center"
                        , Html.Attributes.style "justify-content" "center"
                        , Html.Attributes.style "color" "white"
                        , Html.Attributes.style "font-weight" "600"
                        , Html.Attributes.style "font-size" "16px"
                        ]
                        [ Html.text "A" ]

                    , -- Element B (Green) - CSS transition managed
                      Html.div
                        [ Html.Attributes.id "element-b"
                        , Html.Attributes.style "position" "absolute"
                        , Html.Attributes.style "width" "50px"
                        , Html.Attributes.style "height" "50px"
                        , Html.Attributes.style "background" "linear-gradient(135deg, #10B981, #059669)"
                        , Html.Attributes.style "border-radius" "12px"
                        , Html.Attributes.style "transform" ("translate(" ++ String.fromFloat positionB.x ++ "px, " ++ String.fromFloat positionB.y ++ "px)")
                        , Html.Attributes.style "transition" cssStylesB
                        , Html.Attributes.style "display" "flex"
                        , Html.Attributes.style "align-items" "center"
                        , Html.Attributes.style "justify-content" "center"
                        , Html.Attributes.style "color" "white"
                        , Html.Attributes.style "font-weight" "600"
                        , Html.Attributes.style "font-size" "16px"
                        ]
                        [ Html.text "B" ]

                    , -- Element C (Purple) - CSS transition managed
                      Html.div
                        [ Html.Attributes.id "element-c"
                        , Html.Attributes.style "position" "absolute"
                        , Html.Attributes.style "width" "50px"
                        , Html.Attributes.style "height" "50px"
                        , Html.Attributes.style "background" "linear-gradient(135deg, #A855F7, #9333EA)"
                        , Html.Attributes.style "border-radius" "12px"
                        , Html.Attributes.style "transform" ("translate(" ++ String.fromFloat positionC.x ++ "px, " ++ String.fromFloat positionC.y ++ "px)")
                        , Html.Attributes.style "transition" cssStylesC
                        , Html.Attributes.style "display" "flex"
                        , Html.Attributes.style "align-items" "center"
                        , Html.Attributes.style "justify-content" "center"
                        , Html.Attributes.style "color" "white"
                        , Html.Attributes.style "font-weight" "600"
                        , Html.Attributes.style "font-size" "16px"
                        ]
                        [ Html.text "C" ]

                    , -- Element D (Orange) - CSS transition managed
                      Html.div
                        [ Html.Attributes.id "element-d"
                        , Html.Attributes.style "position" "absolute"
                        , Html.Attributes.style "width" "50px"
                        , Html.Attributes.style "height" "50px"
                        , Html.Attributes.style "background" "linear-gradient(135deg, #F97316, #EA580C)"
                        , Html.Attributes.style "border-radius" "12px"
                        , Html.Attributes.style "transform" ("translate(" ++ String.fromFloat positionD.x ++ "px, " ++ String.fromFloat positionD.y ++ "px)")
                        , Html.Attributes.style "transition" cssStylesD
                        , Html.Attributes.style "display" "flex"
                        , Html.Attributes.style "align-items" "center"
                        , Html.Attributes.style "justify-content" "center"
                        , Html.Attributes.style "color" "white"
                        , Html.Attributes.style "font-weight" "600"
                        , Html.Attributes.style "font-size" "16px"
                        ]
                        [ Html.text "D" ]

                    , -- Element E (Red) - CSS transition managed
                      Html.div
                        [ Html.Attributes.id "element-e"
                        , Html.Attributes.style "position" "absolute"
                        , Html.Attributes.style "width" "50px"
                        , Html.Attributes.style "height" "50px"
                        , Html.Attributes.style "background" "linear-gradient(135deg, #EF4444, #DC2626)"
                        , Html.Attributes.style "border-radius" "12px"
                        , Html.Attributes.style "transform" ("translate(" ++ String.fromFloat positionE.x ++ "px, " ++ String.fromFloat positionE.y ++ "px)")
                        , Html.Attributes.style "transition" cssStylesE
                        , Html.Attributes.style "display" "flex"
                        , Html.Attributes.style "align-items" "center"
                        , Html.Attributes.style "justify-content" "center"
                        , Html.Attributes.style "color" "white"
                        , Html.Attributes.style "font-weight" "600"
                        , Html.Attributes.style "font-size" "16px"
                        ]
                        [ Html.text "E" ]

                    , -- Element F (Pink) - CSS transition managed
                      Html.div
                        [ Html.Attributes.id "element-f"
                        , Html.Attributes.style "position" "absolute"
                        , Html.Attributes.style "width" "50px"
                        , Html.Attributes.style "height" "50px"
                        , Html.Attributes.style "background" "linear-gradient(135deg, #EC4899, #DB2777)"
                        , Html.Attributes.style "border-radius" "12px"
                        , Html.Attributes.style "transform" ("translate(" ++ String.fromFloat positionF.x ++ "px, " ++ String.fromFloat positionF.y ++ "px)")
                        , Html.Attributes.style "transition" cssStylesF
                        , Html.Attributes.style "display" "flex"
                        , Html.Attributes.style "align-items" "center"
                        , Html.Attributes.style "justify-content" "center"
                        , Html.Attributes.style "color" "white"
                        , Html.Attributes.style "font-weight" "600"
                        , Html.Attributes.style "font-size" "16px"
                        ]
                        [ Html.text "F" ]
                    ]
                )
            )
        ]