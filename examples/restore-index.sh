#!/bin/bash

# Restore the examples dashboard from backup
# Run this if index.html gets accidentally overwritten by elm make

echo "🔄 Restoring examples dashboard from backup..."

if [ -f "index.html.backup" ]; then
    cp index.html.backup index.html
    echo "✅ Dashboard restored successfully!"
    echo "🌐 You can now open index.html to access the examples"
else
    echo "❌ Backup file not found!"
    echo "💡 The backup should be at: index.html.backup"
fi