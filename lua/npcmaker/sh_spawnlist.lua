local self = {}
NPCMaker.SpawnList = NPCMaker.MakeConstructor (self)

function self:ctor ()
	self.SpawnPoints = {}
	
	NPCMaker.EventProvider (self)
end

function self:AddSpawnPoint (spawnPoint)
	self.SpawnPoints [spawnPoint:GetID ()] = spawnPoint
	
	self:DispatchEvent ("SpawnPointAdded", spawnPoint:GetID (), spawnPoint)
end

function self:GetNextFreeID (id)
	if not self.SpawnPoints [id] then
		return id
	end
	local i = 1
	while self.SpawnPoints [id .. "_" .. tostring (i)] do
		i = i + 1
	end
	return id .. "_" .. tostring (i)
end

function self:GetSpawnPoint (id)
	return self.SpawnPoints [id]
end

self.GetSpawnPointIterator = NPCMaker.MakeKeyValueIterator ("SpawnPoints")