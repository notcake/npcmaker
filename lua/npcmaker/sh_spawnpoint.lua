local self = {}

NPCMaker.SpawnPoint = NPCMaker.MakeConstructor (self)

function self:ctor (id)
	self.ID = id

	self.Position = Vector (0, 0, 0)
	self.Angle = Angle (0, 0, 0)
end

function self:GetAngle (angle)
	return self.Angle
end

function self:GetID ()
	return self.ID
end

function self:GetPosition (pos)
	return self.Position
end

function self:SetAngle (angle)
	self.Angle = angle
end

function self:SetID (id)
	if self.ID == id then
		return
	end
	self.ID = id
end

function self:SetPosition (pos)
	self.Position = pos
end