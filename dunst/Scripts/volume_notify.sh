#!/bin/bash

# Settings
BAR_WIDTH=12                 # Slim but visible
BAR_HEIGHT=100               # Vertical size
CORNER_RADIUS=6              # Rounder corners
IMG_PATH="/tmp/volume.png"

# Get volume info
INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOLUME=$(echo "$INFO" | grep -oP '[0-9.]+' | head -1)
MUTED=$(echo "$INFO" | grep -o '\[MUTED\]')

# Calculate percentage and fill height
VOLUME_PERCENT=$(awk "BEGIN { printf \"%d\", $VOLUME * 100 }")
FILLED_HEIGHT=$(awk "BEGIN { printf \"%d\", $VOLUME * $BAR_HEIGHT }")

# Colors (you can tweak these to match your wallpaper)
BG_COLOR="#1e1b23"       # Subtle transparent background
FILL_COLOR="#e38c8f"     # Pinkish fill (sunset tone)

# Create background (slightly rounded rectangle with transparent corners)
convert -size ${BAR_WIDTH}x${BAR_HEIGHT} xc:none \
    -fill "$BG_COLOR" -draw "roundrectangle 0,0 $BAR_WIDTH,$BAR_HEIGHT $CORNER_RADIUS,$CORNER_RADIUS" \
    "$IMG_PATH"

# Create fill image (same shape, rounded)
convert -size ${BAR_WIDTH}x${FILLED_HEIGHT} xc:none \
    -fill "$FILL_COLOR" \
    -draw "roundrectangle 0,0 $BAR_WIDTH,$FILLED_HEIGHT $CORNER_RADIUS,$CORNER_RADIUS" \
    /tmp/volume_fill.png

# Composite the fill onto the base image from the bottom (south)
composite -gravity south /tmp/volume_fill.png "$IMG_PATH" "$IMG_PATH"

# Choose Font Awesome icon
if [ -n "$MUTED" ]; then
    ICON=""  # 
elif [ "$VOLUME_PERCENT" -ge 70 ]; then
    ICON=""  # 
elif [ "$VOLUME_PERCENT" -ge 30 ]; then
    ICON=""  # 
else
    ICON=""  #  (quiet)
fi

# Show notification with no "Volume" word
dunstify -a "vol" -r 9993 "$ICON $VOLUME_PERCENT%" "" -i "$IMG_PATH" -t 1000 -u low

