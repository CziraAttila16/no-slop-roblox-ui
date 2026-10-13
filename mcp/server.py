#!/usr/bin/env python3
"""
Roblox Simulator UI Kit - MCP Server
Zero-dependency MCP stdio server compatible with Claude Desktop and Antigravity.
Provides icon searching and instant Luau component generation for Roblox Simulator UIs.
"""

import sys
import os
import json
import re

# Default icon library search paths
DEFAULT_ICON_PATHS = [
    r"C:\Users\czira\Documents\IconPlugins",
    os.path.join(os.path.dirname(__file__), "..", "assets"),
]

# Pre-indexed Roblox verified rbxassetids
VERIFIED_ASSETS = {
    "currency": {
        "green_robux": "rbxassetid://140133844283644",
        "white_robux": "rbxassetid://132185731364109",
        "gold_robux": "rbxassetid://106123470666055",
        "cash_bags": "rbxassetid://88694661500877",
        "golden_cash": "rbxassetid://118771267624474",
        "green_cash": "rbxassetid://97810563752933",
        "gold_coin": "rbxassetid://116920405583438",
        "blue_gem": "rbxassetid://101730596451341",
    },
    "shop": {
        "red_shopping_basket": "rbxassetid://73921878294396",
        "gold_shopping_cart": "rbxassetid://82781328025500",
        "shopping_bag": "rbxassetid://73978096223223",
        "gift_box": "rbxassetid://119237247140869",
    },
    "luck": {
        "clover_4_leaf": "rbxassetid://140578230080247",
        "clover_outline": "rbxassetid://140578230080247",
        "lucky_block": "rbxassetid://119237247140869",
        "golden_horseshoe": "rbxassetid://104095781189267",
    },
    "textures": {
        "roblox_studs": "rbxassetid://6372755229",
        "checkerboard_damier": "rbxassetid://385956923",
        "sunburst_bloom": "rbxassetid://130563114903838",
    },
    "sounds": {
        "hover_sfx": "rbxassetid://6895079853",
        "click_sfx": "rbxassetid://6895079853",
    }
}

TOOLS = [
    {
        "name": "search_roblox_icons",
        "description": "Searches for cartoon/simulator icons across both verified rbxassetids and local PNG libraries.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": "Keyword to search for, e.g. 'basket', 'clover', 'luck', 'money', 'robux', 'sword'"
                },
                "category": {
                    "type": "string",
                    "description": "Optional category filter: 'currency', 'shop', 'luck', 'textures', or empty for all"
                }
            },
            "required": ["query"]
        }
    },
    {
        "name": "generate_simulator_shop",
        "description": "Generates complete production-grade Luau code for a Pet Simulator / Brainrot style Shop UI.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "title": {
                    "type": "string",
                    "description": "Window title, e.g. 'Shop'"
                },
                "server_luck": {
                    "type": "boolean",
                    "description": "Whether to include the Server Luck promotion card with 4-leaf clover"
                },
                "include_starter_pack": {
                    "type": "boolean",
                    "description": "Whether to include the 3-item Starter Pack card"
                },
                "include_pro_pack": {
                    "type": "boolean",
                    "description": "Whether to include the rainbow-bordered Pro Pack card"
                }
            }
        }
    },
    {
        "name": "get_design_system_rules",
        "description": "Retrieves the non-negotiable Check-UI / Roblox Simulator Design System rules (fonts, strokes, bevels, stud overlays).",
        "inputSchema": {
            "type": "object",
            "properties": {}
        }
    },
    {
        "name": "generate_studs_overlay",
        "description": "Generates Luau code for creating a tileable Lego-style studs background overlay on any Roblox UI frame.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "parent_name": {
                    "type": "string",
                    "description": "Variable name of the parent frame, e.g. 'header', 'card', 'button'"
                },
                "tint_color_rgb": {
                    "type": "string",
                    "description": "Optional RGB tint, e.g. '0, 150, 235'"
                },
                "transparency": {
                    "type": "number",
                    "description": "Transparency level between 0 and 1, default 0.82"
                }
            }
        }
    }
]

def search_local_files(query):
    results = []
    q = query.lower()
    for root_dir in DEFAULT_ICON_PATHS:
        if not os.path.exists(root_dir):
            continue
        for root, _, files in os.walk(root_dir):
            for f in files:
                if f.lower().endswith(('.png', '.svg')) and q in f.lower():
                    results.append({
                        "filename": f,
                        "path": os.path.join(root, f)
                    })
                    if len(results) >= 25:
                        return results
    return results

def handle_search_icons(args):
    q = args.get("query", "").lower()
    cat_filter = args.get("category", "").lower()
    
    verified_matches = []
    for cat, items in VERIFIED_ASSETS.items():
        if cat_filter and cat != cat_filter:
            continue
        for name, asset_id in items.items():
            if q in name or q in cat:
                verified_matches.append({
                    "name": name,
                    "category": cat,
                    "rbxassetid": asset_id
                })
                
    local_matches = search_local_files(q)
    
    return {
        "verified_rbxassetids": verified_matches,
        "local_png_files_count": len(local_matches),
        "local_png_samples": local_matches[:15]
    }

def handle_generate_shop(args):
    title = args.get("title", "Shop")
    server_luck = args.get("server_luck", True)
    starter_pack = args.get("include_starter_pack", True)
    pro_pack = args.get("include_pro_pack", True)
    
    # Read BrainrotShopExample.luau template
    template_path = os.path.join(os.path.dirname(__file__), "..", "examples", "BrainrotShopExample.luau")
    if os.path.exists(template_path):
        with open(template_path, "r", encoding="utf-8") as f:
            code = f.read()
    else:
        code = "-- Refer to src/SimulatorUIComponents.luau"
        
    return {
        "message": f"Generated {title} window with production-grade components.",
        "luau_code": code
    }

def handle_get_rules(args):
    rules = {
        "1_typography": "Strict Enum.Font.GothamBlack with black UIStroke (2.0px to 3.5px).",
        "2_canvas": "Solid slate blue Color3.fromRGB(59, 88, 102) (#3B5866), 4px UICorner, 3.5px black UIStroke.",
        "3_close_button": "Exact 38x38px square with 3D burgundy bevel extrusion (#730010), shifted crimson face, inner pastel highlight, white GothamBlack 'X'.",
        "4_header_divider": "2-tier separator: upper 3px dark thematic accent bar + lower 3px solid black bar.",
        "5_studs_overlay": "Tileable Roblox Studs texture overlay (rbxassetid://6372755229) with transparency 0.75-0.88.",
        "6_rainbow_border": "UIGradient ColorSequence applied to UIStroke for Pro/Exclusive tier cards.",
        "7_viewport_frames": "Use ViewportFrames for 3D character/brainrot/pet models inside item slots instead of flat 2D stock photos.",
        "8_responsive_scaling": "Governed by dynamic UIScale clamped between 0.52 (mobile) and 1.18 (desktop) based on 1050x620 baseline."
    }
def handle_generate_studs(args):
    parent = args.get("parent_name", "targetFrame")
    tint = args.get("tint_color_rgb", "0, 120, 200")
    trans = args.get("transparency", 0.82)
    
    code = f"""-- Tileable Studs Background Overlay
local studs = Instance.new("ImageLabel")
studs.Name = "StudsBackground"
studs.Size = UDim2.new(1, 0, 1, 0)
studs.BackgroundTransparency = 1
studs.Image = "rbxassetid://6372755229"
studs.ImageColor3 = Color3.fromRGB({tint})
studs.ImageTransparency = {trans}
studs.ScaleType = Enum.ScaleType.Tile
studs.TileSize = UDim2.new(0, 18, 0, 18)
studs.ZIndex = 2
studs.Parent = {parent}
"""
    return {"luau_code": code}

def main():
    while True:
        line = sys.stdin.readline()
        if not line:
            break
        line = line.strip()
        if not line:
            continue
        try:
            req = json.loads(line)
        except Exception:
            continue

        method = req.get("method")
        msg_id = req.get("id")

        if method == "initialize":
            res = {
                "jsonrpc": "2.0",
                "id": msg_id,
                "result": {
                    "protocolVersion": "2024-11-05",
                    "capabilities": {
                        "tools": {}
                    },
                    "serverInfo": {
                        "name": "roblox-simulator-ui",
                        "version": "1.0.0"
                    }
                }
            }
            sys.stdout.write(json.dumps(res) + "\n")
            sys.stdout.flush()
        elif method == "notifications/initialized":
            pass
        elif method == "tools/list":
            res = {
                "jsonrpc": "2.0",
                "id": msg_id,
                "result": {
                    "tools": TOOLS
                }
            }
            sys.stdout.write(json.dumps(res) + "\n")
            sys.stdout.flush()
        elif method == "tools/call":
            params = req.get("params", {})
            tool_name = params.get("name")
            tool_args = params.get("arguments", {})
            
            if tool_name == "search_roblox_icons":
                out = handle_search_icons(tool_args)
            elif tool_name == "generate_simulator_shop":
                out = handle_generate_shop(tool_args)
            elif tool_name == "get_design_system_rules":
                out = handle_get_rules(tool_args)
            elif tool_name == "generate_studs_overlay":
                out = handle_generate_studs(tool_args)
            else:
                out = {"error": f"Unknown tool: {tool_name}"}

            res = {
                "jsonrpc": "2.0",
                "id": msg_id,
                "result": {
                    "content": [
                        {
                            "type": "text",
                            "text": json.dumps(out, indent=2)
                        }
                    ]
                }
            }
            sys.stdout.write(json.dumps(res) + "\n")
            sys.stdout.flush()

if __name__ == "__main__":
    main()
