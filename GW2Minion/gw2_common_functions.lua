gw2_common_functions = {}

function gw2_common_functions.HasBuffs(entity, buffIDs)
    if ( entity ) then
		local buffs = entity.buffs
		if (buffs == nil or TableSize(buffs) == 0) then return false end
			
			for _orids in StringSplit(buffIDs,",") do
				local found = false
				for _andid in StringSplit(_orids,"+") do
					found = false
					for i, buff in pairs(buffs) do
						
						if (buff.buffID == tonumber(_andid)) then 
							found = true
						end
					end
					if (not found) then 
						break
					end
				end
				if (found) then 
					return true 
				end
			end
	end
    return false
end

function gw2_common_functions.BufflistHasBuffs(bufflist, buffIDs)

	if (bufflist == nil or TableSize(bufflist) == 0) then return false end
			
	for _orids in StringSplit(buffIDs,",") do
		local found = false
		for _andid in StringSplit(_orids,"+") do
				found = false
			for i, buff in pairs(bufflist) do
				
				if (buff.buffID == tonumber(_andid)) then 
					found = true
				end
			end
			if (not found) then 
				break
			end
		end
		if (found) then 
			return true 
		end
	end
    return false
end