module Anim.Engine.Sub.DiscreteExitSpec exposing (suite)

{-| Render-level assertions for discrete exit behavior in
`Anim.Engine.Sub`.

These tests assert the inline styles emitted by `Sub.attributes`.

-}

import Anim.Engine.Sub as Sub
import Anim.Property.Opacity as Opacity
import Html
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


rendered : Sub.AnimState -> Query.Single msg
rendered state =
    Html.div (Sub.attributes "el" state) []
        |> Query.fromHtml


suite : Test
suite =
    describe "Anim.Engine.Sub discrete exit behavior"
        [ test "local discrete exit keeps the start value inline while the animation is running" <|
            \_ ->
                Sub.init []
                    |> (\state ->
                            Sub.animate state <|
                                Sub.for "el"
                                    >> Sub.discreteExit "display" "block" "none"
                                    >> Opacity.begin
                                    >> Opacity.to 0
                                    >> Opacity.duration 500
                                    >> Opacity.end
                       )
                    |> rendered
                    |> Query.has [ Selector.style "display" "block" ]
        , test "discrete exit with no duration applies the exit value immediately" <|
            \_ ->
                Sub.init []
                    |> (\state ->
                            Sub.animate state <|
                                Sub.for "el"
                                    >> Sub.discreteExit "display" "block" "none"
                                    >> Opacity.begin
                                    >> Opacity.to 0
                                    >> Opacity.end
                       )
                    |> rendered
                    |> Query.has [ Selector.style "display" "none" ]
        ]
