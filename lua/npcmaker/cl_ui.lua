include ("npcmaker/ui/conversation.lua")
include ("npcmaker/ui/menu.lua")
include ("npcmaker/ui/menu/base.lua")
include ("npcmaker/ui/menu/main.lua")
include ("npcmaker/ui/menu/npcs.lua")
include ("npcmaker/ui/menu/autospawner.lua")

if NPCMaker.Menu then
	if NPCMaker.Menu:IsValid () then
		NPCMaker.Menu:Remove ()
	end
	NPCMaker.Menu = nil
end

function NPCMaker.CreateMenu ()
	if NPCMaker.Menu and NPCMaker.Menu:IsValid () then
		return NPCMaker.Menu
	end
	NPCMaker.Menu = vgui.Create ("NPCMakerMenu")
	
	return NPCMaker.Menu
end

concommand.Add ("npcmaker_menu", function ()
	NPCMaker.Menu = NPCMaker.CreateMenu ()
	NPCMaker.Menu:SetVisible (true)
end)