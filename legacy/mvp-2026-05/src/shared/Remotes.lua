--!strict
-- Remotes.lua
-- Cria/obtém os RemoteEvents centrais do Crumble Arena.
-- Servidor cria, cliente apenas obtém via WaitForChild.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FOLDER_NAME = "CrumbleArenaRemotes"

local REMOTE_NAMES = {
	"RequestThrowBall",
	"RoundStateChanged",
	"HUDUpdate",
	"CenterMessage",
	"MatchScoreUpdate",
}

local Remotes = {}

local function getOrCreateFolder(): Folder
	local existing = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
	if existing and existing:IsA("Folder") then
		return existing
	end
	if RunService:IsServer() then
		local folder = Instance.new("Folder")
		folder.Name = FOLDER_NAME
		folder.Parent = ReplicatedStorage
		return folder
	end
	-- cliente espera o servidor criar
	return ReplicatedStorage:WaitForChild(FOLDER_NAME, 30) :: Folder
end

local function getOrCreateRemote(folder: Folder, name: string): RemoteEvent
	local existing = folder:FindFirstChild(name)
	if existing and existing:IsA("RemoteEvent") then
		return existing
	end
	if RunService:IsServer() then
		local remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = folder
		return remote
	end
	return folder:WaitForChild(name, 30) :: RemoteEvent
end

function Remotes.init()
	local folder = getOrCreateFolder()
	for _, remoteName in ipairs(REMOTE_NAMES) do
		Remotes[remoteName] = getOrCreateRemote(folder, remoteName)
	end
	return Remotes
end

function Remotes.get(name: string): RemoteEvent
	if not Remotes[name] then
		Remotes.init()
	end
	return Remotes[name]
end

return Remotes
