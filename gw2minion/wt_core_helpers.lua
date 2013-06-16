wt_core_helpers = {}
wt_core_helpers.MapObjects =
{
    ["sellMerchant"] = nil,
    ["buyMerchant"] = nil,
    ["repairMerchant"] = nil,
    ["lastrun"] = 0
}

-- returns the closest waypoint to a 3d position or nil if no suitable waypoint is found
function wt_core_helpers:GetWaypoint(pos, currentDist)
	local Waypoints = (WaypointList("onmesh,samezone,notcontested,mindistance=3500"))
	local WP1, WP2, gotoWP = nil
	local wpToPosDist,gotoDist = nil

	if Waypoints then
		i,wp = next(Waypoints)
		while ( i ~= nil ) do
			local newWP = WaypointList:Get(i)
			local wpDist = Distance3D(newWP.pos.x, newWP.pos.y, newWP.pos.z, pos.x, pos.y, pos.z)

			if ( wpToPosDist == nil or wpDist < wpToPosDist ) then
				wpToPosDist = wpDist
				WP2 = WP1
				WP1 = newWP
			end

			i,wp = next(Waypoints,i)
		 end
	end
	
	-- check path distance to the two waypoints
	if (WP1 ~= nil and WP2 ~= nil) then
		local dist1 = PathDistance(NavigationManager:GetPath(WP1.pos.x, WP1.pos.y, WP1.pos.z, pos.x, pos.y, pos.z))
		local dist2 = PathDistance(NavigationManager:GetPath(WP2.pos.x, WP2.pos.y, WP2.pos.z, pos.x, pos.y, pos.z))
		
		if (dist1 < dist2) then
			gotoWP = WP1
			gotoDist = dist1
		else
			gotoWP = WP2
			gotoDist = dist2
		end
	elseif (WP1 ~= nil) then
		local dist1 = PathDistance(NavigationManager:GetPath(WP1.pos.x, WP1.pos.y, WP1.pos.z, pos.x, pos.y, pos.z))
		gotoWP = WP1
		gotoDist = dist1
	end
	-- TELEPORT
	if (gotoDist ~= nil and gotoWP ~= nil) then
		if ( currentDist - 1000 >  gotoDist) then
			return gotoWP
		end
	end
	
	return nil
end

function wt_core_helpers:OkayToWaypoint()
	return(os.difftime(os.time(), wt_core_taskmanager.waypointTimer) > 180) and not Player.inCombat
end

function wt_core_helpers:TimedWaypoint(wpID)
	wt_debug("Teleporting to contentID "..tostring(wpID))
	wt_core_taskmanager.waypointTimer = os.time()
	Player:TeleportToWaypoint(wpID)
end

-- returns the closest vendor 
-- currently only recognizes merchants (coins) and repair merchants (broken red shield)
function wt_core_helpers:GetClosestSellVendor(maxDistance)
    if (wt_global_information.Now - wt_core_helpers.MapObjects["lastrun"] > 30000) then
       wt_core_helpers:UpdateMapObject("repairMerchant")
       wt_core_helpers:UpdateMapObject("sellMerchant")
    end
    
    local repairMerchant = wt_core_helpers.MapObjects["repairMerchant"]
    local sellMerchant = wt_core_helpers.MapObjects["sellMerchant"]
    
	
    if (repairMerchant ~= nil and sellMerchant ~= nil and
		wt_core_taskmanager.npcBlacklist[repairMerchant.characterID] == nil and
		wt_core_taskmanager.npcBlacklist[sellMerchant.characterID] == nil) 
	then
        if (repairMerchant.distance < sellMerchant.distance) then
            if (repairMerchant.distance <= maxDistance) then
                return repairMerchant
            end
        else
            if (sellMerchant.distance < maxDistance) then
                return sellMerchant
            end
        end
    elseif (repairMerchant ~= nil and wt_core_taskmanager.npcBlacklist[repairMerchant.characterID] == nil) then
        if (repairMerchant.distance <= maxDistance) then
            return repairMerchant
        end
    elseif (sellMerchant ~= nil and wt_core_taskmanager.npcBlacklist[sellMerchant.characterID] == nil) then
        if (sellMerchant.distance <= maxDistance) then
            return sellMerchant
        end
    else
        return false
    end
end

function wt_core_helpers:GetClosestBuyVendor(maxDistance)
	if (wt_global_information.Now - wt_core_helpers.MapObjects["lastrun"] > 30000) then
       wt_core_helpers:UpdateMapObject("buyMerchant")
    end
    
    local buyMerchant = wt_core_helpers.MapObjects["buyMerchant"]
    if (buyMerchant ~= nil and buyMerchant.distance < maxDistance and 
		wt_core_taskmanager.vendorBlacklist[buyMerchant.characterID] == nil and
		wt_core_taskmanager.npcBlacklist[buyMerchant.characterID] == nil) 
	then
        return buyMerchant
    else
        return false
    end
end

function wt_core_helpers:GetClosestRepairVendor(maxDistance)
	if (wt_global_information.Now - wt_core_helpers.MapObjects["lastrun"] > 30000) then
       wt_core_helpers:UpdateMapObject("repairMerchant")
    end
    
    local repairMerchant = wt_core_helpers.MapObjects["repairMerchant"]
    if (repairMerchant ~= nil and repairMerchant.distance < maxDistance and wt_core_taskmanager.npcBlacklist[repairMerchant.characterID] == nil) then
        return repairMerchant
    else
        return false
    end
end

-- probably not working properly, don't trust it (it's a trap!)
function wt_core_helpers:GetClosestEvent(maxDistance)
	local MMList = MapMarkerList("worldmarkertype=20,maxdistance="..tostring(maxDistance))
	local event = nil
	if ( TableSize( MMList ) > 0 ) then
		i, entry = next( MMList )
		while ( i ~= nil and entry ~= nil ) do
			local etype = entry.type
			local mtype = entry.markertype
			if ( mtype==6 and entry.onmesh and entry.eventID ~= 0 ) then
				if (event == nil or entry.distance < event.distance) then
					event = entry
				end
			end
			i, entry = next( MMList, i )
		end
	end
	
	if (event ~= nil) then
		return event
	else
		return false
	end
end

function wt_core_helpers:UpdateMapObject(objectType)
    if (objectType == "sellMerchant") then
        local list = MapObjectList("onmesh,nearest,type="..GW2.MAPOBJECTTYPE.Merchant)
        if (TableSize(list) > 0) then
            local id, object = next(list)
            if (object ~= nil and wt_core_taskmanager.npcBlacklist[object.characterID] == nil) then
                wt_core_helpers.MapObjects["sellMerchant"] = object
            end
        end
    elseif (objectType == "buyMerchant") then
        local bestMerchant = nil
        local list = MapObjectList("onmesh,nearest,type="..GW2.MAPOBJECTTYPE.Merchant)
        if (TableSize(list) > 0) then
            local id, object = next(list)
            while (id ~= nil) do
                if (object ~= nil and wt_core_taskmanager.npcBlacklist[object.characterID] == nil and wt_core_taskmanager.vendorBlacklist[object.characterID] == nil) then
                    if (bestMerchant == nil or bestMerchant.distance > object.distance) then
                        bestMerchant = object
                    end
                end
                id, object = next(list, id)
            end
        end
        
        if (bestMerchant ~= nil) then
            wt_core_helpers.MapObjects["buyMerchant"] = bestMerchant
        end
    elseif (objectType == "repairMerchant") then
        local list = MapObjectList("onmesh,nearest,type="..GW2.MAPOBJECTTYPE.RepairMerchant)
        if (TableSize(list) > 0) then
            local id, object = next(list)
            if (object ~= nil and wt_core_taskmanager.npcBlacklist[object.characterID] == nil) then
                wt_core_helpers.MapObjects["repairMerchant"] = object
            end
        end
    end
    
    wt_core_helpers.MapObjects["lastrun"] = wt_global_information.Now
end