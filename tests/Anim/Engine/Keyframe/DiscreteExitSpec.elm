module Anim.Engine.Keyframe.DiscreteExitSpec exposing (suite)

{-| Render-level assertions for discrete exit behavior in
`Anim.Engine.Keyframe`.

These tests assert the inline styles emitted by `Keyframe.attributes`,
ensuring that the start value remains inline while the animation is running.

-}

import Anim.Engine.Keyframe as Keyframe
import Anim.Property.Opacity as Opacity
import Html
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


rendered : Keyframe.AnimState -> Query.Single msg
rendered state =
    Html.div (Keyframe.attributes "el" state) []
        |> Query.fromHtml


suite : Test
suite =
    describe "Anim.Engine.Keyframe discrete exit behavior"
        [ test "local discrete exit keeps the start value inline while the animation is running" <|
            \_ ->
                Keyframe.init []
                    |> (\state ->
                            Keyframe.animate state <|
                                Keyframe.for "el"
                                    >> Keyframe.discreteExit "display" "block" "none"
                                    >> Opacity.begin
                                    >> Opacity.to 0
                                    >> Opacity.duration 500
                                    >> Opacity.end
                       )
                    |> rendered
                    |> Query.has [ Selector.style "display" "block" ]
        , test "discrete exit with no duration applies the exit value immediately" <|
            \_ ->
                Keyframe.init []
                    |> (\state ->
                            Keyframe.animate state <|
                                Keyframe.for "el"
                                    >> Keyframe.discreteExit "display" "block" "none"
                                    >> Opacity.begin
                                    >> Opacity.to 0
                                    >> Opacity.end
                       )
                    |> rendered
                    |> Query.has [ Selector.style "display" "none" ]
        ]
