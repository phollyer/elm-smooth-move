# API Alignment Guide

This document shows how the APIs are now aligned across all 5 animation approaches, making it easy to experiment and switch between them.

## 🎯 Unified Function Names

All modules now use the same core function names:

```elm
-- Basic animation (uses defaultConfig)
animateTo : String -> Float -> Float -> [ModelType] -> [ReturnType]

-- Configurable animation  
animateToWithConfig : Config -> String -> Float -> Float -> [ModelType] -> [ReturnType]
```

**Note**: `SmoothMoveTask` focuses on scrolling, so it uses `String -> Task` instead of `String -> Float -> Float -> Model`.

## 🔧 Configuration Alignment

### Common Configuration Fields

| Field | SmoothMoveTask | SmoothMoveSub | SmoothMoveState | SmoothMoveCSS | SmoothMovePorts |
|-------|----------------|---------------|-----------------|---------------|-----------------|
| **axis** | ✅ Axis | ✅ Axis | ✅ Axis | ✅ Axis | ✅ Axis |
| **easing** | ✅ Ease.Easing | ✅ Ease.Easing | ✅ Ease.Easing | ✅ String | ✅ String |
| **speed/duration** | ✅ Float | ✅ Float | ✅ Float | ✅ Float | ✅ Float |

### Speed/Duration Parameter Meanings

- **SmoothMoveTask**: `speed` = Animation frame count (higher = smoother)
- **SmoothMoveSub/State**: `speed` = Pixels per second (higher = faster)  
- **SmoothMoveCSS/Ports**: `duration` = Milliseconds (higher = slower)

### Unified Default Configurations

```elm
-- SmoothMoveTask (scrolling focused)
{ speed = 400.0, offset = 0, easing = Ease.outCubic, axis = Y }

-- SmoothMoveSub/State (element positioning)  
{ speed = 400.0, easing = Ease.outCubic, axis = Both }

-- SmoothMoveCSS (CSS transitions)
{ axis = Both, duration = 400, easing = "cubic-bezier(0.4, 0.0, 0.2, 1)" }

-- SmoothMovePorts (Web Animations API)
{ axis = Both, duration = 400, easing = "ease-out" }
```

## 🔄 Easy Migration Examples

### From SmoothMoveTask to SmoothMoveSub

```elm
-- Before (SmoothMoveTask)
import SmoothMoveTask exposing (animateTo)
Task.attempt (always NoOp) (animateTo "my-element")

-- After (SmoothMoveSub)  
import SmoothMoveSub exposing (animateTo)
{ model | smoothMove = animateTo "my-element" 200 300 model.smoothMove }
```

### From SmoothMoveSub to SmoothMoveCSS

```elm
-- Before (SmoothMoveSub)
import SmoothMoveSub exposing (animateToWithConfig, defaultConfig)
{ model | smoothMove = animateToWithConfig config "elem" 200 300 model.smoothMove }

-- After (SmoothMoveCSS)
import SmoothMoveCSS exposing (animateToWithConfig, defaultConfig)  
{ model | smoothMove = animateToWithConfig config "elem" 200 300 model.smoothMove }
```

## 📚 State Management Alignment

All modules use consistent patterns:

| Pattern | SmoothMoveTask | SmoothMoveSub | SmoothMoveState | SmoothMoveCSS | SmoothMovePorts |
|---------|----------------|---------------|-----------------|---------------|-----------------|
| **Init** | N/A (Tasks) | `init` | `init` | `init` | `init` |
| **Update** | N/A (Tasks) | `step` | `step` | `step` | ports |
| **Subscriptions** | N/A (Tasks) | `subscriptions` | `subscriptions` | `subscriptions` | ports |
| **Query State** | N/A (Tasks) | `isAnimating`, `getPosition` | `isAnimating`, `getPosition` | `isAnimating`, `getPosition` | `isAnimating`, `getPosition` |
| **Styling** | N/A (Tasks) | `transform` | `transform`, `transformElement` | `transform`, `transformElement` | `transform`, `transformElement` |

## 🎨 Axis Configuration

All modules now support the same axis options:

```elm
type Axis = X | Y | Both

-- Usage examples
{ defaultConfig | axis = X }     -- Horizontal only
{ defaultConfig | axis = Y }     -- Vertical only  
{ defaultConfig | axis = Both }  -- Both directions
```

## 🚀 Performance Comparison

| Approach | CPU Usage | Battery | Smoothness | Complexity |
|----------|-----------|---------|------------|------------|
| **SmoothMoveTask** | Medium | Medium | Good | Simple |
| **SmoothMoveSub** | Medium | Medium | Good | Medium |
| **SmoothMoveState** | Medium | Medium | Good | Simple |
| **SmoothMoveCSS** | Low* | Best* | Excellent* | Simple |
| **SmoothMovePorts** | Low* | Best* | Excellent* | Complex |

*Hardware accelerated when available

This alignment makes it much easier to:
1. **Learn**: Similar patterns across all approaches
2. **Experiment**: Quick switching to test different approaches
3. **Optimize**: Easy migration to better-performing approaches
4. **Maintain**: Consistent code patterns across your project