-- This task is for the TaskManager and will try to interact with a single target
gw2_task_interact = inheritsFrom(ml_task)
gw2_task_interact.name = GetString("taskTypeInteract")

function gw2_task_interact.Create()
	local newinst = inheritsFrom(gw2_task_interact)

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

function gw2_task_interact:Init()


	-- Normal elements
	-- Revive Downed/Dead Partymember
	self:add(ml_element:create( "RevivePartyMember", c_RezzPartyMember, e_RezzPartyMember, 375 ), self.process_elements)	-- creates subtask: moveto
	-- Revive other Players
	self:add(ml_element:create( "RevivePlayer", c_reviveDownedPlayersInCombat, e_reviveDownedPlayersInCombat, 350 ), self.process_elements)	-- creates subtask: moveto
	-- FightAggro
	self:add(ml_element:create( "FightAggro", c_FightAggro, e_FightAggro, 325 ), self.process_elements) --creates immediate queue task for combat

	-- Resting / Wait to heal
	self:add(ml_element:create( "Resting", c_waitToHeal, e_waitToHeal, 300 ), self.process_elements)

	-- MoveToInteractable
	self:add(ml_element:create( "MoveToInteractable", c_MoveToInteractable, e_MoveToInteractable, 125 ), self.process_elements)

	-- Interact
	self:add(ml_element:create( "InteractObject", c_InteractObject, e_InteractObject, 100 ), self.process_elements)


	self:AddTaskCheckCEs()
end
function gw2_task_interact:task_complete_eval()
	-- Check for nearby unfinished HQs
	if ( ml_task_hub:CurrentTask().started == true ) then

		-- currenttask interacted + wait + not casting anymore -> done

	end
	return false
end

function gw2_task_interact:UIInit()
	return true
end
function gw2_task_interact:UIDestroy()

end

function gw2_task_interact.ModuleInit()
	d("gw2_task_interact:ModuleInit")

	ml_task_mgr.AddTaskType(GetString("taskTypeInteract"), gw2_task_interact) -- Allow this task to be selectable in TaskManager
end

-- TaskManager functions
function gw2_task_interact:UIInit_TM()
	ml_task_mgr.NewField("ContentID", "interactContentIDs")
	ml_task_mgr.NewField("ContentID2", "interactContentID2s")
	ml_task_mgr.NewNumeric("InteractDuration(s)", "tIDuration")
	ml_task_mgr.NewCheckBox("Uses Short Teleports", "usesTeleport")
end
-- TaskManager function: Checks for custom conditions to start this task, this is checked before the task is selected to be enqueued/created
function gw2_task_interact.CanTaskStart_TM(nextTask)
	if ( TableSize(nextTask.customVars) > 0 and TableSize(nextTask.customVars.TM_TASK_usesTeleport) > 0 ) then

		if ( nextTask.customVars.TM_TASK_usesTeleport.value == "1" and gAllowTeleport == "0" ) then
			d("This Task requires short teleports but teleports are not allowed (Settings -> AllowTeleport), finishing task")
			return false
		end
	end
	return true
end
-- TaskManager function: Checks for custom conditions to keep this task running, this is checked during the task is actively running
function gw2_task_interact.CanTaskRun_TM()


	return true
end

c_MoveToInteractable = inheritsFrom( ml_cause )
e_MoveToInteractable = inheritsFrom( ml_effect )
e_MoveToInteractable.targetPos = nil
function c_MoveToInteractable:evaluate()

	if ( ml_task_hub:CurrentTask().pos ~= nil ) then
		local startPos = ml_task_hub:CurrentTask().pos
		local dist = Distance3D(startPos.x,startPos.y,startPos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)

		if ( dist > 50 ) then
			e_MoveToInteractable.targetPos = startPos
			return true
		end

	else
		ml_error("c_MoveToInteractable no valid task position")
	end
	e_MoveToInteractable.targetPos = nil
	return false
end
function e_MoveToInteractable:execute()
	ml_log("e_MoveToInteractable ")
	if ( e_MoveToInteractable.targetPos ~= nil ) then
		local newTask = gw2_task_moveto.Create()
		newTask.name = "e_MoveToInteractable "..ml_task_hub:CurrentTask().mytask.name.." StartPosition"
		newTask.targetPos = e_MoveToInteractable.targetPos
		ml_task_hub:CurrentTask():AddSubTask(newTask)
		return ml_log(true)

	else
		ml_error("e_MoveToInteractable no valid task position")
	end
	return ml_log(false)
end

-- Interact with stuff than we should interact with
c_InteractObject = inheritsFrom( ml_cause )
e_InteractObject = inheritsFrom( ml_effect )
e_InteractObject.lastTargetID = nil
e_InteractObject.lastQueryTmr = 0
e_InteractObject.WasChecked = false -- to make sure handleinteract is done before enemy checks
function c_InteractObject:evaluate()
	if ( ValidString(ml_task_hub:CurrentTask().interactContentIDs) ) then
		-- to prevent hammering the "shortestpath"
		if (e_InteractObject.lastTargetID ~= nil and TimeSince(e_InteractObject.lastQueryTmr) < 2000 ) then
			if ( ValidTable(CharacterList:Get(e_InteractObject.lastTargetID)) or ValidTable(GadgetList:Get(e_InteractObject.lastTargetID)) ) then
				return true
			end
		end

		-- dont spam it when no target was found
		if (TimeSince(e_InteractObject.lastQueryTmr) < 1000) then e_InteractObject.WasChecked = false return false end
		e_InteractObject.lastQueryTmr = ml_global_information.Now
		e_InteractObject.WasChecked = true

		-- Check nearest interactable target
		local nearTarget = Player:GetInteractableTarget()
		if ( nearTarget ) then
			local contentID = nearTarget.contentID
			if ( contentID ~= nil and string.find(ml_task_hub:CurrentTask().interactContentIDs,tostring(contentID)) ~= nil ) then
				e_InteractObject.lastTargetID = nearTarget.id
				return true
			end
		end

		--Search Charlist and Gadgetlist for the wanted targets
		local radius = tonumber(ml_task_hub:CurrentTask().radius)
		if ( radius == 0 ) then radius = 3500 end
		local TargetList = CharacterList("nearest,maxdistance=" .. radius .. ",interactable,selectable,contentID="..string.gsub(ml_task_hub:CurrentTask().interactContentIDs,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
		if ( TargetList ) then
			local id,entry = next(TargetList)
			if (id and entry ) then
				e_InteractObject.lastTarget = entry 
				e_InteractObject.lastTargetID = id
				return true
			end
		end
		
		local TargetList = GadgetList("nearest,maxdistance=" .. radius .. ",interactable,selectable,contentID="..string.gsub(ml_task_hub:CurrentTask().interactContentIDs,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
		if ( TargetList ) then
			local id,entry = next(TargetList)
			if (id and entry ) then
				e_InteractObject.lastTarget = entry 
				e_InteractObject.lastTargetID = id
				return true
			end
		end
		
		if (ValidString(ml_task_hub:CurrentTask().interactContentID2s)) then
			-- Search Gadgetlist for the wanted targets	
			local TargetList = GadgetList("nearest,maxdistance=" .. radius .. ",interactable,selectable,contentID2="..string.gsub(ml_task_hub:CurrentTask().interactContentID2s,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then
					e_InteractObject.lastTarget = entry
					e_InteractObject.lastTargetID = id
					return true
				end
			end
		end

		-- if we are here and havent found anything to interact with, task done
		d("Nothing to interact nearby, finishing task")
		ml_task_hub:CurrentTask().completed = true
	end
	e_InteractObject.lastTargetID = nil
	e_InteractObject.lastQueryTmr = ml_global_information.Now
	return false
end
function e_InteractObject:execute()
	ml_log("e_InteractObject ")
	if(e_InteractObject.lastTargetID ~= nil) then
		local target = CharacterList:Get(e_InteractObject.lastTargetID) or GadgetList:Get(e_InteractObject.lastTargetID)
		if(target ~= nil) then
			if ( target.interactable and target.selectable) then
				if ( target.isInInteractRange) then
					Player:StopMovement()
					local target = Player:GetTarget()
					if (not target or target.id ~= target.id) then
						Player:SetTarget(target.id)

					end

					d("Interact with Target.. ")
					if ( Player:GetCurrentlyCastedSpell() == ml_global_information.MAX_SKILLBAR_SLOTS ) then
						Player:Interact(target.id)

						-- For TM Conditions
						if ( tonumber(ml_task_hub:CurrentTask().tIDuration) > 1 ) then
							ml_global_information.Wait(tonumber(ml_task_hub:CurrentTask().tIDuration)*1000)
							else
							ml_global_information.Wait(1500)
						end
						d("Interacting done, task completed")
						ml_task_hub:CurrentTask().completed = true
					end
					return ml_log(true)



				else
					-- Get in range
					ml_log(" Getting in InteractRange, Distance:"..tostring(math.floor(target.distance)))
					local ePos = target.pos
					local tRadius = target.radius or 50
					if ( tRadius < 25 ) then tRadius = 35 end
					if ( not gw2_unstuck.HandleStuck() ) then
						local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,tRadius,false,false,true))
						if (tonumber(navResult) < 0) then
							d("MoveInRange result: "..tonumber(navResult))
						else
							--ml_task_hub:CurrentTask().pos = e_InteractObject.lastTarget.pos  leaving it static for now..too much fuckups :/
							return ml_log(true)
						end
					end
				end
			else
				e_InteractObject.lastTargetID = nil
				e_InteractObject.lastQueryTmr = ml_global_information.Now
			end
		end
	end

	return ml_log(false)
end


RegisterEventHandler("Module.Initalize",gw2_task_interact.ModuleInit)