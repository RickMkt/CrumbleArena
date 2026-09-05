--!strict
-- Main.client.lua
-- Ponto de entrada do cliente Crumble Arena.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- garante que os Remotes existam antes dos controllers conectarem
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)
Remotes.init()

local controllers = script.Parent:WaitForChild("controllers")
local UIController = require(controllers.UIController)
local RoundHUDController = require(controllers.RoundHUDController)
local WeaponController = require(controllers.WeaponController)
local CameraController = require(controllers.CameraController)
local SoundController = require(controllers.SoundController)

CameraController.init()
local hud = UIController.init()
RoundHUDController.init(hud)
WeaponController.init()
SoundController.init()

print("[CrumbleArena] Client initialized.")
