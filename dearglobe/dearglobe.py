from PIL import Image, ImageDraw, ImageFont
import numpy as np
import cv2
import svgwrite

width, height = 1920, 780

def generate_both_outlines(img, text):
    # Create SVG file that will contain both outlines
    dwg = svgwrite.Drawing(text + "_outlines.svg", size=(f"{width}px", f"{height}px"), profile="full")
    dwg.attribs['viewBox'] = f"0 0 {width} {height}"
    
    # Get original outline contours
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    _, binary = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)
    original_contours, _ = cv2.findContours(binary, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    
    # Add original contours to SVG (in white)
    for contour in original_contours:
        path_data = "M"
        for i, point in enumerate(contour):
            x, y = point[0]
            if i == 0:
                path_data += f" {x},{y}"
            else:
                path_data += f" L {x},{y}"
        path_data += " Z"  # Close the path
        
        # Add the original outline path to the SVG
        path = dwg.path(d=path_data, fill="none", stroke="white", stroke_width=2)
        dwg.add(path)

    # Now create dilated version with circular kernel
    kernel_size = 85  # Adjust this value as needed
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (kernel_size, kernel_size))
    dilated = cv2.dilate(binary, kernel, iterations=1)

    # Get dilated contours
    dilated_contours, _ = cv2.findContours(dilated, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    
    # Add dilated contours to the same SVG (in a different color like cyan)
    for contour in dilated_contours:
        path_data = "M"
        for i, point in enumerate(contour):
            x, y = point[0]
            if i == 0:
                path_data += f" {x},{y}"
            else:
                path_data += f" L {x},{y}"
        path_data += " Z"  # Close the path
        
        # Add the dilated outline path to the SVG with a different color
        path = dwg.path(d=path_data, fill="none", stroke="cyan", stroke_width=2)
        dwg.add(path)
    
    # Save the SVG file with both outlines
    dwg.save()
    print(f"SVG with both outlines saved as '{text}_outlines.svg'")

def genOutline(text):
    # Create a blank image with the specified size
    global width, height
    image = Image.new('RGB', (width, height), color='black')
    draw = ImageDraw.Draw(image)
    
    # Load the font
    font_size = 600
    try:
        font = ImageFont.truetype("Montserrat-Regular.ttf", font_size)
    except IOError:
        # Fallback to a default font
        font = ImageFont.load_default()
        print("Warning: Montserrat font not found, using default font")
    
    # Calculate the total width with reduced kerning
    kerning_factor = 0.9  # Adjust this value (0.9 = 90% of normal spacing)
    total_width = 0
    
    # Calculate width of each character
    widths = []
    for char in text:
        char_width = draw.textlength(char, font=font)
        widths.append(char_width)
        total_width += char_width * kerning_factor
    
    # Calculate starting position (centered)
    x_start = (width - total_width) // 2
    y_position = 0
    
    # Draw each character with reduced spacing
    x_pos = x_start
    for i, char in enumerate(text):
        draw.text((x_pos, y_position), char, font=font, fill='white')
        x_pos += widths[i] * kerning_factor
    
    # Save the image
    image.save(text + ".png")
    
    # Load with OpenCV and generate both outlines in one SVG
    img = cv2.imread(text + ".png")
    generate_both_outlines(img, text)

# Generate outlines for both words
genOutline("dear")
genOutline("globe")