assert(not game:GetService("RunService"):IsRunning(), "Edit only")
local model = workspace.CrumbleArena.Lobby.SocialArea.CreatorStore_Campfire_User
assert(not model:FindFirstChild("CampfireFlameOrigin"), "Already applied")
local fire = model:FindFirstChildWhichIsA("Fire", true)
assert(fire, "Existing native Fire required")
local p = Instance.new("Part")
p.Name = "CampfireFlameOrigin"
p.Size = Vector3.new(.2, .2, .2)
p.Position = Vector3.new(-52, 3.3, 12)
p.Anchored = true
p.Transparency = 1
p.CanCollide = false
p.CanTouch = false
p.CanQuery = false
p.CastShadow = false
p.Parent = model
fire.Parent = p
fire.Size = 5
fire.Heat = 5
