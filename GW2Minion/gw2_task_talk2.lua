-- This task is for the TaskManager and will try to interact with a single target
gw2_task_talk2 = inheritsFrom(ml_task)
gw2_task_talk2.name = "Talk_Index"

function gw2_task_talk2.Create()
	local newinst = inheritsFrom(gw2_task_talk2)

    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}

	-- General fields
	newinst.startTime = ml_global_information.Now
	newinst.usesTeleport = "0"

    return newinst
end

function gw2_task_talk2:Init()


	-- Normal elements
	-- Revive Downed/Dead Partymember
	self:add(ml_element:create( "RevivePartyMember", c_RezzPartyMember, e_RezzPartyMember, 375 ), self.process_elements)	-- creates subtask: moveto
	-- Revive other Players
	self:add(ml_element:create( "RevivePlayer", c_reviveDownedPlayersInCombat, e_reviveDownedPlayersInCombat, 350 ), self.process_elements)	-- creates subtask: moveto
	-- FightAggro
	self:add(ml_element:create( "FightAggro", c_FightAggro, e_FightAggro, 325 ), self.process_elements) --creates immediate queue task for combat

	-- Resting / Wait to heal
	self:add(ml_element:create( "Resting", c_waitToHeal, e_waitToHeal, 300 ), self.process_elements)

	-- HandleConversation
	self:add(ml_element:create( "HandleConversation", c_THandleConversation, e_THandleConversationByIndex, 200 ), self.process_elements)

	-- MoveToInteractTarget
	self:add(ml_element:create( "MoveToInteractTarget", c_MoveToInteractTarget, e_MoveToInteractTarget, 125 ), self.process_elements)

	-- StartConversation
	self:add(ml_element:create( "StartConversation", c_StartConversation, e_StartConversation, 100 ), self.process_elements)


	self:AddTaskCheckCEs()
end
function gw2_task_talk2:task_complete_eval()
	-- Check for nearby unfinished HQs
	if ( ml_task_hub:CurrentTask().started == true ) then

		if ( not ml_global_information.Player_InCombat and Player:IsConversationOpen() ) then
			ml_task_hub:CurrentTask().conversationStarted = true

		end

		if ( ml_task_hub:CurrentTask().conversationStarted and ml_task_hub:CurrentTask().conversationStarted == true and not Player:IsConversationOpen() ) then
			d("Conversation done, finishing task : "..ml_task_hub:CurrentTask().name)
			ml_task_hub:CurrentTask().completed = true
		end
	end
	return false
end

function gw2_task_talk2:UIInit()
	return true
end
function gw2_task_talk2:UIDestroy()

end

function gw2_task_talk2.ModuleInit()
	d("gw2_task_talk2:ModuleInit")

	ml_task_mgr.AddTaskType("Talk_Index", gw2_task_talk2) -- Allow this task to be selectable in TaskManager
end

-- TaskManager functions
function gw2_task_talk2:UIInit_TM()
	ml_task_mgr.NewField("Conversation Order (Index)", "conversationOrder")
	ml_task_mgr.NewField("Interact ContentIDs", "interactContentIDs")
end
-- TaskManager function: Checks for custom conditions to start this task, this is checked before the task is selected to be enqueued/created
function gw2_task_talk2.CanTaskStart_TM(nextTask)
	if ( TableSize(nextTask.customVars) > 0 and TableSize(nextTask.customVars.TM_TASK_usesTeleport) > 0 ) then

		if ( nextTask.customVars.TM_TASK_usesTeleport.value == "1" and gAllowTeleport == "0" ) then
			d("This Task requires short teleports but teleports are not allowed (Settings -> AllowTeleport), finishing task")
			return false
		end
	end
	return true
end
-- TaskManager function: Checks for custom conditions to keep this task running, this is checked during the task is actively running
function gw2_task_talk2.CanTaskRun_TM()


	return true
end

e_THandleConversationByIndex = inheritsFrom( ml_effect )
function e_THandleConversationByIndex:execute()
	ml_log("e_THandleConversationByIndex ")

	local options = Player:GetConversationOptions()
	if ( TableSize(options) > 0 ) then

		local index,option = next ( options)
		while ( index and option ) do
			if ( e_THandleConversation.nextChatOption ~= nil ) then
				if( option.type == e_THandleConversation.nextChatOption) then
					d("Selecting Chatoption by type:"..tostring(e_THandleConversation.nextChatOption))

					Player:SelectConversationOptionByIndex(e_THandleConversation.nextChatOption)

					e_THandleConversation.nextChatOption = nil
					ml_global_information.Wait(1200)
					return ml_log(true)
				end
			else
				if ( option.index == 0 ) then
					d("Selecting First Chatoption:"..tostring(option.type))
					Player:SelectConversationOptionByIndex(option.type)
					e_THandleConversation.nextChatOption = nil
					ml_global_information.Wait(1200)
					return ml_log(true)
				end
			end
			index,option = next ( options,index )
		end

	else
		ml_error("e_THandleConversation has no valid options")
	end
	e_THandleConversation.lastChatOption = nil
	e_THandleConversation.nextChatOption = nil
	return ml_log(false)
end


RegisterEventHandler("Module.Initalize",gw2_task_talk2.ModuleInit)