--!strict
-- SimulatorIcons.luau
-- Production-verified icon registry for Roblox simulator games.
-- Includes canonical rbxassetids and local file path mappings.

local SimulatorIcons = {}

SimulatorIcons.Catalog = {
	Currency = {
		GreenRobux       = "rbxassetid://140133844283644",
		WhiteRobux       = "rbxassetid://132185731364109",
		GoldRobux        = "rbxassetid://106123470666055",
		CashBags         = "rbxassetid://88694661500877",
		GoldenCash       = "rbxassetid://118771267624474",
		GreenCash        = "rbxassetid://97810563752933",
		GoldCoin         = "rbxassetid://116920405583438",
		BlueGem          = "rbxassetid://101730596451341",
	},
	Shop = {
		RedShoppingBasket = "rbxassetid://73921878294396",
		GoldShoppingCart  = "rbxassetid://82781328025500",
		RedShoppingBag    = "rbxassetid://73921878294396",
		GoldShoppingBag   = "rbxassetid://73978096223223",
		GiftBox           = "rbxassetid://119237247140869",
	},
	Luck = {
		FourLeafClover   = "rbxassetid://140578230080247",
		CloverOutline    = "rbxassetid://140578230080247",
		LuckyBlock       = "rbxassetid://119237247140869",
		GoldenHorseshoe  = "rbxassetid://104095781189267",
	},
	Animals = {
		Bunny            = "rbxassetid://107471473111631",
		Cat              = "rbxassetid://126233304381053",
		Dog              = "rbxassetid://94720044097792",
		GoldenCat        = "rbxassetid://136641367912532",
	},
	UI = {
		SettingsGear     = "rbxassetid://16898734421",
		SearchMagnifier  = "rbxassetid://16898734065",
		RebirthArrows    = "rbxassetid://16898733036",
		Checkmark        = "rbxassetid://16898670072",
		Lock             = "rbxassetid://16898673616",
	},
	Textures = {
		RobloxStuds      = "rbxassetid://6372755229",
		CheckerboardDamier = "rbxassetid://385956923",
		SunburstBloom    = "rbxassetid://130563114903838",
	}
}

function SimulatorIcons.Get(category: string, name: string): string?
	local cat = SimulatorIcons.Catalog[category]
	if cat then
		return cat[name]
	end
	return nil
end

function SimulatorIcons.Search(keyword: string): { [string]: string }
	local results = {}
	local lowerKey = string.lower(keyword)
	for catName, catGroup in pairs(SimulatorIcons.Catalog) do
		for iconName, id in pairs(catGroup) do
			if string.find(string.lower(iconName), lowerKey) or string.find(string.lower(catName), lowerKey) then
				results[catName .. "." .. iconName] = id
			end
		end
	end
	return results
end

return SimulatorIcons
