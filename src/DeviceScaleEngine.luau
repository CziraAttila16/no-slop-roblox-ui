--!strict
-- DeviceScaleEngine.luau
-- Dynamic multi-device responsive scaling calculation for Roblox UIs.
-- Ensures windows look proportional across Mobile, Tablet, PC, and Console.

local DeviceScaleEngine = {}

local BASELINE_WIDTH = 1050
local BASELINE_HEIGHT = 620
local MIN_SCALE = 0.52
local MAX_SCALE = 1.18

function DeviceScaleEngine.CalculateScale(viewportSize: Vector2): number
	if viewportSize.X <= 0 or viewportSize.Y <= 0 then
		return 1.0
	end
	
	local scaleX = viewportSize.X / BASELINE_WIDTH
	local scaleY = viewportSize.Y / BASELINE_HEIGHT
	local rawScale = math.min(scaleX, scaleY)
	
	return math.clamp(rawScale, MIN_SCALE, MAX_SCALE)
end

function DeviceScaleEngine.Attach(uiScale: UIScale, camera: Camera): RBXScriptConnection
	local function update()
		uiScale.Scale = DeviceScaleEngine.CalculateScale(camera.ViewportSize)
	end
	
	update()
	return camera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
end

return DeviceScaleEngine
