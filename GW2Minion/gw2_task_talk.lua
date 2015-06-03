-- This task is for the TaskManager and will try to interact with a single target
gw2_task_talk = inheritsFrom(ml_task)
gw2_task_talk.name = GetString("taskTalk")

function gw2_task_talk.Create()
	local newinst = inheritsFrom(gw2_task_talk)

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

function gw2_task_talk:Init()


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
	self:add(ml_element:create( "HandleConversation", c_THandleConversation, e_THandleConversation, 200 ), self.process_elements)

	-- MoveToInteractTarget
	self:add(ml_element:create( "MoveToInteractTarget", c_MoveToInteractTarget, e_MoveToInteractTarget, 125 ), self.process_elements)

	-- StartConversation
	self:add(ml_element:create( "StartConversation", c_StartConversation, e_StartConversation, 100 ), self.process_elements)


	self:AddTaskCheckCEs()
end
function gw2_task_talk:task_complete_eval()
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

function gw2_task_talk:UIInit()
	return true
end
function gw2_task_talk:UIDestroy()

end

function gw2_task_talk.ModuleInit()
	d("gw2_task_talk:ModuleInit")

	ml_task_mgr.AddTaskType(GetString("taskTalk"), gw2_task_talk) -- Allow this task to be selectable in TaskManager
end

-- TaskManager functions
function gw2_task_talk:UIInit_TM()
	ml_task_mgr.NewField("Conversation Order (Type)", "conversationOrder")
	ml_task_mgr.NewField("Interact ContentIDs", "interactContentIDs")
end
-- TaskManager function: Checks for custom conditions to start this task, this is checked before the task is selected to be enqueued/created
function gw2_task_talk.CanTaskStart_TM(nextTask)
	if ( TableSize(nextTask.customVars) > 0 and TableSize(nextTask.customVars.TM_TASK_usesTeleport) > 0 ) then

		if ( nextTask.customVars.TM_TASK_usesTeleport.value == "1" and gAllowTeleport == "0" ) then
			d("This Task requires short teleports but teleports are not allowed (Settings -> AllowTeleport), finishing task")
			return false
		end
	end
	return true
end
-- TaskManager function: Checks for custom conditions to keep this task running, this is checked during the task is actively running
function gw2_task_talk.CanTaskRun_TM()


	return true
end

-- Handle conversations by the entered order of the task
c_THandleConversation = inheritsFrom( ml_cause )
e_THandleConversation = inheritsFrom( ml_effect )
e_THandleConversation.lastChatOptionReached = false
e_THandleConversation.lastChatOption = nil
e_THandleConversation.nextChatOption = nil
function c_THandleConversation:evaluate()
	if ( not ml_global_information.Player_InCombat and Player:IsConversationOpen() ) then

		if ( e_THandleConversation.nextChatOption ~= nil ) then
			return true
		end

		if ( ml_task_hub:CurrentTask().conversationOrder ~= nil and ml_task_hub:CurrentTask().conversationOrder ~= "" ) then
			e_THandleConversation.lastChatOptionReached = false
			for chatoption in StringSplit(ml_task_hub:CurrentTask().conversationOrder,",") do
				if ( e_THandleConversation.lastChatOption == nil ) then
					e_THandleConversation.lastChatOption = tonumber(chatoption)
					e_THandleConversation.nextChatOption = tonumber(chatoption)
					return true

				else
					if ( tonumber(chatoption) == e_THandleConversation.lastChatOption ) then
						e_THandleConversation.lastChatOptionReached = true
					end
					
					if ( e_THandleConversation.lastChatOptionReached and tonumber(chatoption) ~= e_THandleConversation.lastChatOption ) then
						e_THandleConversation.lastChatOption = tonumber(chatoption)
						e_THandleConversation.nextChatOption = tonumber(chatoption)
						return true
					end
				end
			end
		end

		if ( TableSize(Player:GetConversationOptions()) > 0 ) then
		-- default select 1st option..usually does the job
			return true
		end
	end
	
	e_THandleConversation.lastChatOptionReached = false
	e_THandleConversation.lastChatOption = nil
	e_THandleConversation.nextChatOption = nil
	return false
end
function e_THandleConversation:execute()
	ml_log("e_THandleConversation ")

	local options = Player:GetConversationOptions()
	if ( TableSize(options) > 0 ) then

		local index,option = next ( options)
		while ( index and option ) do
			if ( e_THandleConversation.nextChatOption ~= nil ) then
				if( option.type == e_THandleConversation.nextChatOption) then
					d("Selecting Chatoption by type:"..tostring(e_THandleConversation.nextChatOption))

					Player:SelectConversationOption(e_THandleConversation.nextChatOption)

					e_THandleConversation.nextChatOption = nil
					ml_global_information.Wait(1200)
					return ml_log(true)
				end
			else
				if ( option.index == 0 ) then
					d("Selecting First Chatoption:"..tostring(option.type))
					Player:SelectConversationOption(option.type)
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


c_MoveToInteractTarget = inheritsFrom( ml_cause )
e_MoveToInteractTarget = inheritsFrom( ml_effect )
e_MoveToInteractTarget.targetPos = nil
e_MoveToInteractTarget.targetPosReached = false
function c_MoveToInteractTarget:evaluate()
	if (e_MoveToInteractTarget.targetPosReached == false) then
		if ( ml_task_hub:CurrentTask().pos ~= nil ) then
			local startPos = ml_task_hub:CurrentTask().pos
			local dist = Distance3D(startPos.x,startPos.y,startPos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)

			if ( dist > 50 ) then
				e_MoveToInteractTarget.targetPos = startPos
				return true
			elseif (dist <= 50) then
				e_MoveToInteractTarget.targetPosReached = true
			end

		else
			ml_error("c_MoveToInteractTarget no valid task position")
		end
	end
	e_MoveToInteractTarget.targetPos = nil
	return false
end
function e_MoveToInteractTarget:execute()
	ml_log("e_MoveToInteractTarget ")
	if ( e_MoveToInteractTarget.targetPos ~= nil ) then
		local newTask = gw2_task_moveto.Create()
		newTask.name = "e_MoveToInteractTarget "..ml_task_hub:CurrentTask().mytask.name.." StartPosition"
		newTask.targetPos = e_MoveToInteractTarget.targetPos
		ml_task_hub:CurrentTask():AddSubTask(newTask)
		return ml_log(true)

	else
		ml_error("e_MoveToInteractTarget no valid task position")
	end
	return ml_log(false)
end



-- Interact with stuff than we should interact with
c_StartConversation = inheritsFrom( ml_cause )
e_StartConversation = inheritsFrom( ml_effect )
e_StartConversation.lastTarget = nil
e_StartConversation.lastTargetID = nil
e_StartConversation.lastQueryTmr = 0
e_StartConversation.WasChecked = false -- to make sure handleinteract is done before enemy checks
function c_StartConversation:evaluate()
	-- to prevent hammering the "shortestpath"
	if ( e_StartConversation.lastTarget ~= nil and e_StartConversation.lastTargetID ~= nil and TimeSince(e_StartConversation.lastQueryTmr) < 2000 ) then
		if ( ValidTable(CharacterList:Get(e_StartConversation.lastTargetID)) or ValidTable(GadgetList:Get(e_StartConversation.lastTargetID)) ) then
			return true
		end
	end

	-- dont spam it when no target was found
	if (TimeSince(e_StartConversation.lastQueryTmr) < 1000) then e_StartConversation.WasChecked = false return false end 
	e_StartConversation.lastQueryTmr = ml_global_information.Now
	e_StartConversation.WasChecked = true
	
	if ( ValidString(ml_task_hub:CurrentTask().interactContentIDs) ) then
		-- Check nearest interactable target 
		local nearTarget = Player:GetInteractableTarget()
		if ( nearTarget ) then 
			local contentID = nearTarget.contentID
			if ( contentID ~= nil and string.find(ml_task_hub:CurrentTask().interactContentIDs,tostring(contentID)) ~= nil ) then
				e_StartConversation.lastTarget = nearTarget 
				e_StartConversation.lastTargetID = nearTarget.id
				return true
			end
		end
		
		-- Search Charlist and Gadgetlist for the wanted targets
		--Search Charlist and Gadgetlist for the wanted targets
		local radius = tonumber(ml_task_hub:CurrentTask().radius)
		if ( radius == 0 or radius == nil ) then radius = 3500 end
		local TargetList = CharacterList("nearest,onmesh,interactable,selectable,maxdistance="..radius..",contentID="..string.gsub(ml_task_hub:CurrentTask().interactContentIDs,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
		if ( TargetList ) then
			local id,entry = next(TargetList)
			if (id and entry ) then
				e_StartConversation.lastTarget = entry 
				e_StartConversation.lastTargetID = id
				return true
			end
		end
		
		local TargetList = GadgetList("nearest,onmesh,interactable,selectable,maxdistance="..radius..",contentID="..string.gsub(ml_task_hub:CurrentTask().interactContentIDs,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
		if ( TargetList ) then
			local id,entry = next(TargetList)
			if (id and entry ) then
				e_StartConversation.lastTarget = entry 
				e_StartConversation.lastTargetID = id
				return true
			end
		end
	end
	
	local nearTarget = Player:GetInteractableTarget()
	if ( nearTarget ) then						
		e_StartConversation.lastTarget = nearTarget 
		e_StartConversation.lastTargetID = nearTarget.id					
		return true				
	end
	
	-- if we are here and havent found anything to interact with, task done
	d("Nothing to interact nearby, finishing task")
	ml_task_hub:CurrentTask().completed = true
	
	
	e_StartConversation.lastTarget = nil
	e_StartConversation.lastTargetID = nil
	e_StartConversation.lastQueryTmr = ml_global_information.Now
	return false
end
function e_StartConversation:execute()
	ml_log("e_StartConversation ")
	if ( e_StartConversation.lastTarget and e_StartConversation.lastTarget.interactable and e_StartConversation.lastTarget.selectable) then 
		if ( e_StartConversation.lastTarget.isInInteractRange) then
			Player:StopMovement()
			local target = Player:GetTarget()
			if (not target or target.id ~= e_StartConversation.lastTarget.id) then
				Player:SetTarget(e_StartConversation.lastTarget.id)
			end
			d("Interact with Target.. ")
			if ( Player:GetCurrentlyCastedSpell() == ml_global_information.MAX_SKILLBAR_SLOTS ) then
				Player:Interact(e_StartConversation.lastTarget.id)
				ml_global_information.Wait(1500)
			end
			return ml_log(true)
		else
			-- Get in range
			ml_log(" Getting in InteractRange, Distance:"..tostring(math.floor(e_StartConversation.lastTarget.distance)))			
			local ePos = e_StartConversation.lastTarget.pos
			local tRadius = e_StartConversation.lastTarget.radius or 50
				if ( tRadius < 25 ) then tRadius = 35 end
				if ( not gw2_unstuck.HandleStuck() ) then
					local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,tRadius,false,false,true))
					if (tonumber(navResult) < 0) then
						d("MoveInRange result: "..tonumber(navResult))
					else
						--ml_task_hub:CurrentTask().pos = e_StartConversation.lastTarget.pos  leaving it static for now..too much fuckups :/
						return ml_log(true)
					end
				end
			end
		else
		e_StartConversation.lastTarget = nil
			e_StartConversation.lastTargetID = nil
			e_StartConversation.lastQueryTmr = ml_global_information.Now
		end

	return ml_log(false)
end


RegisterEventHandler("Module.Initalize",gw2_task_talk.ModuleInit)