--!strict
-- SimulatorUIComponents.luau
-- Production-grade component constructors for Roblox simulator UIs.
-- Designed to eliminate generic AI output and enforce Pet Simulator / Brainrot standards.

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local SimulatorUITheme = require(script.Parent.SimulatorUITheme)
local SimulatorIcons = require(script.Parent.SimulatorIcons)
local DeviceScaleEngine = require(script.Parent.DeviceScaleEngine)

local SimulatorUIComponents = {}

-- Helper: Add standard cartoon black stroke
local function addBlackStroke(instance: GuiObject, thickness: number?, mode: Enum.ApplyStrokeMode?): UIStroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = SimulatorUITheme.Stroke.Color
	stroke.Thickness = thickness or 2.5
	stroke.ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
	stroke.Parent = instance
	return stroke
end

-- Helper: Bind tactile spring/bounce interactions to buttons
local function bindButtonBounce(btn: GuiButton, scaleObj: UIScale)
	assert(btn.AnchorPoint == Vector2.new(0.5, 0.5), "Button must have AnchorPoint (0.5, 0.5) for center zoom!")
	
	local tweenHover = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenClick = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenRelease = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	
	btn.MouseEnter:Connect(function()
		TweenService:Create(scaleObj, tweenHover, { Scale = 1.05 }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(scaleObj, tweenHover, { Scale = 1.0 }):Play()
	end)
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(scaleObj, tweenClick, { Scale = 0.94 }):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(scaleObj, tweenRelease, { Scale = 1.05 }):Play()
	end)
end

-- 1. Create Base ScreenGui with Responsive Engine
function SimulatorUIComponents.CreateScreenGui(name: string): (ScreenGui, UIScale)
	local gui = Instance.new("ScreenGui")
	gui.Name = name
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	local globalScale = Instance.new("UIScale")
	globalScale.Name = "GlobalScale"
	globalScale.Parent = gui
	
	local camera = workspace.CurrentCamera
	if camera then
		DeviceScaleEngine.Attach(globalScale, camera)
	end
	
	return gui, globalScale
end

-- 2. Signature 3D Beveled Square Close Button [X]
function SimulatorUIComponents.CreateCloseButton(header: GuiObject, onClose: (() -> ())?): ImageButton
	local btn = Instance.new("ImageButton")
	btn.Name = "CloseButton"
	btn.Size = UDim2.new(0, 38, 0, 38)
	btn.Position = UDim2.new(1, -26, 0.5, 0)
	btn.AnchorPoint = Vector2.new(0.5, 0.5)
	btn.BackgroundColor3 = SimulatorUITheme.Colors.CloseBevelBase
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.ZIndex = 30
	btn.Parent = header
	
	addBlackStroke(btn, 2.8)
	
	-- Face frame shifted upward by 4px to expose the 3D dark bottom bevel
	local face = Instance.new("Frame")
	face.Name = "Face"
	face.Size = UDim2.new(1, 0, 1, -4)
	face.Position = UDim2.new(0, 0, 0, 0)
	face.BackgroundColor3 = SimulatorUITheme.Colors.PureWhite
	face.BorderSizePixel = 0
	face.ZIndex = 31
	face.Parent = btn
	
	local faceGrad = Instance.new("UIGradient")
	faceGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, SimulatorUITheme.Colors.CloseFaceTop),
		ColorSequenceKeypoint.new(1, SimulatorUITheme.Colors.CloseFaceBottom)
	}
	faceGrad.Rotation = 90
	faceGrad.Parent = face
	
	-- Inner pastel stroke highlight
	local inner = Instance.new("Frame")
	inner.Name = "InnerHighlight"
	inner.Size = UDim2.new(1, -2, 1, -2)
	inner.Position = UDim2.new(0.5, 0, 0.5, 0)
	inner.AnchorPoint = Vector2.new(0.5, 0.5)
	inner.BackgroundTransparency = 1
	inner.BorderSizePixel = 0
	inner.ZIndex = 32
	inner.Parent = face
	
	local innerStroke = Instance.new("UIStroke")
	innerStroke.Color = SimulatorUITheme.Colors.CloseInnerStroke
	innerStroke.Thickness = 1.2
	innerStroke.Parent = inner
	
	-- White GothamBlack "X"
	local xLabel = Instance.new("TextLabel")
	xLabel.Name = "X"
	xLabel.Text = "X"
	xLabel.Font = SimulatorUITheme.Font
	xLabel.TextSize = 28
	xLabel.TextColor3 = SimulatorUITheme.Colors.PureWhite
	xLabel.Size = UDim2.new(1, 0, 1, 0)
	xLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	xLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	xLabel.BackgroundTransparency = 1
	xLabel.ZIndex = 33
	xLabel.Parent = face
	
	local xStroke = Instance.new("UIStroke")
	xStroke.Color = SimulatorUITheme.Colors.PureBlack
	xStroke.Thickness = 3.0
	xStroke.Parent = xLabel
	
	local btnScale = Instance.new("UIScale")
	btnScale.Name = "ButtonScale"
	btnScale.Parent = btn
	
	bindButtonBounce(btn, btnScale)
	if onClose then
		btn.MouseButton1Click:Connect(onClose)
	end
	
	return btn
end

-- 3. Create 3D Beveled Robux Buy Button
function SimulatorUIComponents.CreateRobuxButton(price: number | string, onClick: (() -> ())?): ImageButton
	local btn = Instance.new("ImageButton")
	btn.Name = "RobuxBuyButton"
	btn.Size = UDim2.new(0, 125, 0, 42)
	btn.AnchorPoint = Vector2.new(0.5, 0.5)
	btn.BackgroundColor3 = SimulatorUITheme.Buttons.RobuxGreen.Bevel
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.ClipsDescendants = false
	btn.ZIndex = 20
	
	addBlackStroke(btn, SimulatorUITheme.Stroke.ButtonOutline)
	
	-- 3D Face shifted up by 4px
	local face = Instance.new("Frame")
	face.Name = "Face"
	face.Size = UDim2.new(1, 0, 1, -4)
	face.Position = UDim2.new(0, 0, 0, 0)
	face.BackgroundColor3 = SimulatorUITheme.Colors.PureWhite
	face.BorderSizePixel = 0
	face.ClipsDescendants = true
	face.ZIndex = 21
	face.Parent = btn
	
	local faceGrad = Instance.new("UIGradient")
	faceGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, SimulatorUITheme.Buttons.RobuxGreen.FaceGradient[1]),
		ColorSequenceKeypoint.new(1, SimulatorUITheme.Buttons.RobuxGreen.FaceGradient[2])
	}
	faceGrad.Rotation = 90
	faceGrad.Parent = face
	
	-- Studs texture overlay inside button
	local studs = Instance.new("ImageLabel")
	studs.Name = "StudsOverlay"
	studs.Size = UDim2.new(1, 0, 1, 0)
	studs.BackgroundTransparency = 1
	studs.Image = SimulatorUITheme.Assets.StudsTexture
	studs.ImageTransparency = 0.88
	studs.ScaleType = Enum.ScaleType.Tile
	studs.TileSize = UDim2.new(0, 14, 0, 14)
	studs.ZIndex = 22
	studs.Parent = face
	
	-- Inner pastel highlight border
	local inner = Instance.new("Frame")
	inner.Name = "InnerHighlight"
	inner.Size = UDim2.new(1, -2, 1, -2)
	inner.Position = UDim2.new(0.5, 0, 0.5, 0)
	inner.AnchorPoint = Vector2.new(0.5, 0.5)
	inner.BackgroundTransparency = 1
	inner.ZIndex = 23
	inner.Parent = face
	
	local inStroke = Instance.new("UIStroke")
	inStroke.Color = SimulatorUITheme.Buttons.RobuxGreen.Highlight
	inStroke.Thickness = 1.2
	inStroke.Parent = inner
	
	-- Content container (Robux icon + Price text)
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, 0)
	content.BackgroundTransparency = 1
	content.ZIndex = 24
	content.Parent = face
	
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 4)
	layout.Parent = content
	
	local rbxIcon = Instance.new("ImageLabel")
	rbxIcon.Name = "RobuxIcon"
	rbxIcon.Size = UDim2.new(0, 22, 0, 22)
	rbxIcon.BackgroundTransparency = 1
	rbxIcon.Image = SimulatorUITheme.Assets.WhiteRobuxIcon
	rbxIcon.ScaleType = Enum.ScaleType.Fit
	rbxIcon.ZIndex = 25
	rbxIcon.Parent = content
	
	local priceLabel = Instance.new("TextLabel")
	priceLabel.Name = "PriceLabel"
	priceLabel.Text = tostring(price)
	priceLabel.Font = SimulatorUITheme.Font
	priceLabel.TextSize = 24
	priceLabel.TextColor3 = SimulatorUITheme.Colors.PureWhite
	priceLabel.Size = UDim2.new(0, 0, 1, 0)
	priceLabel.AutomaticSize = Enum.AutomaticSize.X
	priceLabel.BackgroundTransparency = 1
	priceLabel.ZIndex = 25
	priceLabel.Parent = content
	
	local priceStroke = Instance.new("UIStroke")
	priceStroke.Color = SimulatorUITheme.Colors.PureBlack
	priceStroke.Thickness = 2.8
	priceStroke.Parent = priceLabel
	
	local scale = Instance.new("UIScale")
	scale.Name = "ButtonScale"
	scale.Parent = btn
	
	bindButtonBounce(btn, scale)
	if onClick then
		btn.MouseButton1Click:Connect(onClick)
	end
	
	return btn
end

-- 4. Create Main Modal Window with Studs Header & 2-Tier Shadow
function SimulatorUIComponents.CreateWindow(props: {
	Title: string,
	Width: number?,
	Height: number?,
	Theme: string?,
	OnClose: (() -> ())?,
}): (Frame, Frame)
	local width = props.Width or 640
	local height = props.Height or 460
	local themeConfig = SimulatorUITheme.Headers[props.Theme or "Shop"] or SimulatorUITheme.Headers.Shop
	
	local window = Instance.new("Frame")
	window.Name = props.Title .. "Window"
	window.Size = UDim2.new(0, width, 0, height)
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.BackgroundColor3 = SimulatorUITheme.Colors.WindowCanvas
	window.BorderSizePixel = 0
	window.ClipsDescendants = false
	window.ZIndex = 10
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = window
	
	addBlackStroke(window, SimulatorUITheme.Stroke.WindowOutline)
	
	-- Header Frame
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 56)
	header.BackgroundColor3 = SimulatorUITheme.Colors.PureWhite
	header.BorderSizePixel = 0
	header.ClipsDescendants = true
	header.ZIndex = 11
	header.Parent = window
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 4)
	headerCorner.Parent = header
	
	local headerGrad = Instance.new("UIGradient")
	headerGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, themeConfig.GradientTop),
		ColorSequenceKeypoint.new(1, themeConfig.GradientBottom)
	}
	headerGrad.Rotation = 90
	headerGrad.Parent = header
	
	-- Tileable Roblox Studs texture overlay on header
	local headerStuds = Instance.new("ImageLabel")
	headerStuds.Name = "StudsOverlay"
	headerStuds.Size = UDim2.new(1, 0, 1, 0)
	headerStuds.BackgroundTransparency = 1
	headerStuds.Image = SimulatorUITheme.Assets.StudsTexture
	headerStuds.ImageColor3 = themeConfig.StudColor
	headerStuds.ImageTransparency = themeConfig.StudOpacity
	headerStuds.ScaleType = Enum.ScaleType.Tile
	headerStuds.TileSize = UDim2.new(0, 18, 0, 18)
	headerStuds.ZIndex = 12
	headerStuds.Parent = header
	
	-- Header Basket / Category Icon
	local icon = Instance.new("ImageLabel")
	icon.Name = "CategoryIcon"
	icon.Size = UDim2.new(0, 40, 0, 40)
	icon.Position = UDim2.new(0, 16, 0.5, 0)
	icon.AnchorPoint = Vector2.new(0, 0.5)
	icon.BackgroundTransparency = 1
	icon.Image = SimulatorUITheme.Assets.ShoppingBasket
	icon.ScaleType = Enum.ScaleType.Fit
	icon.ZIndex = 15
	icon.Parent = header
	
	-- Header Title
	local title = Instance.new("TextLabel")
	title.Name = "TitleLabel"
	title.Text = props.Title
	title.Font = SimulatorUITheme.Font
	title.TextSize = 32
	title.TextColor3 = SimulatorUITheme.Colors.PureWhite
	title.Position = UDim2.new(0, 64, 0.5, 0)
	title.AnchorPoint = Vector2.new(0, 0.5)
	title.Size = UDim2.new(0, 200, 1, 0)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.BackgroundTransparency = 1
	title.ZIndex = 15
	title.Parent = header
	
	local titleStroke = Instance.new("UIStroke")
	titleStroke.Color = SimulatorUITheme.Colors.PureBlack
	titleStroke.Thickness = 3.5
	titleStroke.Parent = title
	
	-- Signature Close Button [X]
	SimulatorUIComponents.CreateCloseButton(header, props.OnClose)
	
	-- 2-Tier 3D Shadow Divider at bottom of header
	local divDark = Instance.new("Frame")
	divDark.Name = "DividerThematic"
	divDark.Size = UDim2.new(1, 0, 0, 3)
	divDark.Position = UDim2.new(0, 0, 0, 56)
	divDark.BackgroundColor3 = themeConfig.StudColor
	divDark.BorderSizePixel = 0
	divDark.ZIndex = 16
	divDark.Parent = window
	
	local divBlack = Instance.new("Frame")
	divBlack.Name = "DividerBlack"
	divBlack.Size = UDim2.new(1, 0, 0, 3)
	divBlack.Position = UDim2.new(0, 0, 0, 59)
	divBlack.BackgroundColor3 = SimulatorUITheme.Colors.PureBlack
	divBlack.BorderSizePixel = 0
	divBlack.ZIndex = 16
	divBlack.Parent = window
	
	-- Body Container (Inner Scrolling Canvas)
	local container = Instance.new("ScrollingFrame")
	container.Name = "BodyContainer"
	container.Size = UDim2.new(1, -16, 1, -72)
	container.Position = UDim2.new(0.5, 0, 0, 66)
	container.AnchorPoint = Vector2.new(0.5, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ScrollBarThickness = 6
	container.ScrollBarImageColor3 = Color3.fromRGB(20, 30, 35)
	container.CanvasSize = UDim2.new(0, 0, 0, 0)
	container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	container.ZIndex = 12
	container.Parent = window
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 10)
	layout.Parent = container
	
	return window, container
end

-- 5. Create Server Luck Card (Wide Promotional Card with Clover & Studs)
function SimulatorUIComponents.CreateServerLuckCard(props: {
	Title: string?,
	Description: string?,
	LuckMultiplier: string?,
	Price: number?,
	Parent: GuiObject,
	OnBuy: (() -> ())?,
}): Frame
	local card = Instance.new("Frame")
	card.Name = "ServerLuckCard"
	card.Size = UDim2.new(1, 0, 0, 105)
	card.BackgroundColor3 = SimulatorUITheme.Cards.ServerLuck.Background
	card.BorderSizePixel = 0
	card.ClipsDescendants = false
	card.ZIndex = 15
	card.Parent = props.Parent
	
	addBlackStroke(card, SimulatorUITheme.Stroke.CardOutline)
	
	-- Left Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Text = props.Title or "Server Luck!"
	title.Font = SimulatorUITheme.Font
	title.TextSize = 26
	title.TextColor3 = SimulatorUITheme.Colors.PureWhite
	title.Position = UDim2.new(0, 12, 0, 10)
	title.Size = UDim2.new(0, 240, 0, 28)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.BackgroundTransparency = 1
	title.ZIndex = 16
	title.Parent = card
	
	local tStroke = Instance.new("UIStroke")
	tStroke.Color = SimulatorUITheme.Colors.PureBlack
	tStroke.Thickness = 3.0
	tStroke.Parent = title
	
	-- Left Subtitle / Description (Neon yellow)
	local desc = Instance.new("TextLabel")
	desc.Name = "Description"
	desc.Text = props.Description or "Makes better brainrots spawn in the game!"
	desc.Font = SimulatorUITheme.Font
	desc.TextSize = 18
	desc.TextColor3 = SimulatorUITheme.Cards.ServerLuck.DescColor
	desc.Position = UDim2.new(0, 12, 0, 42)
	desc.Size = UDim2.new(0, 240, 0, 52)
	desc.TextWrapped = true
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextYAlignment = Enum.TextYAlignment.Top
	desc.BackgroundTransparency = 1
	desc.ZIndex = 16
	desc.Parent = card
	
	local dStroke = Instance.new("UIStroke")
	dStroke.Color = SimulatorUITheme.Colors.PureBlack
	dStroke.Thickness = 2.5
	dStroke.Parent = desc
	
	-- Center Giant Clover Icon
	local clover = Instance.new("ImageLabel")
	clover.Name = "CloverIcon"
	clover.Size = UDim2.new(0, 78, 0, 78)
	clover.Position = UDim2.new(0.5, -45, 0.5, 0)
	clover.AnchorPoint = Vector2.new(0.5, 0.5)
	clover.BackgroundTransparency = 1
	clover.Image = SimulatorUITheme.Assets.LuckyCloverIcon
	clover.ScaleType = Enum.ScaleType.Fit
	clover.ZIndex = 17
	clover.Parent = card
	
	-- Top-Right Multiplier Label ("Luck = 1x")
	local mult = Instance.new("TextLabel")
	mult.Name = "MultiplierLabel"
	mult.Text = props.LuckMultiplier or "Luck = 1x"
	mult.Font = SimulatorUITheme.Font
	mult.TextSize = 28
	mult.TextColor3 = SimulatorUITheme.Colors.PureWhite
	mult.Position = UDim2.new(1, -78, 0, 10)
	mult.AnchorPoint = Vector2.new(0.5, 0)
	mult.Size = UDim2.new(0, 150, 0, 30)
	mult.BackgroundTransparency = 1
	mult.ZIndex = 16
	mult.Parent = card
	
	local mStroke = Instance.new("UIStroke")
	mStroke.Color = SimulatorUITheme.Colors.PureBlack
	mStroke.Thickness = 3.2
	mStroke.Parent = mult
	
	-- Bottom-Right Robux Purchase Button
	local buyBtn = SimulatorUIComponents.CreateRobuxButton(props.Price or 19, props.OnBuy)
	buyBtn.Position = UDim2.new(1, -78, 0, 68)
	buyBtn.Parent = card
	
	return card
end

-- 6. Create Pack Card (Bundle Card with Multiple Slots & Optional Rainbow Border)
function SimulatorUIComponents.CreatePackCard(props: {
	Title: string,
	SubBadge: string?,
	Price: number,
	RainbowBorder: boolean?,
	Slots: { { Name: string, Image: string?, Is3D: boolean?, Model: Model? } },
	Parent: GuiObject,
	OnBuy: (() -> ())?,
}): Frame
	local card = Instance.new("Frame")
	card.Name = props.Title .. "Card"
	card.Size = UDim2.new(1, 0, 0, 120)
	card.BackgroundColor3 = SimulatorUITheme.Cards.StarterPack.Background
	card.BorderSizePixel = 0
	card.ZIndex = 15
	card.Parent = props.Parent
	
	local cardStroke = addBlackStroke(card, SimulatorUITheme.Stroke.CardOutline)
	if props.RainbowBorder then
		local strokeGrad = Instance.new("UIGradient")
		strokeGrad.Color = SimulatorUITheme.RainbowSequence
		strokeGrad.Rotation = 45
		strokeGrad.Parent = cardStroke
	end
	
	-- Slots Container (Left side)
	local slotsContainer = Instance.new("Frame")
	slotsContainer.Name = "SlotsContainer"
	slotsContainer.Size = UDim2.new(0, 360, 1, -12)
	slotsContainer.Position = UDim2.new(0, 8, 0.5, 0)
	slotsContainer.AnchorPoint = Vector2.new(0, 0.5)
	slotsContainer.BackgroundTransparency = 1
	slotsContainer.ZIndex = 16
	slotsContainer.Parent = card
	
	local slotsLayout = Instance.new("UIListLayout")
	slotsLayout.FillDirection = Enum.FillDirection.Horizontal
	slotsLayout.Padding = UDim.new(0, 8)
	slotsLayout.Parent = slotsContainer
	
	for i, slotData in ipairs(props.Slots) do
		local slot = Instance.new("Frame")
		slot.Name = "Slot_" .. i
		slot.Size = UDim2.new(0, 110, 1, 0)
		slot.BackgroundColor3 = Color3.fromRGB(240, 245, 250)
		slot.BorderSizePixel = 0
		slot.ZIndex = 17
		slot.Parent = slotsContainer
		
		addBlackStroke(slot, 2.0)
		
		if slotData.Is3D and slotData.Model then
			-- 3D ViewportFrame
			local viewport = Instance.new("ViewportFrame")
			viewport.Name = "Viewport"
			viewport.Size = UDim2.new(1, 0, 1, -22)
			viewport.Position = UDim2.new(0, 0, 0, 0)
			viewport.BackgroundTransparency = 1
			viewport.ZIndex = 18
			viewport.Parent = slot
			
			local cam = Instance.new("Camera")
			cam.Parent = viewport
			viewport.CurrentCamera = cam
			
			local cloneModel = slotData.Model:Clone()
			cloneModel.Parent = viewport
			
			-- Center camera on primary part
			local cf, size = cloneModel:GetBoundingBox()
			cam.CFrame = CFrame.new(cf.Position + Vector3.new(0, size.Y * 0.3, size.Z * 2.5), cf.Position)
		elseif slotData.Image then
			-- 2D Sprite Image
			local img = Instance.new("ImageLabel")
			img.Name = "ItemImage"
			img.Size = UDim2.new(0, 72, 0, 72)
			img.Position = UDim2.new(0.5, 0, 0.5, -8)
			img.AnchorPoint = Vector2.new(0.5, 0.5)
			img.BackgroundTransparency = 1
			img.Image = slotData.Image
			img.ScaleType = Enum.ScaleType.Fit
			img.ZIndex = 18
			img.Parent = slot
		end
		
		-- Item Name Footer Label
		local label = Instance.new("TextLabel")
		label.Name = "ItemName"
		label.Text = slotData.Name
		label.Font = SimulatorUITheme.Font
		label.TextSize = 14
		label.TextColor3 = SimulatorUITheme.Colors.PureWhite
		label.Position = UDim2.new(0.5, 0, 1, -12)
		label.AnchorPoint = Vector2.new(0.5, 0.5)
		label.Size = UDim2.new(1, -4, 0, 18)
		label.BackgroundTransparency = 1
		label.ZIndex = 19
		label.Parent = slot
		
		local lblStroke = Instance.new("UIStroke")
		lblStroke.Color = SimulatorUITheme.Colors.PureBlack
		lblStroke.Thickness = 2.0
		lblStroke.Parent = label
	end
	
	-- Right Side: Pack Title
	local title = Instance.new("TextLabel")
	title.Name = "PackTitle"
	title.Text = props.Title
	title.Font = SimulatorUITheme.Font
	title.TextSize = 24
	title.TextColor3 = SimulatorUITheme.Colors.PureWhite
	title.Position = UDim2.new(1, -78, 0, 12)
	title.AnchorPoint = Vector2.new(0.5, 0)
	title.Size = UDim2.new(0, 150, 0, 26)
	title.BackgroundTransparency = 1
	title.ZIndex = 16
	title.Parent = card
	
	local pStroke = Instance.new("UIStroke")
	pStroke.Color = SimulatorUITheme.Colors.PureBlack
	pStroke.Thickness = 3.0
	pStroke.Parent = title
	
	-- Limited Time Sub-Badge
	local badge = Instance.new("TextLabel")
	badge.Name = "LimitedBadge"
	badge.Text = props.SubBadge or "Limited Time"
	badge.Font = SimulatorUITheme.Font
	badge.TextSize = 15
	badge.TextColor3 = SimulatorUITheme.Cards.StarterPack.BadgeColor
	badge.Position = UDim2.new(1, -78, 0, 38)
	badge.AnchorPoint = Vector2.new(0.5, 0)
	badge.Size = UDim2.new(0, 150, 0, 18)
	badge.BackgroundTransparency = 1
	badge.ZIndex = 16
	badge.Parent = card
	
	local bStroke = Instance.new("UIStroke")
	bStroke.Color = SimulatorUITheme.Colors.PureBlack
	bStroke.Thickness = 2.2
	bStroke.Parent = badge
	
	-- Robux Buy Button
	local buyBtn = SimulatorUIComponents.CreateRobuxButton(props.Price, props.OnBuy)
	buyBtn.Position = UDim2.new(1, -78, 0, 80)
	buyBtn.Parent = card
	
	return card
end

return SimulatorUIComponents
