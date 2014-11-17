-- TM Task , to run it in the main loop
gw2_task_taskmanager = inheritsFrom(ml_task)
gw2_task_taskmanager.name = GetString("grindMode")

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
	d("gw2_task_taskmanager:Process")
		
end

function gw2_task_taskmanager:UIInit()
	d("gw2_task_taskmanager:UIInit")
	local mw = WindowManager:GetWindow(gw2minion.MainWindow.Name)
	if ( mw ) then	
		mw:NewButton(GetString("Setup Tasks"),"gw2_task_taskmanager.Toggle",GetString("taskManager"))
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