local PANEL = {}

function PANEL:Init ()
	self.Autospawner = vgui.Create ("DButton", self)
	self.Autospawner:SetText ("Autospawner")
	self.Autospawner.DoClick = function ()
		self:GetMenu ():PushPanel ("Autospawner")
	end
	
	self.NPCs = vgui.Create ("DButton", self)
	self.NPCs:SetText ("NPCs")
	self.NPCs.DoClick = function ()
		self:GetMenu ():PushPanel ("NPCs")
	end
end

function PANEL:DoNothing ()
end

function PANEL:PerformLayout ()
	self.NPCs:SetSize (self:GetWide () * 0.5, 128)
	self.Autospawner:SetSize (self:GetWide () * 0.5, 128)
	
	self.NPCs:SetPos ((self:GetWide () - self.NPCs:GetWide ()) * 0.5, (self:GetTall () - self.NPCs:GetTall () - self.Autospawner:GetTall () - 4) * 0.5)
	self.Autospawner:SetPos ((self:GetWide () - self.Autospawner:GetWide ()) * 0.5, (self:GetTall () - self.NPCs:GetTall () - self.Autospawner:GetTall () - 4) * 0.5 + self.NPCs:GetTall () + 4)
	
	self.NPCs:SetFont ("TargetID")
	self.Autospawner:SetFont ("TargetID")
	
	self.NPCs.ApplySchemeSettings = self.DoNothing
	self.Autospawner.ApplySchemeSettings = self.DoNothing
end

vgui.Register ("NPCMakerMenuMainPanel", PANEL, "NPCMakerMenuPanel")