gw2_omc_unstuck = {}
gw2_omc_unstuck.ticks = 0
gw2_omc_unstuck.stuckCount = 0
gw2_omc_unstuck.targetOMC = {}
gw2_omc_unstuck.lastPos = nil
gw2_omc_unstuck.stuckTimer = 0
gw2_omc_unstuck.stuckDistance = 25
gw2_omc_unstuck.lastResult = false
gw2_omc_unstuck.lastStuckCount = 0

gw2_omc_unstuck.trackedOMC = {}

gw2_omc_unstuck.STUCKSTATES = {
	MinStuckCount = 25,
	Jump = 30,
	AddAvoidance = 35,
	AddObstacle = 50,
	MoveToMesh = 50,
	UseWaypoint = 60,
	StopBot = 60
}

function gw2_omc_unstuck.HandleStuck(type,startPos,endPos)
	local targetOMC = gw2_omc_unstuck.GetTrackedOMC({startPos = startPos, endPos = endPos, type = type})

	if(not targetOMC) then
		targetOMC = {
			startPos = startPos;
			endPos = endPos;
			type = type;
			stuckCount = 0;
			resetCount = 0;
			avoidanceAreaAdded = false;
			obstacleAdded = false;
			inCombatTimer = 0;
			waypointCount = 0;
			jumpCount = 0;
			startTime = ml_global_information.Now;
		}

		gw2_omc_unstuck.TrackOMC(targetOMC)
	end

	gw2_omc_unstuck.targetOMC = targetOMC
	
	if(TimeSince(gw2_omc_unstuck.stuckTimer) < 250) then
		return gw2_omc_unstuck.lastResult
	end
	
	gw2_omc_unstuck.stuckTimer = ml_global_information.Now
	
	local distmoved = math.huge
	if(ValidTable(gw2_omc_unstuck.lastPos)) then
		distmoved = Distance3DT(ml_global_information.Player_Position,gw2_omc_unstuck.lastPos)
	end
	gw2_omc_unstuck.lastPos = Player.pos
	
	if (gw2_common_functions.HasBuffs(Player, gw2_unstuck.immobilizeConditions) ) then
		gw2_omc_unstuck.lastResult = false
		return false
	end

	if(distmoved > gw2_omc_unstuck.stuckDistance and not ml_mesh_mgr.OMCStartPositionReached and gw2_omc_unstuck.targetOMC.stuckCount < gw2_omc_unstuck.STUCKSTATES.MinStuckCount) then
		gw2_omc_unstuck.lastResult = false
		return false
	end

	if(distmoved < gw2_omc_unstuck.stuckDistance or gw2_omc_unstuck.targetOMC.jumpCount > 0) then
		gw2_omc_unstuck.targetOMC.stuckCount = gw2_omc_unstuck.targetOMC.stuckCount + 1
	end

	if(gw2_omc_unstuck.targetOMC.stuckCount > gw2_omc_unstuck.STUCKSTATES.MinStuckCount) then
		gw2_omc_unstuck.Log("OMC stuckCount: " .. gw2_omc_unstuck.targetOMC.stuckCount)
		
		local startDistance = ml_mesh_mgr.OMCStartDistance - (gw2_omc_unstuck.targetOMC.stuckCount-10)
		if(startDistance > 5) then
			gw2_omc_unstuck.Log("Reducing OMC start distance")
			ml_mesh_mgr.OMCStartDistance = startDistance
		end

		if(gw2_omc_unstuck.targetOMC.stuckCount < gw2_omc_unstuck.STUCKSTATES.Jump) then
			gw2_omc_unstuck.Log("Trying to jump")
			Player:SetFacingExact(gw2_omc_unstuck.targetOMC.endPos.x,gw2_omc_unstuck.targetOMC.endPos.y,gw2_omc_unstuck.targetOMC.endPos.z)
			Player:Jump()
			Player:SetMovement(GW2.MOVEMENTTYPE.Forward)
			gw2_omc_unstuck.targetOMC.jumpCount = gw2_omc_unstuck.targetOMC.jumpCount + 1
		elseif(gw2_omc_unstuck.targetOMC.avoidanceAreaAdded == false and (gw2_omc_unstuck.targetOMC.stuckCount == gw2_omc_unstuck.STUCKSTATES.AddAvoidance or gw2_omc_unstuck.targetOMC.resetCount == 2)) then
			gw2_omc_unstuck.StopMovement()
			table.insert(ml_mesh_mgr.currentMesh.AvoidanceAreas, { x=gw2_omc_unstuck.targetOMC.startPos.x, y=gw2_omc_unstuck.targetOMC.startPos.y, z=gw2_omc_unstuck.targetOMC.startPos.z, r=50 })
			gw2_omc_unstuck.Log("Setting avoidance area on OMC start position.")
			NavigationManager:SetAvoidanceAreas(ml_mesh_mgr.currentMesh.AvoidanceAreas)
			gw2_omc_unstuck.targetOMC.avoidanceAreaAdded = true
		elseif(gw2_omc_unstuck.targetOMC.obstacleAdded == false and gw2_omc_unstuck.targetOMC.stuckCount == gw2_omc_unstuck.STUCKSTATES.AddObstacle) then
			gw2_omc_unstuck.StopMovement()
			table.insert(ml_mesh_mgr.currentMesh.Obstacles, { x=gw2_omc_unstuck.targetOMC.startPos.x, y=gw2_omc_unstuck.targetOMC.startPos.y, z=gw2_omc_unstuck.targetOMC.startPos.z, r=150, t=ml_global_information.Now })
			gw2_omc_unstuck.Log("Adding obstacle on OMC start position.")
			NavigationManager:AddNavObstacles(ml_mesh_mgr.currentMesh.Obstacles)
			gw2_omc_unstuck.targetOMC.obstacleAdded = true
		elseif(gw2_omc_unstuck.targetOMC.stuckCount < gw2_omc_unstuck.STUCKSTATES.MoveToMesh) then
			gw2_omc_unstuck.targetOMC.jumpCount = 0
			gw2_omc_unstuck.StopMovement()
			if(not Player.onmesh) then
				gw2_omc_unstuck.Log("Trying to get back on the mesh")
				local p = NavigationManager:GetClosestPointOnMesh(ml_global_information.Player_Position)
				if(ValidTable(p) and p.distance < 550) then
					Player:SetFacingExact(p.x,p.y,p.z)
					Player:SetMovement(GW2.MOVEMENTTYPE.Forward)
				end
			else
				gw2_omc_unstuck.Log("On mesh, resetting OMC")
				if(gw2_omc_unstuck.targetOMC.resetCount < 5) then
					gw2_omc_unstuck.targetOMC.stuckCount = gw2_omc_unstuck.targetOMC.stuckCount - 10
					gw2_omc_unstuck.targetOMC.resetCount = gw2_omc_unstuck.targetOMC.resetCount + 1
					ml_mesh_mgr.ResetOMC()
				end
			end
		elseif(gw2_omc_unstuck.targetOMC.stuckCount < gw2_omc_unstuck.STUCKSTATES.UseWaypoint) then
			gw2_omc_unstuck.Log("Trying to use a waypoint")
			gw2_omc_unstuck.StopMovement()
			if (Player.alive and Inventory:GetInventoryMoney() > 300) then
				if(Player.inCombat == false) then
					if(gw2_omc_unstuck.targetOMC.waypointCount < 2) then
						local wp = gw2_common_functions.GetClosestWaypointToPos(ml_global_information.CurrentMapID,Player.pos)
						if (ValidTable(wp)) then
							ml_mesh_mgr.ResetOMC()
							gw2_omc_unstuck.targetOMC.stuckCount = 0
							gw2_omc_unstuck.targetOMC.waypointCount = gw2_omc_unstuck.targetOMC.waypointCount + 1
							Player:TeleportToWaypoint(wp.id)
							ml_global_information.Wait(math.random(5000,15000))
						end
					end
				else
					gw2_omc_unstuck.Log("In combat. Waiting.")
					if(gw2_omc_unstuck.targetOMC.inCombatTimer == 0) then
						gw2_omc_unstuck.targetOMC.inCombatTimer = ml_global_information.Now
					end
					
					if(TimeSince(gw2_omc_unstuck.targetOMC.inCombatTimer) < 120000) then
						if(gw2_omc_unstuck.targetOMC.stuckCount-1 > gw2_omc_unstuck.STUCKSTATES.MoveToMesh) then
							gw2_omc_unstuck.targetOMC.stuckCount = gw2_omc_unstuck.targetOMC.stuckCount - 1
						end
						gw2_omc_unstuck.targetOMC.startTime = gw2_omc_unstuck.targetOMC.startTime - 250
					end
				end
			end
		elseif(gw2_omc_unstuck.targetOMC.stuckCount >= gw2_omc_unstuck.STUCKSTATES.StopBot) then
			gw2_omc_unstuck.Log({
				"Something is wrong with the OMC. Stopping bot.",
				"Current position:",
				{x = Player.pos.x, y = Player.pos.y, z = Player.pos.z},
				"OMC position:",
				{x = gw2_omc_unstuck.targetOMC.startPos.x, y = gw2_omc_unstuck.targetOMC.startPos.y, z = gw2_omc_unstuck.targetOMC.startPos.z}
			}, true)

			gw2_omc_unstuck.StopMovement()
			ml_mesh_mgr.ResetOMC()
			gw2_omc_unstuck.Reset()
			gAutostartbot = "0"
			Settings.GW2Minion.gAutostartbot = gAutostartbot		
			gw2minion.ToggleBot("off")
		end
		gw2_omc_unstuck.lastStuckCount = gw2_omc_unstuck.targetOMC.stuckCount
		gw2_omc_unstuck.lastResult = true
		return true
	end
	
	gw2_omc_unstuck.lastStuckCount = gw2_omc_unstuck.targetOMC.stuckCount
	gw2_omc_unstuck.lastResult = false
	return false
end

function gw2_omc_unstuck.Reset()
	gw2_omc_unstuck.stuckCount = 0
	gw2_omc_unstuck.targetOMC.stuckCount = 0
	gw2_omc_unstuck.targetOMC.resetCount = 0
	gw2_omc_unstuck.targetOMC.inCombatTimer = 0
	gw2_omc_unstuck.targetOMC.waypointCount = 0
	gw2_omc_unstuck.targetOMC.jumpCount = 0
	gw2_omc_unstuck.stuckDistance = 25
	gw2_omc_unstuck.lastResult = false
end

function gw2_omc_unstuck.StopMovement()
	for i=1,3 do
		Player:UnSetMovement(i)
	end
	Player:StopMovement()
end

function gw2_omc_unstuck.Match(omc,type,startPos,endPos)
	if(ValidTable(omc)) then
		if(
			ValidTable(omc.startPos) and ValidTable(omc.endPos) and
			ValidTable(startPos) and ValidTable(endPos) and
			(
				omc.type == type and
				omc.startPos.x == startPos.x and omc.startPos.y == startPos.y and omc.startPos.z == startPos.z and
				omc.endPos.x == endPos.x and omc.endPos.y == endPos.y and omc.endPos.z == endPos.z
			) and
			TimeSince(omc.startTime) < 180000
		) then
			return omc
		end
	end
	
	return false
end

function gw2_omc_unstuck.TrackOMC(targetOMC)
	local tracked = gw2_omc_unstuck.GetTrackedOMC(targetOMC)
	if(not tracked and ValidTable(targetOMC)) then
		table.insert(gw2_omc_unstuck.trackedOMC, targetOMC)
	end
end

function gw2_omc_unstuck.GetTrackedOMC(omc)
	if(ValidTable(omc)) then
		for _,trackedOMC in pairs(gw2_omc_unstuck.trackedOMC) do
			if(gw2_omc_unstuck.Match(trackedOMC,omc.type,omc.startPos,omc.endPos)) then
				return trackedOMC
			end
		end
	end
	
	return false
end

function gw2_omc_unstuck.Log(msg, err)
	if(gw2_omc_unstuck.targetOMC.stuckCount > gw2_omc_unstuck.lastStuckCount) then
		if(ValidTable(msg)) then
			for _,m in ipairs(msg) do
				local val = m
				if(ValidTable(m)) then
					val = "{ "
					for k,v in pairs(m) do
						val = val .. k .. "=" .. v .. "; "
					end
					val = val .. "}"
				end
		
				if(err) then
					ml_error(val)
				else
					d(val)
				end
			end
		else
			if(err) then
				ml_error(msg)
			else
				d(msg)
			end			
		end
	end
end

function gw2_omc_unstuck.OnUpdate(Event, ticks) 
	if(TimeSince(gw2_omc_unstuck.ticks) > 5000) then
		gw2_omc_unstuck.ticks = ticks
		for i,omc in pairs(gw2_omc_unstuck.trackedOMC) do
			if(TimeSince(omc.startTime) > 180000) then
				table.remove(gw2_omc_unstuck.trackedOMC, i)
			end
		end
	end
end

RegisterEventHandler("Gameloop.Update",gw2_omc_unstuck.OnUpdate)