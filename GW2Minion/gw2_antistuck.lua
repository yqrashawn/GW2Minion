gw2_antistuck = {}
gw2_antistuck.stuckLevel = 0
gw2_antistuck.obstacles = {}
gw2_antistuck.stuckLevel0Data = { botrunning = false, hitobjects={}, lastpos = {x=0,y=0,z=0}, notmovingtimer = 0, notmovingcount = 0 } -- keeps track of the thinks we ran into
gw2_antistuck.stuckLevel1Data = { antistuckdistance = 0 , direction = 0, start = 0, lastdirectionchange = 0}
gw2_antistuck.stuckLevel2Data = { respawntimer = 0, logoutTmr = 0}

function gw2_antistuck.Reset()
	
	Player:StopMovement()
	gw2_antistuck.stuckLevel = 0
	gw2_antistuck_stuckLevel = gw2_antistuck.stuckLevel
	if ( gw2_antistuck.stuckLevel0Data.botrunning ) then
		ml_global_information.Running = true
	end
	gw2_antistuck.stuckLevel0Data.botrunning = false
	gw2_antistuck.stuckLevel0Data.lastpos = ml_global_information.Player_Position
	gw2_antistuck.stuckLevel0Data.notmovingtimer = 0
	gw2_antistuck.stuckLevel0Data.notmovingcount = 0
	gw2_antistuck.stuckLevel1Data = { antistuckdistance = 0 , direction = 0, start = 0, lastdirectionchange = 0}
	gw2_antistuck.stuckLevel2Data = { respawntimer = 0, logoutTmr = 0}
			
	
end

function gw2_antistuck.OnUpdate(tick)
	
	if ( ml_global_information.Running or gw2_antistuck.stuckLevel0Data.botrunning ) then 
		-- Player must be alive, can move and a mesh is loaded
		if ( gBotMode ~= GetString("assistMode") and ml_global_information.Player_Alive and NavigationManager:GetNavMeshState() == GLOBAL.MESHSTATE.MESHREADY) then --and ml_global_information.Player_IsMoving) then
				
			-- IF IS RUNNING OR DATA0.Running == ture
			--ml_global_information.Player_OnMesh and  ??	
				
			if ( gw2_antistuck.stuckLevel == 0 and (ml_global_information.Player_MovementState == GW2.MOVEMENTSTATE.GroundMoving or ml_global_information.Player_MovementState == GW2.MOVEMENTSTATE.BelowWaterMoving or ml_global_information.Player_MovementState == GW2.MOVEMENTSTATE.AboveWaterMoving )) then -- all peachy status
				-- Raycast ahead of player to find obstacles
				local pPos = ml_global_information.Player_Position
				local hit,x,y,z,a,b,c = raycast(pPos.x,pPos.y,pPos.z, pPos.x+pPos.hx*55, pPos.y+pPos.hy*55, pPos.z-35 ,0xffff)
				if ( hit or gw2_antistuck.NotMovingCheck() ) then
					
					local handlestuck = false
					if ( hit ) then
						d(tostring(a ).."  "..tostring(string.format( "%x",tonumber(b ))).."  "..tostring(c))			
						-- save the thing we hit to determine if we were running into this more than a few times
						if ( gw2_antistuck.stuckLevel0Data.hitobjects[a] == nil ) then
							gw2_antistuck.stuckLevel0Data.hitobjects[a] = { count = 1, lasthit = ml_global_information.Now }
						else
							gw2_antistuck.stuckLevel0Data.hitobjects[a].count = gw2_antistuck.stuckLevel0Data.hitobjects[a].count + 1
							gw2_antistuck.stuckLevel0Data.hitobjects[a].lasthit = ml_global_information.Now
							
							if ( gw2_antistuck.stuckLevel0Data.hitobjects[a].count % 10 == 0) then
								d("AntiStuck: Running into an Object more than 10 times...")
								handlestuck = true
							end
						end
					end
					-- check are we still running into the same thing in the past seconds - check
					for a,e in pairs(gw2_antistuck.stuckLevel0Data.hitobjects) do
						local t = TimeSince(e.lasthit)
						if ( t > 60000 ) then
							gw2_antistuck.stuckLevel0Data.hitobjects[a] = nil
						--[[elseif( t > 5000) then
							if ( e.count > 1 ) then
								e.count = e.count - 1							
							end]]
						end
					end
					
					
					-- check if we can jump over it (do 2 more raycasts)
					if ( 	raycast(pPos.x,pPos.y,pPos.z-70, pPos.x+pPos.hx*55, pPos.y+pPos.hy*55, pPos.z-75 ,0xffff)
						and raycast(pPos.x,pPos.y,pPos.z-110, pPos.x+pPos.hx*55, pPos.y+pPos.hy*55, pPos.z-120 ,0xffff)) then
						
						if ( handlestuck ) then
							if ( c == 13 ) then
								-- Gadget, aka door n stuff
								d("Gadget Blocks Path ")
								local gList = GadgetList("maxdistance=1200")
								local gTarget = nil
								if ( TableSize(gList) > 0 )then
									local i,e = next (gList)
									while i and e do 
										if ( e.isUnknown8 == a ) then
											gTarget = e
											break
										end
										i,e = next(gList,i)
									end
								end
								if ( gTarget ) then
									if ( not gTarget.attackable ) then
										gw2_antistuck.AddObstacleAtTarget( gTarget )
									else
										d("TODO: AntiStuck: Attack blocking Gadget here")
										
										
									end
								end
								
							elseif ( c == 12 ) then
								-- Portal Doors ...any other ?
								-- Check if we can go through them or not...
								
								gw2_antistuck.AddObstacleInfrontPlayer()
							else
								d("Path Blocked by unknown Geometry, type : "..tostring(c))
								gw2_antistuck.AddObstacleInfrontPlayer()
							end
						end			
					else
						-- Something is infront of us but we can jump over it
						Player:Jump()
						-- another check in case we somehow cannot jump over it
						if ( gw2_antistuck.stuckLevel0Data.hitobjects[a].count > 20 ) then
							d("AntiStuck: Seems we cannot jump over the object...")
							gw2_antistuck.stuckLevel0Data.hitobjects[a].count = 0
							gw2_antistuck.AddObstacleInfrontPlayer()
							
						end
					end
				end
			
			-- we hit an object, placed a NavObstacle and are now trying to walk a bit backwards onto the mesh we came from to query a new path around that object
			elseif ( gw2_antistuck.stuckLevel == 1 ) then
			
				-- Reset if we are back on the mesh
					if ( gw2_antistuck.stuckLevel1Data.direction ~= 0 and Player.onmeshexact ) then
						d("AntiStuck: Reset, we are back on the mesh.")
						gw2_antistuck.Reset()
						ml_global_information.Running = true
						return
					end
				
				if ( ml_global_information.Now - gw2_antistuck.stuckLevel1Data.lastdirectionchange > 2000 ) then
					gw2_antistuck.stuckLevel1Data.lastdirectionchange = ml_global_information.Now
											
									
					-- change direction 0 = forward, 1 = backwards, 2 = left, 3 = right
					if ( gw2_antistuck.stuckLevel1Data.direction == 3 ) then
						gw2_antistuck.stuckLevel = gw2_antistuck.stuckLevel + 1
						gw2_antistuck_stuckLevel = gw2_antistuck.stuckLevel		
					end
					
					Player:UnSetMovement(gw2_antistuck.stuckLevel1Data.direction)
					gw2_antistuck.stuckLevel1Data.direction = gw2_antistuck.stuckLevel1Data.direction + 1				
					Player:SetMovement(gw2_antistuck.stuckLevel1Data.direction)
					d("AntiStuck: SetMovement Direction "..tostring(gw2_antistuck.stuckLevel1Data.direction))
					
				else
					-- inbetween moving into some direction
					Player:Jump()				
				end
			
			elseif ( gw2_antistuck.stuckLevel == 2 ) then
			-- TODO ADD AVOIDANCEAREA
			
				d("HandleStuck_UseWaypoint().....")
				if ( ml_global_information.Now - gw2_antistuck.stuckLevel2Data.respawntimer < 30000 ) then
					ml_error("We already used a Waypoint for unstuck within the last 30 seconds already but are stuck again !?")
					ml_error("Stopping bot...")
					gw2minion.ToggleBot()
						--ExitGW()
				else
					if ( not ml_global_information.Player_InCombat ) then
						if ( Inventory:GetInventoryMoney() < 300 ) then
							ml_log("We may not have enough money for using a waypoint anymore...")
						end
						d("Trying to teleport to nearest Waypoint for unstuck..")
						-- safetycheck
						local WList = WaypointList("nearest,onmesh,notcontested,samezone")
						if ( ValidTable(WList) ) then
							local id,wp = next(WList)
							if ( id and wp and wp.distance > 500 ) then
								if ( Player:RespawnAtClosestWaypoint() ) then
									gw2_antistuck.stuckLevel2Data.respawntimer = ml_global_information.Now
									gw2_antistuck.Reset()
									ml_global_information.Running = true
								end
							else
								ml_error("We are at a waypoint but need to teleport again!? Something weird is going on, stopping bot")
								d("Logging out...")
								Player:Logout()
							end
						end
						ml_global_information.Wait(3000)
						gw2_antistuck.stuckLevel2Data.logoutTmr = 0
					else
						if ( gw2_antistuck.stuckLevel2Data.logoutTmr == 0 ) then
							gw2_antistuck.stuckLevel2Data.logoutTmr = ml_global_information.Now
						elseif ( ml_global_information.Now - gw2_antistuck.stuckLevel2Data.logoutTmr > 60000 ) then --and gAutostartbot == "1" ) then
							gw2_antistuck.stuckLevel2Data.logoutTmr = ml_global_information.Now
							d("60 seconds in combat but we need to use a waypoint, logging out...")
							Player:Logout()
						end

						d("Seems we are still in combat, cant use waypoint..TimeLeft till logout: "..tostring(60000 - (ml_global_information.Now - gw2_antistuck.stuckLevel2Data.logoutTmr)))

					end
				end
			end
		else
			gw2_antistuck.Reset()
		end
	else
		gw2_antistuck.Reset()
	end
end

-- fallback check in case the raycast does not pick up anything that blocks us
function gw2_antistuck.NotMovingCheck()
	if ( TimeSince(gw2_antistuck.stuckLevel0Data.notmovingtimer) > 1500 ) then
		gw2_antistuck.stuckLevel0Data.notmovingtimer = ml_global_information.Now
		
		gw2_antistuck_distmoved = Distance2D ( ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, gw2_antistuck.stuckLevel0Data.lastpos.x,  gw2_antistuck.stuckLevel0Data.lastpos.y)
		
		if ( gw2_antistuck_distmoved < 50 ) then
			gw2_antistuck.stuckLevel0Data.notmovingcount = gw2_antistuck.stuckLevel0Data.notmovingcount + 1
			
			if ( gw2_antistuck.stuckLevel0Data.notmovingcount > 5 ) then
				d("Antistuck: We are not moving anymore ?")
				Player:StopMovement()
				gw2_antistuck.stuckLevel = 1 
				gw2_antistuck_stuckLevel = gw2_antistuck.stuckLevel
				gw2_antistuck.stuckLevel1Data.antistuckdistance = 100
				gw2_antistuck.stuckLevel1Data.start = ml_global_information.Now
				gw2_antistuck.stuckLevel0Data.botrunning = ml_global_information.Running
				gw2_antistuck.stuckLevel0Data.notmovingcount = 0
				ml_global_information.Running = false
				gw2_antistuck.AddObstacleInfrontPlayer()
			end
		
		else
			gw2_antistuck.stuckLevel0Data.notmovingcount = 0
		
		end		
		gw2_antistuck.stuckLevel0Data.lastpos = ml_global_information.Player_Position
	end
end


-- Sets an obstacle at the target's position with the target's radius
function gw2_antistuck.AddObstacleAtTarget( target )
	if ( ValidTable(target) ) then
		local tPos = target.pos
		if (ValidTable(tPos) ) then
			-- Check if an obstacle at this pos exists already 
			local refID = nil
			for id,o in pairs(gw2_antistuck.obstacles) do 
				local dist = Distance3D(o.x,o.y,o.z,tPos.x,tPos.y,tPos.z+50)
				if ( dist <= o.r ) then				
					d("AntiStuck: Obstacle exists already at that position")
					refID = id
					break
				end
			end
			
			local radius = target.radius 
			if ( refID == nil ) then
				d("AntiStuck: Adding NavObstacle infront of Player")
				local newrefid = NavigationManager:AddNavObstacle({ x=tPos.x, y=tPos.y, z=tPos.z+50, r=radius })
				gw2_antistuck.obstacles[newrefid] = { x=tPos.x, y=tPos.y, z=tPos.z+50, r=radius, t=ml_global_information.Now }
			
			else
				d("AntiStuck: Increasing nearby obstacle radius ")
				NavigationManager:RemoveNavObstacle(refID)			
				local obstacle = gw2_antistuck.obstacles[refID]
				local newrefid = NavigationManager:AddNavObstacle({ x=obstacle.x, y=obstacle.y, z=obstacle.z, r=obstacle.r*1.5 })
				gw2_antistuck.obstacles[newrefid] = { x=obstacle.x, y=obstacle.y, z=obstacle.z, r=obstacle.r*1.5, t=ml_global_information.Now }
				gw2_antistuck.obstacles[refID] = nil			
			end
						
			gw2_antistuck.stuckLevel = 1 
			gw2_antistuck_stuckLevel = gw2_antistuck.stuckLevel
			gw2_antistuck.stuckLevel1Data.antistuckdistance = radius - Distance3D(tPos.x,tPos.y,tPos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)
			gw2_antistuck.stuckLevel1Data.start = ml_global_information.Now
			gw2_antistuck.stuckLevel0Data.botrunning = ml_global_information.Running
			ml_global_information.Running = false
			Player:StopMovement()
		end
	end
end

-- Sets an obstacle
function gw2_antistuck.AddObstacleInfrontPlayer()
	local tPos = ml_global_information.Player_Position
	if (ValidTable(tPos) ) then
		-- Check if an obstacle at this pos exists already 
		local refID = nil
		for id,o in pairs(gw2_antistuck.obstacles) do 
			local dist = Distance3D(o.x,o.y,o.z,tPos.x,tPos.y,tPos.z+50)
			d("DIST "..tostring(dist))
			if ( dist <= o.r ) then				
				d("AntiStuck: Obstacle exists already at that position")
				refID = id
				break
			end
		end
		
		if ( refID == nil ) then
			d("AntiStuck: Adding NavObstacle infront of Player")
			local newrefid = NavigationManager:AddNavObstacle({ x=tPos.x, y=tPos.y, z=tPos.z+50, r=50 })
			gw2_antistuck.obstacles[newrefid] = { x=tPos.x, y=tPos.y, z=tPos.z+50, r=50, t=ml_global_information.Now }
		
		else
			d("AntiStuck: Increasing nearby obstacle radius ")
			NavigationManager:RemoveNavObstacle(refID)			
			local obstacle = gw2_antistuck.obstacles[refID]
			local newrefid = NavigationManager:AddNavObstacle({ x=obstacle.x, y=obstacle.y, z=obstacle.z, r=obstacle.r*1.5 })
			gw2_antistuck.obstacles[newrefid] = { x=obstacle.x, y=obstacle.y, z=obstacle.z, r=obstacle.r*1.5, t=ml_global_information.Now }
			gw2_antistuck.obstacles[refID] = nil			
		end
		
		gw2_antistuck.stuckLevel = 1 
		gw2_antistuck_stuckLevel = gw2_antistuck.stuckLevel
		gw2_antistuck.stuckLevel1Data.antistuckdistance = 100
		gw2_antistuck.stuckLevel1Data.start = ml_global_information.Now
		gw2_antistuck.stuckLevel0Data.botrunning = false
		ml_global_information.Running = false	
		Player:StopMovement()		
	end
end

function gw2_antistuck.ModuleInit()
	d("gw2_antistuck:ModuleInit")

	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("StuckLevel","gw2_antistuck_stuckLevel","AntiStuck")
		dw:NewField("Distance Moved","gw2_antistuck_distmoved","AntiStuck")
		
	end
end

RegisterEventHandler("Module.Initalize",gw2_antistuck.ModuleInit)