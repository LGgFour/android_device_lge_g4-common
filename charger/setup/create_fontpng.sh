#!/usr/bin/env python3
"""
Font Atlas Generator for the LG G4
Copyright (c) 2026 steadfasterX <steadfasterX |AT| binbash #DOT# rocks>
All rights reserved.
"""
import os
import sys

# Check for required Pillow library
try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("Error: Pillow (PIL) is not installed.")
    print("Please install it using: pip install Pillow")
    sys.exit(1)

def get_font_path():
    """Checks multiple system paths for the required font file."""
    search_paths = [
        "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "/usr/local/share/fonts/DejaVuSans-Bold.ttf",
        "C:\\Windows\\Fonts\\DejaVuSans-Bold.ttf"
    ]
    for path in search_paths:
        if os.path.exists(path):
            return path
    return None

def create_perfect_font(output_name="font.png", font_size=38, pad_factor=4, vertical_nudge=38, spacing_factor=1.1):
    # Base character set (32-127)
    chars = "".join(chr(i) for i in range(32, 128))
    
    # Automatic font path discovery
    font_path = get_font_path()
    if not font_path:
        print("Error: DejaVuSans-Bold.ttf not found in common system paths.")
        return

    # Initialize font with high-res scale
    adjusted_font_size = int(font_size * pad_factor)
    font = ImageFont.truetype(font_path, adjusted_font_size)

    # DYNAMIC WIDTH CALCULATION:
    # Find the widest character in the set (usually '@', 'W' or '%')
    max_char_w = 0
    for char in chars:
        bbox = font.getbbox(char)
        w = bbox[2] - bbox[0]
        if w > max_char_w:
            max_char_w = w
    
    # Apply spacing_factor to the widest character to define the cell width
    # This ensures NO character (like %) will ever be cut off.
    CELL_W = int(max_char_w * spacing_factor)
    CELL_H = int(22 * 3 * pad_factor) # Keep height logic consistent
    
    # Define canvas size for 96 ASCII characters in two rows
    TOTAL_W = CELL_W * 96
    TOTAL_H = CELL_H * 2
    
    canvas = Image.new("L", (TOTAL_W, TOTAL_H), 0)
    draw = ImageDraw.Draw(canvas)

    for i, char in enumerate(chars):
        if i >= 96: break
        x_start = i * CELL_W
        
        # Determine precise text bounding box for current character
        bbox = font.getbbox(char)
        w = bbox[2] - bbox[0]
        h = bbox[3] - bbox[1]
        
        # Center character horizontally within its safe cell
        x_offset = x_start + (CELL_W - w) // 2
        
        # Vertical alignment with the proven nudge factor
        y_pos = (CELL_H - h) - vertical_nudge
        
        # Draw character in both rows
        draw.text((x_offset, y_pos), char, font=font, fill=255)
        draw.text((x_offset, y_pos + CELL_H), char, font=font, fill=255)

    canvas.save(output_name)
    print(f"Font atlas generated: {output_name}")
    print(f"Calculated Cell Width: {CELL_W}px (based on widest character)")
    print(f"Settings: Size {font_size}, SpacingFactor {spacing_factor}, Nudge {vertical_nudge}")

if __name__ == "__main__":
    # best balance for the LG G4:
    create_perfect_font(font_size=38, pad_factor=4, vertical_nudge=38, spacing_factor=0.846)

