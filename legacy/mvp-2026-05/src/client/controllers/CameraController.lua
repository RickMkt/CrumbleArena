--!strict
-- CameraController.lua
-- No MVP a câmera nativa do Roblox basta. Este controller apenas garante o
-- modo padrão e deixa um espaço pronto para evoluir depois (spectator cam etc).

local Players = game:GetService("Players")

local CameraController = {}

function CameraController.init()
	local localPlayer = Players.LocalPlayer
	localPlayer.CameraMode = Enum.CameraMode.Classic
	localPlayer.CameraMaxZoomDistance = 35
	localPlayer.CameraMinZoomDistance = 6
end

return CameraController
