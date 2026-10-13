from PIL import Image, ImageDraw

def create_stud_texture(filename, size=64):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Outer circle (subtle shadow)
    margin = size // 6
    bbox = [margin, margin, size - margin, size - margin]
    draw.ellipse(bbox, fill=(255, 255, 255, 90), outline=(0, 0, 0, 80), width=2)
    
    # Inner bevel ring (highlight top-left)
    inner_margin = margin + 4
    inner_bbox = [inner_margin, inner_margin, size - inner_margin, size - inner_margin]
    draw.ellipse(inner_bbox, fill=(255, 255, 255, 140))
    
    # Inner center dot
    center_margin = margin + 8
    center_bbox = [center_margin, center_margin, size - center_margin, size - center_margin]
    draw.ellipse(center_bbox, fill=(255, 255, 255, 60))
    
    img.save(filename, "PNG")
    print(f"Saved {filename}")

if __name__ == "__main__":
    create_stud_texture(r"C:\Users\czira\.gemini\antigravity\scratch\roblox-simulator-ui-kit\assets\textures\studs_tile.png")
