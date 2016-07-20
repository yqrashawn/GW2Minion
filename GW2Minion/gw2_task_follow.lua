-- FollowTarget Task, this is utilizing optionally party and multibotserver data
gw2_task_follow = inheritsFrom(ml_task)
gw2_task_follow.name = GetString("followmode")
gw2_task_follow.targetPath = {}
gw2_task_follow.lastFollowTargetPos = {}

-- constantly update the FollowTarget data 
function gw2_task_follow.OnUpdate( tickcount)
	
	if ( gBotMode == GetString("followmode") ) then
	
		-- Use partydata to update followtarget, this is needed for when we switch zones while following, then the ID changes
		if ( gFollowTargetName ~= nil and gFollowTargetName ~= "") then
			local pMember = gw2_common_functions.GetPartyMemberByName( gFollowTargetName )
			if ( pMember and tonumber(pMember.id) and tonumber(gFollowTargetID) ~= pMember.id) then 
				d("FollowTargetID changed! "..tostring(gFollowTargetID).. " to "..tostring(pMember.id))
				gFollowTargetID = pMember.id
				-- Start new path
				gw2_task_follow.targetPath = {}
				gw2_task_follow.lastFollowTargetPos = {}
			end
		end
	
		if ( gFollowTargetID ~= nil and gFollowTargetID ~= 0 and gFollowTargetID ~= "") then
			local target = CharacterList:Get(gFollowTargetID)
				
			-- try to get followtarget by name if it wasnt found, this is needed for when we switch zones while following, then the ID changes
			if ( TableSize(target) == 0 ) then
				local CList = CharacterList("selectable")
				if ( TableSize(CList) > 0 ) then
					local index, player  = next( CList )		
					while ( index ~= nil and player ~= nil ) do
						if (player.name == name) then
							d("Changed FollowTargetID "..tostring(player.id))
							gFollowTargetID = player.id
							gFollowTargetMap = gw2_datamanager.GetMapName(ml_global_information.CurrentMapID)
							target = player
							break
						end
						index, player  = next( CList,index )
					end	
				end			
			end
			
			-- Our FollowTarget was found, update the path and position data..
			if ( TableSize(target)>0 ) then
				local mstate = target.movementstate
				local tpos = target.pos					
				gw2_task_follow.lastFollowTargetPos = tpos
				
				-- UPDATE NAVPATH
				local pSize = TableSize(gw2_task_follow.targetPath)				
				if ( pSize > 0 ) then
					-- Extend existing path
					local pPos = ml_global_information.Player_Position
					local dist = Distance3D( tpos.x, tpos.y, tpos.z, gw2_task_follow.targetPath[pSize].pos.x ,gw2_task_follow.targetPath[pSize].pos.y , gw2_task_follow.targetPath[pSize].pos.z)
					if ( dist < 500 and dist > 120 ) then
						table.insert(gw2_task_follow.targetPath, { pos = { x=tpos.x, y=tpos.y, z=tpos.z } , flag = mstate })
					end
					
				else
					-- Start new path
					gw2_task_follow.targetPath = {}
					gw2_task_follow.lastFollowTargetPos = {}
					local pPos = ml_global_information.Player_Position
					local dist = Distance3D( pPos.x, pPos.y, pPos.z, tpos.x, tpos.y, tpos.z)
					if ( dist < 1500 and target.los == true or dist < 500 ) then
						table.insert(gw2_task_follow.targetPath, { pos = { x=tpos.x, y=tpos.y, z=tpos.z } , flag = mstate })
					else
						ml_log("Target_To_Follow_Is_out_of_Followrange")
					end
				end
				
				-- OPTIMIZE NAVPATH by removing crossing paths etc
				if ( TableSize(gw2_task_follow.targetPath) > 0 ) then
					local optpath = {}
					local idx = 1
					local pPos = ml_global_information.Player_Position
										
					-- get closest startpoint to player
					local shortestdist = 450
					if ( target.los == true ) then shortestdist = 1500 end
						
					for i = 1, TableSize(gw2_task_follow.targetPath), 1 do
						local dist = Distance3D( pPos.x, pPos.y, pPos.z, gw2_task_follow.targetPath[i].pos.x, gw2_task_follow.targetPath[i].pos.y, gw2_task_follow.targetPath[i].pos.z)
						if ( dist < shortestdist ) then
							shortestdist = dist
							idx = i
						end						
					end					
					-- remove every useless node from start to idx
					if ( idx > 1 ) then
						for i = idx, TableSize(gw2_task_follow.targetPath), 1 do
							table.insert(optpath,gw2_task_follow.targetPath[idx])
						end
						gw2_task_follow.targetPath = deepcopy(optpath)
					end					
					
					-- shorten path by removing "crossing paths"										
					if ( TableSize(gw2_task_follow.targetPath) > 2 ) then
						optpath = {}
						local optimized = false
						for i = 1, TableSize(gw2_task_follow.targetPath)-2, 1 do
							for k = i+2, TableSize(gw2_task_follow.targetPath), 1 do
								local dist = Distance3D( gw2_task_follow.targetPath[i].pos.x ,gw2_task_follow.targetPath[i].pos.y , gw2_task_follow.targetPath[i].pos.z, gw2_task_follow.targetPath[k].pos.x ,gw2_task_follow.targetPath[k].pos.y , gw2_task_follow.targetPath[k].pos.z)
								
								if ( dist <= 110 ) then
									-- we can shortcut our path here
									-- add start nodes till shortening point
									for j = 1, i, 1 do
										table.insert(optpath,gw2_task_follow.targetPath[j])
									end
									-- add last points
									for j = k, TableSize(gw2_task_follow.targetPath), 1 do
										table.insert(optpath,gw2_task_follow.targetPath[k])
									end
									gw2_task_follow.targetPath = deepcopy(optpath)
									optimized = true
									break
								end
							end
							if ( optimized == true ) then
								break
							end
						end
					end
				end
				
			else
				-- the target to follow is not in our characterlist 
				ml_log("Cannot find the Target to follow nearby")				
				if ( TableSize(gw2_task_follow.lastFollowTargetPos) == 0 and not ml_global_information.Player_IsMoving ) then
					gw2_task_follow.targetPath = {}
					gw2_task_follow.lastFollowTargetPos = {}
				end
				
			end
			if ( ml_global_information.ShowDebug ) then 
				gFollowTargetPathSize = TableSize(gw2_task_follow.targetPath)
			end
			
		else
		
			ml_log("Select a Target to follow or enter a Partymember name!")
		end
	end
end



function gw2_task_follow.Create()
	local newinst = inheritsFrom(gw2_task_follow)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
	
    return newinst
end

function gw2_task_follow:Init()
	
	-- Handle Dead
	self:add(ml_element:create( "Dead", c_Dead, e_Dead, 500 ), self.overwatch_elements)	
	
	-- Downed 
	self:add(ml_element:create( "Downed", c_Downed, e_DownedEmpty, 450 ), self.overwatch_elements)
	
	-- Handle Rezz-Target is alive again or gone, deletes the subtask moveto in case it is needed
	self:add(ml_element:create( "RevivePartyMemberOverWatch", c_RezzOverWatchCheck, e_RezzOverWatchCheck, 400 ), self.overwatch_elements)
	
	-- Normal elements
	-- Revive Downed/Dead Partymember
	self:add(ml_element:create( "RevivePartyMember", c_RezzPartyMember, e_RezzPartyMember, 375 ), self.process_elements)	-- creates subtask: moveto
	self:add(ml_element:create( "FollowingTargetToMap", c_FollowTargetToMap, e_FollowTargetToMap, 350 ), self.process_elements) -- create subtask navigatetomap
	
	--Buy & Repair & Vendoring this would need some special Cause that only vendors when a vendor is really nearby, else the followers are running away always from the one it should follow
	self:add(ml_element:create( "VendorSell", c_createVendorSellTask, e_createVendorSellTask, 250 ), self.process_elements)
	self:add(ml_element:create( "VendorBuy", c_createVendorBuyTask, e_createVendorBuyTask, 240 ), self.process_elements)
	
	-- ReviveNPCs
	--self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 200 ), self.process_elements) -- creates subtask: moveto	
	-- Gathering
	self:add(ml_element:create( "Gathering", c_GatherTask, e_GatherTask, 225 ), self.process_elements) -- creates subtask: gatheringTask 
	
	self:add(ml_element:create( "FollowingTarget", c_FollowTarget, e_FollowTarget, 200 ), self.process_elements)
	self:add(ml_element:create( "AttackBestCharacterTarget", c_AttackBestNearbyCharacterTarget, e_AttackBestNearbyCharacterTarget, 100 ), self.process_elements)	
	
	
	self:AddTaskCheckCEs()
end
function gw2_task_follow:task_complete_eval()	
	
	return false
end

function gw2_task_follow:UIInit()
	d("gw2_task_follow:UIInit")
	local mw = WindowManager:GetWindow(gw2minion.MainWindow.Name)
	if ( mw ) then
		mw:NewComboBox(GetString("sMtargetmode"),"sMtargetmode",GetString("followmode"),"None,LowestHealth,Closest,Biggest Crowd");
		mw:NewComboBox(GetString("sMmode"),"sMmode",GetString("followmode"),"Everything,Players Only")
		mw:NewField(GetString("followtarget"),"gFollowTargetName",GetString("followmode"))		
		mw:NewButton(GetString("followtarget"),"gw2_task_follow.FollowTarget",GetString("followmode"))
		RegisterEventHandler("gw2_task_follow.FollowTarget", gw2_task_follow.SetFollowTarget)	
		
		mw:UnFold( GetString("followmode") )
		
		-- Multibot functions
		mw:NewCheckBox(GetString("activated"),"gMultiBotEnabled",GetString("serverInfo"))
		mw:NewField(GetString("status"),"dPartyStatus",GetString("serverInfo"))
		mw:NewField(GetString("partyrole"),"gRole",GetString("serverInfo"))
				
	end
	
	sMtargetmode = Settings.GW2Minion.sMtargetmode
	if ( sMtargetmode == "None" ) then
		sMtargetmode = "Closest"
	end
	if ( Settings.GW2Minion.gFollowTargetName ) then
		gFollowTargetName = Settings.GW2Minion.gFollowTargetName
	end
	sMmode = Settings.GW2Minion.sMmode
	return true
end
function gw2_task_follow:UIDestroy()
	d("gw2_task_follow:UIDestroy")
	GUI_DeleteGroup(gw2minion.MainWindow.Name, GetString("followmode"))
	GUI_DeleteGroup(gw2minion.MainWindow.Name, GetString("serverInfo"))	
end

function gw2_task_follow.ModuleInit()
	-- Setup Debug fields
	if (Settings.GW2Minion.sMtargetmode == nil) then
		Settings.GW2Minion.sMtargetmode = "None"
	end
	if (Settings.GW2Minion.sMmode == nil) then
		Settings.GW2Minion.sMmode = "Everything"
	end
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("FollowTargetID","gFollowTargetID","Task_Follow")
		dw:NewField("FollowTargetMap","gFollowTargetMap","Task_Follow")
		dw:NewField("FollowPathSize","gFollowTargetPathSize","Task_Follow")
	end
end
RegisterEventHandler("Module.Initalize",gw2_task_follow.ModuleInit)
ml_global_information.AddBotMode(GetString("followmode"), gw2_task_follow)


-- Button handler for follow current target
function gw2_task_follow.SetFollowTarget()
	local t = Player:GetTarget()
	gw2_task_follow.targetPath = {}
	gw2_task_follow.lastFollowTargetPos = {}
	c_FollowTarget.randomDist = math.random(150,700)
	e_FollowTarget.rndStopDist = math.random(55,400)
	if ( t ) then
		gFollowTargetName = t.name		
		gFollowTargetID = t.id
		gFollowTargetMap = gw2_datamanager.GetMapName(ml_global_information.CurrentMapID)
	else
		gFollowTargetName = ""
		gFollowTargetID = 0
		gFollowTargetMap = ""
	end
end



-- C&Es

-- Used with multibotserver, to move to the map where the leader is 
c_FollowTargetToMap = inheritsFrom( ml_cause )
e_FollowTargetToMap = inheritsFrom( ml_effect )
e_FollowTargetToMap.targetMapID = nil
e_FollowTargetToMap.targetNearestWaypointID = nil
function c_FollowTargetToMap:evaluate()
	
	--TODO:	Check for handling dungeon join dialogs here ?
	
	
	-- Only when we are not moving (else the bot should still have followpath data to follow the target through portals etc...
	if ( TableSize(gw2_task_follow.lastFollowTargetPos) == 0 ) then

		-- Use PartyInfo data to follow a groupmember (if that one is the target to follow)
		if ( gFollowTargetName ~= nil and gFollowTargetName ~= "") then
			local pMember = gw2_common_functions.GetPartyMemberByName( gFollowTargetName )
			if ( pMember ) then 
				-- Our FollowTarget is a partymember
				
				-- FollowTarget is not on our current server
				local pPlayer = gw2_multibot_manager.GetPlayerPartyData()
				if (pPlayer ~= nil and pMember.currentserverid ~= pPlayer.currentserverid ) then
					ml_log("FollowTarget is on a different Server!")
					local sID = tonumber(pMember.currentserverid)
					if ( sID ~= nil and sID > 0 ) then
						local serverlist = {}
						if ( sID > 1000 and sID < 2000 ) then
							serverlist = ml_global_information.ServersUS
						elseif ( sID > 2000 and sID < 3000 ) then
							serverlist = ml_global_information.ServersEU
						end	
						if ( TableSize(serverlist) > 0) then
							local i,entry = next ( serverlist)
							while i and entry do
								if ( entry.id == sID ) then
									gGuestServer = entry.name
									SetServer(sID)									
									d("Setting Guestserver: "..(entry.name) .." ID: ".. tostring(entry.id))
									-- saving followtarget's name
									Settings.GW2Minion.gFollowTargetName = gFollowTargetName
									Player:Logout()
									ml_global_information.Wait(5000)									
									return true
								end
								i,entry = next ( serverlist,i)
							end
						end
					end
				
				-- FollowTarget is on a different Map
				elseif( tonumber(pMember.mapid) and tonumber(pMember.mapid) ~= ml_global_information.CurrentMapID ) then
					ml_log("Trying to get a random Waypoint in the target mapID and teleport there")
					local mapdata = gw2_datamanager.GetLocalMapData(pMember.mapid)
					local wpList = {}
					if ( ValidTable(mapdata) and TableSize(mapdata["floors"]) > 0 and TableSize(mapdata["floors"][0]) > 0) then
						local pois = mdata["floors"][0]["points_of_interest"]
						if ( TableSize(pois) > 0 ) then							
							local id,entry = next (pois)
							while id and entry do			
								if ( entry["type"] == "waypoint" ) then
									table.insert(wpList,id)
								end								
								id,entry = next(pois,id)
							end
						end						
					end
					if (TableSize(wpList) > 0) then
						wpID = wpList[math.random(#wpList)]
						if (tonumber(wpID))then
							e_FollowTargetToMap.targetNearestWaypointID = wpID
							e_FollowTargetToMap.targetMapID = pMember.mapid
							return true
						else
							ml_error("Invalid WaypointID from WPList : "..tostring(wpID))
						end					
					end
					
				elseif ( pMember.connectstatus == 1 ) then
					ml_log("Leader has disconnected?!")
					
				else				
					--ml_log("Unknown error in finding the leader! ")		
				end			
			
			end				
		end		

		-- Use multibotserver data to follow the leader (after mapchange/out of map/ etc...)
		if ( gw2_multibot_manager.multiBotIsConnected ) then		
			
			if ( Player:GetRole() == 0 ) then -- Use ofcourse only when we are not leader and when we are in the same map
				if ( gw2_multibot_manager.leaderMapID ~= nil and gw2_multibot_manager.leaderMapID ~= 0 and gw2_multibot_manager.leaderMapID ~= ml_global_information.CurrentMapID) then
					e_FollowTargetToMap.targetMapID = gw2_multibot_manager.leaderMapID
					e_FollowTargetToMap.targetNearestWaypointID = gw2_multibot_manager.leaderWPID or nil
					return true
				end			
			end	
		end

	end
	
	e_FollowTargetToMap.targetMapID = nil
	e_FollowTargetToMap.targetNearestWaypointID = nil
	return false
end
function e_FollowTargetToMap:execute()
	
	-- Use waypoint to get to the followtarget	
	if ( e_FollowTargetToMap.targetNearestWaypointID ~= nil and ml_global_information.Player_InCombat == false and Inventory:GetInventoryMoney() > 500) then
		if ( ValidTable(WaypointList:Get(e_FollowTargetToMap.targetNearestWaypointID) ) ) then
			ml_log(" Using Waypoint to get to FollowTarget: ")
				
			ml_log(Player:TeleportToWaypoint(tonumber(e_FollowTargetToMap.targetNearestWaypointID)))
			ml_global_information.Wait(5000)
			return ml_log(true)
		end
	end
	
	-- Use normal navigation to get to the followtarget's map
	if ( e_FollowTargetToMap.targetMapID ) then
		local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position, ml_global_information.CurrentMapID, e_FollowTargetToMap.targetMapID )
		
		if (ValidTable(pos)) then		
			d("Moving to Map: "..gw2_datamanager.GetMapName( e_FollowTargetToMap.targetMapID ))
			local newTask = gw2_task_navtomap.Create()
			newTask.targetMapID = e_FollowTargetToMap.targetMapID
			newTask.name = "Moving to Map: "..gw2_datamanager.GetMapName( e_FollowTargetToMap.targetMapID )
			ml_task_hub:CurrentTask():AddSubTask(newTask)
							
		else
			ml_error("Cannot Navigate to the Map of our FollowTarget, MapID: "..tostring(e_FollowTargetToMap.targetMapID))
		end	
	end
	
end

-- Makes sure that we stay near the FollowTarget/Leader
c_FollowTarget = inheritsFrom( ml_cause )
e_FollowTarget = inheritsFrom( ml_effect )
c_FollowTarget.randomDist = math.random(150,650)
c_FollowTarget.movingtoleader = false
c_FollowTarget.followTarget = nil
c_FollowTarget.followTargetPos = nil
c_FollowTarget.followTargetDistance = nil
function c_FollowTarget:evaluate()
		
	-- Get the data
	c_FollowTarget.followTarget = nil
	c_FollowTarget.followTargetPos = nil	
	c_FollowTarget.followTargetDistance = nil
	
	if ( gFollowTargetID ~= nil and gFollowTargetID ~= 0 and gFollowTargetID ~= "") then
		c_FollowTarget.followTarget = CharacterList:Get(gFollowTargetID)
	end
	
	if ( not ValidTable(c_FollowTarget.followTarget) ) then
		-- Use multibotserver data to update the followtarget position
		if ( gw2_multibot_manager.multiBotIsConnected ) then		
			if ( Player:GetRole() == 0 ) then -- Use ofcourse only when we are not leader and when we are in the same map
				if ( gw2_multibot_manager.leaderPosition ~= nil and TableSize(gw2_multibot_manager.leaderPosition) == 3 ) then
					c_FollowTarget.followTargetPos = gw2_multibot_manager.leaderPosition
					c_FollowTarget.followTargetDistance = Distance3D( ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, ml_global_information.Player_Position.z, followTargetPos.x, followTargetPos.y, followTargetPos.z)
				end
			end	
		end
	
	else
		-- we have a valid character, use its position
		c_FollowTarget.followTargetPos = c_FollowTarget.followTarget.pos
		c_FollowTarget.followTargetDistance = c_FollowTarget.followTarget.distance
	end
	
	
	if ( c_FollowTarget.followTargetDistance and c_FollowTarget.followTargetPos ) then 
		
		-- Use navmesh to follow Target
		if ( ml_global_information.Player_OnMesh ) then 

			-- extend the range threshold when to follow our target while we are fighting
			if ( ml_global_information.Player_InCombat and Player:GetTarget() ~= nil ) then
				if ( c_FollowTarget.followTargetDistance > c_FollowTarget.randomDist + 1000 ) then							
					return true
				end
			else
				if ( c_FollowTarget.followTargetDistance > c_FollowTarget.randomDist ) then							
					return true					
				end					
			end
			
			-- not sure if this is still needed...
			--if ( TableSize(gw2_task_follow.targetPath) > 0 ) then				
				--return true
			--end
		
		-- Use recorded path to follow target, stick closer with this one 
		else
			if (TableSize(gw2_task_follow.targetPath) > 0 ) then
			
				if ( TableSize(c_FollowTarget.followTarget)>0 ) then				
					local mstate = c_FollowTarget.followTarget.movementstate
					local dist = Distance3D( ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, ml_global_information.Player_Position.z, c_FollowTarget.followTargetPos.x, c_FollowTarget.followTargetPos.y, c_FollowTarget.followTargetPos.z)
					if ( dist > 400 or (mstate == GW2.MOVEMENTSTATE.GroundMoving or mstate == GW2.MOVEMENTSTATE.BelowWaterMoving or mstate == GW2.MOVEMENTSTATE.AboveWaterMoving and dist > 250 )) then -- when char is moving
						return true
					end
				else
					-- sticktly stick to the followTarget position, in this weird case of not having the followtarget in the charlist but a recorded path still needs to be walked
					return true					
				end
			end
		end
	
	else
	
		-- check if the followtarget just left the local map and follow him if so
		if ( TableSize(gw2_task_follow.lastFollowTargetPos) > 0 and TableSize(gw2_task_follow.targetPath) > 0 and Distance3D( gw2_task_follow.lastFollowTargetPos.x, gw2_task_follow.lastFollowTargetPos.y, gw2_task_follow.lastFollowTargetPos.z, gw2_task_follow.targetPath[1].pos.x, gw2_task_follow.targetPath[1].pos.y, gw2_task_follow.targetPath[1].pos.z) < 1000 ) then
			ml_log("FollowTarget not nearby anymore ?")
			return true
		
		else
			ml_log("FollowTarget cannot be found/followed!")		
		end		
	end
		
	-- check if we reached our target / no conditions were met
	if ( c_FollowTarget.movingtoleader == true ) then
		if ( ml_global_information.Player_IsMoving ) then
			return true
		
		else
			c_FollowTarget.movingtoleader = false
			Player:StopMovement()
		end
	end	
	
	c_FollowTarget.followTarget = nil
	c_FollowTarget.followTargetPos = nil	
	c_FollowTarget.followTargetDistance = nil
	return false
end

e_FollowTarget.rndStopDist = math.random(155,450)
function e_FollowTarget:execute()
	
	if ( c_FollowTarget.followTargetDistance and c_FollowTarget.followTargetPos ) then 
		
		-- Follow on the navmesh
		if ( ml_global_information.Player_OnMesh ) then 
			ml_log("Following Target (onmesh)->")

			-- Follow our chosen Target
			if ( TableSize(c_FollowTarget.followTarget)>0 and c_FollowTarget.followTarget.onmesh == true ) then	
							
				if ( not gw2_unstuck.HandleStuck() ) then
						
					if ( ValidTable(NavigationManager:GetPath(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,c_FollowTarget.followTargetPos.x,c_FollowTarget.followTargetPos.y,c_FollowTarget.followTargetPos.z))) then
						local navResult = tostring(Player:MoveTo(c_FollowTarget.followTargetPos.x,c_FollowTarget.followTargetPos.y,c_FollowTarget.followTargetPos.z,c_FollowTarget.randomDist,false,false,true))
						if (tonumber(navResult) < 0) then					
							d("e_FollowTarget result: "..tonumber(navResult))
							c_FollowTarget.movingtoleader = false
							Player:StopMovement()
						else
							c_FollowTarget.movingtoleader = true
						end
					end
					
					-- add this targetpoint on mesh as our first node in the navpath in case the target leaves the navmesh
					--local mstate = target.movementstate
					--gw2_task_follow.targetPath = {}
					--table.insert(gw2_task_follow.targetPath, { pos = { x=c_FollowTarget.followTargetPos.x, y=c_FollowTarget.followTargetPos.y, z=c_FollowTarget.followTargetPos.z } , flag = mstate })
						
				end							
				return ml_log(true)
			
			
			else
				-- followtarget not in charlist or on the mesh, follow along recorded targetPath / last pos
				if ( TableSize(gw2_task_follow.lastFollowTargetPos) > 0 and TableSize(gw2_task_follow.targetPath) > 0 and Distance3D( gw2_task_follow.lastFollowTargetPos.x, gw2_task_follow.lastFollowTargetPos.y, gw2_task_follow.lastFollowTargetPos.z, gw2_task_follow.targetPath[1].pos.x, gw2_task_follow.targetPath[1].pos.y, gw2_task_follow.targetPath[1].pos.z) <= 1000 ) then
					e_FollowTarget.rndStopDist = 35					
					if ( TableSize(gw2_task_follow.targetPath) == 1 ) then -- replace the last point 
						d("Moving to last known FollowTarget position..")
						gw2_task_follow.targetPath[1].pos = gw2_task_follow.lastFollowTargetPos
						gw2_task_follow.lastFollowTargetPos = {}
					
					else -- add the last known position to our current path
						table.insert(gw2_task_follow.targetPath, { pos = { x=gw2_task_follow.lastFollowTargetPos.x, y=gw2_task_follow.lastFollowTargetPos.y, z=gw2_task_follow.lastFollowTargetPos.z } , flag = GW2.MOVEMENTSTATE.GroundMoving })
						gw2_task_follow.lastFollowTargetPos = {}
					end
				end
				ml_log("FollowTarget Not In CharacterList")				
			end
		end	
	end
	
	-- Handle movement offside the mesh
	ml_log("Following Target (offmesh)->")
	if ( TableSize(gw2_task_follow.targetPath) > 0 ) then
		local node = gw2_task_follow.targetPath[1]
		local pPos = ml_global_information.Player_Position
		local jump = false
		local dist = Distance3D( pPos.x, pPos.y, pPos.z, node.pos.x, node.pos.y, node.pos.z)
		-- followtarget was jumping/falling try 2d dist
		if ( node.flag == GW2.MOVEMENTSTATE.Falling or node.flag == GW2.MOVEMENTSTATE.Jumping) then
			dist = Distance2D( pPos.x, pPos.y, node.pos.x, node.pos.y)
		end
		
		-- Next node reached check
		if ( TableSize(gw2_task_follow.targetPath) == 1 ) then
			if ( dist < e_FollowTarget.rndStopDist ) then
				if ( node.flag == GW2.MOVEMENTSTATE.Falling or node.flag == GW2.MOVEMENTSTATE.Jumping) then jump = true end
				table.remove(gw2_task_follow.targetPath,1)
			end
		
		else
			if ( dist < 75 ) then
				if ( node.flag == GW2.MOVEMENTSTATE.Falling or node.flag == GW2.MOVEMENTSTATE.Jumping) then jump = true end
				table.remove(gw2_task_follow.targetPath,1)
			end
		end
		
		-- Check for next node & goto or stop
		if ( TableSize(gw2_task_follow.targetPath) > 0 ) then
			node = gw2_task_follow.targetPath[1]
			Player:SetFacing(node.pos.x, node.pos.y, node.pos.z)
			if ( Player:CanMove() and ml_global_information.Player_IsMoving == false ) then
				Player:SetMovement(0)
				c_FollowTarget.movingtoleader = true
			end
			if ( jump ) then Player:Jump() end
			
			if ( ml_global_information.Player_IsMoving == true ) then
				gw2_unstuck.HandleStuck("follow")
			end
				
			ml_log("Moving to next followpathnode")
		
		else
			c_FollowTarget.movingtoleader = false
			Player:StopMovement()
			c_FollowTarget.randomDist = math.random(100,650)
			e_FollowTarget.rndStopDist = math.random(75,400)
		end
	end
	return ml_log(false)
end

