-- Grind
gw2_task_grind = inheritsFrom(ml_task)
gw2_task_grind.name = GetString("grindMode")

function gw2_task_grind.Create()
	local newinst = inheritsFrom(gw2_task_grind)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
    return newinst
end

function gw2_task_grind:Init()
	d("gw2_task_grind:Init")
end

function gw2_task_grind:Process()
	d("gw2_task_grind:Process")
		
end

function gw2_task_grind:UIInit()
	d("gw2_task_grind:UIInit")
	return true
end
function gw2_task_grind:UIDestroy()
	d("gw2_task_grind:UIDestroy")
end

function gw2_task_grind:RegisterDebug()
    d("gw2_task_grind:RegisterDebug")
end

function gw2_task_grind.ModuleInit()
	d("gw2_task_grind:ModuleInit")
	
end

ml_global_information.AddBotMode(GetString("grindMode"), gw2_task_grind)
RegisterEventHandler("Module.Initalize",gw2_task_grind.ModuleInit)
