-- API:
-- ml_task_mgr.AddTaskType( botmodename, task )  : to add a task to the dropdown "type" box
-- Each task which needs custom variables, add (example):
-- function gw2_task_grind:UIInit_TM()
-- Which creates taskCustomConditions elements:
-- 	ml_task_mgr.NewField("testfield", "beer")
--	ml_task_mgr.NewNumeric("testnum", "vodka")
--	ml_task_mgr.NewCombobox("testcbox", "whiskey", "A,B,C")
-- On creation of the task, these custom variables "beer" will be set in the newinstance of the task, example newinstance.beer / gw2_task_grind.beer


ml_task_mgr = {}
ml_task_mgr.mainWindow = {name = GetString("taskManager"), x = 350, y = 50, w = 250, h = 350}
ml_task_mgr.editWindow = {name = GetString("taskEditor"), x = 600, y = 50, w = 250, h = 550}
ml_task_mgr.profile = nil
ml_task_mgr.currentTask = nil
ml_task_mgr.path = GetAddonPath() .. [[GW2Minion\TaskManagerProfiles\]]
ml_task_mgr.taskTypes = {}

-- For Handling Tasks
ml_task_mgr.taskHistory = {}
ml_task_mgr.activeTask = nil
ml_task_mgr.nextTaskPriority = nil

function ml_task_mgr.ModuleInit()
	-- Set Default Profile
	if (Settings.GW2Minion.gCurrentTaskProfile == nil) then
		Settings.GW2Minion.gCurrentTaskProfile = "None"
	end
	ml_task_mgr.profile = ml_task_mgr.InitProfile(Settings.GW2Minion.gCurrentTaskProfile)
end

-- Task object for TM 
ml_UITask = {}
function ml_UITask.Create()
	local newinst = inheritsFrom( ml_UITask )
	newinst.id = nil
	newinst.priority = nil
	newinst.type = GetString("grindMode")
	newinst.pretaskid = nil
	newinst.name = ""
	newinst.enabled = "1"
	newinst.complete = false
	newinst.mapid = ""	--startmapid
	newinst.mappos = "" --startmappos
	newinst.radius = 0  --the radius around the startposition of where the bot should not walk beyond
	newinst.minlvl = 0
	newinst.maxlvl = 80
	newinst.minduration = 0
	newinst.maxduration = 0	
	newinst.cooldown = 0	
	newinst.partysize = 0	
	newinst.customVars = {}
    return newinst
end

-- Profile object for TM
ml_UITaskProfile = {
	name = "None",
	idcounter = 0,
	version = 1,
	currentTaskID = nil,
	tasks = {}
}
function ml_UITaskProfile:InsertTask( task )
	if (task and task.priority) then		
		table.insert(self.tasks, task.priority, task)
		self:UpdateTaskPriority()
	end
end
function ml_UITaskProfile:EditTask( task )
	d("TODO:EDIT TASK DIALOG")
end
function ml_UITaskProfile:UpdateTaskPriority()
	for priority=1,TableSize(self.tasks) do
		self.tasks[priority].priority = priority
	end
end
function ml_UITaskProfile:Save()	
	local saveFile = {
		name = self.name,
		idcounter = self.idcounter,
		version = self.version,
		currentTaskID = self.currentTaskID,
		tasks = {}
	}
	for priority=1,TableSize(self.tasks) do		
		saveFile.tasks[priority] = self.tasks[priority]
	end
	persistence.store(ml_task_mgr.path .. self.name .. ".lua", saveFile)
end
function ml_UITaskProfile:Delete()
	os.remove(ml_task_mgr.path .. self.name .. ".lua")
	self = ml_UITaskProfile.Create()
end
function ml_UITaskProfile.Create()
	local newinst = inheritsFrom( ml_UITaskProfile )
	newinst.name = "None"
	newinst.idcounter = 0
	newinst.version = 1
	newinst.currentTaskID = nil
	newinst.tasks = {}
    return newinst
end


-- TaskManager Functions
function ml_task_mgr.InitProfile(profileName)
	if (GetGameState() ~= 16) then return false end	
	if (profileName == nil or profileName == "None") then return false end
	
	profileName = string.gsub(profileName,'%W','')
		
	local newProfile = persistence.load(ml_task_mgr.path .. profileName .. ".lua")	
	if ( not newProfile ) then		
		ml_task_mgr.profile = nil
		ml_task_mgr.profile = ml_UITaskProfile.Create()
		ml_task_mgr.profile.name = profileName
				
	else
		ml_task_mgr.profile = ml_UITaskProfile.Create()
		ml_task_mgr.profile.name = newProfile.name
		ml_task_mgr.profile.idcounter = newProfile.idcounter
		ml_task_mgr.profile.version = newProfile.version
		ml_task_mgr.profile.currentTask = newProfile.currentTask
		
		-- Sort table by task.id
		--
		
		for key,task in ipairs(newProfile.tasks) do
			if (key and task) then
				
				local newtask = ml_UITask.Create()
				newtask = deepcopy(task)
				ml_task_mgr.profile.tasks[newtask.priority] = newtask

				
				--[[ loading custom tasksetting variables				
				if ( TableSize(ml_task_mgr.profile.tasks[newtask.priority].customVars) > 0 ) then
					for globalvar,entry in pairs(newProfile.tasks[newtask.priority].customVars) do
						d("WHAT : "..tostring(globalvar) .." :: "..tostring(entry.value))
						_G[globalvar] = entry.value
					end
				end]]
			end
		end
		
	end
	return ml_task_mgr.profile
end


function ml_task_mgr.GetProfileList(newTaskProfile)	
	local list = "None"
	if (ValidString(newTaskProfile)) then list = list .. "," .. newTaskProfile end
	
	local profileList = dirlist(ml_task_mgr.path,".*lua")
	if (ValidTable(profileList)) then
		for _,profile in pairs(profileList) do
			profile = string.gsub(profile, ".lua", "")
			list = list .. "," .. profile				
		end
	end
	return list
end

function ml_task_mgr.SaveProfile()
	if (ml_task_mgr.profile) then
		ml_task_mgr.profile:Save()
		gTMCurrentProfileName_listitems = ml_task_mgr.GetProfileList()
		local name = ml_task_mgr.profile.name		
		gTMCurrentProfileName = string.gsub(name,'%W','')
		Settings.GW2Minion.gCurrentTaskProfile = gTMCurrentProfileName
	end
end
-- Dialog func for save profile
function ml_task_mgr.newTaskProfile(profileName)	
	ml_task_mgr.profile = ml_task_mgr.InitProfile(profileName)
	ml_task_mgr.UpdateMainWindow()
	ml_task_mgr.currenttask = nil
	ml_task_mgr.UpdateEditWindow()
	gTMCurrentProfileName_listitems = ml_task_mgr.GetProfileList(profileName)	
	gTMCurrentProfileName = profileName
end
--for adding a brand new task from button "AddTask"
function ml_task_mgr.AddNewTask()
	if ( ml_task_mgr.profile ) then		
		local task = ml_UITask.Create()
		ml_task_mgr.profile.idcounter = ml_task_mgr.profile.idcounter + 1
		task.id = ml_task_mgr.profile.idcounter		
		task.priority = TableSize(ml_task_mgr.profile.tasks)+1				
		ml_task_mgr.profile.tasks[task.priority] = task		
		ml_task_mgr.profile:UpdateTaskPriority()
		ml_task_mgr.UpdateEditWindow( "TM"..task.priority )
		ml_task_mgr.UpdateMainWindow()
	else
		d("YOU NEED TO CREATE OR SELECT A TASKMANAGER PROFILE FIRST")	
	end
end

function ml_task_mgr.CreateMainWindow()
	if (WindowManager:GetWindow(ml_task_mgr.mainWindow.name) == nil) then
		-- Init Main Window
		local mainWindow = WindowManager:NewWindow(ml_task_mgr.mainWindow.name,ml_task_mgr.mainWindow.x,ml_task_mgr.mainWindow.y,ml_task_mgr.mainWindow.w,ml_task_mgr.mainWindow.h,false)
		if (mainWindow) then
			-- Settings section
			mainWindow:NewComboBox(GetString("profile"),"gTMCurrentProfileName",GetString("settings"),"")
			gTMCurrentProfileName = Settings.GW2Minion.gCurrentTaskProfile
			mainWindow:NewButton(GetString("taskNewTaskProfile"),"gTMnewTaskProfile",GetString("settings"))
			RegisterEventHandler("gTMnewTaskProfile",function() ml_task_mgr.CreateDialog(GetString("newTaskProfileName"),ml_task_mgr.newTaskProfile) end)
			
			-- Main window elements
			mainWindow:NewButton(GetString("saveProfile"),"gTMprofile")
			RegisterEventHandler("gTMprofile",ml_task_mgr.SaveProfile)
			
			mainWindow:NewButton(GetString("taskAddTask"),"gTMaddTask")
			RegisterEventHandler("gTMaddTask",ml_task_mgr.AddNewTask)
			
			mainWindow:UnFold(GetString("settings"))
			
			mainWindow:Hide()
		end
	end
	ml_task_mgr.UpdateMainWindow()
end
function ml_task_mgr.UpdateMainWindow()
	local mainWindow = WindowManager:GetWindow(ml_task_mgr.mainWindow.name)
	if (mainWindow) then
		gTMCurrentProfileName_listitems = ml_task_mgr.GetProfileList()
		
		mainWindow:DeleteGroup(GetString("tasks"))
		if (ml_task_mgr.profile) then	
			
			for prio, task in ipairs (ml_task_mgr.profile.tasks) do				
				if ( task.enabled == "0" ) then 
					mainWindow:NewButton("ID "..task.id..": ".. task.name.." (Disabled)","TM"..task.priority,GetString("tasks"))
				else
					mainWindow:NewButton("ID "..task.id..": ".. task.name,"TM"..task.priority,GetString("tasks"))
				end
				RegisterEventHandler("TM"..task.priority,ml_task_mgr.UpdateEditWindow)								
			end
			mainWindow:UnFold(GetString("tasks"))
		end
	end
	RaiseEvent("ml_task_mgr.UpdateMainWindow")
end

function ml_task_mgr.CreateEditWindow()
	if (WindowManager:GetWindow(ml_task_mgr.editWindow.name) == nil) then
		-- Init Edit Window
		local editWindow = WindowManager:NewWindow(ml_task_mgr.editWindow.name,ml_task_mgr.editWindow.x,ml_task_mgr.editWindow.y,ml_task_mgr.editWindow.w,ml_task_mgr.editWindow.h,true)
		if (editWindow) then
			-- Buttons
			editWindow:NewButton(GetString("taskDeleteTask"),"gTMdeletetask")
			RegisterEventHandler("gTMdeletetask",ml_task_mgr.DeleteTask)
			editWindow:NewButton(GetString("taskMoveDownTask"),"gTMMoveTaskDown")
			RegisterEventHandler("gTMMoveTaskDown",ml_task_mgr.MoveTaskDown)
			editWindow:NewButton(GetString("taskMoveUpTask"),"gTMMoveTaskUp")
			RegisterEventHandler("gTMMoveTaskUp",ml_task_mgr.MoveTaskUp)

			-- Tasks
			editWindow:NewField(GetString("name"),"TM_Name",GetString("task"))
			editWindow:NewComboBox(GetString("taskType"),"TM_Type",GetString("task"),"")
			editWindow:NewCheckBox(GetString("enabled"),"TM_Enabled",GetString("task"))
			TM_Type_listitems = ml_task_mgr.GetTasksAsString()
			--editWindow:NewField(GetString("taskPreTaskIDsComplete"),"TM_PreTaskIDs",GetString("taskStartConditions"))
			editWindow:NewField(GetString("taskStartMapID"),"TM_MapID",GetString("taskStartConditions"))
			editWindow:NewField(GetString("taskStartMapPos"),"TM_MapPos",GetString("taskStartConditions"))
			editWindow:NewButton(GetString("taskUseCurretPos"),"gTMUseMyPos",GetString("taskStartConditions"))
			RegisterEventHandler("gTMUseMyPos",ml_task_mgr.UpdateTaskPositionData)
			editWindow:NewNumeric(GetString("taskRadius"),"TM_Radius",GetString("taskStartConditions"),0,999999)
			editWindow:NewNumeric(GetString("taskMinLvl"),"TM_MinLvl",GetString("taskStartConditions"),0,80)
			editWindow:NewNumeric(GetString("taskMaxLvl"),"TM_MaxLvl",GetString("taskStartConditions"),0,80)
			--editWindow:NewNumeric(GetString("taskMinDuration"),"TM_MinDuration",GetString("taskStartConditions"))
			editWindow:NewNumeric(GetString("taskMaxDuration"),"TM_MaxDuration",GetString("taskStartConditions"))
			editWindow:NewNumeric(GetString("taskCoolDownDuration"),"TM_CoolDownDuration",GetString("taskStartConditions"))
			editWindow:NewNumeric(GetString("taskPartySize"),"TM_PartyPlayerCount",GetString("taskStartConditions"))
									
			editWindow:UnFold(GetString("task"))
			editWindow:UnFold(GetString("taskStartConditions"))
						
			editWindow:Hide()
		end
	end
end
-- Updates StartMapID & StartMap Position in the current task
function ml_task_mgr.UpdateTaskPositionData()
	TM_MapPos = tostring(math.floor(ml_global_information.Player_Position.x)).."/"..tostring(math.floor(ml_global_information.Player_Position.y)).."/"..tostring(math.floor(ml_global_information.Player_Position.z))
	TM_MapID = ml_global_information.CurrentMapID
	ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].mapid = TM_MapID
	ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].mappos = TM_MapPos
end

function ml_task_mgr.DeleteTask()
	if ( ml_task_mgr.currenttask and ml_task_mgr.profile.tasks[ml_task_mgr.currenttask]) then 
		table.remove(ml_task_mgr.profile.tasks, ml_task_mgr.currenttask)
		ml_task_mgr.profile:UpdateTaskPriority()
		ml_task_mgr.UpdateMainWindow()
		ml_task_mgr.currenttask = nil
		ml_task_mgr.UpdateEditWindow()
	end
end
function ml_task_mgr.MoveTaskDown()
	if ( ml_task_mgr.currenttask and ml_task_mgr.profile.tasks[ml_task_mgr.currenttask]) then 
		if ( ml_task_mgr.currenttask < TableSize(ml_task_mgr.profile.tasks) ) then
			local tmp = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask]			
			tmp.priority = tmp.priority + 1			
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask] = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask+1]			
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].priority = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].priority - 1			
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask+1] = tmp
			ml_task_mgr.profile:UpdateTaskPriority()
			ml_task_mgr.currenttask = ml_task_mgr.currenttask + 1
			ml_task_mgr.UpdateMainWindow()			
		end
	end
end
function ml_task_mgr.MoveTaskUp()
	if ( ml_task_mgr.currenttask and ml_task_mgr.profile.tasks[ml_task_mgr.currenttask]) then 
		if (ml_task_mgr.currenttask > 1) then
			local tmp = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask]
			tmp.priority = tmp.priority - 1
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask] = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask-1]
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].priority = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].priority + 1
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask-1] = tmp
			ml_task_mgr.currenttask = ml_task_mgr.currenttask - 1
			ml_task_mgr.profile:UpdateTaskPriority()
			ml_task_mgr.UpdateMainWindow()
		end
	end
end

function ml_task_mgr.UpdateEditWindow(arg)
	local taskid = mil
	if ( arg ) then
		taskid = tonumber(string.sub(arg, 3))
	end
	
	ml_task_mgr.CreateEditWindow()
	local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)	

	if (taskid and editWindow and ml_task_mgr.profile) then
		local t = ml_task_mgr.profile.tasks[tonumber(taskid)]
		if ( not t ) then return end
		local taskpriority = t.priority
		if (editWindow.visible and tonumber(taskpriority) == tonumber(ml_task_mgr.currenttask)) then
			editWindow:Hide()
			return 
		else
			local mainWindow = WindowManager:GetWindow(ml_task_mgr.mainWindow.name)
			if (mainWindow) then
				editWindow:SetPos(mainWindow.x+mainWindow.width,mainWindow.y)
			end		
			editWindow:Show()
		end
		ml_task_mgr.currenttask = tonumber(taskpriority)
		local task = ml_task_mgr.profile.tasks[tonumber(taskpriority)]
				
		-- task
		TM_ID = task.id
		TM_Prio = task.priority
		TM_Name = task.name
		TM_Enabled = task.enabled or "1"
		TM_Type = task.type or GetString("grindMode") or ""
		TM_PreTaskIDs = task.pretaskid or ""
		TM_MapID = task.mapid or ""
		TM_MapPos = task.mappos or ""
		TM_Radius = task.radius or 0
		TM_MinLvl = task.minlvl or 0
		TM_MaxLvl = task.maxlvl or 80
		TM_MaxDuration = task.maxduration or 0
		TM_CoolDownDuration = task.cooldown or 0
		TM_PartyPlayerCount = task.partysize or 0
		
		ml_task_mgr.UpdateTaskUIforType()
		
		
	elseif (arg == nil and editWindow) then
		editWindow:Hide()
	end	
end

-- gets called when the type of the task changes, updates the UI elements which are task specific
function ml_task_mgr.UpdateTaskUIforType(typeswitched)
	local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile) then
		-- clear the old settings			
		editWindow:DeleteGroup(GetString("taskCustomConditions"))
		if ( typeswitched ) then
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars = {}
		end
		
		-- build new settings
		local task = ml_task_mgr.taskTypes[TM_Type]
		if ( task ) then
			task:UIInit_TM() -- calls the task's UI Init function to populate the taskCustomConditions group
			editWindow:UnFold(GetString("taskCustomConditions"))
		else
			d("Unknown Tasktype selected?")
		end
	end	
end
-- "API"-Functions to create UI elements in the taskCustomConditions section
function ml_task_mgr.NewField(label,globalvar,newvalue)
	local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)

	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile and ValidString(label) and ValidString(globalvar)) then
		editWindow:NewField(label,"TM_TASK_"..globalvar,GetString("taskCustomConditions"))

		if ( ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] ~= nil ) then -- set the existing values			
			_G["TM_TASK_"..globalvar] = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar].value
		else -- create a new default entry			
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] = { type = "Field", value = newvalue or "" }
		end
	end
end
function ml_task_mgr.NewNumeric(label,globalvar,newvalue)
	local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile and ValidString(label) and ValidString(globalvar)) then
		editWindow:NewNumeric(label,"TM_TASK_"..globalvar,GetString("taskCustomConditions"))		
		if ( ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] ~= nil ) then -- set the existing values			
			_G["TM_TASK_"..globalvar] = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar].value
		else -- create a new default entry
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] = { type = "Numeric", value = newvalue or 0 }
		end		
	end
end	
function ml_task_mgr.NewCombobox(label,globalvar,liststring,newvalue)
	local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile and ValidString(label) and ValidString(globalvar) and ValidString(liststring)) then
		editWindow:NewComboBox(label,"TM_TASK_"..globalvar,GetString("taskCustomConditions"),liststring)
		if ( ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] ~= nil ) then -- set the existing values
			_G["TM_TASK_"..globalvar] = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar].value
		else -- create a new default entry	
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] = { type = "ComboBox", value = newvalue or "" }
		end		
	end
end
function ml_task_mgr.NewCheckBox(label,globalvar,newvalue)
	local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile and ValidString(label) and ValidString(globalvar)) then
		editWindow:NewCheckBox(label,"TM_TASK_"..globalvar,GetString("taskCustomConditions"))		
		if ( ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] ~= nil ) then -- set the existing values			
			_G["TM_TASK_"..globalvar] = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar].value
		else -- create a new default entry
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] = { type = "CheckBox", value = newvalue or "0" }
		end		
	end
end

-- not going to implement that button yet, would need a Item.GUI handler to handle the clicks
function ml_task_mgr.NewButton(label,globalvar,callbackfunc)
	--[[local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile and ValidString(label) and ValidString(globalvar) and callbackfunc ~= nil) then
		editWindow:NewButton(label,"TM_TASK_"..globalvar,GetString("taskCustomConditions"))
		RegisterEventHandler("TM_TASK_"..globalvar,callbackfunc) -- this should register only once a func to one global var ...not sure if that works
		if ( ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] ~= nil ) then -- set the existing values
			_G["TM_TASK_"..globalvar] = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar].value
		else -- create a new default entry		
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] = { type = "ComboBox", value = "" }
		end
		ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] = { type = "Button", value = callbackfunc }
	end]]
end


function ml_task_mgr.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		-- Changes in tasks
		-- task change
		if ( k == "TM_Name" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].name = v
		elseif ( k == "TM_Prio" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].priority = v
		elseif ( k == "TM_Type" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].type = v ml_task_mgr.UpdateTaskUIforType(true)
		elseif ( k == "TM_Enabled" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].enabled = v
		elseif ( k == "TM_PreTaskIDs" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].pretaskid = v
		elseif ( k == "TM_MapID" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].mapid = v
		elseif ( k == "TM_MapPos" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].mappos = v
		elseif ( k == "TM_Radius" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].radius = v
		elseif ( k == "TM_MinLvl" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].minlvl = v
		elseif ( k == "TM_MaxLvl" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].maxlvl = v
		elseif ( k == "TM_MaxDuration" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].maxduration = v
		elseif ( k == "TM_CoolDownDuration" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].cooldown = v
		elseif ( k == "TM_PartyPlayerCount" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].partysize = v

		
		--	if (v == "true") then v = true elseif (v == "false") then v = false end
		--	if (tonumber(v) ~= nil) then v = tonumber(v) end
					
		elseif (k == "gTMCurrentProfileName") then
			ml_task_mgr.profile = ml_task_mgr.InitProfile(gTMCurrentProfileName)
			ml_task_mgr.UpdateMainWindow()
			ml_task_mgr.currenttask = nil
			ml_task_mgr.UpdateEditWindow()
			Settings.GW2Minion.gCurrentTaskProfile = gTMCurrentProfileName
		
		elseif ( ValidString(k) and ml_task_mgr.currenttask and ml_task_mgr.profile ) then
			local sPos = string.find(k, "TM_TASK_") 
			if ( sPos ) then				
				ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars[k].value = v
				
			end
		end
	end	
end

function ml_task_mgr.ToggleMenu()
	ml_task_mgr.CreateMainWindow()
	local mainWindow = WindowManager:GetWindow(ml_task_mgr.mainWindow.name)
	if (mainWindow) then
		if ( mainWindow.visible ) then
			mainWindow:Hide()
			local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
			if ( editWindow ) then 
				editWindow:Hide()
			end
		else
			local wnd = WindowManager:GetWindow(gw2minion.MainWindow.Name)
			if ( wnd ) then
				mainWindow:SetPos(wnd.x+wnd.width,wnd.y)
				mainWindow:Show()
			end
			local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
			if ( editWindow ) then 
				editWindow:SetPos(wnd.x+wnd.width+mainWindow.width,wnd.y)
			end
		end
	end
end

function ml_task_mgr.CreateDialog()
	
	local dialog = WindowManager:GetWindow(GetString("newTaskProfileName"))
	local wSize = {w = 300, h = 100}
	if ( not dialog ) then
		dialog = WindowManager:NewWindow(GetString("newTaskProfileName"),nil,nil,nil,nil,true)
		dialog:NewField(GetString("newTaskProfileName"),"tmdialogfieldString","Please Enter")
		dialog:UnFold("Please Enter")
		
		local bSize = {w = 60, h = 20}
		-- Cancel Button
		local cancel = dialog:NewButton("Cancel","CancelDialog")
		cancel:Dock(0)
		cancel:SetSize(bSize.w,bSize.h)
		cancel:SetPos(((wSize.w - 12) - bSize.w),40)
		RegisterEventHandler("CancelDialog", function() dialog:SetModal(false) dialog:Hide() end)
		-- OK Button
		local OK = dialog:NewButton("OK","OKDialog")
		OK:Dock(0)
		OK:SetSize(bSize.w,bSize.h)
		OK:SetPos(((wSize.w - 12) - (bSize.w * 2 + 10)),40)
		RegisterEventHandler("OKDialog", function() if (ValidString(tmdialogfieldString) == false) then ml_error("Please enter " .. GetString("newTaskProfileName") .. " first.") return false end dialog:SetModal(false) dialog:Hide() ml_task_mgr.newTaskProfile(tmdialogfieldString)  return true end)
	end
	
	dialog:SetSize(wSize.w,wSize.h)
	dialog:Dock(GW2.DOCK.Center)
	dialog:Focus()
	dialog:SetModal(true)	
	dialog:Show()
end

function ml_task_mgr.GetTasksAsString() -- for combobox
	local typestring = ""
	
	for name,tasktype in pairs(ml_task_mgr.taskTypes) do
		if ( ValidString(name)) then
			if ( typestring  == "") then
				typestring = tostring(name)
			else
				typestring = typestring.. "," .. name
			end
		end
	end
	return typestring
end

-- Adds a task to be available in the taskmanager
function ml_task_mgr.AddTaskType( botmode, task )
	ml_task_mgr.taskTypes[botmode] = task
end



--*********************************
-- TM Logic and execution functions
--*********************************
-- Gets the current active task
function ml_task_mgr.GetCurrentTask()
	if ( ml_task_mgr.activeTask == nil or not ml_task_mgr.CanActiveTaskRun() ) then
		return nil
	end
	return ml_task_mgr.activeTask
end

-- Checks if the currently active task is still valid to run / checks all "running" conditions
function ml_task_mgr.CanActiveTaskRun()
	-- Wait until the start map and position were reached
	if ( ml_task_mgr.activeTask.started == false or ml_task_hub:CurrentTask().name == GetString("customTasks")) then return true end
	
	-- Checking Conditions	
	if ( ml_task_mgr.activeTask.completed == true 
		or ( tonumber(ml_task_mgr.activeTask.maxduration) ~= 0 and ml_global_information.Now - ml_task_mgr.activeTask.startTimer > tonumber(ml_task_mgr.activeTask.maxduration)*1000)
		or ( ml_task_mgr.activeTask.CanTaskRun_TM ~= nil and not ml_task_mgr.activeTask.CanTaskRun_TM() )
		or ( tonumber(ml_task_mgr.activeTask.maxlvl) ~= 0 and ml_global_information.Player_Level > tonumber(ml_task_mgr.activeTask.maxlvl) )
		-- or ( ml_task_mgr.activeTask.radius ~= nil and ml_task_mgr.activeTask.radius ~= 0 dont limit the radius in here, leave that to the tasks itself, else back n forth switching chaos may happen
		) then

		d("Task : "..ml_task_mgr.activeTask.name.." finished. Task completed: "..tostring(ml_task_mgr.activeTask.completed)..", Duration: "..tostring(math.floor((ml_global_information.Now - ml_task_mgr.activeTask.startTimer)/1000)).." > "..tostring(ml_task_mgr.activeTask.maxduration) .." CanRun:"..tostring(ml_task_mgr.activeTask.CanTaskRun_TM()))
		
		-- Enter it into our ml_task_mgr.taskHistory tabls
		ml_task_mgr.taskHistory[ml_task_mgr.activeTask.id] = ml_global_information.Now
		ml_task_mgr.SetTaskComplete(ml_task_mgr.activeTask)
		return false
	end
	
	return true
end

-- Returns the next valid task in our tasklist or nil if none is found
function ml_task_mgr.GetNextTask()
	if (ml_task_mgr.profile ~= nil ) then
		if ( TableSize(ml_task_mgr.profile.tasks) > 0 ) then
			local prio = ml_task_mgr.nextTaskPriority or nil
			ml_task_mgr.nextTaskPriority = nil
			
			if ( ml_task_mgr.activeTask ) then prio = ml_task_mgr.activeTask.priority end 
			
			local p,nextTask = next(ml_task_mgr.profile.tasks,prio)
			-- start from top of our profilelist again if we reached the bottom
			if ( prio ~= nil and not p ) then
				p,nextTask = next(ml_task_mgr.profile.tasks)
			end
			-- get the next task from profile
			while ( p and nextTask ) do
				if ( nextTask.enabled == "1" and ml_task_mgr.CanTaskStart(nextTask) ) then
					break
				end
				p,nextTask = next(ml_task_mgr.profile.tasks,p)
			end
			if ( nextTask ) then
				ml_task_mgr.activeTask = nil
				ml_task_mgr.activeTask = ml_task_mgr.taskTypes[nextTask.type].Create()
				ml_task_mgr.activeTask.startTimer = ml_global_information.Now
				ml_task_mgr.activeTask.started = false
				local startPos = {}
				-- Convert startposition string to usable numbers
				if ( ValidString(nextTask.mappos)) then 
					for pos in StringSplit(nextTask.mappos,"/") do
						table.insert(startPos,pos)
					end
					if ( TableSize(startPos) == 3 ) then
						ml_task_mgr.activeTask.pos = { x=tonumber(startPos[1]), y=tonumber(startPos[2]), z=tonumber(startPos[3]) }				
					else
						ml_error("TASK "..nextTask.name.." DOES NOT HAVE A VALID STARTPOSITION! ")
						ml_task_mgr.SetTaskDisabled(nextTask)
						return nil
					end
				else
					ml_error("TASK "..nextTask.name.." DOES NOT HAVE A VALID START-POSITION! ")
					ml_task_mgr.SetTaskDisabled(nextTask)
					return nil
				end
				
				-- Load TM data into task
				for key,entry in pairs(nextTask) do
					ml_task_mgr.activeTask[key] = entry
				end
				-- Load custom fields into task
				if ( TableSize(ml_task_mgr.activeTask.customVars) > 0 ) then				
					
					for globalvar,entry in pairs(ml_task_mgr.activeTask.customVars) do
						local sPos = string.find(globalvar, "TM_TASK_") 
						if ( sPos ) then
							local vname = string.sub(globalvar,9)						
							--d("Setting Task value : "..tostring(vname) .." == "..tostring(entry.value))
							ml_task_mgr.activeTask[vname] = entry.value
							
						end
					end
				end
								
				return ml_task_mgr.activeTask
			else				
				ml_error("TaskManager Profile Selection has no next tasks !")
			end			
		else
			ml_error("TaskManager Profile has no tasks setup!")
		end
	else
		ml_error("No TaskManager Profile loaded or setup!")
	end	
	return nil
end

-- Returns true/false if a task in our profile meets all starting conditions
function ml_task_mgr.CanTaskStart(nextTask)
	
	if ( nextTask ~= nil ) then
		
		if ( nextTask.pretaskid ~= nil and nextTask.pretaskid ~= "" ) then
			for tid in StringSplit(nextTask.pretaskid,",") do
				local p,Task = next(ml_task_mgr.profile.tasks)
				local complete = false
				while ( p and Task ) do
					d(Task)
					if ( tid == Task.id and Task.complete ) then
						complete = true
						break						
					end					
					p,Task = next(ml_task_mgr.profile.tasks,p)
				end
				if ( not complete ) then
					return false -- a task needed to be completed was not found/not completed yet
				end
			end
		end
		if ( tonumber(nextTask.minlvl) > ml_global_information.Player_Level or tonumber(nextTask.maxlvl) < ml_global_information.Player_Level ) then
			return false
		end
		
		if ( ml_task_mgr.taskHistory[nextTask.id] and ml_global_information.Now - ml_task_mgr.taskHistory[nextTask.id] < tonumber(nextTask.cooldown)*1000 ) then			
			return false
		end
		if ( tonumber(nextTask.partysize) > 0 and tonumber(nextTask.partysize) < TableSize(ml_global_information.Player_Party)) then
			return false
		end
		if ( ml_task_mgr.taskTypes[nextTask.type] and ml_task_mgr.taskTypes[nextTask.type].CanTaskStart_TM and not ml_task_mgr.taskTypes[nextTask.type].CanTaskStart_TM(nextTask) ) then
			return false
		end
		
		return true -- all conditions are ok
	end
	return false
end
-- Set the task.started field to true
function ml_task_mgr.SetActiveTaskStarted()
	if (ml_task_mgr.activeTask ~= nil ) then
		ml_task_mgr.activeTask.started = true
		ml_task_mgr.activeTask.startTimer = ml_global_information.Now
	end
end
-- Set the task.enabled field to false
function ml_task_mgr.SetTaskDisabled(activetask)
	if (ValidTable(ml_task_mgr.profile) ) then
		if ( TableSize(ml_task_mgr.profile.tasks) > 0 ) then						
			for prio,task in pairs( ml_task_mgr.profile.tasks )do				
				if ( task.id == activetask.id ) then
					task.enabled = "0"
					break
				end
			end
		end
	end
end
-- Set the task.complete field to true
function ml_task_mgr.SetTaskComplete(activetask)
	if (ValidTable(ml_task_mgr.profile)) then
		if ( TableSize(ml_task_mgr.profile.tasks) > 0 ) then						
			for prio,task in pairs( ml_task_mgr.profile.tasks )do				
				if ( task.id == activetask.id ) then
					task.complete = true
					break
				end
			end
		end
	end
end
-- Returns all tasks
function ml_task_mgr.GetTaskList()
	if ( ValidTable(ml_task_mgr.profile) ) then
		if ( TableSize(ml_task_mgr.profile.tasks) > 0 ) then	
			return ml_task_mgr.profile.tasks
		end
	end
	return nil
end

function ml_task_mgr.GetTaskByID(taskid)
	if ( ValidTable(ml_task_mgr.profile) and tonumber(taskid) ) then
		if ( TableSize(ml_task_mgr.profile.tasks) > 0 ) then						
			for prio,task in pairs( ml_task_mgr.profile.tasks )do				
				if ( task.id == taskid ) then
					return task
				end
			end
		end
	end
	return nil
end

-- Sets the task that should be run 
function ml_task_mgr.SetNextTaskByID(taskid)
	if (ValidTable(ml_task_mgr.profile) and tonumber(taskid) ) then
		if ( TableSize(ml_task_mgr.profile.tasks) > 0 ) then						
			for prio,task in pairs( ml_task_mgr.profile.tasks )do				
				if ( task.id == taskid ) then
					ml_task_mgr.activeTask = nil
					if ( task.priority > 1 ) then
						ml_task_mgr.nextTaskPriority = task.priority - 1 
					else
						ml_task_mgr.nextTaskPriority = nil
					end
					return true
				end
			end
		end
	end
	return false
end

RegisterEventHandler("Module.Initalize",ml_task_mgr.ModuleInit)
RegisterEventHandler("GUI.Update",ml_task_mgr.GUIVarUpdate)
