--!strict
-- WeaponController.lua
-- Captura o input do jogador e envia RequestThrowBall ao servidor.
-- Aplica um cooldown visual local (apenas estético — o servidor é autoritativo).

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)
local WeaponConfig = require(Shared.WeaponConfig)

local WeaponController = {}

local lastFireLocal = 0

local function getThrowDirection(): Vector3?
	local camera = workspace.CurrentCamera
	if not camera then
		return nil
	end
	local mouse = Players.LocalPlayer:GetMouse()
	local hitPos = mouse.Hit.Position
	local origin = camera.CFrame.Position
	local dir = (hitPos - origin)
	if dir.Magnitude < 0.05 then
		return camera.CFrame.LookVector
	end
	return dir.Unit
end

local function fire()
	local now = os.clock()
	if now - lastFireLocal < WeaponConfig.BallCooldown then
		return
	end
	local localPlayer = Players.LocalPlayer
	local character = localPlayer.Character
	if not character then
		return
	end
	local hrp = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not hrp then
		return
	end
	local direction = getThrowDirection()
	if not direction then
		return
	end
	lastFireLocal = now
	local request = {
		direction = direction,
		origin = hrp.Position,
	}
	Remotes.get("RequestThrowBall"):FireServer(request)
end

function WeaponController.init()
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			fire()
		elseif input.UserInputType == Enum.UserInputType.Touch then
			fire()
		elseif input.KeyCode == Enum.KeyCode.ButtonR2 then
			fire()
		end
	end)
end

return WeaponController
