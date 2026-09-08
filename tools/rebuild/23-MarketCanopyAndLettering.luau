local M = workspace.CrumbleArena.Lobby.Market
local backup = game.ServerStorage.AstraMarketDetailRollback
assert(not backup:FindFirstChild("OldAwning"), "Already applied")
M.Awning.Name = "OldAwning"
M.OldAwning.Parent = backup
local roof = Instance.new("Folder")
roof.Name = "Awning"
roof.Parent = M
local function part(name, size, cf, color)
 local p = Instance.new("Part")
 p.Name=name p.Size=size p.CFrame=cf p.Color=color
 p.Material=Enum.Material.Fabric p.Anchored=true
 p.CanCollide=false p.CanTouch=false p.CanQuery=false
 p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=roof return p
end
local nodes={{-45,14.42},{-40.3,12.65},{-36.1,11.76},{-33.1,11.65}}
for i=1,7 do
 local x=-46.5+(i-4)*3.3428
 local color=i%2==1 and Color3.fromRGB(16,133,140) or Color3.fromRGB(232,220,186)
 for j=1,3 do
  local a,b=nodes[j],nodes[j+1]
  local dz,dy=b[1]-a[1],b[2]-a[2]
  part("Canvas_"..i.."_"..j,Vector3.new(3.3428,.16,math.sqrt(dz*dz+dy*dy)),CFrame.new(x,(a[2]+b[2])/2,(a[1]+b[1])/2)*CFrame.Angles(-math.atan2(dy,dz),0,0),color)
 end
 local flap=part("CanvasHem_"..i,Vector3.new(3.3428,.8,.16),CFrame.new(x,11.25,-33.1),color)
 -- A broad lower panel gives a tailored edge without tiny decorative wedges.
 part("CanvasHemTip_"..i,Vector3.new(2.94,.22,.16),CFrame.new(x,10.74,-33.1),color)
end
local sign=M.Signage.MarketSign
local gui=sign.Display
gui.SizingMode=Enum.SurfaceGuiSizingMode.FixedSize
gui.CanvasSize=Vector2.new(1000,190)
local label=gui.Label
label.Text="CRUMBLE SUPPLY" label.Font=Enum.Font.FredokaOne
label.TextScaled=false label.TextSize=94 label.TextWrapped=false
label.Size=UDim2.fromScale(.94,.82) label.Position=UDim2.fromScale(.03,.09)
label.TextColor3=Color3.fromRGB(250,235,196)
for _,p in M:GetDescendants() do
 if p:IsA("TextLabel") and p~=label then
  if p.Text:find("TRADER") then p.Text="GEAR & GOODIES" end
  if p.Parent:IsA("SurfaceGui") then
   p.Parent.SizingMode=Enum.SurfaceGuiSizingMode.FixedSize
   p.Parent.CanvasSize=Vector2.new(600,260)
   p.Font=Enum.Font.FredokaOne p.TextScaled=false p.TextSize=60
   p.TextWrapped=true p.Position=UDim2.fromScale(.06,.06) p.Size=UDim2.fromScale(.88,.88)
  end
 end
end
return "Canopy replaced; typography and market name updated"
