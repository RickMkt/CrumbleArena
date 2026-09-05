--!strict
-- SoundController.lua
-- Stub leve de sons. Sem assets externos no MVP — estrutura pronta para
-- receber IDs de SoundService no futuro.

local SoundService = game:GetService("SoundService")

local SoundController = {}

local sounds: { [string]: Sound } = {}

local DEFINITIONS = {
	-- ["roundStart"] = "rbxassetid://0",
	-- ["roundEnd"]   = "rbxassetid://0",
	-- ["throw"]      = "rbxassetid://0",
	-- ["blockBreak"] = "rbxassetid://0",
}

function SoundController.init()
	for key, soundId in pairs(DEFINITIONS) do
		local sound = Instance.new("Sound")
		sound.Name = key
		sound.SoundId = soundId
		sound.Volume = 0.6
		sound.Parent = SoundService
		sounds[key] = sound
	end
end

function SoundController.play(name: string)
	local sound = sounds[name]
	if sound then
		sound:Play()
	end
end

return SoundController
