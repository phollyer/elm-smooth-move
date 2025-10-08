#!/bin/bash

# Elm Smooth Move Examples Build Script
# This script compiles all examples to their respective JavaScript files

echo "🚀 Building Elm Smooth Move Examples..."

# Change to examples directory
cd "$(dirname "$0")"

# Build SmoothMoveTask examples
echo "📦 Building SmoothMoveTask examples..."
elm make src/SmoothMoveTask/Basic.elm --output=src/SmoothMoveTask/basic.js
elm make src/SmoothMoveTask/Container.elm --output=src/SmoothMoveTask/container.js

# Build SmoothMoveSub examples
echo "📦 Building SmoothMoveSub examples..."
elm make src/SmoothMoveSub/Basic.elm --output=src/SmoothMoveSub/basic.js
elm make src/SmoothMoveSub/Multiple.elm --output=src/SmoothMoveSub/multiple.js

# Build SmoothMoveState examples
echo "📦 Building SmoothMoveState examples..."
elm make src/SmoothMoveState/Basic.elm --output=src/SmoothMoveState/basic.js
elm make src/SmoothMoveState/Multiple.elm --output=src/SmoothMoveState/multiple.js

# Build SmoothMoveCSS examples
echo "📦 Building SmoothMoveCSS examples..."
elm make src/SmoothMoveCSS/Basic.elm --output=src/SmoothMoveCSS/basic.js
elm make src/SmoothMoveCSS/Multiple.elm --output=src/SmoothMoveCSS/multiple.js

# Build SmoothMovePorts examples
echo "📦 Building SmoothMovePorts examples..."
elm make src/SmoothMovePorts/Basic.elm --output=src/SmoothMovePorts/basic.js
elm make src/SmoothMovePorts/Multiple.elm --output=src/SmoothMovePorts/multiple.js

# Build ElmUI examples
echo "🎨 Building ElmUI examples..."
elm make src/SmoothMoveTaskUI/Basic.elm --output=src/SmoothMoveTaskUI/basic.js
elm make src/SmoothMoveTaskUI/Container.elm --output=src/SmoothMoveTaskUI/container.js
elm make src/SmoothMoveSubUI/Basic.elm --output=src/SmoothMoveSubUI/basic.js
elm make src/SmoothMoveSubUI/Multiple.elm --output=src/SmoothMoveSubUI/multiple.js
elm make src/SmoothMoveStateUI/Basic.elm --output=src/SmoothMoveStateUI/basic.js
elm make src/SmoothMoveStateUI/Multiple.elm --output=src/SmoothMoveStateUI/multiple.js
elm make src/SmoothMoveCSSUI/Basic.elm --output=src/SmoothMoveCSSUI/basic.js
elm make src/SmoothMoveCSSUI/Multiple.elm --output=src/SmoothMoveCSSUI/multiple.js
elm make src/SmoothMovePortsUI/Basic.elm --output=src/SmoothMovePortsUI/basic.js
elm make src/SmoothMovePortsUI/Multiple.elm --output=src/SmoothMovePortsUI/multiple.js

echo "✅ All examples built successfully!"
echo "🌐 Open index.html to view the examples dashboard"
echo "🎨 ElmUI examples available at:"
echo "   - http://localhost:8080/src/SmoothMoveTaskUI/basic.html"
echo "   - http://localhost:8080/src/SmoothMoveTaskUI/container.html"
echo "   - http://localhost:8080/src/SmoothMoveSubUI/basic.html"
echo "   - http://localhost:8080/src/SmoothMoveSubUI/multiple.html"
echo "   - http://localhost:8080/src/SmoothMoveStateUI/basic.html"
echo "   - http://localhost:8080/src/SmoothMoveStateUI/multiple.html"
echo "   - http://localhost:8080/src/SmoothMoveCSSUI/basic.html"
echo "   - http://localhost:8080/src/SmoothMoveCSSUI/multiple.html"
echo "   - http://localhost:8080/src/SmoothMovePortsUI/basic.html"
echo "   - http://localhost:8080/src/SmoothMovePortsUI/multiple.html"