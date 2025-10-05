# Elm Smooth Move

A comprehensive Elm package providing **5 different animation approaches** for smooth DOM element movement. Choose the approach that best fits your performance needs and use case.

> **Credits**: This package builds upon the excellent foundation of [`linuss/smooth-scroll`](https://package.elm-lang.org/packages/linuss/smooth-scroll/latest/) by expanding it into a multi-approach animation library.

## 🎯 Five Animation Approaches

### 1. **SmoothMoveTask** - Task-Based Scrolling
Perfect for **document/container scrolling** with composable error handling.
```elm
import SmoothMoveTask exposing (scrollTo)

-- Basic usage
scrollTo "target-element-id"
    |> Task.attempt (always NoOp)

-- With configuration
scrollToWithOptions 
    { defaultConfig | offset = 60, speed = 15 } 
    "target-element-id"
    |> Task.attempt (always NoOp)
```

### 2. **SmoothMoveSub** - Subscription-Based Positioning  
Ideal for **multiple simultaneous element animations** with frame-rate independence.
```elm
import SmoothMoveSub exposing (AnimationState, moveTo, subscriptions)

-- Animate an element to position (100, 200)
( newAnimations, _ ) = moveTo "my-element" 100 200 model.animations

-- Apply in view with CSS transform
style "transform" (SmoothMoveSub.transformElement "my-element" model.animations)
```

### 3. **SmoothMoveState** - State-Based Convenience
Simplified wrapper around subscription-based approach for **easier state management**.
```elm
import SmoothMoveState

-- Similar API to SmoothMoveSub but with additional convenience functions
```

### 4. **SmoothMoveCSS** - CSS Transition-Based
Uses **native browser CSS transitions** for optimal performance and battery efficiency.
```elm
import SmoothMoveCSS exposing (cssTransitionStyle)

-- Browser handles the animation with hardware acceleration
div [ cssTransitionStyle 100 200 ] [ text "Smooth!" ]
```

### 5. **SmoothMovePorts** - Web Animations API
**JavaScript integration** for maximum performance and complex animations.
```elm
-- Requires companion JavaScript file and port definitions
-- See examples/src/SmoothMovePorts/ for complete integration guide
```

## 🚀 Quick Start

### 1. Install the package
```bash
elm install phollyer/elm-smooth-move
```

### 2. Choose your first approach (we recommend starting simple)

**For page scrolling:**  
```elm
import SmoothMoveTask exposing (animateTo)

-- In your update function
SmoothScroll elementId ->
    ( model, Task.attempt (always NoOp) (animateTo elementId) )
```

**For moving UI elements:**
```elm
import SmoothMoveState exposing (animateTo, init, subscriptions)

-- In your model
type alias Model = { animations : SmoothMoveState.State, ... }

-- In your update  
AnimateElement ->
    { model | animations = animateTo "my-element" 200 300 model.animations }

-- Don't forget subscriptions!
subscriptions model = SmoothMoveState.subscriptions model.animations
```

### 3. Explore the examples
```bash
cd examples/
elm reactor
# Navigate to: http://localhost:8000/src/SmoothMoveTask/Basic.elm
```

### 4. Experiment with different approaches
Once you're comfortable, try switching `SmoothMoveState` to `SmoothMoveCSS` in your imports for better performance, or `SmoothMovePorts` for maximum control!

## 📚 Examples

Comprehensive examples for each approach are available in the `examples/` directory:

- **`SmoothMoveTask/`** - Task-based scrolling (Basic.elm, Container.elm)
- **`SmoothMoveSub/`** - Subscription-based positioning (Basic.elm, Multiple.elm)  
- **`SmoothMoveState/`** - State-based convenience (Basic.elm, Multiple.elm)
- **`SmoothMoveCSS/`** - CSS transition-based (Basic.elm, Multiple.elm)
- **`SmoothMovePorts/`** - JavaScript Web Animations API (Basic.elm, Multiple.elm, README.md)

## 🎨 Choosing the Right Approach

### Quick Decision Guide
- **Scrolling a page?** → Use `SmoothMoveTask`
- **Moving multiple elements?** → Use `SmoothMoveSub` or `SmoothMoveState`
- **Need best battery life?** → Use `SmoothMoveCSS` or `SmoothMovePorts`
- **Complex animations?** → Use `SmoothMovePorts`
- **Simple and clean?** → Use `SmoothMoveState`

### Detailed Comparison

| Approach | Best For | Performance | Battery | Complexity | Axis Support |
|----------|----------|-------------|---------|------------|-------------|
| **SmoothMoveTask** | Document/container scrolling | Good | Medium | Simple | X, Y, Both |
| **SmoothMoveSub** | Multiple simultaneous elements | Good | Medium | Medium | X, Y, Both |
| **SmoothMoveState** | Clean state management | Good | Medium | Simple | X, Y, Both |
| **SmoothMoveCSS** | Battery efficiency, simple UI | Excellent* | Best* | Simple | X, Y, Both |
| **SmoothMovePorts** | Maximum control & performance | Excellent* | Best* | Complex | X, Y, Both |

_*Hardware accelerated when available_

### Axis Control
All approaches support constraining movement to specific axes:
```elm
{ defaultConfig | axis = X }     -- Horizontal only
{ defaultConfig | axis = Y }     -- Vertical only  
{ defaultConfig | axis = Both }  -- Both directions (default)
```

## ⚙️ Configuration & Switching Between Approaches

### Consistent Configuration
All approaches use similar configuration patterns, making it easy to switch:

```elm
-- Task-based scrolling
{ defaultConfig | offset = 60, speed = 400, easing = Ease.outCubic, axis = Y }

-- Element positioning (Sub/State)
{ defaultConfig | speed = 400, easing = Ease.outCubic, axis = Both }

-- CSS transitions
{ defaultConfig | duration = 400, easing = "cubic-bezier(0.4, 0.0, 0.2, 1)", axis = Both }

-- Web Animations API (Ports)
{ defaultConfig | duration = 400, easing = "ease-out", axis = Both }
```

### Easy Migration Between Approaches
Switching approaches is as simple as changing imports:

```elm
-- Try SmoothMoveState first (simple)
import SmoothMoveState exposing (animateTo, defaultConfig)
animatedState = animateTo "my-element" 200 300 state

-- Switch to SmoothMoveCSS for better performance  
import SmoothMoveCSS exposing (animateTo, defaultConfig)
animatedState = animateTo "my-element" 200 300 state

-- Same API, different implementation!
```

## 📖 API Documentation

- **SmoothMoveTask**: `scrollTo`, `scrollToWithOptions`, `containerElement`
- **SmoothMoveSub**: `moveTo`, `moveToWithOptions`, `subscriptions`, `transformElement`
- **SmoothMoveState**: Similar to SmoothMoveSub with convenience functions
- **SmoothMoveCSS**: `cssTransitionStyle`, `moveWithTransition`
- **SmoothMovePorts**: Port helpers and JavaScript integration utilities

## � Troubleshooting

### Animation not working?
- **Check element IDs**: Make sure the element ID exists in your DOM
- **Missing subscriptions**: For `SmoothMoveSub`/`SmoothMoveState`/`SmoothMoveCSS`, ensure you have `subscriptions` wired up
- **CSS positioning**: Elements need `position: absolute` or `position: relative` for transforms to work
- **JavaScript setup**: For `SmoothMovePorts`, make sure you've set up the JavaScript side (see examples)

### Performance issues?
- Try `SmoothMoveCSS` for hardware acceleration
- Use `axis` constraints to animate fewer dimensions
- Consider `SmoothMovePorts` for complex animations

### Need help choosing an approach?
- Start with `SmoothMoveState` - it's the simplest
- Move to `SmoothMoveCSS` when you need better performance
- Use `SmoothMoveTask` for scrolling
- Use `SmoothMovePorts` when you need maximum control

## 🙏 Credits

This package builds upon the excellent foundation of [`linuss/smooth-scroll`](https://package.elm-lang.org/packages/linuss/smooth-scroll/latest/). The original design and architecture provided the inspiration for this expanded multi-approach animation library.

## 📄 License

BSD-3-Clause
