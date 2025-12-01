#!/bin/bash

# --- Configuration ---
# 1. Directory where your wallpapers are stored
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# 2. Cache file to store the index of the current wallpaper
CACHE_FILE="/tmp/hyprland_swww_index"

# 3. Transition settings (optional, but makes swww awesome!)
# Available types: wipe, grow, outer, simple, center, wave, convolute, radial, random
TRANSITION_TYPE="wipe"
TRANSITION_STEP=10 # Smaller number = smoother/slower transition
TRANSITION_FPS=60 
TRANSITION_ANGLE=$((RANDOM % 360)) # Random angle for some transition types

# --- Script Logic ---

# Get a sorted list of all supported wallpaper files
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.jxl" -o -iname "*.gif" \) | sort))

# Check if any wallpapers were found
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Read the current index, default to 0 if the file doesn't exist
if [ -f "$CACHE_FILE" ]; then
    CURRENT_INDEX=$(<"$CACHE_FILE")
else
    CURRENT_INDEX=0
fi

# Calculate the index of the next wallpaper (cycle through the array)
NEXT_INDEX=$(((CURRENT_INDEX + 1) % ${#WALLPAPERS[@]}))

# Get the path of the next wallpaper
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Set the wallpaper using swww
swww img "$NEXT_WALLPAPER" \
    --transition-type "$TRANSITION_TYPE" \
    --transition-step "$TRANSITION_STEP" \
    --transition-fps "$TRANSITION_FPS" \
    --transition-angle "$TRANSITION_ANGLE"

# 4. Save the new index
echo "$NEXT_INDEX" > "$CACHE_FILE"

echo "Switched wallpaper (swww) to: $NEXT_WALLPAPER (Index: $NEXT_INDEX)"