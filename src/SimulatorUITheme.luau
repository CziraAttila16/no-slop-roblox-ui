--!strict
-- SimulatorUITheme.luau
-- Design tokens and constants for production-grade Roblox simulator and tycoon UIs.

local SimulatorUITheme = {}

-- Typography standard
SimulatorUITheme.Font = Enum.Font.GothamBlack
SimulatorUITheme.FontFallback = Enum.Font.FredokaOne

-- Border & Stroke Constants
SimulatorUITheme.Stroke = {
	WindowOutline = 3.5,
	CardOutline   = 2.5,
	InnerCard     = 2.0,
	ButtonOutline = 2.8,
	TextLarge     = 3.5,
	TextMedium    = 2.8,
	TextSmall     = 2.0,
	Color = Color3.fromRGB(15, 20, 24), -- Deep cartoon charcoal black (#0F1418)
}

-- Common Colors
SimulatorUITheme.Colors = {
	WindowCanvas      = Color3.fromRGB(59, 88, 102),  -- Solid slate blue (#3B5866)
	DarkRecessed      = Color3.fromRGB(22, 34, 42),   -- Inner container background
	PureWhite         = Color3.fromRGB(255, 255, 255),
	PureBlack         = Color3.fromRGB(0, 0, 0),
	
	-- Close Button 3D Bevel
	CloseFaceTop      = Color3.fromRGB(255, 125, 175),
	CloseFaceBottom   = Color3.fromRGB(255, 20, 40),
	CloseBevelBase    = Color3.fromRGB(115, 0, 16),
	CloseSepLine      = Color3.fromRGB(70, 0, 10),
	CloseInnerStroke  = Color3.fromRGB(255, 210, 235),
}

-- Verified Asset IDs
SimulatorUITheme.Assets = {
	-- Tileable Roblox Studs texture
	StudsTexture     = "rbxassetid://6372755229",
	CheckerboardFade = "rbxassetid://385956923",
	SunburstBloom    = "rbxassetid://130563114903838",
	WhiteRobuxIcon   = "rbxassetid://132185731364109",
	LuckyCloverIcon  = "rbxassetid://140578230080247",
	CashBagsIcon     = "rbxassetid://88694661500877",
	ShoppingBasket   = "rbxassetid://73921878294396",
	HoverSFX         = "rbxassetid://6895079853",
	ClickSFX         = "rbxassetid://6895079853",
}

-- Canonical Header Themes
SimulatorUITheme.Headers = {
	Shop = {
		GradientTop    = Color3.fromRGB(0, 210, 255),    -- Cyan stud header (Brainrot / Pet Sim style)
		GradientBottom = Color3.fromRGB(0, 150, 235),
		StudColor      = Color3.fromRGB(0, 100, 180),
		StudOpacity    = 0.75,
		Title          = "Shop",
		Icon           = "ShoppingBasket",
	},
	Codes = {
		GradientTop    = Color3.fromRGB(0, 235, 200),
		GradientBottom = Color3.fromRGB(0, 160, 180),
		StudColor      = Color3.fromRGB(0, 110, 130),
		StudOpacity    = 0.75,
		Title          = "Codes",
		Icon           = "GiftBox",
	},
	Rebirth = {
		GradientTop    = Color3.fromRGB(180, 50, 255),
		GradientBottom = Color3.fromRGB(120, 10, 220),
		StudColor      = Color3.fromRGB(80, 0, 150),
		StudOpacity    = 0.75,
		Title          = "Rebirth",
		Icon           = "RebirthArrows",
	},
}

-- Card Color Presets
SimulatorUITheme.Cards = {
	ServerLuck = {
		Background = Color3.fromRGB(25, 235, 25),      -- Bright radioactive neon green
		DarkAccent = Color3.fromRGB(10, 140, 15),
		BadgeBg    = Color3.fromRGB(10, 120, 15),
		TextColor  = Color3.fromRGB(255, 255, 255),
		DescColor  = Color3.fromRGB(240, 255, 100),    -- Bright neon yellow
	},
	StarterPack = {
		Background  = Color3.fromRGB(215, 245, 255),   -- Icy cyan container
		BorderColor = Color3.fromRGB(0, 180, 240),
		SlotBg      = Color3.fromRGB(255, 255, 255),
		SlotBorder  = Color3.fromRGB(20, 25, 30),
		BadgeColor  = Color3.fromRGB(255, 230, 0),     -- Limited Time gold
	},
	ProPack = {
		Background  = Color3.fromRGB(255, 255, 255),
		RainbowStroke = true,
		SlotBg      = Color3.fromRGB(240, 245, 250),
		BadgeColor  = Color3.fromRGB(255, 60, 80),
	},
}

-- Robux Purchase Button Theme
SimulatorUITheme.Buttons = {
	RobuxGreen = {
		FaceGradient = { Color3.fromRGB(185, 255, 30), Color3.fromRGB(115, 235, 10) },
		Bevel        = Color3.fromRGB(20, 130, 15),     -- Dark 3D bottom extrusion
		Highlight    = Color3.fromRGB(240, 255, 160),
		StudOpacity  = 0.85,
	},
	ClaimLime = {
		FaceGradient = { Color3.fromRGB(180, 255, 25), Color3.fromRGB(105, 225, 0) },
		Bevel        = Color3.fromRGB(15, 120, 15),
		Highlight    = Color3.fromRGB(235, 255, 130),
	},
	LockedRed = {
		FaceGradient = { Color3.fromRGB(255, 45, 85), Color3.fromRGB(210, 10, 40) },
		Bevel        = Color3.fromRGB(115, 0, 20),
		Highlight    = Color3.fromRGB(255, 180, 200),
	},
}

-- Pro Pack Signature Rainbow Stroke Sequence (Rotation = 45°)
SimulatorUITheme.RainbowSequence = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 40, 90)),
	ColorSequenceKeypoint.new(0.18, Color3.fromRGB(255, 150, 0)),
	ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 235, 0)),
	ColorSequenceKeypoint.new(0.52, Color3.fromRGB(40, 240, 60)),
	ColorSequenceKeypoint.new(0.70, Color3.fromRGB(0, 215, 255)),
	ColorSequenceKeypoint.new(0.85, Color3.fromRGB(100, 70, 255)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(230, 20, 240)),
}

return SimulatorUITheme
