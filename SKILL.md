---
name: roblox-ui-vision-replicator
description: >-
  Recreates ANY Roblox UI screenshot or reference image 1:1 in Roblox Studio (Luau).
  When given a UI image (Shop, Codes, Rebirth, Inventory, Gamepass, Brainrot UI), analyzes
  the visual anatomy, finds or searches matching icons, applies tileable Studs and Checkerboard
  backgrounds, constructs 3D beveled buttons, builds real-time ViewportFrames for 3D entities,
  and delivers clean, copy-paste ready production code.
---

# Roblox UI Vision Replicator — 1:1 Image-to-Studio AI Skill

## 🎯 Purpose & Trigger
Activate this skill whenever the user:
1. **Uploads an image / screenshot of a Roblox UI** (e.g., Shop, Codes, Rebirth, Daily Rewards, Packs, HUD) and asks to *"Csináld meg ezt Roblox Studioba!"* ("Build this 1:1 in Roblox Studio").
2. Asks for a production-grade cartoon / simulator / brainrot interface (Pet Simulator 99, Steal a Brainrot, Anime Champions standard).

**The Rule**: Never output flat, generic web-style UI. Every interface must strictly match the screenshot's tactile depth, thick cartoon outlines, 3D extruded buttons, tileable studs backgrounds, and exact mathematical proportions.

---

## 🛠️ The 6-Step Vision-to-Luau 1:1 Pipeline

### Step 1: Visual Decomposition of the Image
When an image is provided, immediately inspect and break down:
1. **Canvas Canvas**:
   - Solid slate blue `#3B5866` canvas with `UICorner` (4px) and outer black `UIStroke` (3.5px).
   - Is there a **Studs Background** or **Damier Checkerboard** overlay?
2. **Header Anatomy**:
   - Background gradient (Cyan, Magenta, Gold, Purple).
   - **Roblox Studs Overlay**: Tileable studs pattern (`ScaleType = Tile`).
   - Title text: `Enum.Font.GothamBlack` + 3.0px to 3.5px black stroke.
   - Category icon (Shopping basket, gift box, rebirth arrows).
   - **Signature 3D Beveled Square Close Button `[X]`**: 38x38px square, burgundy bevel base, shifted pink-crimson face, pastel stroke highlight, white "X".
   - **2-Tier 3D Shadow Divider**: Upper 3px dark accent line + lower 3px solid black line.
3. **Card Types & Grids**:
   - **Promotion / Feature Cards** (e.g. "Server Luck!"): Neon green background, giant clover icon, multiplier label (`Luck = 1x`), Robux button.
   - **Bundle / Pack Cards** (e.g. "Starter Pack", "Pro Pack"): 3-slot horizontal item grid, "Limited Time" gold badge, item names, Robux button.
   - **Tier Borders**: Rainbow gradient border (`UIGradient` on `UIStroke` with 45° rotation) for Pro/Exclusive packs.
4. **Interactive 3D Buttons**:
   - Robux buy button: Neon green face shifted up by 4px to expose the dark green 3D bevel, tileable studs pattern, white vector Robux icon, price text with black stroke.

---

### Step 2: The Icon & Asset Resolution Engine (Never Hallucinate!)
When placing icons from the screenshot:

1. **Category 1: 3D Characters / Pets / Brainrots (e.g. Cactus Lion, Bird, Titan)**:
   - **MANDATE**: DO NOT use a flat 2D stock image!
   - Construct a **`ViewportFrame`** containing the 3D `Model` or `MeshPart`.
   - Point an internal `Camera` at the model's bounding box (`cloneModel:GetBoundingBox()`).
   - Add a gentle rotating loop (`RunService.RenderStepped`) so the entity lives in 3D inside the UI slot.

2. **Category 2: Standard Simulator Icons**:
   Use the verified `rbxassetid://` catalog:
   ```lua
   -- Textures
   StudsTexture       = "rbxassetid://6372755229"  -- Classic tileable studs
   CheckerboardDamier = "rbxassetid://385956923"   -- Checkerboard fade
   SunburstBloom      = "rbxassetid://130563114903838"

   -- Currencies & Actions
   WhiteRobuxIcon     = "rbxassetid://132185731364109"
   GreenRobuxIcon     = "rbxassetid://140133844283644"
   ShoppingBasket     = "rbxassetid://73921878294396" -- Red cartoon basket
   CashBagsIcon       = "rbxassetid://88694661500877" -- Money bag (+100K)
   GoldenCashIcon     = "rbxassetid://118771267624474"
   LuckyCloverIcon    = "rbxassetid://140578230080247" -- 4-leaf clover
   ```

3. **Category 3: Missing or Custom Icons**:
   - Search the local icon repository in `C:\Users\czira\Documents\IconPlugins` (over 2,900+ organized PNGs: Currency, Events, Gvesster, ClassicDivines).
   - If generating code, assign the best matching verified ID and add a clear inline comment:
     ```lua
     img.Image = "rbxassetid://140578230080247" -- [Icon: Clover 1st Outline 256px - replace with your Decal if custom]
     ```

---

### Step 3: Background & Texture Engineering Formulas

#### A. Tileable Studs Background (Lego-style Dots)
Used on headers, cards, and buttons:
```lua
local studs = Instance.new("ImageLabel")
studs.Name = "StudsBackground"
studs.Size = UDim2.new(1, 0, 1, 0)
studs.BackgroundTransparency = 1
studs.Image = "rbxassetid://6372755229"
studs.ImageColor3 = Color3.fromRGB(0, 120, 200) -- Tint matching the theme
studs.ImageTransparency = 0.82                  -- Subtle tactile texture
studs.ScaleType = Enum.ScaleType.Tile
studs.TileSize = UDim2.new(0, 18, 0, 18)
studs.ZIndex = 2
studs.Parent = targetFrame
```

#### B. 2-Tier 3D Shadow Divider (Header Separator)
Every header MUST terminate with this exact 6px double separator:
```lua
-- Tier 1: Dark theme-colored 3px bar
local divDark = Instance.new("Frame")
divDark.Size = UDim2.new(1, 0, 0, 3)
divDark.Position = UDim2.new(0, 0, 0, 56)
divDark.BackgroundColor3 = Color3.fromRGB(0, 80, 140)
divDark.BorderSizePixel = 0
divDark.ZIndex = 5
divDark.Parent = window

-- Tier 2: Solid black 3px bar
local divBlack = Instance.new("Frame")
divBlack.Size = UDim2.new(1, 0, 0, 3)
divBlack.Position = UDim2.new(0, 0, 0, 59)
divBlack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
divBlack.BorderSizePixel = 0
divBlack.ZIndex = 5
divBlack.Parent = window
```

#### C. Pro Pack Signature Rainbow Stroke
```lua
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3.0
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = card

local rainbow = Instance.new("UIGradient")
rainbow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 40, 90)),
    ColorSequenceKeypoint.new(0.18, Color3.fromRGB(255, 150, 0)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 235, 0)),
    ColorSequenceKeypoint.new(0.52, Color3.fromRGB(40, 240, 60)),
    ColorSequenceKeypoint.new(0.70, Color3.fromRGB(0, 215, 255)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(100, 70, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(230, 20, 240)),
}
rainbow.Rotation = 45
rainbow.Parent = stroke
```

---

### Step 4: 3D Beveled Buttons & Spring Micro-Interactions

#### The 3D Bevel Formula:
A 3D button consists of TWO parts:
1. **Outer Frame (Base/Bevel)**: Colored with the dark shade (e.g. `#0F780F` dark green). Has a 2.8px black border.
2. **Inner Frame (Face)**: Shifted UPWARD by 4px (`Size = UDim2.new(1, 0, 1, -4)`). Contains the vibrant gradient, the tileable studs pattern, the icon, and the text.

#### The Tactile Spring Interaction:
Every button MUST have `AnchorPoint = Vector2.new(0.5, 0.5)` and a child `UIScale`:
```lua
local function bindButtonBounce(btn, scaleObj)
    btn.MouseEnter:Connect(function()
        TweenService:Create(scaleObj, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1.05 }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(scaleObj, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1.0 }):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(scaleObj, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.94 }):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(scaleObj, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.05 }):Play()
    end)
end
```

---

### Step 5: Multi-Device Responsive Scaling Engine
Every generated window is automatically governed by dynamic `UIScale`:
```lua
local camera = workspace.CurrentCamera
local function getDeviceScale()
    local vp = camera.ViewportSize
    if vp.X <= 0 or vp.Y <= 0 then return 1 end
    return math.clamp(math.min(vp.X / 1050, vp.Y / 620), 0.52, 1.18)
end

local scaleObj = Instance.new("UIScale")
scaleObj.Scale = getDeviceScale()
scaleObj.Parent = screenGui

camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    scaleObj.Scale = getDeviceScale()
end)
```

---

## 📋 Checklist for 1:1 Re-creation

When delivering the final Luau script to the user:
- [ ] **Font**: ALL text uses `Enum.Font.GothamBlack` with thick black `UIStroke`
- [ ] **Canvas**: Solid slate `#3B5866` background, 4px UICorner, 3.5px black border
- [ ] **Close Button**: Exact 38x38 3D beveled square with shifted face & pastel stroke
- [ ] **Studs Overlay**: Applied to headers and purchase buttons (`ScaleType = Tile`)
- [ ] **2-Tier Shadow**: 3px dark accent line + 3px black line under header
- [ ] **3D Entities**: Rendered via real-time `ViewportFrame` with camera framing
- [ ] **3D Robux Buttons**: Shifted face with dark bevel base + bounce interaction
- [ ] **Pro Pack Border**: Rainbow `UIGradient` on `UIStroke`
- [ ] **Responsive**: Governed by dynamic `UIScale` [0.52, 1.18]
