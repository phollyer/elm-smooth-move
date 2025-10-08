module SmoothMoveSubUI.Basic exposing (main)

{-| 
This example demonstrates SmoothMoveSub using ElmUI - subscription-based positioning with automatic state management.

BENEFITS:
- ✅ No need to track AnimationState in your model
- ✅ No need to track element positions in your model  
- ✅ No need to handle animation completion manually
- ✅ No need to pass Position data around in messages
- ✅ Library manages ALL state automatically
- ✅ Simple animateTo and subscriptions calls
- ✅ Get positions with transform when needed

DEVELOPER EXPERIENCE:
- Keep only a SmoothMoveSub.Model in your model
- Call animateTo to begin animations (automatic current position)
- Subscribe with SmoothMoveSub.subscriptions for smooth updates (just deltaMs!)
- Use transform for CSS transforms with getPosition!
- Use getPosition when you need the actual position values
- Library handles everything else automatically!
-}

import Browser exposing (Document)
import Element exposing (Element, column, el, layout, maximum, paddingXY, rgb255, spacing, text, width, fill, centerX, htmlAttribute, height, px, moveUp, moveDown, link, alignLeft, padding, paragraph)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import SmoothMoveSub exposing (animateTo, subscriptions, transform, getPosition, isAnimating, setInitialPosition, init)


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
    { smoothMove : SmoothMoveSub.Model
    }


-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( { smoothMove = SmoothMoveSub.init }
    , Cmd.none
    )


-- UPDATE


type Msg
    = StartMove Float Float
    | AnimationFrame Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartMove x y ->
            let
                updatedSmoothMove =
                    animateTo "moving-box" x y model.smoothMove
            in
            ( { model | smoothMove = updatedSmoothMove }, Cmd.none )

        AnimationFrame deltaMs ->
            let
                updatedSmoothMove =
                    SmoothMoveSub.step deltaMs model.smoothMove
            in
            ( { model | smoothMove = updatedSmoothMove }, Cmd.none )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    SmoothMoveSub.subscriptions model.smoothMove AnimationFrame


-- VIEW


view : Model -> Document Msg
view model =
    { title = "SmoothMoveSub Basic ElmUI Example"
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
    let
        position = getPosition "moving-box" model.smoothMove |> Maybe.withDefault { x = 0, y = 0 }
        isMoving = isAnimating model.smoothMove
    in
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
            (text "SmoothMoveSub Basic Example")

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
                [ text "This example demonstrates the SmoothMoveSub module, which provides "
                , el [ Font.semiBold ] (text "subscription-based positioning")
                , text " with frame-rate independent animations. It offers "
                , el [ Font.semiBold ] (text "real-time updates")
                , text " via onAnimationFrameDelta subscriptions, ensuring smooth element transitions across different device capabilities."
                ]

            , paragraph
                [ Font.size 16
                , Font.color (rgb255 71 85 105)
                , width fill
                ]
                [ text "Perfect for applications requiring "
                , el [ Font.semiBold ] (text "precise timing control")
                , text " and multiple simultaneous animations with automatic state management."
                ]
            ]

        , -- Position display
          el
            [ Font.size 14
            , Font.color (rgb255 107 114 128)
            , centerX
            ]
            (text ("Position: (" ++ String.fromInt (round position.x) ++ ", " ++ String.fromInt (round position.y) ++ ")"))

        , -- Buttons for predefined moves
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
                { onPress = Just (StartMove 100 100)
                , label = text "Move to (100, 100)"
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
                { onPress = Just (StartMove 300 200)
                , label = text "Move to (300, 200)"
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
                { onPress = Just (StartMove 0 0)
                , label = text "Return to Origin"
                }
            ]

        , -- Animation area with moving box
          el
            [ width (fill |> maximum 500)
            , height (px 400)
            , Background.color (rgb255 255 255 255)
            , Border.rounded 12
            , Border.shadow
                { offset = (0, 4)
                , size = 0
                , blur = 8
                , color = Element.rgba 0 0 0 0.1
                }
            , centerX
            , htmlAttribute (Html.Attributes.style "position" "relative")
            , htmlAttribute (Html.Attributes.style "overflow" "hidden")
            , htmlAttribute (Html.Attributes.class "responsive-animation-container")
            ]
            (el
                [ width (px 50)
                , height (px 50)
                , Background.color (rgb255 59 130 246)
                , Border.rounded 8
                , htmlAttribute (Html.Attributes.id "moving-box")
                , htmlAttribute (Html.Attributes.style "position" "absolute")
                , htmlAttribute (Html.Attributes.style "transform" (transform position.x position.y))
                , htmlAttribute (Html.Attributes.style "transition" "none")
                ]
                (text "")
            )
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
        font-size: 32px;
        line-height: 1.2;
        margin-bottom: 30px;
    }
    
    .responsive-tech-info {
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 16px;
        margin-bottom: 30px;
    }
    
    .responsive-buttons {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-bottom: 30px;
    }
    
    .responsive-buttons > * {
        min-height: 44px;
        min-width: 44px;
    }
    
    .responsive-paragraph {
        line-height: 1.6;
        margin-bottom: 20px;
    }
    
    .responsive-animation-container {
        max-width: 100%;
        min-width: 300px;
    }
    
    /* Tablet breakpoint */
    @media (max-width: 768px) {
        .responsive-layout {
            padding: 16px;
        }
        
        .responsive-header {
            font-size: 24px;
            margin-bottom: 24px;
        }
        
        .responsive-tech-info {
            padding: 12px;
            margin-bottom: 24px;
        }
        
        .responsive-buttons {
            margin-bottom: 24px;
        }
        
        .responsive-paragraph {
            margin-bottom: 16px;
        }
        
        .responsive-animation-container {
            height: 300px !important;
        }
    }
    
    /* Mobile breakpoint */
    @media (max-width: 480px) {
        .responsive-layout {
            padding: 12px;
        }
        
        .responsive-header {
            font-size: 20px;
            margin-bottom: 20px;
        }
        
        .responsive-tech-info {
            padding: 10px;
            margin-bottom: 20px;
        }
        
        .responsive-buttons {
            margin-bottom: 20px;
        }
        
        .responsive-paragraph {
            margin-bottom: 14px;
        }
        
        .responsive-animation-container {
            height: 250px !important;
            min-width: 280px;
        }
    }
    </style>
    """