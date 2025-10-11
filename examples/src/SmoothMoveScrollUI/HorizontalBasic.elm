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
import SmoothMoveScroll exposing (animateToCmd, animateToTask, animateToCmdWithConfig, defaultConfig, Axis(..))
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
    UI.createDocument "SmoothMoveScroll Horizontal ElmUI Example" UI.Horizontal (viewContent model)


viewContent : Model -> List (Element Msg)
viewContent model =
        [ -- Back Button
          UI.backButton

        , -- Header
          UI.pageHeader "Horizontal X Axis Scrolling"

            , -- Technical Info
              UI.techInfo
                [ UI.techParagraph
                    [ text "This example demonstrates "
                    , UI.highlight "X axis scrolling"
                    , text " using "
                    , UI.highlight "{ axis = X }"
                    , text " configuration. The sections scroll horizontally instead of vertically, creating a smooth left-to-right navigation experience."
                    ]

                , UI.techParagraph
                    [ text "Perfect for horizontal layouts, carousels, and side-scrolling interfaces where content flows naturally from left to right."
                    ]
                ]

            , -- Navigation Buttons
              UI.htmlActionButtons
                [ ( UI.Primary, ScrollToStart, "Start" )
                , ( UI.Success, ScrollToSectionOne, "Section 1" )
                , ( UI.Purple, ScrollToSectionTwo, "Section 2" )
                , ( UI.Warning, ScrollToSectionThree, "Section 3" )
                ]

        , -- Horizontal Content Container (move scrolling to document level)
          row
            [ spacing 40
            , paddingXY 20 20
            , htmlAttribute (Html.Attributes.style "width" "300vw")
            , htmlAttribute (Html.Attributes.class "horizontal-content-row")
            ]
                [ -- Start Section
                  viewSection "start" "🚀 Start Here" Colors.primary ScrollToSectionOne "Begin Journey →"
                    [ "Welcome to the horizontal scrolling demonstration!"
                    , "This is the starting point of our X axis scrolling example."
                    , "Click the button below to begin the horizontal journey through the sections."
                    ]

                , -- Section One
                  viewSection "section-one" "Section One" Colors.primary ScrollToSectionTwo "Continue to Section Two →"
                    [ "This is the first section of our horizontal scrolling example."
                    , "Notice how the scroll animation moves left-to-right instead of up-and-down."
                    , "The X axis configuration makes this possible with smooth horizontal movement."
                    ]

                , -- Section Two  
                  viewSection "section-two" "Section Two" Colors.success ScrollToSectionThree "Continue to Section Three →"
                    [ "Welcome to the second section! The horizontal scrolling continues smoothly."
                    , "Each section is positioned side-by-side in a horizontal layout."
                    , "The animation automatically calculates the correct X position for each target."
                    ]

                , -- Section Three
                  viewSection "section-three" "Section Three" Colors.purple ScrollToStart "Back to Start ←"
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
        , Background.color Colors.backgroundWhite
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
                    , Font.color Colors.textMedium
                    , width fill
                    ]
                    [ text line ]
            ) contentLines)

        , -- Navigation Button
          UI.smallActionButton UI.Primary nextAction buttonText
        ]


