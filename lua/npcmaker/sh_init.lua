NPCMaker = NPCMaker or {}

include ("npcmaker/sh_oop.lua")
include ("npcmaker/sh_eventprovider.lua")
include ("npcmaker/sh_subscriberlist.lua")

if SERVER then
	include ("npcmaker/sv_resources.lua")
	include ("npcmaker/sv_init.lua")
elseif CLIENT then
	include ("npcmaker/cl_init.lua")
end

include ("npcmaker/sh_spawnpoint.lua")
include ("npcmaker/sh_spawnlist.lua")
include ("npcmaker/sh_networking.lua")

NPCMaker.SpawnList = NPCMaker.SpawnList ()
NPCMaker.SpawnListSerializer = NPCMaker.Net.SpawnListSerializer (NPCMaker.SpawnList)

function NPCMaker.CanPlayerEditSpawnList (ply)
	if NPCMaker.IsPlayerConsole (ply) then
		return true
	end
	if ply:IsSuperAdmin () then
		return true
	end
	return false
end

function NPCMaker.CanPlayerViewSpawnList (ply)
	if NPCMaker.IsPlayerConsole (ply) then
		return true
	end
	if ply:IsSuperAdmin () then
		return true
	end
	return false
end

function NPCMaker.IsPlayerConsole (ply)
	if not ply or not ply:IsValid () then
		return true
	end
	return false
end