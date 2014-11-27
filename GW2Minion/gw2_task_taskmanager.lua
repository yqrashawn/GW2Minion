-- TM Task , to run it in the main loop
gw2_task_taskmanager = inheritsFrom(ml_task)
gw2_task_taskmanager.name = GetString("customTasks")

function gw2_task_taskmanager.Create()
	local newinst = inheritsFrom(gw2_task_taskmanager)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
    return newinst
end

function gw2_task_taskmanager:Init()
	d("gw2_task_taskmanager:Init")
end

function gw2_task_taskmanager:Process()
	
	local mytask = ml_task_mgr.GetCurrentTask()
	
	
	if ( not mytask ) then
d("No current active task or current task doesnt meet the run-conditions anymore, getting the next task")
		mytask = ml_task_mgr.GetNextTask()		
	end
	
	if ( not mytask ) then 
		d("TaskManager has no startable task left")
		ml_global_information.Stop()
		ml_global_information.Wait(5000)
	else
		
		-- New task, move to starting position first
		if ( not mytask.started ) then
			if ( mytask.mapid ~= ml_global_information.CurrentMapID ) then
				d("MYMAPID: "..tostring(mytask.mapid))
				local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position, ml_global_information.CurrentMapID, mytask.mapid )
				
				if (ValidTable(pos)) then
					local newTask = gw2_task_navtomap.Create()
					newTask.targetMapID = mytask.mapid
					newTask.name = "MoveTo Task StartMap"
					ml_task_hub:CurrentTask():AddSubTask(newTask)
									
				else
					ml_error("Cannot reach StartMap of Task, disabling Task : "..mytask.name)
					ml_task_mgr.SetTaskDisabled(mytask)
					
				end
				
			else
								
				local startPos = {}
				for pos in StringSplit(mytask.mappos,"/") do
					table.insert(startPos,pos)
				end
				
				local dist = Distance3D(startPos[1],startPos[2],startPos[3],ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)
				d("Distance to TaskStartPosition : "..tostring(dist))
				if ( dist > 50 ) then
					local newTask = gw2_task_moveto.Create()
					newTask.name = "MoveTo Task StartPosition"
					newTask.targetPos = { x=tonumber(startPos[1]), y=tonumber(startPos[2]), z=tonumber(startPos[3]) }
					ml_task_hub:CurrentTask():AddSubTask(newTask)
					
				else
					d("Task Startposition reached, starting task...")
					ml_task_mgr.SetActiveTaskStarted()
				end
				
			end
			
		else
		-- Do task
			ml_log( mytask.name.."("..tostring(math.floor((ml_global_information.Now - mytask.startTimer)/1000)).."s/"..tostring(mytask.maxduration).."s)")
			
			
		end
	
	end
		
end

function gw2_task_taskmanager:UIInit()
	d("gw2_task_taskmanager:UIInit")
	local mw = WindowManager:GetWindow(gw2minion.MainWindow.Name)
	if ( mw ) then	
		mw:NewButton(GetString("taskSetupTasks"),"gw2_task_taskmanager.Toggle",GetString("taskManager"))
		RegisterEventHandler("gw2_task_taskmanager.Toggle", ml_task_mgr.ToggleMenu)
		mw:UnFold(GetString("taskManager"))
	end	
	return true
end
function gw2_task_taskmanager:UIDestroy()
	d("gw2_task_taskmanager:UIDestroy")
	GUI_DeleteGroup(gw2minion.MainWindow.Name, GetString("taskManager"))	
end

function gw2_task_taskmanager.ModuleInit()
	d("gw2_task_taskmanager:ModuleInit")		
end

ml_global_information.AddBotMode(GetString("customTasks"), gw2_task_taskmanager)
RegisterEventHandler("Module.Initalize",gw2_task_taskmanager.ModuleInit)