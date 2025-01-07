#!/bin/sh

# Initialize workspace if it's empty
if [ ! -f "/app/package.json" ]; then
    echo "First time setup: Copying template files..."
    cp -r /template-files/* /app/
    cp -r /template-files/.* /app/ 2>/dev/null || true  # Copy hidden files too
    
    echo "Installing dependencies..."
    cd /app && npm install
else
    echo "Workspace already initialized, skipping setup..."
fi

exec "$@"