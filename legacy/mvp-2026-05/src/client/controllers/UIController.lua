--!strict
-- UIController.lua
-- Cria a HUD do Crumble Arena no PlayerGui e expõe os handles para outros
-- controllers atualizarem.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UI = ReplicatedStorage:WaitForChild("UI")
local CreateHUD = require(UI.CreateHUD)

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)

local UIController = {}

local hud: any = nil

function UIController.init()
	local localPlayer = Players.LocalPlayer
	hud = CreateHUD.build(localPlayer, Config.GameName)
	return hud
end

function UIController.getHud()
	return hud
end

return UIController
