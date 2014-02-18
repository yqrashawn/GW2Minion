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
	newinst.currentQuest = nil
	newinst.currentStep = nil
		
    return newinst
end

function mc_ai_questprofile:Init()

end

function mc_ai_questprofile:Process()
	
	-- Get a Quest
	if ( self.currentQuest == nil ) then
		self.currentQuest = ml_quest_mgr.GetNewQuest()		
		if ( self.currentQuest == nil ) then
			d("No more Quests in Questprofile left, terminating task")
			self.completed = true
		end
	
	else
		-- Get next QuestStep
		if ( self.currentStep == nil or self.currentStep.done == "1" or ( self.currentStep.script ~= nil and self.currentStep.script.completed == true)) then
			
			-- Set this step to "Finished" in our character's questprofile progress			-- 									
			if ( self.currentStep~=nil and self.currentStep.script ~= nil ) then 
				d("QuestStep "..tostring(self.currentStep.name).." completed!") 				
				ml_quest_mgr.SetQuestData( self.currentQuest, self.currentStep, nil, "done", "1" )
				self.currentStep = nil
			end
						
			-- Getting next questStep
			self.currentStep = ml_quest_mgr.GetNextQuestStep( self.currentQuest )				
			if ( self.currentStep == nil ) then
				d("All steps of current Quest "..tostring( self.currentQuest.name).." are finished!")
				ml_quest_mgr.SetQuestData( self.currentQuest, nil, nil, "done", "1" )
								
				-- Reset QuestSteps for repeatable Quests
				if ( self.currentQuest.repeatable == "1" ) then
					d("Resetting QuestSteps for "..tostring( self.currentQuest.name))
					ml_quest_mgr.ResetQuest( self.currentQuest )
				end
				
				d("Saving QuestProgress..")
				ml_quest_mgr.SaveProfile()		
				self.currentQuest = nil
			end			
		else
			-- Execute currentStep Task
			if ( self.currentStep.script ~= nil ) then
								
				ml_task_hub:CurrentTask():AddSubTask(self.currentStep.script)
				
			else
				ml_error("QuestStep "..tostring(self.currentStep.name).." has NO script selected!!!!!")
			end			
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