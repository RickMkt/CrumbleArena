-- Visual selection supplied by Rick from screenshots on 2026-09-07.
-- Leaves both the full catalog and Astra shortlist untouched.
local staging=workspace.CrumbleArena.AssetStaging
assert(not staging:FindFirstChild("UserSelectedAssets"),"UserSelectedAssets already exists")
local root=Instance.new("Model") root.Name="UserSelectedAssets" root.Parent=staging
root:SetAttribute("SelectedBy","Rick") root:SetAttribute("SelectionDate","2026-09-07")
root:SetAttribute("Purpose","User visual selection; review before production integration")
root:SetAttribute("ProductionApproved",false)

local function part(name,size,pos,color,parent)
 local p=Instance.new("Part") p.Name=name p.Size=size p.Position=pos p.Color=color
 p.Material=Enum.Material.Plastic p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=false
 p.TopSurface=Enum.SurfaceType.Studs p.BottomSurface=Enum.SurfaceType.Smooth p.Parent=parent return p
end
part("SelectionPlatform",Vector3.new(156,1,118),Vector3.new(500,-.5,180),Color3.fromRGB(74,86,101),root).CanCollide=true
for _,v in {{156,1.4,1,500,.2,121.5},{156,1.4,1,500,.2,238.5},{1,1.4,118,422.5,.2,180},{1,1.4,118,577.5,.2,180}} do
 local p=part("PlatformTrim",Vector3.new(v[1],v[2],v[3]),Vector3.new(v[4],v[5],v[6]),Color3.fromRGB(34,45,61),root) p.CanCollide=true
end
local function board(text,pos,size,color)
 local p=part("Board",size,pos,Color3.fromRGB(23,34,52),root)
 local g=Instance.new("SurfaceGui") g.Face=Enum.NormalId.Front g.SizingMode=Enum.SurfaceGuiSizingMode.FixedSize g.CanvasSize=Vector2.new(1000,220) g.Parent=p
 local t=Instance.new("TextLabel") t.BackgroundTransparency=1 t.Size=UDim2.fromScale(.96,.9) t.Position=UDim2.fromScale(.02,.05)
 t.Text=text t.TextColor3=color or Color3.fromRGB(244,232,195) t.Font=Enum.Font.FredokaOne t.TextScaled=true t.TextWrapped=true t.Parent=g
 local back=g:Clone() back.Face=Enum.NormalId.Back back.Parent=p
 return p
end
board("SELECAO DO RICK - ASSETS PARA O LOBBY",Vector3.new(500,9,121.9),Vector3.new(64,7,.5),Color3.fromRGB(93,207,218))

local entries={
 {"OrzePack.60_PicaretaB","Picareta B"},{"OrzePack.57_Caixote","Caixote"},
 {"OrzePack.27_BarrilB","Pedras Orze"},{"OrzePack.34_ArvoreB","Arvore B"},
 {"Zona_Arbuzowski.Models.21_Lantern_01","Lanterna de poste"},
 {"Zona_Arbuzowski.Models.11_Flag_02","Bandeira azul"},{"Zona_Arbuzowski.Models.12_Flag_01","Bandeira roxa"},
 {"Zona_Arbuzowski.Models.28_RockPile_01","Pedras escuras"},
 {"Zona_Skully.Models.06_coin","Moeda"},{"Zona_Skully.Models.07_LightPost","Poste de luz"},
 {"Zona_Skully.Models.08_Lamp","Lampiao pequeno"},
 {"Zona_HapyAssets.Models.02_Rock","Rocha grande"},{"Zona_HapyAssets.Models.22_Grass","Arbusto Hapy"},
 {"Zona_HapyAssets.Models.26_Grass","Arvore Hapy A"},{"Zona_HapyAssets.Models.27_Grass","Arvore Hapy B"},
 {"Zona_HapyAssets.Models.31_Grass","Arvore Hapy C"},
 {"Zona_HapyLowPoly.Models.01_BorderPart","Borda de terreno"},{"Zona_HapyLowPoly.Models.03_Fence","Cerca Hapy"},
 {"Zona_HapyLowPoly.Models.04_Tree","Pinheiro Hapy"},{"Zona_HapyLowPoly.Models.05_3WoodLog","Pilha de lenha"},
 {"Zona_HapyLowPoly.Models.06_Grass","Terreno baixo"},{"Zona_HapyLowPoly.Models.08_GrassPart","Tufo de grama"},
 {"Zona_HapyLowPoly.Models.09_GroundRock","Pedra de chao"},{"Zona_HapyLowPoly.Models.10_Rock","Rocha Hapy"},
}
local folder=Instance.new("Folder") folder.Name="SelectedModels" folder.Parent=root
local function resolve(path)
 local o=staging for token in path:gmatch("[^%.]+") do o=o:FindFirstChild(token) assert(o,"Missing "..path) end return o
end
for i,e in ipairs(entries) do
 local col=(i-1)%6 local row=math.floor((i-1)/6)
 local x=440+col*24 local z=143+row*24
 local source=resolve(e[1]) local clone=source:Clone() clone.Name=e[2]:gsub(" ","_") clone.Parent=folder
 for _,d in clone:GetDescendants() do
  if d:IsA("LuaSourceContainer") or d:IsA("RemoteEvent") or d:IsA("RemoteFunction") or d:IsA("PackageLink") then d:Destroy()
  elseif d:IsA("BasePart") then d.Anchored=true d.CanCollide=false d.CanTouch=false d.CanQuery=false end
 end
 local _,size=clone:GetBoundingBox() clone:PivotTo(CFrame.new(x,.35+size.Y/2,z))
 clone:SetAttribute("SourcePath",source:GetFullName()) clone:SetAttribute("SelectedBy","Rick")
 clone:SetAttribute("Status","USER_SELECTED_VISUAL") clone:SetAttribute("ProductionApproved",false)
 source:SetAttribute("UserSelected",true)
 part("Pad_"..i,Vector3.new(18,.35,18),Vector3.new(x,.175,z),Color3.fromRGB(139,151,153),root)
 board(string.format("%02d  %s",i,e[2]),Vector3.new(x,1.4,z-8.8),Vector3.new(17,1.8,.2))
end
local waterfall=Instance.new("Folder") waterfall.Name="Waterfall_Selected_NotCloned" waterfall.Parent=root
waterfall:SetAttribute("SourcePath","Workspace.CrumbleArena.AssetStaging.Zona_HapyAssets.Models.01_Waterfall")
waterfall:SetAttribute("Reason","Effect-only preview uses external attachments; preserve source and audit before relocating")
waterfall:SetAttribute("SelectedBy","Rick") waterfall:SetAttribute("ProductionApproved",false)
board("25  CACHOEIRA HAPY\nselecionada, mantida na plataforma original; exige auditoria dos efeitos antes de mover",Vector3.new(500,5,237.9),Vector3.new(72,6,.5),Color3.fromRGB(255,220,118))
return {displayed=#entries,waterfallReference=true,originalsPreserved=true}
