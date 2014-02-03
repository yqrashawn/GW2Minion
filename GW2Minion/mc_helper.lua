mc_helper = {}

 --*         recalc_coords([[9856,11648],[13440,14080]], [[-43008,-27648],[43008,30720]], [9835,-17597])
 --*         -> [12058, 13661] 
function mc_helper.recalc_coords(continent_rect, map_rect, coords)
	--return [
	--	Math.round(continent_rect[0][0]+(continent_rect[1][0]-continent_rect[0][0])*(coords[0]-map_rect[0][0])/(map_rect[1][0]-map_rect[0][0])),
	--	Math.round(continent_rect[0][1]+(continent_rect[1][1]-continent_rect[0][1])*(1-(coords[1]-map_rect[0][1])/(map_rect[1][1]-map_rect[0][1])))
	--]
end

function mc_helper.HasBuffs(entity, buffIDs)
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

function mc_helper.BufflistHasBuffs(bufflist, buffIDs)

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