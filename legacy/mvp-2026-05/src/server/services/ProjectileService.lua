--!strict
-- ProjectileService.lua
-- Server-authoritative: recebe RequestThrowBall do cliente, valida, cria a
-- bolinha em Workspace.CrumbleArena.Projectiles e a move via raycast por frame.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local WeaponConfig = require(Shared.WeaponConfig)
local Remotes = require(Shared.Remotes)
local RoundStates = require(Shared.RoundStates)

local services = script.Parent
local ArenaService = require(services.ArenaService)
local BlockService = require(services.BlockService)
local PlayerRoundService = require(services.PlayerRoundService)

local ProjectileService = {}

type Projectile = {
	part: BasePart,
	velocity: Vector3,
	owner: Player,
	expiresAt: number,
	dead: boolean,
}

local active: { [BasePart]: Projectile } = {}
local cooldowns: { [number]: number } = {}
local heartbeatConnection: RBXScriptConnection? = nil
local getStateFn: (() -> string)? = nil

local function isThrowAllowed(player: Player, direction: Vector3): (boolean, string?)
	if getStateFn and getStateFn() ~= RoundStates.InRound then
		return false, "not in round"
	end
	if not PlayerRoundService.isAlive(player) then
		return false, "not alive"
	end
	if direction.Magnitude < 0.05 then
		return false, "invalid direction"
	end
	local now = os.clock()
	local lastFire = cooldowns[player.UserId]
	if lastFire and now - lastFire < WeaponConfig.BallCooldown then
		return false, "cooldown"
	end
	return true
end

local function spawnBall(player: Player, origin: Vector3, direction: Vector3)
	local folder = ArenaService.getProjectilesFolder()

	local ball = Instance.new("Part")
	ball.Name = "SnowBall"
	ball.Shape = Enum.PartType.Ball
	ball.Anchored = true
	ball.CanCollide = false
	ball.Massless = true
	ball.Material = WeaponConfig.BallMaterial
	ball.Color = WeaponConfig.BallColor
	ball.Size = Vector3.new(WeaponConfig.BallSize, WeaponConfig.BallSize, WeaponConfig.BallSize)
	ball.CFrame = CFrame.new(origin)
	ball:SetAttribute("OwnerUserId", player.UserId)

	local trail = Instance.new("Trail")
	local a0 = Instance.new("Attachment")
	a0.Position = Vector3.new(0, WeaponConfig.BallSize / 2, 0)
	a0.Parent = ball
	local a1 = Instance.new("Attachment")
	a1.Position = Vector3.new(0, -WeaponConfig.BallSize / 2, 0)
	a1.Parent = ball
	trail.Attachment0 = a0
	trail.Attachment1 = a1
	trail.Lifetime = 0.18
	trail.Color = ColorSequence.new(WeaponConfig.BallColor)
	trail.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.4),
		NumberSequenceKeypoint.new(1, 1),
	})
	trail.WidthScale = NumberSequence.new(1, 0)
	trail.Parent = ball

	ball.Parent = folder

	local proj: Projectile = {
		part = ball,
		velocity = direction.Unit * WeaponConfig.BallSpeed,
		owner = player,
		expiresAt = os.clock() + WeaponConfig.BallLifetime,
		dead = false,
	}
	active[ball] = proj
	return proj
end

local function destroyProjectile(proj: Projectile)
	if proj.dead then
		return
	end
	proj.dead = true
	active[proj.part] = nil
	if proj.part and proj.part.Parent then
		proj.part:Destroy()
	end
end

local function tickProjectiles(dt: number)
	local now = os.clock()
	-- snapshot para permitir destruição segura durante a iteração
	local snapshot: { Projectile } = {}
	for _, proj in pairs(active) do
		table.insert(snapshot, proj)
	end
	for _, proj in ipairs(snapshot) do
		if proj.dead then
			continue
		end
		if now >= proj.expiresAt then
			destroyProjectile(proj)
			continue
		end
		local part = proj.part
		if not part or not part.Parent then
			proj.dead = true
			continue
		end

		local startPos = part.Position
		local step = proj.velocity * dt

		local rayParams = RaycastParams.new()
		rayParams.FilterType = Enum.RaycastFilterType.Exclude
		local exclude: { Instance } = { ArenaService.getProjectilesFolder() }
		local ownerChar = proj.owner and proj.owner.Character
		if ownerChar then
			table.insert(exclude, ownerChar)
		end
		rayParams.FilterDescendantsInstances = exclude
		rayParams.IgnoreWater = true

		local result = workspace:Raycast(startPos, step, rayParams)
		if result and result.Instance then
			local hit = result.Instance
			if BlockService:IsBreakable(hit) then
				BlockService:BreakBlock(hit)
			end
			-- destrói no ponto de impacto
			part.CFrame = CFrame.new(result.Position)
			destroyProjectile(proj)
		else
			part.CFrame = CFrame.new(startPos + step)
		end
	end
end

local function onRequestThrow(player: Player, payload: any)
	if typeof(payload) ~= "table" then
		return
	end
	local direction = payload.direction
	if typeof(direction) ~= "Vector3" then
		return
	end
	local allowed, reason = isThrowAllowed(player, direction)
	if not allowed then
		return
	end

	local character = player.Character
	if not character then
		return
	end
	local hrp = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not hrp then
		return
	end

	-- valida se a origem informada pelo cliente está perto do personagem
	local clientOrigin = payload.origin
	local serverAnchor = hrp.Position
	if typeof(clientOrigin) == "Vector3" then
		if (clientOrigin - serverAnchor).Magnitude > WeaponConfig.MaxThrowDistance then
			-- ignora origem do cliente, usa servidor
			clientOrigin = nil
		end
	end

	local forward = direction.Unit
	local origin = (clientOrigin or serverAnchor) + forward * 1.5 + Vector3.new(0, 1, 0)

	cooldowns[player.UserId] = os.clock()
	spawnBall(player, origin, forward)
end

function ProjectileService.init(deps: { getRoundState: () -> string })
	getStateFn = deps.getRoundState
	local remote = Remotes.get("RequestThrowBall")
	remote.OnServerEvent:Connect(onRequestThrow)

	if heartbeatConnection then
		heartbeatConnection:Disconnect()
	end
	heartbeatConnection = RunService.Heartbeat:Connect(tickProjectiles)

	Players.PlayerRemoving:Connect(function(player)
		cooldowns[player.UserId] = nil
	end)
end

function ProjectileService.clearAll()
	for _, proj in pairs(active) do
		destroyProjectile(proj)
	end
end

return ProjectileService
