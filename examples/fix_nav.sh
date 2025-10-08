#!/bin/bash

# Fix navigation styling for all ElmUI HTML files
for file in SmoothMove*UI-*.html; do
    if [ -f "$file" ]; then
        echo "Fixing navigation in $file..."
        # Replace z-index: 1000 with z-index: 9999 !important and add other !important declarations
        sed -i '' 's/z-index: 1000;/z-index: 9999 !important;/g' "$file"
        sed -i '' 's/position: fixed;/position: fixed !important;/g' "$file"
        sed -i '' 's/top: 20px;/top: 20px !important;/g' "$file"
        sed -i '' 's/left: 20px;/left: 20px !important;/g' "$file"
        sed -i '' 's/right: 20px;/right: 20px !important;/g' "$file"
        sed -i '' 's/display: block;/display: block !important;/g' "$file"
        # Add display: block !important if not present
        sed -i '' '/z-index: 9999 !important;/a\
            display: block !important;' "$file"
    fi
done

echo "Done fixing navigation!"
