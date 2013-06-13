wt_core_helpers = {}

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
	local id,vendor,repairVendor,bestVendor
	local vendorList = MapObjectList( "onmesh,maxdistance="..tostring(maxDistance)..",type="..GW2.MAPOBJECTTYPE.Merchant )
	if ( TableSize (vendorList) > 0 ) then
		id, vendor = next(vendorList)
		while (id ~= nil) do
			if ((bestVendor == nil or vendor.distance < bestVendor.distance) and wt_core_taskmanager.npcBlacklist[vendor.characterID] == nil) then
				bestVendor = vendor
			end
			id, vendor = next(vendorList,id)
		end
	end
	
	vendorList = MapObjectList( "onmesh,maxdistance="..tostring(maxDistance)..",type="..GW2.MAPOBJECTTYPE.RepairMerchant )
	if ( TableSize (vendorList) > 0 ) then
		id, vendor = next(vendorList)
		while (id ~= nil) do
			if ((bestVendor == nil or vendor.distance < bestVendor.distance) and wt_core_taskmanager.npcBlacklist[vendor.characterID] == nil) then
				bestVendor = vendor
			end
			id, vendor = next(vendorList,id)
		end
	end
	
	if (bestVendor ~= nil) then
		return bestVendor
	else
		return false
	end
end

function wt_core_helpers:GetClosestBuyVendor(maxDistance)
	local id,vendor,bestVendor
	local vendorList = MapObjectList( "onmesh,maxdistance="..tostring(maxDistance)..",type="..GW2.MAPOBJECTTYPE.Merchant )
	if ( TableSize (vendorList) > 0 ) then
		id, vendor = next(vendorList)
		while (id ~= nil) do
			if ((bestVendor == nil or vendor.distance < bestVendor.distance) and (wt_core_taskmanager.npcBlacklist[vendor.characterID] == nil and wt_core_taskmanager.vendorBlacklist[vendor.characterID] == nil )) then
				bestVendor = vendor
			end
			id, vendor = next(vendorList,id)
		end
	end
	
	if (bestVendor ~= nil) then
		return bestVendor
	else
		return false
	end
end

function wt_core_helpers:GetClosestRepairVendor(maxDistance)
	local id,vendor,repairVendor,bestVendor,bestID
	local vendorList = MapObjectList( "onmesh,maxdistance="..tostring(maxDistance)..",type="..GW2.MAPOBJECTTYPE.RepairMerchant )
	if ( TableSize (vendorList) > 0 ) then
		id, vendor = next(vendorList)
		while (id ~= nil) do
			if ((bestVendor == nil or vendor.distance < bestVendor.distance) and wt_core_taskmanager.npcBlacklist[vendor.characterID] == nil) then
				bestVendor = vendor
			end
			id, vendor = next(vendorList,id)
		end
	end
	
	if (bestVendor ~= nil) then
		return bestVendor
	else
		return false
	end
end

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