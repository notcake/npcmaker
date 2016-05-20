local PANEL = {}
local WireframeMaterial = Material ("models/wireframe")

function PANEL:Init ()
	self.List = vgui.Create ("GComboBox", self)
	
	self.List.Menu = vgui.Create ("GMenu")
	self.List.Menu:AddOption ("New")
		:SetIcon ("gui/g_silkicons/add")
		:AddEventListener ("Click", function (item)
			RunConsoleCommand ("npcmaker_create_spawnpoint")
		end)
		
	NPCMaker.SpawnList:AddEventListener ("SpawnPointAdded", tostring (self), function (spawnList, id, spawnPoint)
		local item = self.List:AddItem (id)
		item.SpawnPoint = spawnPoint
		
		if not self:GetSelectedSpawnPoint () then
			self:SelectSpawnPoint (spawnPoint)
		end
	end)
	
	self.Title = vgui.Create ("GEditableLabel", self)
	self.Title:SetColor (Color (255, 255, 255, 255))
	self.Title:SetFont ("TargetID")
	self.Title:SetText ("Spawn name")
	
	self.DataGroupBox = vgui.Create ("GGroupBox", self)
	self.DataGroupBox:SetText ("Spawn data")
	self.DataGroupBox:AddEventListener ("PerformLayout", function (groupBox)
		self:DataGroupBox_PerformLayout (groupBox)
	end)
	
	self.ClassLabel = self.DataGroupBox:CreateLabel ("Class:")
	self.ClassChoice = self.DataGroupBox:Create ("GMultiChoiceX")
	self.ClassChoice:SetAutocompleter (function (text)
		text = text:gsub ("%[", "%[")
		text = text:gsub ("%]", "%]")
		text = text:gsub ("%(", "%)")
		text = text:gsub ("%(", "%)")
		text = text:gsub ("%%", "%%")
		text = text:gsub ("%.", "%.")
		text = text:gsub ("%+", "%+")
		text = text:gsub ("%?", "%?")
		text = text:gsub ("%^", "%^")
		text = text:gsub ("%$", "%$")
		text = text:gsub ("*", ".*")
		local classes = {}
		for class, _ in pairs (scripted_ents.GetList ()) do
			if class:lower ():find (text) then
				classes [#classes + 1] = class
			end
		end
		table.sort (classes)
		return classes
	end)
	
	self.ModelLabel = self.DataGroupBox:CreateLabel ("Model:")
	self.ModelChoice = self.DataGroupBox:Create ("GModelChoice")
	self.ModelChoice:AddEventListener ("ModelChanged", function (modelChoice, model)
		self.ModelPanel:SetModel ("models/" .. model)
		
		local bboxMin, bboxMax = self.ModelPanel.Entity:GetRenderBounds ()
		self.ModelPanel:SetCamPos (bboxMin:Distance (bboxMax) * Vector (0.75, 0.75, 0.5))
		self.ModelPanel:SetLookAt ((bboxMax + bboxMin) * 0.5)
		
		self.SkinChoice:Clear ()
		for i = 0, self.ModelPanel.Entity:SkinCount () - 1 do
			self.SkinChoice:AddChoice (tostring (i), i)
		end
		self.SkinChoice:ChooseOptionID (1)
	end)
	
	self.SkinLabel = self.DataGroupBox:CreateLabel ("Skin:")
	self.SkinChoice = self.DataGroupBox:Create ("GMultiChoice")
	self.SkinChoice:SetEditable (false)
	self.SkinChoice:AddChoice ("0", 0)
	self.SkinChoice:ChooseOptionID (1)
	self.SkinChoice:AddEventListener ("ItemSelected", function (multiChoice, value, id)
		if self.ModelPanel.Entity and self.ModelPanel.Entity:IsValid () then
			self.ModelPanel.Entity:SetSkin (id)
		end
	end)
	
	self.ModelPanel = self.DataGroupBox:Create ("DModelPanel")
	
	self.PositionGroupBox = vgui.Create ("GGroupBox", self)
	self.PositionGroupBox:SetText ("Positioning")
	self.PositionGroupBox:AddEventListener ("PerformLayout", function (groupBox)
		self:PositionGroupBox_PerformLayout ()
	end)
	self.WorldView = self.PositionGroupBox:Create ("GWorldView")
	
	self.WorldView:AddEventListener ("PostDrawEntities", function (worldView)
		local trace = worldView:GetCameraTrace ()
		local targetEntity = trace.Entity
		if targetEntity and targetEntity:IsValid () and targetEntity:GetClass () ~= "worldspawn" then
			SetMaterialOverride (WireframeMaterial)
			targetEntity:DrawModel ()
			SetMaterialOverride (nil)
		end
	end)
	self.WorldView:AddEventListener ("Post3DRender", function (worldView)
		local cx = worldView:GetWide () * 0.5
		local cy = worldView:GetTall () * 0.5
		local size = 8
		surface.SetDrawColor (255, 255, 255, 128)
		surface.DrawLine (cx - size, cy - size, cx + size, cy + size)
		surface.DrawLine (cx + size, cy - size, cx - size, cy + size)
		surface.DrawCircle (worldView:GetWide () * 0.5, worldView:GetTall () * 0.5, 8, Color (255, 255, 255, 128))
	end)
	
	self.ImportButton = self.PositionGroupBox:Create ("GButton")
	self.SetPositionButton = self.PositionGroupBox:Create ("GButton")
	
	self.SelectedSpawnPoint = nil
	
	RunConsoleCommand ("npcmaker_request_spawnpoints")
end

function PANEL:DataGroupBox_PerformLayout (groupBox)
	self.ClassLabel:SetPos (0, 0)
	self.ClassLabel:SetWide (64)
	self.ClassChoice:SetPos (64, 0)
	self.ClassChoice:SetWide (self.ClassChoice:GetParent ():GetWide () - 64)
	
	self.ModelLabel:SetPos (0, 24)
	self.ModelLabel:SetWide (64)
	self.ModelChoice:SetPos (64, 24)
	self.ModelChoice:SetWide (self.ModelChoice:GetParent ():GetWide () - 64)
	
	self.SkinLabel:SetPos (0, 48)
	self.SkinLabel:SetWide (64)
	self.SkinChoice:SetPos (64, 48)
	self.SkinChoice:SetWide (self.ModelChoice:GetParent ():GetWide () - 64)
	
	self.ModelPanel:SetPos (64, 64)
	self.ModelPanel:SetSize (160, 160)
end

function PANEL:GetSelectedSpawnPoint ()
	return self.SelectedSpawnPoint
end

function PANEL:PerformLayout ()
	self.List:SetPos (4, 4)
	self.List:SetSize (256, self:GetTall () - 8)
	
	self.Title:SetPos (264, 4)
	self.Title:SetWide (self:GetWide () - 268)
	
	self.DataGroupBox:SetPos (264, 28)
	self.DataGroupBox:SetSize ((self:GetWide () - 264) * 0.5, self:GetTall () - 32)
	
	self.PositionGroupBox:SetPos (self.DataGroupBox:GetPos () + self.DataGroupBox:GetWide () + 4, 28)
	self.PositionGroupBox:SetSize (self:GetWide () - self.PositionGroupBox:GetPos () - 4, self:GetTall () - 32)
end

function PANEL:PositionGroupBox_PerformLayout ()
	self.WorldView:SetPos (0, 0)
	self.WorldView:SetSize (self.WorldView:GetParent ():GetWide (), self.WorldView:GetParent ():GetTall () * 0.5)
end

function PANEL:SelectSpawnPoint (spawnPoint)
	if self.SelectedSpawnPoint then
	end

	self.SelectedSpawnPoint = spawnPoint
	
	if self.SelectedSpawnPoint then
		self.Title:SetText (spawnPoint:GetID ())
	end
end

vgui.Register ("NPCMakerMenuAutospawnerPanel", PANEL, "NPCMakerMenuPanel")