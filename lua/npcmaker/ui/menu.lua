local PANEL = {}

function PANEL:Init ()
	self:SetTitle ("NPC Maker")
	self:SetSize (ScrW () * 0.75, ScrH () * 0.75)
	
	self:SetDeleteOnClose (false)
	self:Center ()
	self:MakePopup ()
	
	self.Back = vgui.Create ("DButton", self)
	self.Back:SetText ("< Back")
	self.Back.DoClick = function ()
		self:PopPanel ()
	end
	
	self.Panels = {}
	self.PanelHistory = {}
	self.CurrentPanel = nil
	
	self:RegisterPanel ("Main", "NPCMakerMenuMainPanel")
	self:RegisterPanel ("NPCs", "NPCMakerMenuNPCsPanel")
	self:RegisterPanel ("Autospawner", "NPCMakerMenuAutospawnerPanel")
	self:SetCurrentPanel ("Main")
	
	self:InvalidateLayout ()
end

function PANEL:GetPanel (name)
	if type (name) == "Panel" then
		return name
	end
	return self.Panels [name]
end

function PANEL:PerformLayout ()
	DFrame.PerformLayout (self)
	
	if self.Back then
		self.Back:SetSize (96, 32)
		self.Back:SetPos (4, 24)
		self.Back:SetDisabled (#self.PanelHistory == 0)
	end
	
	if self.CurrentPanel then
		self.CurrentPanel:SetPos (4, 28 + self.Back:GetTall ())
		self.CurrentPanel:SetSize (self:GetWide () - 8, self:GetTall () - 32 - self.Back:GetTall ())
	end
end

function PANEL:PopPanel ()
	self:SetCurrentPanel (self.PanelHistory [#self.PanelHistory] or self:GetPanel ("Main"))
	self.PanelHistory [#self.PanelHistory] = nil
end

function PANEL:PushPanel (name)
	self.PanelHistory [#self.PanelHistory + 1] = self.CurrentPanel
	self:SetCurrentPanel (name)
end

function PANEL:RegisterPanel (name, className)
	local panel = vgui.Create (className, self)
	if panel then
		panel:SetMenu (self)
		self.Panels [name] = panel
	end
end

function PANEL:SetCurrentPanel (name)
	if self.CurrentPanel then
		self.CurrentPanel:SetVisible (false)
	end
	self.CurrentPanel = self:GetPanel (name)
	if self.CurrentPanel then
		self.CurrentPanel:SetVisible (true)
	end
	
	self:InvalidateLayout ()
end

vgui.Register ("NPCMakerMenu", PANEL, "DFrame")