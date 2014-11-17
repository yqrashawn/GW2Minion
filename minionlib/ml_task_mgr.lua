-- API:
-- ml_task_mgr.AddTaskType( botmodename, task )  : to add a task to the dropdown "type" box
-- Each task which needs custom variables, add (example):
-- function gw2_task_grind:UIInit_TM()
-- Which creates TaskSettings elements:
-- 	ml_task_mgr.NewField("testfield", "beer")
--	ml_task_mgr.NewNumeric("testnum", "vodka")
--	ml_task_mgr.NewCombobox("testcbox", "whiskey", "A,B,C")
-- On creation of the task, these custom variables "beer" will be set in the newinstance of the task, example newinstance.beer / gw2_task_grind.beer



ml_task_mgr = {}
ml_task_mgr.mainWindow = {name = GetString("taskManager"), x = 350, y = 50, w = 250, h = 350}
ml_task_mgr.editWindow = {name = GetString("taskEditor"), x = 600, y = 50, w = 250, h = 550}
ml_task_mgr.profile = nil
ml_task_mgr.currentTask = nil
ml_task_mgr.path = GetStartupPath() .. [[\LuaMods\GW2Minion\TaskManagerProfiles\]]
ml_task_mgr.taskTypes = {}

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
	newinst.type = nil
	newinst.requiredTaskIDsCompleted = nil
	newinst.name = ""
	newinst.completed = false
	newinst.startMapName = ""
	newinst.startMapID = ""
	newinst.startMapPosition = ""
	newinst.minLevel = 0
	newinst.maxLevel = 80
	newinst.minDuration = 0
	newinst.maxDuration = 9999
	newinst.cooldownDuration = 0
	newinst.profession = nil
	newinst.partyPlayerCount = 0
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
		
		for key,task in pairs(newProfile.tasks) do
			if (key and task) then
				local newtask = ml_UITask.Create()
				newtask = deepcopy(task)
				ml_task_mgr.profile.tasks[newtask.priority] = newtask
				
				-- loading custom tasksetting variables
				if ( TableSize(ml_task_mgr.profile.tasks[newtask.priority].customVars) > 0 ) then
					for globalvar,entry in pairs(newProfile.tasks) do
						_G[globalvar] = entry.value
					end
				end				
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
			mainWindow:NewButton(GetString("newTaskProfile"),"gTMnewTaskProfile",GetString("settings"))
			RegisterEventHandler("gTMnewTaskProfile",function() ml_task_mgr.CreateDialog(GetString("newTaskProfileName"),ml_task_mgr.newTaskProfile) end)
			
			-- Main window elements
			mainWindow:NewButton(GetString("saveProfile"),"gTMprofile")
			RegisterEventHandler("gTMprofile",ml_task_mgr.SaveProfile)
			
			mainWindow:NewButton(GetString("addTask"),"gTMaddTask")
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
			
			for prio, task in pairs (ml_task_mgr.profile.tasks) do				
				mainWindow:NewButton("ID "..task.id..": ".. task.name,"TM"..task.priority,GetString("tasks"))
				RegisterEventHandler("TM"..task.priority,ml_task_mgr.UpdateEditWindow)
			end
			mainWindow:UnFold(GetString("tasks"))
		end
	end
end

function ml_task_mgr.CreateEditWindow()
	if (WindowManager:GetWindow(ml_task_mgr.editWindow.name) == nil) then
		-- Init Edit Window
		local editWindow = WindowManager:NewWindow(ml_task_mgr.editWindow.name,ml_task_mgr.editWindow.x,ml_task_mgr.editWindow.y,ml_task_mgr.editWindow.w,ml_task_mgr.editWindow.h,true)
		if (editWindow) then
			-- Buttons
			editWindow:NewButton(GetString("smDeletetask"),"gTMdeletetask")
			RegisterEventHandler("gTMdeletetask",ml_task_mgr.DeleteTask)
			editWindow:NewButton(GetString("smMoveDowntask"),"gTMMoveTaskDown")
			RegisterEventHandler("gTMMoveTaskDown",ml_task_mgr.MoveTaskDown)
			editWindow:NewButton(GetString("smMoveUptask"),"gTMMoveTaskUp")
			RegisterEventHandler("gTMMoveTaskUp",ml_task_mgr.MoveTaskUp)

			-- Tasks
			editWindow:NewField(GetString("name"),"TM_Name",GetString("task"))
			editWindow:NewComboBox(GetString("type"),"TM_Type",GetString("task"),"")
			TM_Type_listitems = ml_task_mgr.GetTasksAsString()
			
			editWindow:UnFold(GetString("task"))		
			
			editWindow:Hide()
		end
	end
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
		TM_Type = task.type or ""
		
		
		
		ml_task_mgr.UpdateTaskUIforType()
		
		
	elseif (arg == nil and editWindow) then
		editWindow:Hide()
	end	
end

-- gets called when the type of the task changes, updates the UI elements which are task specific
function ml_task_mgr.UpdateTaskUIforType()
	local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile) then
		
		editWindow:DeleteGroup(GetString("taskSettings")) -- clear the old settings
		local task = ml_task_mgr.taskTypes[TM_Type]
		if ( task ) then
			task:UIInit_TM() -- calls the task's UI Init function to populate the taskSettings group
			editWindow:UnFold(GetString("taskSettings"))
		else
			d("Unknown Tasktype selected?")
		end
	end	
end
-- "API"-Functions to create UI elements in the taskSettings section
function ml_task_mgr.NewField(label,globalvar)
	local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile and ValidString(label) and ValidString(globalvar)) then
		editWindow:NewField(label,"TM_TASK_"..globalvar,GetString("taskSettings"))				
		if ( ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] ~= nil) then -- set the existing values
			_G["TM_TASK_"..globalvar] = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar].value
		else -- create a new default entry		
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] = { type = "Field", value = "" }
		end
	end
end
function ml_task_mgr.NewNumeric(label,globalvar)
	local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile and ValidString(label) and ValidString(globalvar)) then
		editWindow:NewNumeric(label,"TM_TASK_"..globalvar,GetString("taskSettings"))
		if ( ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] ~= nil ) then -- set the existing values
			_G["TM_TASK_"..globalvar] = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar].value
		else -- create a new default entry		
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] = { type = "Numeric", value = 0 }
		end		
	end
end	
function ml_task_mgr.NewCombobox(label,globalvar,liststring)
	local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile and ValidString(label) and ValidString(globalvar) and ValidString(liststring)) then
		editWindow:NewComboBox(label,"TM_TASK_"..globalvar,GetString("taskSettings"),liststring)
		if ( ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] ~= nil ) then -- set the existing values
			_G["TM_TASK_"..globalvar] = ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar].value
		else -- create a new default entry	
			ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].customVars["TM_TASK_"..globalvar] = { type = "ComboBox", value = "" }
		end		
	end
end
-- not going to implement that button yet, would need a Item.GUI handler to handle the clicks
function ml_task_mgr.NewComboBox(label,globalvar,callbackfunc)
	--[[local editWindow = WindowManager:GetWindow(ml_task_mgr.editWindow.name)
	if (ml_task_mgr.currenttask and editWindow and ml_task_mgr.profile and ValidString(label) and ValidString(globalvar) and callbackfunc ~= nil) then
		editWindow:NewButton(label,"TM_TASK_"..globalvar,GetString("taskSettings"))
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
		elseif ( k == "TM_Type" ) then ml_task_mgr.profile.tasks[ml_task_mgr.currenttask].type = v ml_task_mgr.UpdateTaskUIforType()
					
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

function ml_task_mgr.AddTaskType( botmode, task )
	ml_task_mgr.taskTypes[botmode] = task
end



--*********************************
-- TM Logic and execution functions
--*********************************



RegisterEventHandler("Module.Initalize",ml_task_mgr.ModuleInit)
RegisterEventHandler("GUI.Update",ml_task_mgr.GUIVarUpdate)
