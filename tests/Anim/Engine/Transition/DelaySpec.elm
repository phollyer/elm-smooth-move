module Anim.Engine.Transition.DelaySpec exposing (suite)

import Anim.Engine.Transition as Transition
import Anim.Internal.Engine.CSS.CSS as CSS
import Anim.Internal.Engine.CSS.Styles as Styles
import Anim.Internal.Engine.Shared.AnimGroups as AnimGroups
import Anim.Internal.Engine.Transition.AnimGroup as TAnimGroup
import Anim.Property.Opacity as Opacity
import Expect
import Test exposing (Test, describe, test)


transitionCss : String -> Transition.AnimState -> Maybe String
transitionCss groupName (CSS.AnimState _ animGroups) =
    AnimGroups.get groupName animGroups
        |> Maybe.map TAnimGroup.getStyles
        |> Maybe.andThen (Styles.get "transition")


suite : Test
suite =
    describe "Anim.Engine.Transition delay-only timing"
        [ test "property delay is emitted when duration is omitted" <|
            \_ ->
                Transition.init [ Opacity.init "el" 0 ]
                    |> (\state ->
                            Transition.animate state <|
                                Transition.for "el"
                                    >> Opacity.begin
                                    >> Opacity.to 1
                                    >> Opacity.delay 300
                                    >> Opacity.end
                       )
                    |> transitionCss "el"
                    |> Maybe.map (String.contains "300ms")
                    |> Expect.equal (Just True)
        , test "global delay is emitted when duration is omitted" <|
            \_ ->
                Transition.init [ Opacity.init "el" 0 ]
                    |> (\state ->
                            Transition.animate state <|
                                Transition.delay 250
                                    >> Transition.for "el"
                                    >> Opacity.begin
                                    >> Opacity.to 1
                                    >> Opacity.end
                       )
                    |> transitionCss "el"
                    |> Maybe.map (String.contains "250ms")
                    |> Expect.equal (Just True)
        ]
