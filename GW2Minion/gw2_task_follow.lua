-- FollowTarget Task
gw2_task_follow = inheritsFrom(ml_task)
gw2_task_follow.name = GetString("followmode")
gw2_task_follow.targetPath = {}
gw2_task_follow.lastFollowTargetPos = {}

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
	
	self:add(ml_element:create( "UpdateFollowPathData", c_UpdateFollowPathData, e_UpdateFollowPathData, 1000 ), self.process_elements)
	self:add(ml_element:create( "FollowingTarget", c_FollowTarget, e_FollowTarget, 500 ), self.process_elements)
	self:add(ml_element:create( "AttackBestCharacterTarget", c_AttackBestNearbyCharacterTarget, e_AttackBestNearbyCharacterTarget, 400 ), self.process_elements)	
	
	
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
		
		mw:UnFold( GetString("followmode") );
	end
	sMtargetmode = Settings.GW2Minion.sMtargetmode
	sMmode = Settings.GW2Minion.sMmode
	return true
end
function gw2_task_follow:UIDestroy()
	d("gw2_task_follow:UIDestroy")
	GUI_DeleteGroup(gw2minion.MainWindow.Name, GetString("followmode"))
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
	else
		gFollowTargetName = ""
		gFollowTargetID = 0
	end
end



-- C&Es

-- Updates the followpath data
c_UpdateFollowPathData = inheritsFrom( ml_cause )
e_UpdateFollowPathData = inheritsFrom( ml_effect )
function c_UpdateFollowPathData:evaluate()
		if ( gFollowTargetID ~= nil and gFollowTargetID ~= 0 and gFollowTargetID ~= "") then
			local target = CharacterList:Get(gFollowTargetID)
			
			-- try to get followtarget by partyname, this is needed for when we switch zones while following, then the ID changes
			if ( TableSize(target) == 0 and gFollowTargetName ~= nil and gFollowTargetName ~= "") then
				local pMember = gw2_common_functions.GetPartyMemberByName( gFollowTargetName )
				if ( pMember and pMember.id ~= 0) then
					gFollowTargetID = pMember.id
					target = CharacterList:Get(gFollowTargetID)
				end				
			end
			-- try to get followtarget by name
			if ( TableSize(target) == 0 ) then
				local CList = CharacterList("selectable")
				if ( TableSize(CList) > 0 ) then
					local index, player  = next( CList )		
					while ( index ~= nil and player ~= nil ) do
						if (player.name == name) then
							d("ID "..tostring(player.id))
							gFollowTargetID = player.id
							target = player
							break
						end
						index, player  = next( CList,index )
					end	
				end			
			end
			
			if ( TableSize(target)>0 ) then
				local mstate = target.movementstate
				local tpos = target.pos					
				gw2_task_follow.lastFollowTargetPos = tpos
				
				-- UPDATE NAVPATH
				local pSize = TableSize(gw2_task_follow.targetPath)				
				if ( pSize > 0 ) then
					-- Extend existing path
					local pPos = Player.pos
					local dist = Distance3D( tpos.x, tpos.y, tpos.z, gw2_task_follow.targetPath[pSize].pos.x ,gw2_task_follow.targetPath[pSize].pos.y , gw2_task_follow.targetPath[pSize].pos.z)
					if ( dist < 500 and dist > 120 ) then
						table.insert(gw2_task_follow.targetPath, { pos = { x=tpos.x, y=tpos.y, z=tpos.z } , flag = mstate })
					end
					
				else
					-- Start new path
					gw2_task_follow.targetPath = {}
					gw2_task_follow.lastFollowTargetPos = {}
					local pPos = Player.pos
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
					local pPos = Player.pos
										
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
					
					-- shorten path by removing "crossings"										
					if ( TableSize(gw2_task_follow.targetPath) > 2 ) then
						optpath = {}
						local optimized = false
						for i = 1, TableSize(gw2_task_follow.targetPath)-2, 1 do
							for k = i+2, TableSize(gw2_task_follow.targetPath), 1 do
								local dist = Distance3D( gw2_task_follow.targetPath[i].pos.x ,gw2_task_follow.targetPath[i].pos.y , gw2_task_follow.targetPath[i].pos.z, gw2_task_follow.targetPath[k].pos.x ,gw2_task_follow.targetPath[k].pos.y , gw2_task_follow.targetPath[k].pos.z)
								
								if ( dist < 110 ) then
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
				ml_log("Target_To_Follow_Is_not_Nearby!!")				
				if ( TableSize(gw2_task_follow.lastFollowTargetPos) == 0 and not ml_global_information.Player_IsMoving ) then
					gw2_task_follow.targetPath = {}
					gw2_task_follow.lastFollowTargetPos = {}
				end
				
			end
			if ( ml_global_information.ShowDebug ) then 
				gFollowTargetPathSize = TableSize(gw2_task_follow.targetPath)
			end
			
		else
			ml_log("Select a Target to follow!")
		end
end
function e_UpdateFollowPathData:execute()

end


c_FollowTarget = inheritsFrom( ml_cause )
e_FollowTarget = inheritsFrom( ml_effect )
c_FollowTarget.nearleader = false
c_FollowTarget.randomDist = math.random(100,500)
c_FollowTarget.tmr = 0
c_FollowTarget.threshold = 2000
function c_FollowTarget:evaluate()
	
	if ( ml_global_information.Player_OnMesh ) then 
		if ( gw2_task_follow.targetInParty == true ) then
			
			-- TODOOOOO
			ml_error("TODO: Movetoleader cause followmode inparty")
			return c_MoveToLeader:evaluate()
		else
			if ( gFollowTargetID ~= nil and gFollowTargetID ~= 0 and gFollowTargetID ~= "") then
				local target = CharacterList:Get(gFollowTargetID)
				if ( TableSize(target)>0 ) then			
					
					-- extend the range threshold when to follow our target while we are fighting
					if ( ml_global_information.Player_InCombat and Player:GetTarget() ~= nil ) then
						if ( target.distance > c_FollowTarget.randomDist + 1000 ) then							
							return true
						end
					else
						if ( target.distance > c_FollowTarget.randomDist ) then							
							return true					
						end					
					end
					
				else
					if ( TableSize(gw2_task_follow.targetPath) > 0 ) then						
						return true
					end
					ml_log("FollowTarget Not In CharacterList")
				end
			end
		end
	else
		if (TableSize(gw2_task_follow.targetPath) > 0 ) then			
			if ( gFollowTargetID ~= nil and gFollowTargetID ~= 0 and gFollowTargetID ~= "") then
				local target = CharacterList:Get(gFollowTargetID)
				if ( TableSize(target)>0 ) then				
					local mstate = target.movementstate
					local tpos = target.pos
					local pPos = ml_global_information.Player_Position
					local dist = Distance3D( pPos.x, pPos.y, pPos.z, tpos.x, tpos.y, tpos.z)
					if ( dist > 400 or mstate == 3 and dist > 250 ) then
						return true
					end
				else
					if ( TableSize(gw2_task_follow.targetPath) > 0 ) then
						return true
					end
				end
				if ( c_FollowTarget.movingtoleader == true ) then
					c_FollowTarget.movingtoleader = false
					Player:StopMovement()
				end
			end
		end
	end	
	return false
end

e_FollowTarget.rndStopDist = math.random(55,400)
function e_FollowTarget:execute()
	if ( ml_global_information.Player_OnMesh ) then 
		ml_log("Moving On Mesh To FollowTarget,")
		if ( gw2_task_follow.targetInParty == true ) then
			
			return e_MoveToLeader:execute()
		else
			if ( gFollowTargetID ~= nil and gFollowTargetID ~= 0 and gFollowTargetID ~= "") then
				local target = CharacterList:Get(gFollowTargetID)
				if ( TableSize(target)>0 ) then			
					if ( target.onmesh == true and target.distance > c_FollowTarget.randomDist ) then
						local tpos = target.pos
						
						if ( not gw2_unstuck.HandleStuck() ) then
							
							if ( ValidTable(NavigationManager:GetPath(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,tpos.x,tpos.y,tpos.z))) then
								local navResult = tostring(Player:MoveTo(tpos.x,tpos.y,tpos.z,c_FollowTarget.randomDist,false,false,true))
								if (tonumber(navResult) < 0) then					
									d("e_FollowTarget result: "..tonumber(navResult))					
								end
							end
							-- add this targetpoint on mesh as our first node in the navpath in case the target leaves the navmesh
							local mstate = target.movementstate
							gw2_task_follow.targetPath = {}
							table.insert(gw2_task_follow.targetPath, { pos = { x=tpos.x, y=tpos.y, z=tpos.z } , flag = mstate })
							
							-- TODO:
							--[[if ( mc_global.now - c_FollowTarget.tmr > c_FollowTarget.threshold ) then
								c_FollowTarget.tmr = mc_global.now
								c_FollowTarget.threshold = math.random(1000,2000)
								mc_skillmanager.HealMe()
							end]]
						end
						
						return ml_log(true)
					end				
				else
					if ( TableSize(gw2_task_follow.lastFollowTargetPos) > 0 and TableSize(gw2_task_follow.targetPath) > 0 and Distance3D( gw2_task_follow.lastFollowTargetPos.x, gw2_task_follow.lastFollowTargetPos.y, gw2_task_follow.lastFollowTargetPos.z, gw2_task_follow.targetPath[1].pos.x, gw2_task_follow.targetPath[1].pos.y, gw2_task_follow.targetPath[1].pos.z) < 1000 ) then
						e_FollowTarget.rndStopDist = 35
						if ( TableSize(gw2_task_follow.targetPath) == 1 ) then
							d("Moving to last known FollowTarget position..")
							gw2_task_follow.targetPath[1].pos = gw2_task_follow.lastFollowTargetPos
							gw2_task_follow.lastFollowTargetPos = {}
						end
					end
					ml_log("FollowTarget Not In CharacterList")
				end
			end
		end		
	end
	
	
	--- handles movement offside the mesh	
		ml_log("Moving Without Mesh To FollowTarget")
		if ( TableSize(gw2_task_follow.targetPath) > 0 ) then
			local node = gw2_task_follow.targetPath[1]
			local pPos = ml_global_information.Player_Position
			local jump = false
			local dist = Distance3D( pPos.x, pPos.y, pPos.z, node.pos.x, node.pos.y, node.pos.z)
			-- followtarget was jumping/falling try 2d dist
			if ( node.flag == 5 or node.flag == 4) then
				dist = Distance2D( pPos.x, pPos.y, node.pos.x, node.pos.y)
			end
			
			-- last point
			if ( TableSize(gw2_task_follow.targetPath) == 1 ) then
				if ( dist < e_FollowTarget.rndStopDist ) then
					if ( node.flag == 5 or node.flag == 4) then jump = true end
					table.remove(gw2_task_follow.targetPath,1)
				end
			else
				if ( dist < 55 ) then
					if ( node.flag == 5 or node.flag == 4) then jump = true end
					table.remove(gw2_task_follow.targetPath,1)
				end
			end
			
			if ( TableSize(gw2_task_follow.targetPath) > 0 ) then
				node = gw2_task_follow.targetPath[1]
				Player:SetFacing(node.pos.x, node.pos.y, node.pos.z)
				if ( Player:CanMove() and ml_global_information.Player_IsMoving == false ) then
					Player:SetMovement(0)
					c_FollowTarget.movingtoleader = true
				end
				if ( jump ) then Player:Jump() end
				
				if ( ml_global_information.Player_IsMoving ) then
					gw2_unstuck.HandleStuck("follow")
				end
				-- TODOOOOO				
				--[[if ( mc_global.now - c_FollowTarget.tmr > c_FollowTarget.threshold ) then
					c_FollowTarget.tmr = mc_global.now
					c_FollowTarget.threshold = math.random(1000,2000)
					mc_skillmanager.HealMe()
				end	]]
				
				ml_log("Moving to next followpathnode")
			else
				c_FollowTarget.movingtoleader = false
				Player:StopMovement()
				c_FollowTarget.randomDist = math.random(100,500)
				e_FollowTarget.rndStopDist = math.random(55,400)
			end
		end
	return ml_log(false)
end

