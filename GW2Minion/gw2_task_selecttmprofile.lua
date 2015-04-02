-- Task Template (TM Ready), read the comments.
gw2_task_selecttmprofile = inheritsFrom(ml_task) -- replace "gw2_task_selecttmprofile" with your name.
gw2_task_selecttmprofile.name = "Switch TaskManager profile" -- your tasks name here.

function gw2_task_selecttmprofile.Create()
	local newinst = inheritsFrom(gw2_task_selecttmprofile)
	
	--ml_task members
	newinst.valid = true
	newinst.completed = false
	newinst.subtask = nil
	newinst.process_elements = {}
	newinst.overwatch_elements = {}
	return newinst
end

function gw2_task_selecttmprofile:Process()
	ml_log("gw2_task_selecttmprofile: ")
	if (ml_task_hub:CurrentTask().newTaskName == "None") then
		ml_log("No profile selected, please select a profile.")
	else
		ml_task_mgr.profile = ml_task_mgr.InitProfile(ml_task_hub:CurrentTask().newTaskName)
		ml_task_mgr.UpdateMainWindow()
		gTMCurrentProfileName = ml_task_hub:CurrentTask().newTaskName
		ml_task_mgr.currenttask = nil
		ml_task_mgr.UpdateEditWindow()
		Settings.GW2Minion.gCurrentTaskProfile = ml_task_hub:CurrentTask().newTaskName
	end
	ml_task_hub:CurrentTask().completed = true
end

function gw2_task_selecttmprofile:UIInit()
	return true
end
function gw2_task_selecttmprofile:UIDestroy()
	return true
end

function gw2_task_selecttmprofile.ModuleInit()
	d("gw2_task_selecttmprofile:ModuleInit")
	ml_task_mgr.AddTaskType("Switch TM Profile", gw2_task_selecttmprofile) -- Allow this task to be selectable in TaskManager
end

-- TaskManager functions
function gw2_task_selecttmprofile:UIInit_TM()
	ml_task_mgr.NewCombobox("profile:", "newTaskName", ml_task_mgr.GetProfileList(), "None")
end
-- TaskManager function: Checks for custom conditions to start this task
function gw2_task_selecttmprofile.CanTaskStart_TM()
	return true
end
-- TaskManager function: Checks for custom conditions to keep this task running
function gw2_task_selecttmprofile.CanTaskRun_TM()
	-- ml_task_hub:CurrentTask() -> use to acces task members.
	return true
end

RegisterEventHandler("Module.Initalize",gw2_task_selecttmprofile.ModuleInit)
