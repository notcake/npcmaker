function NPCMaker.MakeConstructor (metatable, base)
	metatable.__index = metatable
	
	if base then
		local name, basetable = debug.getupvalue (base, 1)
		metatable.__base = basetable
		setmetatable (metatable, basetable)
	end
	
	return function (...)
		local object = {}
		setmetatable (object, metatable)
		
		-- Call base constructors
		local base = object.__base
		local basectors = {}
		while base ~= nil do
			basectors [#basectors + 1] = base.ctor
			base = base.__base
		end
		for i = #basectors, 1, -1 do
			basectors [i] (object, ...)
		end
		
		-- Call object constructor
		if object.ctor then
			object:ctor (...)
		end
		return object
	end
end

function NPCMaker.MakeArrayIterator (tableName)
	return function (self)
		local next, tbl, key = ipairs (self [tableName])
		return function ()
			key = next (tbl, key)
			return tbl [key]
		end
	end
end

function NPCMaker.MakeKeyIterator (tableName)
	return function (self)
		local next, tbl, key = pairs (self [tableName])
		return function ()
			key = next (tbl, key)
			return key
		end
	end
end

function NPCMaker.MakeKeyValueIterator (tableName)
	return function (self)
		local next, tbl, key = pairs (self [tableName])
		return function ()
			key = next (tbl, key)
			return key, tbl [key]
		end
	end
end

function NPCMaker.MakeValueIterator (tableName)
	return function (self)
		local next, tbl, key = pairs (self [tableName])
		return function ()
			key = next (tbl, key)
			return tbl [key]
		end
	end
end