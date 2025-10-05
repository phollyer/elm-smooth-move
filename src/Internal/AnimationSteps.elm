module Internal.AnimationSteps exposing (interpolate)

import Ease


interpolate : Int -> Ease.Easing -> Float -> Float -> List Float
interpolate speed easing start stop =
    let
        diff =
            abs <| start - stop

        frames =
            Basics.max 1 <| round diff // speed

        framesFloat =
            toFloat frames

        weights =
            List.map (\i -> easing (toFloat i / framesFloat)) (List.range 0 frames)

        operator =
            if start > stop then
                (-)

            else
                (+)
    in
    if speed <= 0 || start == stop then
        []

    else
        List.map (\weight -> operator start (weight * diff)) weights
