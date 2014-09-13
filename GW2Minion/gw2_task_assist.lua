-- Grind
gw2_task_assist = inheritsFrom(ml_task)
gw2_task_assist.name = GetString("assistMode")

function gw2_task_assist.Create()
	local newinst = inheritsFrom(gw2_task_assist)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
    return newinst
end

function gw2_task_assist:Init()
	d("gw2_task_assist:Init")
end

function gw2_task_assist:Process()
	d("gw2_task_assist:Process")
		
end

function gw2_task_assist:UIInit()
	d("gw2_task_assist:UIInit")
	return true
end
function gw2_task_assist:UIDestroy()
	d("gw2_task_assist:UIDestroy")
end

function gw2_task_assist:RegisterDebug()
    d("gw2_task_assist:RegisterDebug")
end

function gw2_task_assist.ModuleInit()
	d("gw2_task_assist:ModuleInit")
	
end


ml_global_information.AddBotMode(GetString("assistMode"), gw2_task_assist)
RegisterEventHandler("Module.Initalize",gw2_task_assist.ModuleInit)