--!strict
-- BrainrotShopExample.luau
-- 1:1 Production Implementation of the Canonical Roblox Simulator Shop Menu.
-- Matches the user-provided brainrot shop reference:
-- 1. Cyan stud-textured header with red shopping basket and 3D square close button.
-- 2. Neon-green Server Luck card with 4-leaf clover and 19 Robux purchase button.
-- 3. 3-Slot Starter Pack card with items + "+100K" cash bag and 599 Robux button.
-- 4. Rainbow-bordered Pro Pack card with exclusive items.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Adjust path according to your project setup
local SimulatorUI = script.Parent.Parent.src
local SimulatorUITheme = require(SimulatorUI.SimulatorUITheme)
local SimulatorUIComponents = require(SimulatorUI.SimulatorUIComponents)
local SimulatorIcons = require(SimulatorUI.SimulatorIcons)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Create Base ScreenGui with Multi-Device Responsive Scaling
local shopGui, globalScale = SimulatorUIComponents.CreateScreenGui("BrainrotShopGui")
shopGui.Parent = playerGui

-- 2. Create Modal Window with Studs Header & 2-Tier Shadow
local window, container = SimulatorUIComponents.CreateWindow({
	Title = "Shop",
	Width = 620,
	Height = 440,
	Theme = "Shop",
	OnClose = function()
		print("[Shop] Close button pressed!")
		shopGui.Enabled = false
	end,
})
window.Parent = shopGui

-- 3. Add Server Luck Card (Neon Green with Giant Clover & 19 Robux Button)
SimulatorUIComponents.CreateServerLuckCard({
	Title = "Server Luck!",
	Description = "Makes better brainrots spawn in the game!",
	LuckMultiplier = "Luck = 1x",
	Price = 19,
	Parent = container,
	OnBuy = function()
		print("[Shop] Purchasing Server Luck (19 Robux)...")
	end,
})

-- 4. Add Starter Pack Card (3 Slots: Lionelo Cactuseli, Fluri Flura, +100K Cash)
SimulatorUIComponents.CreatePackCard({
	Title = "Starter Pack",
	SubBadge = "Limited Time",
	Price = 599,
	RainbowBorder = false,
	Slots = {
		{
			Name = "Lionelo Cactuseli",
			Image = "rbxassetid://107471473111631", -- Or ViewportFrame model
			Is3D = false,
		},
		{
			Name = "Fluri Flura",
			Image = "rbxassetid://126233304381053",
			Is3D = false,
		},
		{
			Name = "+100K",
			Image = SimulatorIcons.Catalog.Currency.CashBags,
			Is3D = false,
		},
	},
	Parent = container,
	OnBuy = function()
		print("[Shop] Purchasing Starter Pack (599 Robux)...")
	end,
})

-- 5. Add Pro Pack Card (Rainbow Border + 3 Exclusive Slots)
SimulatorUIComponents.CreatePackCard({
	Title = "Pro Pack",
	SubBadge = "Limited Time",
	Price = 1299,
	RainbowBorder = true,
	Slots = {
		{
			Name = "Titan Mech",
			Image = "rbxassetid://77589096360120",
			Is3D = false,
		},
		{
			Name = "Radioactive Frog",
			Image = "rbxassetid://94720044097792",
			Is3D = false,
		},
		{
			Name = "+1M Cash",
			Image = SimulatorIcons.Catalog.Currency.GoldenCash,
			Is3D = false,
		},
	},
	Parent = container,
	OnBuy = function()
		print("[Shop] Purchasing Pro Pack (1299 Robux)...")
	end,
})

print("[BrainrotShopExample] Loaded successfully into PlayerGui!")
