#!/usr/bin/env python3
import os
from PIL import Image, ImageDraw, ImageFont

# Canvas setup
width, height = 2600, 1900
img = Image.new("RGB", (width, height), color="#F8FAFC")
draw = ImageDraw.Draw(img)

# Try loading TrueType fonts, fallback to default
try:
    font_title = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 36)
    font_sub = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 20)
    font_tbl_hdr = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 22)
    font_col = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", 17)
    font_card = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 16)
except Exception:
    font_title = ImageFont.load_default()
    font_sub = font_title
    font_tbl_hdr = font_title
    font_col = font_title
    font_card = font_title

# Header
draw.rectangle([(0, 0), (width, 110)], fill="#0F172A")
draw.text((60, 25), "TripSketch Database — Entity-Relationship (ER) Diagram", fill="#F8FAFC", font=font_title)
draw.text((60, 70), "PostgreSQL 3NF / BCNF Relational Schema (Checkpoint 1)  |  12 Entities  |  Referential Integrity & Cardinalities", fill="#94A3B8", font=font_sub)

# Table definitions: name, (x, y, w, h), columns: [(name, type, constraint)]
tables = {
    "states": {
        "box": (80, 160, 320, 130),
        "header_color": "#1E3A8A",
        "cols": [
            ("state_id", "SERIAL", "PK"),
            ("name", "VARCHAR(100)", "UQ, NN")
        ]
    },
    "locations": {
        "box": (80, 360, 340, 160),
        "header_color": "#1E3A8A",
        "cols": [
            ("location_id", "SERIAL", "PK"),
            ("area_name", "VARCHAR(150)", "NN"),
            ("state_id", "INT", "FK -> states")
        ]
    },
    "vibes": {
        "box": (80, 590, 340, 140),
        "header_color": "#1E3A8A",
        "cols": [
            ("vibe_id", "SERIAL", "PK"),
            ("name", "VARCHAR(50)", "UQ, CHK")
        ]
    },
    "crowd_levels": {
        "box": (80, 790, 340, 140),
        "header_color": "#1E3A8A",
        "cols": [
            ("crowd_level_id", "SERIAL", "PK"),
            ("name", "VARCHAR(20)", "UQ, CHK")
        ]
    },
    "spots": {
        "box": (540, 340, 460, 460),
        "header_color": "#0F766E",
        "cols": [
            ("spot_id", "SERIAL", "PK"),
            ("name", "VARCHAR(150)", "NN"),
            ("location_id", "INT", "FK -> locations"),
            ("vibe_id", "INT", "FK -> vibes"),
            ("crowd_level_id", "INT", "FK -> crowd_levels"),
            ("budget_per_day", "NUMERIC(10,2)", "CHK >= 0"),
            ("rating", "NUMERIC(3,2)", "CHK 0-5"),
            ("popularity", "INT", "CHK 0-100"),
            ("description", "TEXT", "NN"),
            ("image_url", "TEXT", ""),
            ("image_keyword", "VARCHAR(100)", ""),
            ("created_at", "TIMESTAMPTZ", "DEFAULT NOW()")
        ]
    },
    "tags": {
        "box": (1140, 160, 340, 130),
        "header_color": "#1E3A8A",
        "cols": [
            ("tag_id", "SERIAL", "PK"),
            ("name", "VARCHAR(50)", "UQ, NN")
        ]
    },
    "spot_tags": {
        "box": (1140, 360, 340, 150),
        "header_color": "#B45309",
        "cols": [
            ("spot_id", "INT", "PK, FK -> spots"),
            ("tag_id", "INT", "PK, FK -> tags")
        ]
    },
    "users": {
        "box": (1640, 420, 380, 180),
        "header_color": "#1E3A8A",
        "cols": [
            ("user_id", "SERIAL", "PK"),
            ("name", "VARCHAR(100)", "NN"),
            ("email", "VARCHAR(255)", "UQ, CHK"),
            ("created_at", "TIMESTAMPTZ", "DEFAULT NOW()")
        ]
    },
    "favourites": {
        "box": (1140, 600, 360, 160),
        "header_color": "#B45309",
        "cols": [
            ("user_id", "INT", "PK, FK -> users"),
            ("spot_id", "INT", "PK, FK -> spots"),
            ("saved_at", "TIMESTAMPTZ", "DEFAULT NOW()")
        ]
    },
    "recently_viewed": {
        "box": (1140, 830, 360, 160),
        "header_color": "#B45309",
        "cols": [
            ("user_id", "INT", "PK, FK -> users"),
            ("spot_id", "INT", "PK, FK -> spots"),
            ("viewed_at", "TIMESTAMPTZ", "DEFAULT NOW()")
        ]
    },
    "itineraries": {
        "box": (1640, 750, 380, 170),
        "header_color": "#6D28D9",
        "cols": [
            ("itinerary_id", "SERIAL", "PK"),
            ("user_id", "INT", "FK -> users"),
            ("title", "VARCHAR(200)", "NN"),
            ("created_at", "TIMESTAMPTZ", "DEFAULT NOW()")
        ]
    },
    "itinerary_items": {
        "box": (1140, 1080, 420, 200),
        "header_color": "#6D28D9",
        "cols": [
            ("item_id", "SERIAL", "PK"),
            ("itinerary_id", "INT", "FK -> itineraries"),
            ("spot_id", "INT", "FK -> spots"),
            ("day_number", "INT", "CHK >= 1"),
            ("position", "INT", "CHK >= 1")
        ]
    }
}

# Draw tables
for tbl_name, data in tables.items():
    x, y, w, h = data["box"]
    # Outer box with shadow
    draw.rounded_rectangle([(x+4, y+4), (x+w+4, y+h+4)], radius=10, fill="#E2E8F0")
    draw.rounded_rectangle([(x, y), (x+w, y+h)], radius=10, fill="#FFFFFF", outline="#CBD5E1", width=2)
    
    # Table Header
    hdr_h = 42
    draw.rounded_rectangle([(x, y), (x+w, y+hdr_h)], radius=10, fill=data["header_color"])
    # square the bottom of header
    draw.rectangle([(x, y+hdr_h-10), (x+w, y+hdr_h)], fill=data["header_color"])
    draw.text((x+16, y+9), tbl_name, fill="#FFFFFF", font=font_tbl_hdr)
    
    # Draw Columns
    curr_y = y + hdr_h + 12
    for col_name, col_type, col_extra in data["cols"]:
        # PK / FK badge
        if "PK" in col_extra:
            draw.rectangle([(x+14, curr_y+2), (x+42, curr_y+20)], fill="#FEF3C7", outline="#F59E0B")
            draw.text((x+18, curr_y+3), "PK", fill="#B45309", font=font_card)
        elif "FK" in col_extra:
            draw.rectangle([(x+14, curr_y+2), (x+42, curr_y+20)], fill="#E0E7FF", outline="#6366F1")
            draw.text((x+18, curr_y+3), "FK", fill="#4338CA", font=font_card)
        else:
            draw.rectangle([(x+14, curr_y+2), (x+42, curr_y+20)], fill="#F1F5F9", outline="#CBD5E1")
            draw.text((x+22, curr_y+3), "•", fill="#64748B", font=font_card)
            
        # Name
        draw.text((x+52, curr_y+2), col_name, fill="#0F172A", font=font_col)
        # Type
        type_str = f"{col_type}"
        draw.text((x+200, curr_y+2), type_str, fill="#64748B", font=font_col)
        # Extra constraints
        if col_extra and not col_extra.startswith("FK") and not col_extra.startswith("PK"):
            draw.text((x+330, curr_y+2), col_extra, fill="#059669", font=font_card)
        curr_y += 28

# Draw Relationship Connectors (smooth lines with labels and cardinalities)
connections = [
    # (from_tbl, to_tbl, from_pt, to_pt, card_from, card_to, label)
    ("states", "locations", (240, 290), (240, 360), "1", "N", "1:N"),
    ("locations", "spots", (420, 440), (540, 440), "1", "N", "1:N"),
    ("vibes", "spots", (420, 640), (540, 520), "1", "N", "1:N"),
    ("crowd_levels", "spots", (420, 840), (540, 600), "1", "N", "1:N"),
    ("spots", "spot_tags", (1000, 410), (1140, 410), "1", "N", "1:N"),
    ("tags", "spot_tags", (1310, 290), (1310, 360), "1", "N", "1:N"),
    ("spots", "favourites", (1000, 550), (1140, 650), "1", "N", "1:N"),
    ("users", "favourites", (1640, 510), (1500, 650), "1", "N", "1:N"),
    ("spots", "recently_viewed", (1000, 680), (1140, 880), "1", "N", "1:N"),
    ("users", "recently_viewed", (1640, 550), (1500, 880), "1", "N", "1:N"),
    ("users", "itineraries", (1830, 600), (1830, 750), "1", "N", "1:N"),
    ("itineraries", "itinerary_items", (1640, 840), (1560, 1140), "1", "N", "1:N"),
    ("spots", "itinerary_items", (800, 800), (1140, 1140), "1", "N", "1:N")
]

for from_t, to_t, p1, p2, c1, c2, lbl in connections:
    # Draw line with nice elbow or direct
    draw.line([p1, p2], fill="#475569", width=3)
    # Cardinality badges
    draw.rectangle([(p1[0]-14, p1[1]-12), (p1[0]+14, p1[1]+12)], fill="#F8FAFC", outline="#475569", width=1)
    draw.text((p1[0]-5, p1[1]-9), c1, fill="#0F172A", font=font_card)
    draw.rectangle([(p2[0]-14, p2[1]-12), (p2[0]+14, p2[1]+12)], fill="#F8FAFC", outline="#475569", width=1)
    draw.text((p2[0]-5, p2[1]-9), c2, fill="#0F172A", font=font_card)

# Legend at bottom right
leg_x, leg_y, leg_w, leg_h = 1640, 1020, 380, 260
draw.rounded_rectangle([(leg_x, leg_y), (leg_x+leg_w, leg_y+leg_h)], radius=8, fill="#FFFFFF", outline="#94A3B8", width=2)
draw.rectangle([(leg_x, leg_y), (leg_x+leg_w, leg_y+36)], fill="#334155")
draw.text((leg_x+16, leg_y+8), "Legend & Architecture Notes", fill="#FFFFFF", font=font_tbl_hdr)

draw.rectangle([(leg_x+20, leg_y+50), (leg_x+48, leg_y+68)], fill="#FEF3C7", outline="#F59E0B")
draw.text((leg_x+24, leg_y+51), "PK", fill="#B45309", font=font_card)
draw.text((leg_x+60, leg_y+50), "Primary Key (Unique Identifier)", fill="#334155", font=font_card)

draw.rectangle([(leg_x+20, leg_y+80), (leg_x+48, leg_y+98)], fill="#E0E7FF", outline="#6366F1")
draw.text((leg_x+24, leg_y+81), "FK", fill="#4338CA", font=font_card)
draw.text((leg_x+60, leg_y+80), "Foreign Key (Referential Integrity)", fill="#334155", font=font_card)

draw.text((leg_x+20, leg_y+115), "• 3NF/BCNF: Normalization eliminates redundancy", fill="#475569", font=font_card)
draw.text((leg_x+20, leg_y+140), "• Locations separates Area from State hierarchy", fill="#475569", font=font_card)
draw.text((leg_x+20, leg_y+165), "• Spot_Tags implements M:N Tag association", fill="#475569", font=font_card)
draw.text((leg_x+20, leg_y+190), "• Itinerary totals computed dynamically (SUM/JOIN)", fill="#475569", font=font_card)
draw.text((leg_x+20, leg_y+215), "• Strict CHECK constraints guard rating/budget", fill="#475569", font=font_card)

script_dir = os.path.dirname(os.path.abspath(__file__))
out_path = os.path.join(script_dir, "diagrams", "er_diagram.png")
os.makedirs(os.path.dirname(out_path), exist_ok=True)
img.save(out_path, "PNG", dpi=(300, 300))
print(f"Successfully generated high-res ER diagram: {out_path}")
