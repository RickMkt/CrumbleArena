--!strict
-- BlockService.lua
-- Quebra blocos da arena com pequeno efeito visual.

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local ArenaConfig = require(Shared.ArenaConfig)

local BlockService = {}

function BlockService:IsBreakable(instance: Instance?): boolean
	if not instance then
		return false
	end
	if not instance:IsA("BasePart") then
		return false
	end
	if instance:GetAttribute("Breakable") ~= true then
		return false
	end
	if instance:GetAttribute("Broken") == true then
		return false
	end
	return true
end

function BlockService:BreakBlock(block: BasePart)
	if not BlockService:IsBreakable(block) then
		return false
	end
	block:SetAttribute("Broken", true)
	block.CanCollide = false
	block.CanTouch = false
	block.CanQuery = false

	local tweenTime = ArenaConfig.BlockBreakTweenTime
	local goalSize = block.Size * ArenaConfig.BlockShrinkScale
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(block, tweenInfo, {
		Size = goalSize,
		Transparency = 1,
	})
	tween:Play()
	tween.Completed:Connect(function()
		if block and block.Parent then
			block:Destroy()
		end
	end)
	-- segurança: remove em qualquer caso
	task.delay(tweenTime + 0.5, function()
		if block and block.Parent then
			block:Destroy()
		end
	end)
	return true
end

-- Quebra todos os blocos breakable em um raio. Usado por features futuras (TNT etc).
function BlockService:BreakBlocksInRadius(position: Vector3, radius: number)
	local count = 0
	local arenaRoot = Workspace:FindFirstChild("CrumbleArena")
	if not arenaRoot then
		return 0
	end
	local current = arenaRoot:FindFirstChild("CurrentArena")
	if not current then
		return 0
	end
	for _, descendant in ipairs(current:GetDescendants()) do
		if descendant:IsA("BasePart") and BlockService:IsBreakable(descendant) then
			local d = (descendant.Position - position).Magnitude
			if d <= radius then
				if BlockService:BreakBlock(descendant) then
					count += 1
				end
			end
		end
	end
	return count
end

return BlockService
