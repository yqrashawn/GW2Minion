-- initializes the questmanager which is included in minionlib and handles the executionlogic of quests/steps
mc_questmanager = {}
mc_questmanager.profilepath = GetStartupPath() .. [[\LuaMods\GW2Minion\QuestManagerProfiles\]];


function mc_questmanager.ModuleInit( ) 
	ml_quest_mgr.ModuleInit("GW2Minion",mc_questmanager.profilepath ) -- from minionlib/ml_quest_mgr.lua
	
end
RegisterEventHandler("Module.Initalize",mc_questmanager.ModuleInit) -- from minionlib/ml_quest_mgr.lua



-- RunQuestProfile-Task for example how to run the quest-step-script-tasks ;)
mc_ai_questprofile = inheritsFrom(ml_task)
mc_ai_questprofile.name = "QuestMode"

function mc_ai_questprofile.Create()
	local newinst = inheritsFrom(mc_ai_questprofile)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	newinst.currentQuestPrio = 0
	newinst.currentStepPrio = 0
	newinst.currentScript = nil

	
    return newinst
end

function mc_ai_questprofile:Init()

end

function mc_ai_questprofile:Process()
		
	if ( self.currentScript == nil ) then
		local t = ml_quest_mgr.GetNextIncompleteQuest()
		if ( TableSize(t) == 3) then
			self.currentQuestPrio = t[1]
			self.currentStepPrio = t[2]
			self.currentScript = t[3]		
			
		else
			mc_log("No QuestProfile loaded or Profile completed!")			
		end
	else
		
		if ( self.currentScript.completed == true ) then
			d("Script finished: "..tostring(self.currentScript.name))
			
			-- Set this step to "Finished" in our character's questprofile progress			-- 									
			ml_quest_mgr.SetQuestData( self.currentQuestPrio, self.currentStepPrio, nil, "done", "1" )
			
			-- TODO: Saving the Quest progress logic has to be done from here too...just call  ml_quest_mgr.SaveProfile() to save it
			

			
			self.currentScript = nil
		else
			--Run quest-Task
			ml_task_hub:CurrentTask():AddSubTask(self.currentScript)
		end		
	end
end

function mc_ai_questprofile:task_complete_eval()
	ml_log("mc_ai_questprofile:task_complete_eval->")
	return false
end
function mc_ai_questprofile:task_complete_execute()
    ml_log("mc_ai_questprofile:task_complete_execute->")
end

if ( mc_global.BotModes) then
	mc_global.BotModes[GetString("questRunProfile")] = mc_ai_questprofile
end