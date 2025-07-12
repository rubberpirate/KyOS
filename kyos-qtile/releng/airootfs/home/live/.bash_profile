#!/usr/bin/env bash

# Auto-start desktop for live user

# Clear the screen
clear

echo "======================================"
echo "    Welcome to KyOS Live Environment"
echo "======================================"
echo "Starting Qtile desktop..."
echo "Please wait..."
echo

# Wait for system to be ready
sleep 2

# Set up X11 environment variables
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=qtile
export XDG_SESSION_CLASS=user

# Start X server with Qtile directly
if command -v startx >/dev/null 2>&1; then
    # Create minimal .xinitrc if it doesn't exist
    if [ ! -f "$HOME/.xinitrc" ]; then
        cat > "$HOME/.xinitrc" << 'EOF'
#!/bin/sh
# Auto-generated .xinitrc for KyOS Live

# Set up environment
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=qtile

# Start Qtile
exec qtile start
EOF
        chmod +x "$HOME/.xinitrc"
    fi
    
    echo "Starting X server with Qtile..."
    exec startx -- vt1 -keeptty
else
    echo "Error: X server not available"
    echo "Starting fallback terminal session..."
    echo "You can try to start the desktop manually with: startx"
    exec /bin/bash
fi
