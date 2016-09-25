gw2_unstuck = {}
gw2_unstuck.stuckCount = 0
gw2_unstuck.stuckTimer = 0

gw2_unstuck.stuckPosition = nil
gw2_unstuck.antiStuckPos = nil
gw2_unstuck.lastPos = nil
gw2_unstuck.lastOnMeshTime = 0
gw2_unstuck.lastResult = false
gw2_unstuck.jumpCount = 0
gw2_unstuck.stuckthreshold = 45
gw2_unstuck.respawntimer = 0
gw2_unstuck.logoutTmr = 0
gw2_unstuck.useWaypointTmr = 0
gw2_unstuck.conversationTryCount = 0
gw2_unstuck.pathBlockingObject = nil
gw2_unstuck.lastRayCastDetails = nil
gw2_unstuck.moveDirSet = {[GW2.MOVEMENTTYPE.Forward] = false, [GW2.MOVEMENTTYPE.Backward] = false, [GW2.MOVEMENTTYPE.Left] = false, [GW2.MOVEMENTTYPE.Right] = false,}

gw2_unstuck.manualBotModes = { [GetString("assistMode")] = true; [GetString("salvage")] = true; }

gw2_unstuck.tickTimer = 0
gw2_unstuck.tickPosition = nil
gw2_unstuck.tickStuckCount = 0
gw2_unstuck.tickMoveDirection = nil
gw2_unstuck.tickMinStuckCount = math.random(300,420)

gw2_unstuck.trackedStuck = {}
  
function gw2_unstuck.HandleStuck(mode)
	-- MainThrottle
	if ( TimeSince(gw2_unstuck.stuckTimer) < 250 ) then
		return gw2_unstuck.lastResult
	end

	-- Update MainThrottle
	gw2_unstuck.stuckTimer = ml_global_information.Now

	-- Botmode Cannot be: Assist
	if (gw2_unstuck.manualBotModes[gBotMode]) then
		gw2_unstuck.Reset()
		gw2_unstuck.lastResult = false
		return gw2_unstuck.lastResult
	end

	-- Player must be alive
	if ( not ml_global_information.Player_Alive ) then
		gw2_unstuck.Reset()
		gw2_unstuck.lastResult = false
		return gw2_unstuck.lastResult
	end

	-- Valid lastposition
	if 	(not table.valid(gw2_unstuck.lastPos)) then
		gw2_unstuck.lastPos = ml_global_information.Player_Position
		gw2_unstuck.lastResult = false
		return gw2_unstuck.lastResult
	end

	-- Dont handle stuck when we are jumping / falling
	if ( not ml_global_information.Player_CanMove ) then
		return gw2_unstuck.lastResult
	end
	
	if(table.valid(gw2_unstuck.pathBlockingObject)) then
		gw2_unstuck.lastResult = gw2_unstuck.HandleStuck_AttackObject()
		return gw2_unstuck.lastResult
	end
	
	-- Dont handle stuck when we cannot move because of some debuff
	if ( gw2_common_functions.HasBuffs(Player, ml_global_information.ImmobilizeConditions) ) then
		gw2_unstuck.lastOnMeshTime = ml_global_information.Now
		gw2_unstuck.useWaypointTmr = ml_global_information.Now
		return gw2_unstuck.lastResult
	end

	-- PLAYER NOT ON MESH
	if ( not ml_global_information.Player_OnMesh ) then

		-- Check if a mesh is loaded
		local meshstate = NavigationManager:GetNavMeshState()
		if ( meshstate == GLOBAL.MESHSTATE.MESHEMPTY or meshstate == GLOBAL.MESHSTATE.MESHBUILDING ) then
			gw2_unstuck.lastResult = false
			return gw2_unstuck.lastResult
		end

		-- Throttle to compensate for situations where the player shortly leaves the mesh (jumping/getting kicked outside etc.)
		if ( TimeSince(gw2_unstuck.lastOnMeshTime) > 2000) then
			d("[Unstuck]: Player not on Navmesh!")

			if ( mode == nil or mode == "combat") then
				-- if the bot is started not on the mesh try to walk back onto the mesh
				local p = NavigationManager:GetClosestPointOnMesh({ x=ml_global_information.Player_Position.x, y=ml_global_information.Player_Position.y, z=ml_global_information.Player_Position.z })

				--d(tostring(gw2_unstuck.lastOnMeshTime).." "..tostring(TimeSince(gw2_unstuck.lastOnMeshTime)).." "..tostring(p.distance))
				if ( (gw2_unstuck.lastOnMeshTime == 0 or TimeSince(gw2_unstuck.lastOnMeshTime) < 20000) and table.valid(p) and p.distance > 0 and p.distance < 1000) then
					d("[Unstuck]: Move blindly to nearby mesh")
					Player:SetFacingExact(p.x,p.y,p.z)
					Player:SetMovement(GW2.MOVEMENTTYPE.Forward)
					gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Forward] = true
					gw2_unstuck.HandleStuck_MovedDistanceCheck(mode)
					gw2_unstuck.HandleStuck_ControlManualMovement()
					gw2_unstuck.useWaypointTmr = ml_global_information.Now

				else
					-- we are not on or nearby the mesh
					-- Another timer to prevent hickups when the p above fails
					if ( TimeSince(gw2_unstuck.useWaypointTmr) > 15000 ) then
						gw2_unstuck.useWaypointTmr = ml_global_information.Now
						gw2_unstuck.HandleStuck_UseWaypoint()
					end

				end
				gw2_unstuck.lastResult = true
				return gw2_unstuck.lastResult

			elseif ( mode == "follow" ) then

				gw2_unstuck.HandleStuck_MovedDistanceCheck()
				gw2_unstuck.HandleStuck_ControlManualMovement()

			end
		end
	else

		-- PLAYER IS ON THE MESH
		-- If an AntistuckPos was set, go there
		if ( gw2_unstuck.antiStuckPos ~= nil and table.valid(gw2_unstuck.antiStuckPos)) then
			local path = NavigationManager:GetPath(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,gw2_unstuck.antiStuckPos.x,gw2_unstuck.antiStuckPos.y,gw2_unstuck.antiStuckPos.z)
			if (table.valid(path)) then
				newnodecount = NavigationManager:MoveTo(gw2_unstuck.antiStuckPos.x,gw2_unstuck.antiStuckPos.y,gw2_unstuck.antiStuckPos.z,20,false,false,false)
				if ( newnodecount <= 0 ) then
					ml_error("[Unstuck]: Can't move to anti stuck position")
					gw2_unstuck.antiStuckPos = nil
				else
					gw2_unstuck.lastResult = true
				end
			end
		end

		gw2_unstuck.HandleStuck_MovedDistanceCheck(mode)
		gw2_unstuck.HandleStuck_ControlManualMovement()

		-- Update time when the player was on the mesh the last time
		gw2_unstuck.lastOnMeshTime = ml_global_information.Now
		gw2_unstuck.useWaypointTmr = ml_global_information.Now
	end

	gw2_unstuck.lastPos = ml_global_information.Player_Position

	return gw2_unstuck.lastResult
end

-- Checks the moved distance and performs different actions in order to handle stuck situations
gw2_unstuck.stuckPositionCount = 0
gw2_unstuck.lastGadgetID = nil
function gw2_unstuck.HandleStuck_MovedDistanceCheck(mode)

	local distmoved = 0
	-- calculate the moved distance depending on where we were stuck before or not
	if ( gw2_unstuck.stuckPosition ~= nil ) then
		distmoved = Distance2D ( ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, gw2_unstuck.stuckPosition.x,  gw2_unstuck.stuckPosition.y)
		gw2_unstuck.stuckPositionCount = gw2_unstuck.stuckPositionCount + 1
	else
		distmoved = Distance2D ( ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, gw2_unstuck.lastPos.x,  gw2_unstuck.lastPos.y)
		gw2_unstuck.stuckPositionCount = 0
	end
	if ( ml_global_information.ShowDebug ) then dbDistMoved = distmoved end


	if ( not ml_global_information.Player_IsMoving ) then
		if ( gw2_unstuck.stuckCount > 20 ) then
			d("[Unstuck]: HandleStuck_MovedDistanceCheck: Player not moving & stuckCount > 20")

		else
			--d("HandleStuck_MovedDistanceCheck: Player not moving")
		end
		gw2_unstuck.lastResult = false
		return
	end

	local StuckThreshOld = gw2_unstuck.stuckthreshold
	if ( mode == "combat" ) then StuckThreshOld = gw2_unstuck.stuckthreshold - 25 end
	if ( gw2_common_functions.HasBuffs(Player, ml_global_information.SlowConditions)) then
		-- We only move half (or less) the distance with conditions that slow movement
		StuckThreshOld = gw2_unstuck.stuckthreshold / 2
	end

	if ( distmoved < StuckThreshOld ) then
		gw2_unstuck.stuckCount = gw2_unstuck.stuckCount + 1

		-- save this stuckposition
		if ( gw2_unstuck.stuckPosition == nil ) then
			gw2_unstuck.stuckPosition = ml_global_information.Player_Position
		end

		local stuckCountTreshold = 1
		if ( mode == "combat" ) then stuckCountTreshold = 3 end

		-- 	Try Jumping
		if ( gw2_unstuck.stuckCount > stuckCountTreshold ) then
			d("[Unstuck]: We are stuck... Distmoved: "..tostring(round(distmoved,2)).. " < "..tostring(StuckThreshOld) .. ", stuckcount: " .. gw2_unstuck.stuckCount)
			if ( gw2_unstuck.stuckCount < 12) then

				-- check for doors n stuff

				if ( gw2_unstuck.stuckCount > 2 and gw2_unstuck.stuckCount < 5) then
					local hit,hitx,hity,hitz,a,b,c = RayCast(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z, ml_global_information.Player_Position.x+(Player.pos.hx*400), ml_global_information.Player_Position.y+(Player.pos.hy*400), ml_global_information.Player_Position.z-55, 0)
					if(hit) then	
						local GList = ( GadgetList("maxdistance=3000"))
						if (table.valid(GList)) then
							local id, gadget  = next( GList )
							local target = nil
							while id and gadget and target == nil do
								if(gadget.isunknown8 == a) then
									target = gadget
								end
								id,gadget  = next(GList, id)
							end
							
							if(not table.valid(target)) then
								target = Player:GetInteractableTarget()
							end
							
							if(not table.valid(target)) then
								local GList = ( GadgetList("nearest,maxdistance=500"))
								if(table.valid(GList)) then
									target = select(2,next(GList))
								end
							end
				
							if ( table.valid(target) and target.isgadget) then
								if(gw2_unstuck.stuckCount == 3 and table.valid(gw2_unstuck.lastRayCastDetails) and Distance3D(gw2_unstuck.lastRayCastDetails.pos.x,gw2_unstuck.lastRayCastDetails.pos.y,gw2_unstuck.lastRayCastDetails.pos.z,hitx,hity,ml_global_information.Player_Position.z) < 100) then
									d("[Unstuck]: We are stuck at the same object as last check.")
									gw2_obstacle_manager.AddAvoidanceAreaAtTarget(target, {duration = 600000})
									Player:StopMovement()
									Player:SetMovement(GW2.MOVEMENTTYPE.Backward)
									gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Backward] = true
									ml_global_information.Wait( 1500 )
									gw2_unstuck.stuckthreshold = 200
									gw2_unstuck.stuckCount = 12
									gw2_unstuck.lastRayCastDetails = nil
									gw2_unstuck.lastGadgetID = nil
									gw2_unstuck.lastResult = true
									return gw2_unstuck.lastResult
								end
								
								gw2_unstuck.lastRayCastDetails = { pos = {x = hitx, y = hity, z = ml_global_information.Player_Position.z}, a = a, b = b, c = c }
								
								if(gw2_unstuck.lastGadgetID == target.id) then
									d("[Unstuck]: Seems like we cant destroy or interact with this gadget")
									
									if(Player:IsConversationOpen() and gw2_unstuck.conversationTryCount < 5) then
										d("[Unstuck]: Conversation dialog is open.")
										Player:StopMovement()
										gw2_unstuck.conversationTryCount = gw2_unstuck.conversationTryCount + 1
										Player:SelectConversationOptionByIndex(0)
										gw2_unstuck.stuckCount = gw2_unstuck.stuckCount - 1
										gw2_unstuck.lastResult = true
										ml_global_information.Wait(1000)
										return gw2_unstuck.lastResult
									end

									gw2_obstacle_manager.AddAvoidanceArea({pos = Player.pos , radius = 75, duration = 1200000})
									Player:StopMovement()
									Player:SetFacingExact(hitx,hity,Player.pos.z)	
									Player:SetMovement(GW2.MOVEMENTTYPE.Backward)
									gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Backward] = true
									gw2_unstuck.stuckCount = 12
									ml_global_information.Wait( 2000 )
									gw2_unstuck.stuckthreshold = 200
									gw2_unstuck.lastResult = true
									return gw2_unstuck.lastResult
								end

								if(target.interactable and target.isininteractrange and gw2_unstuck.stuckCount == 3) then
									d("[Unstuck]: Path-Blocking Object found, trying to interact with it...")
									Player:SetFacingExact(hitx,hity,hitz)
									Player:StopMovement()
									ml_global_information.Wait(1000)
									return ml_log(Player:Interact(target.id))
								end

								if(target.attackable and target.alive) then
									d("[Unstuck]: Path-Blocking Object found, trying to destroy it...")
									gw2_unstuck.lastGadgetID = target.id
									gw2_unstuck.pathBlockingObject = {id = target.id, health = (target.health and target.health.current or 100), pos = {x = hitx, y = hity, z = hitz}, t = ml_global_information.Now, lastHealthCheck = ml_global_information.Now}

									gw2_unstuck.lastResult = true
									return gw2_unstuck.lastResult
								end

								gw2_unstuck.lastGadgetID = target.id
							end
						end

						
					end
				end

				if ( gw2_unstuck.jumpCount <= 2 ) then
					gw2_unstuck.stuckthreshold = 65
					gw2_unstuck.jumpCount = gw2_unstuck.jumpCount + 1

					if(ml_global_information.Player_Position.z > 50 and (ml_global_information.Player_SwimState == GW2.SWIMSTATE.Diving or ml_global_information.Player_SwimState == GW2.SWIMSTATE.Swimming)) then
						Player:StopMovement()
						Player:SetMovement(GW2.MOVEMENTTYPE.SwimUp)
						gw2_common_functions.Evade(math.random(4,7))
						ml_global_information.Wait(500)
					else
						Player:Jump()
					end
				elseif( gw2_unstuck.jumpCount <= 5 ) then
					
					gw2_unstuck.stuckthreshold = 125
					local dir = math.random(2,3)
					Player:SetMovement(dir)
					gw2_unstuck.moveDirSet[dir] = true
					gw2_unstuck.jumpCount = gw2_unstuck.jumpCount + 1
					if(ml_global_information.Player_Position.z > 50 and (ml_global_information.Player_SwimState == GW2.SWIMSTATE.Diving or ml_global_information.Player_SwimState == GW2.SWIMSTATE.Swimming)) then
						d("[Unstuck]: Swim up")
						Player:StopMovement()
						Player:SetMovement(GW2.MOVEMENTTYPE.SwimUp)
						ml_global_information.Wait(500)
					else
						d("[Unstuck]: Jump forward-sideways")
						Player:Jump()
					end
				elseif( gw2_unstuck.jumpCount <= 7 ) then
					d("[Unstuck]: Dodge forward-sideways")
					gw2_unstuck.stuckthreshold = 125
					local dir = math.random(4,5)
					gw2_unstuck.jumpCount = gw2_unstuck.jumpCount + 1
					Player:Evade(dir)
				else
					d("[Unstuck]: Jumping didnt help, setting avoidance area and walking somewhere else a bit")
					gw2_unstuck.stuckthreshold = 200
					gw2_obstacle_manager.AddAvoidanceArea({pos = ml_global_information.Player_Position, radius = 75, duration = 1200000 })
					Player:StopMovement()
					Player:SetMovement(GW2.MOVEMENTTYPE.Backward)
					gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Backward] = true
					ml_global_information.Wait( 2000 )
					if(ml_global_information.Player_Position.z > 50 and (ml_global_information.Player_SwimState == GW2.SWIMSTATE.Diving or ml_global_information.Player_SwimState == GW2.SWIMSTATE.Swimming)) then
						Player:SetMovement(GW2.MOVEMENTTYPE.SwimUp)
					else
						Player:Jump()
					end
				end

			elseif ( gw2_unstuck.stuckCount < 20) then
				d("[Unstuck]: stuckCount > 10 !! Get a random point and try to walk there")
				local p = NavigationManager:GetRandomPointOnCircle(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,50,650)
				if (p) then
					if ( Distance3D(p.x,p.y,p.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z) > 200) then
						d("[Unstuck]: New antistuck-randomposition set")
						gw2_unstuck.antiStuckPos = p
					end
				end
			elseif ( gw2_unstuck.stuckCount < 25 ) then
				gw2_obstacle_manager.AddAvoidanceArea({pos = ml_global_information.Player_Position, radius = 120, duration = 2400000})
				gw2_unstuck.TrackStuckPosition(ml_global_information.Player_Position)
				
				Player:StopMovement()
				Player:SetMovement(GW2.MOVEMENTTYPE.Backward)
				gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Backward] = true
				ml_global_information.Wait( 2000 )
				gw2_unstuck.stuckthreshold = 200
				Player:Jump()
			else
				d("[Unstuck]: We are really really stuck this time...")
				gw2_unstuck.TrackStuckPosition(ml_global_information.Player_Position)
				gw2_unstuck.HandleStuck_UseWaypoint()
			end
		end

	else
		--if ( ml_global_information.Player_OnMesh ) then
			gw2_unstuck.Reset()
			gw2_unstuck.lastResult = false

		--end
	end

end

-- Tries to stop the player from moving offside the mesh in case of "manual" antistuck movement
function gw2_unstuck.HandleStuck_ControlManualMovement()
	if ( ml_global_information.Player_MovementDirections.backward or ml_global_information.Player_MovementDirections.left or ml_global_information.Player_MovementDirections.right ) then
		if ( ml_global_information.Player_MovementDirections.backward and not Player:CanMoveDirection(0,75) ) then Player:UnSetMovement(1) end
		if ( ml_global_information.Player_MovementDirections.left and not ml_global_information.Player_MovementDirections.backward and not ml_global_information.Player_MovementDirections.forward and not Player:CanMoveDirection(6,75) ) then Player:UnSetMovement(2) end
		if ( ml_global_information.Player_MovementDirections.right and not ml_global_information.Player_MovementDirections.backward and not ml_global_information.Player_MovementDirections.forward and not Player:CanMoveDirection(7,75) ) then Player:UnSetMovement(3) end
		if ( ml_global_information.Player_MovementDirections.left and ml_global_information.Player_MovementDirections.backward and not Player:CanMoveDirection(1,75) ) then Player:UnSetMovement(2) end
		if ( ml_global_information.Player_MovementDirections.right and ml_global_information.Player_MovementDirections.backward and not Player:CanMoveDirection(2,75) ) then Player:UnSetMovement(3) end
		if ( ml_global_information.Player_MovementDirections.left and ml_global_information.Player_MovementDirections.forward and not Player:CanMoveDirection(4,75) ) then Player:UnSetMovement(2) end
		if ( ml_global_information.Player_MovementDirections.right and ml_global_information.Player_MovementDirections.forward and not Player:CanMoveDirection(5,75) ) then Player:UnSetMovement(3) end
	end
end

-- Using a waypoint to handle stuck situations
function gw2_unstuck.HandleStuck_UseWaypoint()

	if ( gw2_unstuck.respawntimer and TimeSince(gw2_unstuck.respawntimer) < 30000 ) then
		ml_error("[Unstuck]: We already used a Waypoint for unstuck 30 seconds ago, but are stuck again?!")
		ml_error("[Unstuck]: Stopping bot...")
		ml_global_information.Stop()
		ml_bt_mgr.running = false
	else
		if ( not ml_global_information.Player_InCombat ) then
			d("[Unstuck]: Trying to teleport to nearest Waypoint for unstuck..")
			
			if ( Inventory:GetInventoryMoney() > 200 ) then
				local wp = gw2_common_functions.GetClosestWaypointToPos(ml_global_information.CurrentMapID,ml_global_information.Player_Position)
				if(table.valid(wp) and wp.distance > 500) then	
					Player:StopMovement()
					Player:TeleportToWaypoint(wp.id)
					gw2_unstuck.respawntimer = ml_global_information.Now
				elseif(table.valid(wp) and wp.distance <= 500) then
					ml_error("[Unstuck]: We are at a waypoint but need to teleport again!? Something weird is going on, stopping bot")
					d("[Unstuck]: Logging out...")
					gw2_unstuck.Reset()
					Player:Logout()
				end

				ml_global_information.Wait(3000)
				gw2_unstuck.logoutTmr = 0
			else
				d("[Unstuck]: We dont have enough coin to use a waypoint...")
			end
		else
			if ( gw2_unstuck.logoutTmr == 0 ) then
				gw2_unstuck.logoutTmr = ml_global_information.Now
			elseif ( ml_global_information.Now - gw2_unstuck.logoutTmr > 60000 ) then --and gAutostartbot == "1" ) then
				gw2_unstuck.logoutTmr = ml_global_information.Now
				d("[Unstuck]: 60 seconds in combat but we need to use a waypoint, logging out...")
				Player:Logout()
			end

			d("[Unstuck]: We are in combat, cant use waypoint.. Time left until logout: "..tostring(60000 - (ml_global_information.Now - gw2_unstuck.logoutTmr)))
		end
	end
end

function gw2_unstuck.HandleStuck_AttackObject()
	local pbTarget = gw2_unstuck.pathBlockingObject
	local target = GadgetList:Get(pbTarget.id)
	local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)

	Player:StopMovement()
	--gw2_common_functions.NecroLeaveDeathshroud()
	if(gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Backward]) then
		Player:UnSetMovement(GW2.MOVEMENTTYPE.Backward)
		gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Backward] = false
	end
	
	if(gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Forward]) then		
		Player:UnSetMovement(GW2.MOVEMENTTYPE.Forward)
		gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Forward] = false
	end
	
	if(TimeSince(pbTarget.t) > 60000 or not table.valid(skill) or skill.maxRange == 0 or not table.valid(target) or target.alive == false or target.attackable == false) then
		d("[Unstuck]: Target destroyed or invalid")
		gw2_unstuck.pathBlockingObject = nil
		gw2_unstuck.lastResult = true
		return gw2_unstuck.lastResult
	end
	
	if(TimeSince(pbTarget.t) > 10000 and TimeSince(pbTarget.lastHealthCheck) > 5000) then
		pbTarget.lastHealthCheck = ml_global_information.Now
		if(pbTarget.health <= target.health.current) then
			d("[Unstuck]: Target not losing health")
			gw2_unstuck.pathBlockingObject = nil
			gw2_unstuck.lastResult = true
			return gw2_unstuck.lastResult
		end
		pbTarget.health = target.health.current
	end
	
	local maxRange = skill.maxrange > 150 and skill.maxrange or 150
	
	local dist = Distance2D(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,pbTarget.pos.x,pbTarget.pos.y)
	
	Player:SetFacingExact(pbTarget.pos.x,pbTarget.pos.y,target.pos.z)
	
	if(dist > maxRange) then
		Player:SetMovement(GW2.MOVEMENTTYPE.Forward)
		gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Forward] = true
		gw2_unstuck.lastResult = true
		return gw2_unstuck.lastResult
	end
	
	-- Work around a weird issue with some skills that wont cast if close to the target
	if(target.distance < 150) then
		Player:SetMovement(GW2.MOVEMENTTYPE.Backward)
		gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Backward] = true	
	end
	
	local pTarget = Player:GetTarget()
	if(pTarget == nil or pTarget.id ~= target.id) then
		Player:SetTarget(target.id)
	end

	if(Player.castinfo.slot == ml_global_information.MAX_SKILLBAR_SLOTS) then
		if(skill.isgroundtargeted) then
			Player:CastSpell(skill.slot,pbTarget.pos.x,pbTarget.pos.y,target.pos.z)
		else
			Player:CastSpell(skill.slot,target.id)
		end
	end
	gw2_unstuck.lastResult = true
	return gw2_unstuck.lastResult
end

function gw2_unstuck.TrackStuckPosition(stuckpos)
	local found = nil
	
	for _,pos in pairs(gw2_unstuck.trackedStuck) do
		local dist = Distance3DT(pos,stuckpos)
		if(dist < 100) then
			found = pos
		end
	end
	
	if(found) then
		found.count = found.count and found.count + 1 or 1
		if(found.count > 5) then
			ml_error("Stuck at the same position more then 25 times!")
			ml_error(string.format("{x=%s;y=%s;z=%s}", round(found.x,2), round(found.y,2), round(found.z,2)))
			ml_error("Stopping bot.")
			ml_bt_mgr.running = false
			Player:StopMovement()
			ml_global_information.Stop()
		end
	else
		table.insert(gw2_unstuck.trackedStuck, stuckpos)
	end
end

function gw2_unstuck.Start()
	gw2_unstuck.Stop()
	d("[Unstuck]: Started")
end

function gw2_unstuck.Stop()
	gw2_unstuck.lastRayCastDetails = nil
	gw2_unstuck.lastGadgetID = nil

	gw2_unstuck.lastOnMeshTime = ml_global_information.Now
	gw2_unstuck.useWaypointTmr = ml_global_information.Now
	
	gw2_unstuck.trackedStuck = {}
	
	gw2_unstuck.Reset()
end

function gw2_unstuck.Reset()
	gw2_unstuck.lastPos = ml_global_information.Player_Position
	gw2_unstuck.stuckTimer = ml_global_information.Now
	gw2_unstuck.stuckCount = 0
	gw2_unstuck.antiStuckPos = nil
	gw2_unstuck.stuckPosition = nil
	gw2_unstuck.jumpCount = 0
	gw2_unstuck.stuckthreshold = 45
	gw2_unstuck.respawntimer = nil
	gw2_unstuck.pathBlockingObject = nil
	gw2_unstuck.conversationTryCount = 0
	
	if ( ml_global_information.Player_IsMoving and ml_global_information.Player_CanMove) then
		if ( ml_global_information.Player_MovementDirections.backward and gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Backward] ) then gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Backward] = false Player:UnSetMovement(GW2.MOVEMENTTYPE.Backward) end
		if ( ml_global_information.Player_MovementDirections.left and gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Left] ) then gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Left] = false Player:UnSetMovement(GW2.MOVEMENTTYPE.Left) end
		if ( ml_global_information.Player_MovementDirections.right and gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Right] ) then gw2_unstuck.moveDirSet[GW2.MOVEMENTTYPE.Right] = false Player:UnSetMovement(GW2.MOVEMENTTYPE.Right) end
	end
end


function gw2_unstuck.ModuleInit()
	d("gw2_unstuck:ModuleInit")
end

RegisterEventHandler("Module.Initalize",gw2_unstuck.ModuleInit)