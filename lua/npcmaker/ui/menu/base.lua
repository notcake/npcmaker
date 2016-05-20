local PANEL = {}

function PANEL:Init ()
	self.Menu = nil
	
	self:SetVisible (false)
end

function PANEL:GetMenu ()
	return self.Menu
end

function PANEL:SetMenu (menu)
	self.Menu = menu
end

vgui.Register ("NPCMakerMenuPanel", PANEL, "GPanel")