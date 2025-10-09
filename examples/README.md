# Elm Smooth Move Examples

Interactive examples showcasing all 5 animation approaches. Each example is compiled and ready to run directly in your browser!

> **Note**: If `index.html` gets accidentally overwritten, run `./restore-index.sh` to restore the dashboard.

## 🚀 Quick Start

**Just open `index.html`** in your browser to see the examples dashboard, or open any specific example directly:

- `src/SmoothMoveScroll/basic.html` - Basic scrolling
- `src/SmoothMoveState/basic.html` - Simple element movement (recommended for beginners)
- `src/SmoothMoveCSS/basic.html` - Hardware-accelerated animations
- And many more...

## 🔧 Rebuilding Examples

If you modify any `.elm` files, run the build script to recompile:

```bash
./build.sh
```

This will regenerate all the `.js` files needed by the HTML examples.

## 📚 Example Structure

Each animation approach has its own subdirectory with properly organized Elm modules:

```
examples/src/
├── SmoothMoveScroll/   - Task-based API with pre-calculated animation steps
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
elm make src/SmoothMoveScroll/Basic.elm --output=basic.html

# Run with elm reactor for development
elm reactor
# Then navigate to http://localhost:8000/src/SmoothMoveScroll/Basic.elm

# Build all examples
elm make src/SmoothMoveScroll/Basic.elm src/SmoothMoveSub/Multiple.elm src/SmoothMoveCSS/Basic.elm --output=demo.html
```

## Module Hierarchy

All examples use proper hierarchical module names:
- `SmoothMoveScroll.Basic` 
- `SmoothMoveSub.Multiple`
- `SmoothMoveState.Basic`
- etc.

This organization makes it easy to understand which animation approach each example demonstrates while following Elm's module naming conventions.

## JavaScript Integration

The `SmoothMovePorts` examples require JavaScript integration:
- **Location**: `examples/src/SmoothMovePorts/smooth-move-ports.js`
- **Documentation**: See `examples/src/SmoothMovePorts/README.md` for detailed integration guide
- **Purpose**: Provides Web Animations API integration for hardware-accelerated animations