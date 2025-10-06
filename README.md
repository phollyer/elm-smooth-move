# Elm Smooth Move

A comprehensive Elm package providing **5 different animation approaches** for smooth DOM element movement. Choose the approach that best fits your performance needs and use case.

> **Credits**: This package builds upon the excellent foundation of [`linuss/smooth-scroll`](https://package.elm-lang.org/packages/linuss/smooth-scroll/latest/) by expanding it into a multi-approach animation library.

## 🎯 Five Animation Approaches

### 1. **SmoothMoveTask** - Task-Based Scrolling
Perfect for **document/container scrolling** with composable error handling.
```elm
import SmoothMoveTask exposing (animateTo, animateToWithConfig)
import Task

-- Basic usage
animateTo "target-element-id"
    |> Task.attempt (always NoOp)

-- With configuration
animateToWithConfig 
    { defaultConfig | offset = 60, speed = 15 } 
    "target-element-id"
    |> Task.attempt (always NoOp)
```

### 2. **SmoothMoveSub** - Subscription-Based Positioning  
Ideal for **multiple simultaneous element animations** with frame-rate independence.
```elm
import SmoothMoveSub exposing (animateTo, transform)
import Html.Attributes exposing (style)

-- Animate an element to position (100, 200)
{ model | animations = animateTo "my-element" 100 200 model.animations }

-- Apply in view with CSS transform
style "transform" (transform "my-element" model.animations)
```

### 3. **SmoothMoveState** - State-Based Convenience
Simplified wrapper around subscription-based approach for **easier state management**.
```elm
import SmoothMoveState exposing (animateTo, transform)
import Html.Attributes exposing (style)

-- Animate an element to position (150, 250)
{ model | animations = animateTo "my-element" 150 250 model.animations }

-- Apply in view with CSS transform
style "transform" (transform "my-element" model.animations)
```

### 4. **SmoothMoveCSS** - CSS Transition-Based
Uses **native browser CSS transitions** for optimal performance and battery efficiency.
```elm
import SmoothMoveCSS exposing (animateTo, transform)
import Html exposing (div, text)
import Html.Attributes exposing (style)

-- Animate an element to position (100, 200)
{ model | animations = animateTo "my-element" 100 200 model.animations }

-- Apply CSS transition in view
div [ style "transform" (transform "my-element" model.animations) ] [ text "Smooth!" ]
```

### 5. **SmoothMovePorts** - Web Animations API
**JavaScript integration** for maximum performance and complex animations.
```elm
import SmoothMovePorts exposing (animateTo, animateBatchWithPort)

-- Single element animation
( newAnimations, cmd ) = animateTo "my-element" 100 200 model.animations

-- Batch multiple animations (new!)
( newAnimations, cmd ) = animateBatchWithPort myPort 
    [ ("box1", 100, 150), ("box2", 200, 250), ("box3", 300, 350) ] 
    model.animations

-- Requires companion JavaScript file - see examples/src/SmoothMovePorts/
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

-- In your init (prevent jump to 0,0)
initialAnimations = 
    SmoothMoveState.init
        |> SmoothMoveState.setInitialPosition "my-element" 100 100

-- In your update  
AnimateElement ->
    { model | animations = animateTo "my-element" 200 300 model.animations }

-- Don't forget subscriptions!
subscriptions model = SmoothMoveState.subscriptions model.animations
```

### 3. Explore the examples

**Option A: Direct HTML files (recommended)**
```bash
cd examples/
open index.html  # Opens main examples page in your browser
# Or open any specific example directly, e.g.:
open src/SmoothMoveState/basic.html
```

**Option B: Using elm reactor**
```bash
cd examples/
elm reactor
# Navigate to: http://localhost:8000/src/SmoothMoveTask/Basic.elm
```

### 4. Experiment with different approaches
Once you're comfortable, try switching `SmoothMoveState` to `SmoothMoveCSS` in your imports for better performance, or `SmoothMovePorts` for maximum control!

## 📚 Examples

Interactive examples are ready to run! Each approach has its own folder with compiled HTML files:

- **`SmoothMoveTask/`** - Task-based scrolling ([basic.html](examples/src/SmoothMoveTask/basic.html), [container.html](examples/src/SmoothMoveTask/container.html))
- **`SmoothMoveSub/`** - Subscription-based positioning ([basic.html](examples/src/SmoothMoveSub/basic.html), [multiple.html](examples/src/SmoothMoveSub/multiple.html))  
- **`SmoothMoveState/`** - State-based convenience ([basic.html](examples/src/SmoothMoveState/basic.html), [multiple.html](examples/src/SmoothMoveState/multiple.html))
- **`SmoothMoveCSS/`** - CSS transition-based ([basic.html](examples/src/SmoothMoveCSS/basic.html), [multiple.html](examples/src/SmoothMoveCSS/multiple.html))
- **`SmoothMovePorts/`** - JavaScript Web Animations API ([basic.html](examples/src/SmoothMovePorts/basic.html), [multiple.html](examples/src/SmoothMovePorts/multiple.html))

**🎯 Start here: [examples/index.html](examples/index.html)** - Main examples dashboard

## 🎨 Choosing the Right Approach

### Quick Decision Guide
- **Scrolling a page?** → Use `SmoothMoveTask`
- **Moving multiple elements?** → Use `SmoothMoveSub` or `SmoothMoveState`
- **Need best battery life?** → Use `SmoothMoveCSS` or `SmoothMovePorts`
- **Complex animations?** → Use `SmoothMovePorts`
- **Simple and clean?** → Use `SmoothMoveState`

### Detailed Comparison

| Approach | Best For | Performance | Battery | Complexity |
|----------|----------|-------------|---------|------------|
| **SmoothMoveTask** | Document/container scrolling | Good | Medium | Simple |
| **SmoothMoveSub** | Multiple simultaneous elements | Good | Medium | Medium |
| **SmoothMoveState** | Clean state management | Good | Medium | Simple |
| **SmoothMoveCSS** | Battery efficiency, simple UI | Excellent* | Best* | Simple |
| **SmoothMovePorts** | Maximum control & performance | Excellent* | Best* | Complex |

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
newState = animateTo "my-element" 200 300 state

-- Switch to SmoothMoveCSS for better performance  
import SmoothMoveCSS exposing (animateTo, defaultConfig)
newState = animateTo "my-element" 200 300 state

-- Same API, different implementation!
```

## 📖 API Documentation

- **SmoothMoveTask**: `animateTo`, `animateToWithConfig`, `containerElement`, `containerElementWithConfig`
- **SmoothMoveSub**: `animateTo`, `animateToWithConfig`, `subscriptions`, `transform`, `setInitialPosition`
- **SmoothMoveState**: `animateTo`, `animateToWithConfig`, `subscriptions`, `transform`, `transformElement`, `setInitialPosition`
- **SmoothMoveCSS**: `animateTo`, `animateToWithConfig`, `cssTransitionStyle`, `setInitialPosition`
- **SmoothMovePorts**: `animateTo`, `animateToWithConfig`, `animateBatch`, `animateBatchWithPort`, `setInitialPosition`, `stopBatch`, `stopBatchWithPort`

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
