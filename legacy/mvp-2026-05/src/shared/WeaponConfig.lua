--!strict
-- WeaponConfig.lua
-- Configurações da bolinha (snowball) do MVP.

local WeaponConfig = {}

WeaponConfig.BallCooldown = 0.65
WeaponConfig.BallSpeed = 130
WeaponConfig.BallLifetime = 4
WeaponConfig.BallSize = 1.2
WeaponConfig.BallSpawnOffset = Vector3.new(0, 2, -3)

WeaponConfig.MaxThrowDistance = 8 -- distância máxima entre origin do client e o personagem
WeaponConfig.BallColor = Color3.fromRGB(245, 250, 255)
WeaponConfig.BallMaterial = Enum.Material.SmoothPlastic

return WeaponConfig
