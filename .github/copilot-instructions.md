# Smooth Move Elm Package - AI Coding Instructions

## Project Overview
This is an Elm 0.19 package that provides multiple animation approaches for smooth DOM element movement. The package offers 5 different animation systems, each optimized for different use cases and performance requirements. The core architecture separates public APIs from internal animation logic (`Internal/AnimationSteps.elm`).

## Five Animation Approaches

### 1. Task-Based API (SmoothMoveScroll)
- **Purpose**: Scrolling animations with task-based error handling
- **API**: Functions return `Task Dom.Error (List ())` for composable operations
- **Usage**: `scrollTo "element-id" |> Task.attempt (always NoOp)`
- **Best for**: Document/container scrolling, sequential animations

### 2. Subscription-Based API (SmoothMoveSub) 
- **Purpose**: Element positioning with frame-rate independent animations
- **API**: `onAnimationFrameDelta` subscriptions with model updates
- **Usage**: Create `AnimationState`, subscribe to `subscriptions`, apply via CSS transform
- **Best for**: Multiple simultaneous element animations

### 3. State-Based API (SmoothMoveState)
- **Purpose**: Convenience wrapper around subscription-based approach
- **API**: Simplified state management with helper functions
- **Usage**: Similar to SmoothMoveSub but with more convenience functions
- **Best for**: Simpler state management needs

### 4. CSS Transition-Based API (SmoothMoveCSS)
- **Purpose**: Native browser CSS transitions for optimal performance
- **API**: Generate CSS transition styles, browser handles animation
- **Usage**: Apply returned CSS styles directly to elements
- **Best for**: Hardware acceleration, battery efficiency, simple transitions

### 5. Ports-Based API (SmoothMovePorts)
- **Purpose**: Web Animations API integration via JavaScript
- **API**: Elm ports communicating with JavaScript companion file
- **Usage**: Requires `smooth-move-ports.js` and port definitions
- **Best for**: Complex animations, platform-specific optimizations

## Key Architecture Patterns

### Unified Configuration Pattern
```elm
-- All modules use consistent defaultConfig pattern
scrollToWithOptions { defaultConfig | offset = 60, speed = 15 } "target-id"
moveToWithOptions { defaultConfig | speed = 500, axis = Both } "element-id" 0 0 100 200
```

### Internal Module Organization
- `Internal/AnimationSteps.elm` contains pure interpolation logic (`interpolate` function)
- Main modules handle DOM interactions and API orchestration
- Internal modules are not exposed in `elm.json`

### ElementData Pattern (Position Preservation)
- Dict-based O(1) element lookup and state management
- `ElementData` type preserves element positions when animations stop
- Critical for smooth animation continuity across state changes

## Development Workflows

### Testing
- Run tests with `elm-test` from project root
- Tests focus on interpolation logic in `Internal.AnimationSteps`
- Test edge cases: negative/zero speed, equal start/stop positions

### Examples Organization
- **Location**: `examples/src/` with hierarchical module structure
- **Structure**: Each animation approach has its own subdirectory
  - `SmoothMoveScroll/` - Task-based examples (Basic.elm, Container.elm)
  - `SmoothMoveSub/` - Subscription-based examples (Basic.elm, Multiple.elm)
  - `SmoothMoveState/` - State-based examples (Basic.elm, Multiple.elm)  
  - `SmoothMoveCSS/` - CSS-based examples (Basic.elm, Multiple.elm)
  - `SmoothMovePorts/` - Ports-based examples (Basic.elm, Multiple.elm, README.md, smooth-move-ports.js)
  - `Common/` - Reusable functions for duplicated code in the examples.
- **Compilation**: `elm make examples/src/SmoothMoveScroll/Basic.elm`
- **Development**: `elm reactor` from `examples/` directory

### Package Structure
- **Exposed modules**: All 5 main animation approaches in `elm.json`
- **Internal modules**: Keep implementation details in `Internal/` namespace
- **JavaScript integration**: Companion file co-located with ports examples

## Critical Implementation Details

### Viewport Calculations
- Document body vs container element scrolling uses different DOM APIs
- Container scrolling requires element position relative to container bounds
- Always clamp scroll destination between 0 and max scrollable area

### Animation Systems
- **SmoothMoveScroll**: Pre-calculated frame steps using `Internal.interpolate` function
- **SmoothMoveSub**: Time-based interpolation with `onAnimationFrameDelta`
- **SmoothMoveState**: Convenience wrapper around subscription approach
- **SmoothMoveCSS**: Native CSS transitions with `cssTransitionStyle` helper
- **SmoothMovePorts**: Web Animations API via JavaScript integration
- Speed parameter: pixels per second for SmoothMoveSub, frame count divisor for SmoothMoveScroll
- Easing functions from `elm-community/easing-functions` package applied to progress values

### Error Handling
- All DOM operations can fail with `Dom.Error`
- Use `Task.attempt` to handle errors gracefully in user applications
- Element IDs that don't exist will cause task failure

## Current Project Structure
```
src/
├── Internal/
│   └── AnimationSteps.elm    - Pure interpolation logic (interpolate function)
├── SmoothMoveScroll.elm        - Task-based scrolling API
├── SmoothMoveSub.elm         - Subscription-based positioning API  
├── SmoothMoveState.elm       - State-based convenience API
├── SmoothMoveCSS.elm         - CSS transition-based API
└── SmoothMovePorts.elm       - Ports-based Web Animations API

examples/src/
├── Common/               - Reusable functions for duplicated code in the examples.
├── SmoothMoveScroll/           - Task examples (Basic.elm, Container.elm)
├── SmoothMoveSub/            - Subscription examples (Basic.elm, Multiple.elm)
├── SmoothMoveState/          - State examples (Basic.elm, Multiple.elm)
├── SmoothMoveCSS/            - CSS examples (Basic.elm, Multiple.elm)
└── SmoothMovePorts/          - Ports examples (Basic.elm, README.md, smooth-move-ports.js)
```

## Dependencies & Compatibility
- Elm 0.19.x only
- Requires `elm/browser` for DOM operations
- Uses `elm-community/easing-functions` for animation curves
- Test with `elm-explorations/test`