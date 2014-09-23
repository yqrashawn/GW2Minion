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
	
    return newinst
end

function gw2_task_navtomap:Init()
	d("gw2_task_navtomap:Init")
	
	--self:add(ml_element:create( "MultiBotCheck", c_MultiBotCheck, e_MultiBotCheck, 500 ), self.process_elements)
		
	--self:AddTaskCheckCEs()	
end
function gw2_task_navtomap:task_complete_eval()
    return this.taretMapID == 0
end

function gw2_task_navtomap:Process()
	d("gw2_task_navtomap:Process")
	
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

function gw2minion.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "gNavToMap" ) then
			if ( gNavToMap ~= nil and ValidTable(gw2_task_navtomap.maps) ) then
				local id = 0
				for mid,name in pairs(gw2_task_navtomap.maps) do			
					if ( name == gNavToMap ) then
						id=mid
						break
					end
				end
				if ( id ~= 0 ) then			
					d("Setting new path FROM :"..gw2_datamanager.GetMapName( ml_global_information.CurrentMapID ).. " TO: "..gNavToMap)
					local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position, ml_global_information.CurrentMapID, id	)
					if (ValidTable(pos)) then
						ml_task_hub:ClearQueues()
						local task = ml_global_information.BotModes[gw2_task_navtomap.name]
						if (task ~= nil) then
							task.targetMapID = id
							ml_task_hub:Add(task.Create(), LONG_TERM_GOAL, TP_ASAP)
						end
					else
						ml_error("Cannot find a Path to MapID "..tostring(id).." - "..gw2_datamanager.GetMapName( tonumber(id) ))				
					end
				end
			end
		end
	end
end
RegisterEventHandler("GUI.Update",gw2minion.GUIVarUpdate)
ml_global_information.AddBotMode(gw2_task_navtomap.name, gw2_task_navtomap)
