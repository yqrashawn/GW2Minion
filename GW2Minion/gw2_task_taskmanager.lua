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
	
	newinst.mytask = nil
	
    return newinst
end

function gw2_task_taskmanager:Init()
	-- CheckTask - makes sure we have a active task, controls subtask conditions too
	self:add(ml_element:create( "CheckTask", c_CheckTask, e_CheckTask, 500 ), self.overwatch_elements)
	
	-- RunTasks - executes/runs the active task
	self:add(ml_element:create( "RunTask", c_RunTask, e_RunTask, 250 ), self.process_elements)
	
	self:AddTaskCheckCEs()
end
c_CheckTask = inheritsFrom( ml_cause )
e_CheckTask = inheritsFrom( ml_effect )
function c_CheckTask:evaluate()
	
	ml_task_hub:CurrentTask().mytask = ml_task_mgr.GetCurrentTask()
		
	--d("No current active task or current task doesnt meet the run-conditions anymore, getting the next task")
	if ( not ml_task_hub:CurrentTask().mytask ) then	
		return true
	else
		if ( ml_global_information.ShowDebug ) then 
			dbTMTask = ml_task_hub:CurrentTask().mytask.name
			if ( ml_task_hub:CurrentTask().mytask.started ) then				
				dbTMDuration = tostring(math.floor((ml_global_information.Now - ml_task_hub:ThisTask().mytask.startTimer)/1000)).."s/"..tostring(ml_task_hub:ThisTask().mytask.maxduration).."s"
			else
				dbTMDuration = "0s/"..tostring(ml_task_hub:ThisTask().mytask.maxduration)
			end
		end
	end
	return false	
end
function e_CheckTask:execute()	
	ml_task_hub:CurrentTask().mytask = ml_task_mgr.GetNextTask()
	
	if ( not ml_task_hub:CurrentTask().mytask ) then 
		d("TaskManager has no startable task left")
		ml_global_information.Stop()
		ml_global_information.Wait(5000)
	end
end

c_RunTask = inheritsFrom( ml_cause )
e_RunTask = inheritsFrom( ml_effect )
function c_RunTask:evaluate()
	
	if ( ml_task_hub:CurrentTask().mytask ~= nil ) then				
		return true	
	end
	return false
		
end
function e_RunTask:execute()

	-- New task, move to starting position first
	if ( not ml_task_hub:CurrentTask().mytask.started ) then
		if ( ml_task_hub:CurrentTask().mytask.mapid ~= ml_global_information.CurrentMapID ) then
			
			local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position, ml_global_information.CurrentMapID, ml_task_hub:CurrentTask().mytask.mapid )
			
			if (ValidTable(pos)) then
				local newTask = gw2_task_navtomap.Create()
				newTask.targetMapID = ml_task_hub:CurrentTask().mytask.mapid
				newTask.name = "MoveTo Task "..ml_task_hub:CurrentTask().mytask.name.." StartMap"
				ml_task_hub:CurrentTask():AddSubTask(newTask)
								
			else
				ml_error("Cannot reach StartMap of Task, disabling Task : "..ml_task_hub:CurrentTask().mytask.name)
				ml_task_mgr.SetTaskDisabled(ml_task_hub:CurrentTask().mytask)
				
			end
			
		else
							
			local startPos = {}
			for pos in StringSplit(ml_task_hub:CurrentTask().mytask.mappos,"/") do
				table.insert(startPos,pos)
			end
			
			local dist = Distance3D(startPos[1],startPos[2],startPos[3],ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)
			d("Distance to TaskStartPosition : "..tostring(dist))
			if ( dist > 50 ) then
				local newTask = gw2_task_moveto.Create()
				newTask.name = "MoveTo Task "..ml_task_hub:CurrentTask().mytask.name.." StartPosition"
				newTask.targetPos = { x=tonumber(startPos[1]), y=tonumber(startPos[2]), z=tonumber(startPos[3]) }
				ml_task_hub:CurrentTask():AddSubTask(newTask)
				
			else
				d("Task Startposition reached, starting task...")
				ml_task_mgr.SetActiveTaskStarted()
			end
			
		end
		
	else
		-- Do task
		ml_task_hub:CurrentTask():AddSubTask(ml_task_hub:CurrentTask().mytask)

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
	
	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("Active Task","dbTMTask","Task_Manager")
		dw:NewField("Duration","dbTMDuration","Task_Manager")		
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