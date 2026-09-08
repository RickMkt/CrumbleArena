-- Creates a non-production shortlist beside the full asset catalog.
-- Original catalog entries are never moved or deleted.
local staging = workspace.CrumbleArena.AssetStaging
assert(not staging:FindFirstChild("CuratedLobbyAssets"), "CuratedLobbyAssets already exists")

local root = Instance.new("Model")
root.Name = "CuratedLobbyAssets"
root:SetAttribute("Purpose", "Visual shortlist only; originals remain in AssetStaging")
root:SetAttribute("ProductionApproved", false)
root:SetAttribute("LicenseStatus", "Review package provenance before production use")
root.Parent = staging

local function part(name, size, position, color, parent)
 local p=Instance.new("Part") p.Name=name p.Size=size p.Position=position p.Color=color
 p.Material=Enum.Material.Plastic p.Anchored=true p.CanCollide=true p.CanTouch=false p.CanQuery=true
 p.TopSurface=Enum.SurfaceType.Studs p.BottomSurface=Enum.SurfaceType.Smooth p.Parent=parent
 return p
end

local floor=part("CuratedPlatform",Vector3.new(112,1,102),Vector3.new(350,-.5,180),Color3.fromRGB(74,86,101),root)
floor:SetAttribute("NotLobbyContent",true)
for _,v in {{112,1.4,1,350,.2,129.5},{112,1.4,1,350,.2,230.5},{1,1.4,102,294.5,.2,180},{1,1.4,102,405.5,.2,180}} do
 part("PlatformTrim",Vector3.new(v[1],v[2],v[3]),Vector3.new(v[4],v[5],v[6]),Color3.fromRGB(34,45,61),root)
end

local function label(parent,text,position,size,color)
 local board=part("Label",size,position,Color3.fromRGB(23,34,52),parent)
 board.TopSurface=Enum.SurfaceType.Smooth board.CanCollide=false
 local gui=Instance.new("SurfaceGui") gui.Face=Enum.NormalId.Front gui.SizingMode=Enum.SurfaceGuiSizingMode.FixedSize gui.CanvasSize=Vector2.new(900,220) gui.Parent=board
 local t=Instance.new("TextLabel") t.BackgroundTransparency=1 t.Size=UDim2.fromScale(.94,.9) t.Position=UDim2.fromScale(.03,.05)
 t.Text=text t.TextColor3=color or Color3.fromRGB(244,232,195) t.Font=Enum.Font.FredokaOne t.TextScaled=true t.TextWrapped=true t.Parent=gui
 return board
end

label(root,"LOBBY ASSET SHORTLIST",Vector3.new(350,10,130.3),Vector3.new(42,7,.5))
label(root,"CANDIDATOS VISUAIS - NAO SAO CONTEUDO ATIVO",Vector3.new(350,5.3,130.3),Vector3.new(52,2.1,.4),Color3.fromRGB(93,207,218))

local entries={
 {"MOBILIARIO","OrzePack.55_BarrilA","Barril","Market / Social",310,148},
 {"MOBILIARIO","OrzePack.57_Caixote","Caixote","Market",330,148},
 {"MOBILIARIO","OrzePack.54_Banco","Banco","Social / Outlook",350,148},
 {"MOBILIARIO","OrzePack.56_Lanterna","Lanterna","Market / Social",370,148},
 {"NATUREZA","Zona_HapyLowPoly.Models.05_3WoodLog","Pilha de lenha","Social",310,178},
 {"NATUREZA","Zona_HapyLowPoly.Models.08_GrassPart","Planta baixa","Bordas pontuais",330,178},
 {"NATUREZA","Zona_HapyLowPoly.Models.09_GroundRock","Pedra rasa","Transicoes",350,178},
 {"NATUREZA","Zona_HapyLowPoly.Models.10_Rock","Rocha","Borda / Outlook",370,178},
 {"NATUREZA","Zona_HapyLowPoly.Models.04_Tree","Pinheiro","Variacao rara",390,178},
 {"ESTRUTURA","Zona_HapyLowPoly.Models.03_Fence","Cerca curta","Contencao",310,208},
 {"ESTRUTURA","Zona_Arbuzowski.Models.30_Sign_01","Placa pequena","Wayfinding",335,208},
 {"ESTRUTURA","OrzePack.21_LeaderboardB","Leaderboard B","Information Area",370,208},
}

local groups={}
for _,e in entries do
 local category,path,title,use,x,z=table.unpack(e)
 local group=groups[category]
 if not group then group=Instance.new("Folder") group.Name=category group.Parent=root groups[category]=group end
 local source=staging
 for token in path:gmatch("[^%.]+") do source=source:FindFirstChild(token) assert(source,"Missing "..path) end
 local clone=source:Clone() clone.Name=title:gsub(" ","_") clone.Parent=group
 for _,d in clone:GetDescendants() do
  if d:IsA("LuaSourceContainer") or d:IsA("RemoteEvent") or d:IsA("RemoteFunction") or d:IsA("PackageLink") then d:Destroy()
  elseif d:IsA("BasePart") then d.Anchored=true d.CanCollide=false d.CanTouch=false d.CanQuery=false end
 end
 local cf,sz=clone:GetBoundingBox()
 clone:PivotTo(CFrame.new(x,1+sz.Y/2,z)*cf.Rotation)
 clone:SetAttribute("SourcePath",source:GetFullName()) clone:SetAttribute("RecommendedUse",use)
 clone:SetAttribute("Status","CANDIDATO_VISUAL") clone:SetAttribute("ProductionApproved",false)
 source:SetAttribute("CuratedCandidate",true) source:SetAttribute("RecommendedUse",use)
 local pad=part("Pad_"..title:gsub(" ","_"),Vector3.new(15,.35,15),Vector3.new(x,.175,z),Color3.fromRGB(139,151,153),group)
 pad.CanCollide=false pad.CanQuery=false
 label(group,title.."\n"..use,Vector3.new(x,1.5,z-7.25),Vector3.new(14,2,.25))
end

local note=label(root,"MANTER O CATALOGO ORIGINAL\nOs itens fora desta plataforma nao foram apagados. Compare tendas, carrinhos, vegetacao, fontes e placares nas plataformas originais. Motivos comuns para nao selecionar: tema diferente, excesso de cor, custo alto ou funcao duplicada. Antes de usar: confirmar licenca, clonar, sanitizar e testar escala/colisao.",Vector3.new(350,7,229.6),Vector3.new(78,10,.5),Color3.fromRGB(255,220,118))
note:SetAttribute("ReadMeForCodex",true)
return {shortlist=#entries,parts=#root:GetDescendants(),originalCatalogPreserved=true}
