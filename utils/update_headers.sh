#!/bin/bash
echo "Updating 'current_date' to today's date..."
find . -type f \( -name "*.c" -o -name "*.h" \) -exec sed -i '' "s/current_date/$(date +%Y-%m-%d)/g" {} +
echo "Done."