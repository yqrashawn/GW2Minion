-- Navigate to other maps
gw2_task_navtomap = inheritsFrom(ml_task)
gw2_task_navtomap.name = "MoveToMap"

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
    return false
end

function gw2_task_navtomap:Process()
	d("gw2_task_navtomap:Process")
	
end

function gw2_task_navtomap:UIInit()
	d("gw2_task_navtomap:UIInit")	
	local mw = WindowManager:GetWindow(gw2minion.MainWindow.Name)
	if ( mw ) then
		mw:NewComboBox("TargetMapID","gNavToMapID","MoveToMap","")
		mw:NewButton("GotoMap","navtomapGOTO","MoveToMap")
		RegisterEventHandler("navtomapGOTO",gw2_task_navtomap.GotoMap)
	
		local mapIDs = ""
		if ( ValidTable(ml_mesh_mgr.navData) ) then
			local i,entry = next ( ml_mesh_mgr.navData )
			while i and entry do
				mapIDs = mapIDs..","..i
				i,entry = next ( ml_mesh_mgr.navData,i)
			end
		end
		gNavToMapID_listitems = mapIDs
		mw:UnFold( "MoveToMap" );
	end
	return true
end
function gw2_task_navtomap:UIDestroy()
	GUI_DeleteGroup(gw2minion.MainWindow.Name, "MoveToMap")
	d("gw2_task_navtomap:UIDestroy")
end

function gw2_task_navtomap:RegisterDebug()
    d("gw2_task_navtomap:RegisterDebug")
end

function gw2_task_navtomap.ModuleInit()
	d("gw2_task_navtomap:ModuleInit")
	
	d("FROM :"..gw2_datamanager.GetMapName( 50 ).. " TO: "..gw2_datamanager.GetMapName( 28 ))
	local pos = ml_nav_manager.GetNextPathPos(	Player.pos,
												50,
											28	)
	if (ValidTable(pos)) then
		d(pos)
	end
	
end

function gw2_task_navtomap.GotoMap( )
	d("GOTOMAP")
	d("FROM :"..gw2_datamanager.GetMapName( Player.pos ).. " TO: "..gw2_datamanager.GetMapName( tonumber(gNavToMapID) ))
	local pos = ml_nav_manager.GetNextPathPos(	Player.pos,	Player:GetLocalMapID(),	tonumber(gNavToMapID)	)
	if (ValidTable(pos)) then
		d(Player:MoveTo(pos.x,pos.y,pos.z,25,false,false,false))
	end	
	
end


ml_global_information.AddBotMode("MoveToMap", gw2_task_navtomap)
RegisterEventHandler("Module.Initalize",gw2_task_navtomap.ModuleInit)
