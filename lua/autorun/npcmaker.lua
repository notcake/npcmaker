AddCSLuaFile ("autorun/npcmaker.lua")
include ("npcmaker/sh_init.lua")

if SERVER then
	concommand.Add ("npcmaker_reload", function (ply)
		if ply and ply:IsValid () and not ply:IsSuperAdmin () then
			return
		end
		include ("autorun/npcmaker.lua")
		
		for _, v in ipairs (player.GetAll ()) do
			v:ConCommand ("npcmaker_reload_cl")
		end
	end)
elseif CLIENT then
	concommand.Add ("npcmaker_reload_cl", function ()
		RunConsoleCommand ("gooey_reload_cl")
		include ("autorun/npcmaker.lua")
	end)
end