-- Navigate to other maps
gw2_task_navtomap = inheritsFrom(ml_task)
gw2_task_navtomap.name = "MoveToMap"
gw2_task_navtomap.maps = {}

function gw2_task_navtomap.Create()
	local newinst = inheritsFrom(gw2_task_navtomap)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
	newinst.targetMapID = 0
	newinst.lastMapID = 0
	newinst.gateReached = false
	
	
	
    return newinst
end

function gw2_task_navtomap:Process()
	ml_log("task_navtomap: ")
	if ( ml_task_hub:CurrentTask().targetMapID ~= 0 ) then
		
		if ( ml_task_hub:CurrentTask().targetMapID ~= ml_global_information.CurrentMapID ) then
			local nodedata = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position, ml_global_information.CurrentMapID, ml_task_hub:CurrentTask().targetMapID	)
			if (ValidTable(nodedata)) then
				
				if ( ml_global_information.CurrentMapID ~= ml_task_hub:CurrentTask().lastMapID ) then
					ml_task_hub:CurrentTask().lastMapID = ml_global_information.CurrentMapID
					ml_task_hub:CurrentTask().gateReached = false
				end
				
				local dist = Distance3D(nodedata.x,nodedata.y,nodedata.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)
				if ( dist > 50 and not ml_task_hub:CurrentTask().gateReached ) then					
					local newTask = gw2_task_moveto.Create()
					newTask.targetPos = nodedata
					ml_task_hub:CurrentTask():AddSubTask(newTask)
					
				else
				
					ml_log("Transition reached")
					ml_task_hub:CurrentTask().gateReached = true
					
					-- Get navpoint and handle by type Interact / walk straight through after facing
					if ( nodedata.type ~= nil ) then
						if ( nodedata.type == "Interact" ) then
							if ( ValidTable(Player:GetInteractableTarget())) then
								Player:StopMovement()
								Player:Interact()
								ml_global_information.Wait(2000)
								ml_log("Interacting with Portal/Gate/Door")
								
							else
								ml_log("Moving towards Portal/Gate/Door for interaction")
								Player:SetFacingH(nodedata.hx,nodedata.hy,nodedata.hz)
								Player:SetMovement(GW2.MOVEMENTTYPE.Forward)
							end							
						else
							if ( not Player:IsMoving() ) then
								Player:SetFacingH(nodedata.hx,nodedata.hy,nodedata.hz)
								Player:SetMovement(GW2.MOVEMENTTYPE.Forward)
							else
								ml_log("Moving through Portal/Gate/Door")
							end
						end
					else
						ml_error("gw2_task_navtomap:Process: nodedata.type is nil")
					end					
				end			
			else			
				ml_error("gw2_task_navtomap: Cannot find a path to the targetmap!, aborting task")
				ml_task_hub:CurrentTask().completed = true
			end
			
		else
			ml_log("TargetMap Reached")
			Player:StopMovement()
			ml_task_hub:CurrentTask().completed = true			
		end
	else
	
		-- Get the currently selected targetMap and update our current task with that
		if ( gNavToMap ~= nil and gNavToMap ~= "" and ValidTable(gw2_task_navtomap.maps) ) then
			local id = 0
			for mid,name in pairs(gw2_task_navtomap.maps) do			
				if ( name == gNavToMap ) then
					id=mid
					break
				end
			end
			if ( id == ml_global_information.CurrentMapID ) then
				ml_log("TargetMap Reached")
				Player:StopMovement()
				ml_task_hub:CurrentTask().completed = true
			end
			if ( id ~= 0 ) then			
				d("Setting new path FROM "..gw2_datamanager.GetMapName( ml_global_information.CurrentMapID ).. " TO "..gNavToMap)
				local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position, ml_global_information.CurrentMapID, id	)
				if (ValidTable(pos)) then					
					ml_task_hub:CurrentTask().targetMapID = id				

				else
					ml_error("Cannot find a Path to MapID "..tostring(id).." - "..gw2_datamanager.GetMapName( tonumber(id) ))				
				end
			end
		else
			ml_log("Select a valid TargetMap")
		end
	end
end

function gw2_task_navtomap:UIInit()
	d("gw2_task_navtomap:UIInit")	
	local mw = WindowManager:GetWindow(gw2minion.MainWindow.Name)
	if ( mw ) then		
		mw:NewComboBox("Target Map","gNavToMap","MoveToMap","")
	
		local mapIDs = ""
		gw2_task_navtomap.maps = {}		
		if ( ValidTable(ml_mesh_mgr.navData) ) then
			local i,entry = next ( ml_mesh_mgr.navData )
			while i and entry do
				local mname = gw2_datamanager.GetMapName( i )								
					mname = mname:gsub('%W','') -- only alphanumeric
				if ( mname ~= nil and mname ~= "" and mname ~= "Unknown" ) then
					
					gw2_task_navtomap.maps[i] = mname
					mapIDs = mapIDs..","..mname
				else
					gw2_task_navtomap.maps[i] = i
					mapIDs = mapIDs..","..i
				end
				i,entry = next ( ml_mesh_mgr.navData,i)
			end
		end
		gNavToMap_listitems = mapIDs
		
		mw:UnFold( "MoveToMap" );
	end
	return true
end
function gw2_task_navtomap:UIDestroy()
	GUI_DeleteGroup(gw2minion.MainWindow.Name, "MoveToMap")
	d("gw2_task_navtomap:UIDestroy")
end

function gw2_task_navtomap.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "gNavToMap" ) then
			if ( gNavToMap ~= nil and gNavToMap ~= "" and ValidTable(gw2_task_navtomap.maps) ) then
				local id = 0
				for mid,name in pairs(gw2_task_navtomap.maps) do			
					if ( name == gNavToMap ) then
						id=mid
						break
					end
				end
				if ( id ~= 0 ) then			
					d("Setting new path FROM "..gw2_datamanager.GetMapName( ml_global_information.CurrentMapID ).. " TO "..gNavToMap)
					local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position, ml_global_information.CurrentMapID, id	)
					if (ValidTable(pos)) then
						
						ml_task_hub:ClearQueues()
						local task = ml_global_information.BotModes[gw2_task_navtomap.name]
						if (task ~= nil) then
							task.Create()
							task.targetMapID = id				
							ml_task_hub:Add(task, LONG_TERM_GOAL, TP_ASAP)
						end
					else
						ml_error("Cannot find a Path to Map ID "..tostring(id).." - "..gw2_datamanager.GetMapName( tonumber(id) ))				
					end
				end
			end
		end
	end
end
RegisterEventHandler("GUI.Update",gw2_task_navtomap.GUIVarUpdate)
ml_global_information.AddBotMode(gw2_task_navtomap.name, gw2_task_navtomap)