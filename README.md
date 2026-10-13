# 🛑 no-slop-roblox-ui

> **"Tired of terrible AI Roblox UI? Recreate ANY UI screenshot 1:1 in Roblox Studio!"**

The definitive AI Skill & MCP tool for **Google Antigravity**, **Claude Desktop**, and **Cursor**. Eliminates generic AI UI slop by reverse-engineering any Roblox UI image into production-grade Luau code with cartoon depth, 3D bevels, studs backgrounds, and real-time ViewportFrames.

---

## ⚡ How It Works (The 1:1 Workflow)

1. **You upload ANY UI screenshot** (Shop, Codes, Rebirth, Daily Rewards, Pet Inventory, Brainrot Gamepass menu).
2. **You ask**: *"Csináld meg ezt Roblox Studioba!"* ("Build this 1:1 in Roblox Studio!").
3. **The AI activates this Skill and**:
   - 🔍 Analyzes the exact layout, colors, gradients, and typography.
   - 🧱 Injects the **Lego Studs Background** and **Checkerboard Damier** overlays.
   - 🎯 Resolves all icons from verified `rbxassetid://` registries or local 2,900+ icon packs.
   - 🦁 For 3D characters, pets, and brainrots (like cactus lion, titan mech), generates **real-time `ViewportFrame`** 3D renderers instead of flat stock photos.
   - 🟥 Builds signature **3D beveled buttons** (4px shifted faces, extruded bevel bases, spring bounce animations).
   - 🌈 Adds **Rainbow gradient stroke borders** for exclusive pack tiers.
   - 📱 Hooks up the **Multi-Device Responsive Scaling Engine** (mobile, tablet, PC).

---

## 📦 How to Install This Skill

### Option 1: In Google Antigravity

Clone or copy this repository into your Antigravity skills directory:

```powershell
# One-line install command:
git clone https://github.com/<YOUR_GITHUB_USERNAME>/roblox-simulator-ui-kit.git "$HOME\.gemini\config\skills\roblox-simulator-ui-kit"
```

*Or if you already have the repository locally:*
```powershell
Copy-Item -Recurse "C:\Users\czira\.gemini\antigravity\scratch\roblox-simulator-ui-kit" "$HOME\.gemini\config\skills\roblox-simulator-ui-kit"
```

Once installed, Antigravity automatically detects the `SKILL.md` rules whenever you talk about Roblox UI!

---

### Option 2: In Claude Desktop (MCP Server)

Add the zero-dependency Python MCP server to your `claude_desktop_config.json`:

* **Path**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "roblox-ui-replicator": {
      "command": "python",
      "args": [
        "C:/Users/czira/.gemini/antigravity/scratch/roblox-simulator-ui-kit/mcp/server.py"
      ]
    }
  }
}
```

Restart Claude Desktop, and Claude will automatically have tools to search icons, generate complete shop interfaces, and verify design rules!

---

## 🎨 Core Design Tokens & Features

| Feature | Specification | Purpose |
| :--- | :--- | :--- |
| **Typography** | `Enum.Font.GothamBlack` | Thick, cartoon comic look with 2.5-3.5px black `UIStroke` |
| **Canvas Canvas** | `#3B5866` solid slate blue | Never transparent; gives tactile game depth |
| **Studs Overlay** | `rbxassetid://6372755229` (Tile) | Classic Lego studs background on headers & buttons |
| **Close Button** | 38x38px 3D Bevel Square | Dark burgundy bevel base + pink/crimson shifted face |
| **Divider Bar** | 2-Tier 3D Shadow | 3px theme color bar + 3px solid black bar |
| **3D Entities** | `ViewportFrame` | Real-time 3D camera view of models (no flat stock photos) |
| **Pro Pack Border** | Rainbow `UIGradient` on `UIStroke` | 7-stop spectrum animated gradient |
| **Responsive Scale**| Dynamic `UIScale` [0.52, 1.18] | Scales proportionally on Mobile, Tablet, Console, and PC |

---

## 🚀 Publishing to GitHub

To upload this repository to GitHub so others can download it:

```bash
cd C:\Users\czira\.gemini\antigravity\scratch\roblox-simulator-ui-kit
git init
git add .
git commit -m "feat: 1:1 Roblox UI Vision Replicator skill, MCP server, and Luau library"
git branch -M main
git remote add origin https://github.com/<YOUR_USERNAME>/roblox-simulator-ui-kit.git
git push -u origin main
```

---

## 📄 License
MIT License. Free for commercial and personal Roblox creations.
