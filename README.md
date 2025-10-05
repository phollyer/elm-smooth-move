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

1. **Install the package:**
```bash
elm install phollyer/elm-smooth-move
```

2. **Choose your approach and import:**
```elm
import SmoothMoveTask exposing (scrollTo)
-- or
import SmoothMoveSub exposing (AnimationState, moveTo)
-- or  
import SmoothMoveCSS exposing (cssTransitionStyle)
-- etc.
```

3. **Check out the examples:**
```bash
cd examples/
elm reactor
# Navigate to: http://localhost:8000/src/SmoothMoveTask/Basic.elm
```

## 📚 Examples

Comprehensive examples for each approach are available in the `examples/` directory:

- **`SmoothMoveTask/`** - Task-based scrolling (Basic.elm, Container.elm)
- **`SmoothMoveSub/`** - Subscription-based positioning (Basic.elm, Multiple.elm)  
- **`SmoothMoveState/`** - State-based convenience (Basic.elm, Multiple.elm)
- **`SmoothMoveCSS/`** - CSS transition-based (Basic.elm, Multiple.elm)
- **`SmoothMovePorts/`** - JavaScript Web Animations API (Basic.elm, Multiple.elm, README.md)

## 🎨 When to Use Which Approach

| Approach | Best For | Performance | Complexity |
|----------|----------|-------------|------------|
| **SmoothMoveTask** | Document scrolling, sequential animations | Good | Simple |  
| **SmoothMoveSub** | Multiple elements, frame-perfect timing | Good | Medium |
| **SmoothMoveState** | Simpler state management | Good | Simple |
| **SmoothMoveCSS** | Battery efficiency, simple transitions | Excellent* | Simple |
| **SmoothMovePorts** | Complex animations, maximum control | Excellent* | Complex |

_*Hardware accelerated when available_

## ⚙️ Configuration

All approaches use consistent configuration patterns:

```elm
-- Task-based scrolling configuration
{ defaultConfig | offset = 60, speed = 15, easing = Ease.outCubic }

-- Positioning configuration  
{ defaultConfig | speed = 500, axis = Both, easing = Ease.inOutQuad }

-- CSS configuration
{ defaultConfig | duration = 400, easing = "ease-in-out" }
```

## 📖 API Documentation

- **SmoothMoveTask**: `scrollTo`, `scrollToWithOptions`, `containerElement`
- **SmoothMoveSub**: `moveTo`, `moveToWithOptions`, `subscriptions`, `transformElement`
- **SmoothMoveState**: Similar to SmoothMoveSub with convenience functions
- **SmoothMoveCSS**: `cssTransitionStyle`, `moveWithTransition`
- **SmoothMovePorts**: Port helpers and JavaScript integration utilities

## 🙏 Credits

This package is built upon the excellent foundation of [`linuss/smooth-scroll`](https://package.elm-lang.org/packages/linuss/smooth-scroll/latest/). The original design and architecture provided the inspiration for this expanded multi-approach animation library.

## 📄 License

BSD-3-Clause
