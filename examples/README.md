# Examples

This directory contains examples demonstrating all five animation approaches provided by the smooth-move package:

## Structure

Each animation approach has its own subdirectory with properly organized Elm modules:

```
examples/src/
├── SmoothMoveTask/   - Task-based API with pre-calculated animation steps
│   ├── Basic.elm     - Simple scrolling to elements
│   └── Container.elm - Scrolling within container elements
├── SmoothMoveSub/    - Subscription-based with Browser.Events.onAnimationFrameDelta  
│   ├── Basic.elm     - Single element animation
│   └── Multiple.elm  - Multiple simultaneous animations
├── SmoothMoveState/  - State-based with convenience functions
│   ├── Basic.elm     - Single element animation  
│   └── Multiple.elm  - Multiple simultaneous animations
├── SmoothMoveCSS/    - CSS transition-based for optimal performance
│   ├── Basic.elm     - Single element animation
│   └── Multiple.elm  - Multiple simultaneous animations
└── SmoothMovePorts/  - Web Animations API integration via Elm ports
    ├── Basic.elm     - JavaScript-powered animations
    ├── Multiple.elm  - Multiple simultaneous animations
    ├── README.md     - Detailed integration guide 📖
    └── smooth-move-ports.js - Required JavaScript companion file 🔧
```

## Running Examples

From the `examples/` directory:

```bash
# Compile any example
elm make src/SmoothMoveTask/Basic.elm --output=basic.html

# Run with elm reactor for development
elm reactor
# Then navigate to http://localhost:8000/src/SmoothMoveTask/Basic.elm

# Build all examples
elm make src/SmoothMoveTask/Basic.elm src/SmoothMoveSub/Multiple.elm src/SmoothMoveCSS/Basic.elm --output=demo.html
```

## Module Hierarchy

All examples use proper hierarchical module names:
- `SmoothMoveTask.Basic` 
- `SmoothMoveSub.Multiple`
- `SmoothMoveState.Basic`
- etc.

This organization makes it easy to understand which animation approach each example demonstrates while following Elm's module naming conventions.

## JavaScript Integration

The `SmoothMovePorts` examples require JavaScript integration:
- **Location**: `examples/src/SmoothMovePorts/smooth-move-ports.js`
- **Documentation**: See `examples/src/SmoothMovePorts/README.md` for detailed integration guide
- **Purpose**: Provides Web Animations API integration for hardware-accelerated animations