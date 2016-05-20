local self = {}
NPCMaker.Net.SpawnListSerializer = NPCMaker.MakeConstructor (self)

function self:ctor (spawnList)
	self.SpawnList = spawnList
	self.SpawnList.NetSerializer = self
	self.SubscriberList = NPCMaker.SubscriberList ()
	
	if SERVER then
		self.SpawnList:AddEventListener ("SpawnPointAdded", function (spawnList, id, spawnPoint)
			self:SendSpawnPoint (spawnPoint)
		end)
	end
end

function self:SendAllSpawnPoints (ply)
	for id, spawnPoint in self.SpawnList:GetSpawnPointIterator () do
		self:SendSpawnPoint (spawnPoint, ply)
	end
end

function self:SendSpawnPoint (spawnPoint, ply)
	umsg.Start ("npcmaker_spawnpoint", ply or self.SubscriberList:GetRecipientFilter ())
		umsg.String (spawnPoint:GetID ())
		umsg.Vector (spawnPoint:GetPosition ())
		umsg.Angle (spawnPoint:GetAngle ())
	umsg.End ()
end

if SERVER then
	concommand.Add ("npcmaker_create_spawnpoint", function (ply, _, args)
		if not NPCMaker.CanPlayerEditSpawnList (ply) then
			return
		end
		local id = NPCMaker.SpawnList:GetNextFreeID ("spawnpoint")
		local spawnPoint = NPCMaker.SpawnPoint (id)
		NPCMaker.SpawnList:AddSpawnPoint (spawnPoint)
	end)
	
	concommand.Add ("npcmaker_request_spawnpoints", function (ply, _, args)
		if not NPCMaker.CanPlayerViewSpawnList (ply) then
			return
		end
		NPCMaker.SpawnList.NetSerializer.SubscriberList:AddPlayer (ply)
		NPCMaker.SpawnList.NetSerializer:SendAllSpawnPoints (ply)
	end)
elseif CLIENT then
	usermessage.Hook ("npcmaker_spawnpoint", function (umsg)
		local id = umsg:ReadString ()
		local pos = umsg:ReadVector ()
		local angle = umsg:ReadAngle ()
		
		local spawnPoint = NPCMaker.SpawnList:GetSpawnPoint (id)
		if not spawnPoint then
			spawnPoint = NPCMaker.SpawnPoint (id)
			spawnPoint:SetPosition (pos)
			spawnPoint:SetAngle (angle)
			NPCMaker.SpawnList:AddSpawnPoint (spawnPoint)
		end
		
		spawnPoint:SetPosition (pos)
		spawnPoint:SetAngle (angle)
	end)
end