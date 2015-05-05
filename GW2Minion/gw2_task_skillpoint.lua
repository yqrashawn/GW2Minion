-- This task is for the TaskManager and will try to do the most common HeartQuests...hopefully ^^
gw2_task_skillpoint = inheritsFrom(ml_task)
gw2_task_skillpoint.name = GetString("taskSkillpoint")

function gw2_task_skillpoint.Create()
	local newinst = inheritsFrom(gw2_task_skillpoint)

    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}

	-- General fields
	newinst.SPType = GetString("taskTypeInteractKill") -- Different types
	newinst.enemyContentIDs = nil
	newinst.interactContentIDs = nil
	newinst.interactContentID2s = nil
	newinst.conversationOrder = nil -- handling possible dialog
	newinst.usableItemIDs = nil -- for using items from our Inventory which give us the skillpoint

    return newinst
end

function gw2_task_skillpoint:Init()


	-- Normal elements
	-- Revive Downed/Dead Partymember
	self:add(ml_element:create( "RevivePartyMember", c_RezzPartyMember, e_RezzPartyMember, 375 ), self.process_elements)	-- creates subtask: moveto
	-- Revive other Players
	self:add(ml_element:create( "RevivePlayer", c_reviveDownedPlayersInCombat, e_reviveDownedPlayersInCombat, 350 ), self.process_elements)	-- creates subtask: moveto
	-- FightAggro
	self:add(ml_element:create( "FightAggro", c_FightAggro, e_FightAggro, 325 ), self.process_elements) --creates immediate queue task for combat

	-- Resting / Wait to heal
	self:add(ml_element:create( "Resting", c_waitToHeal, e_waitToHeal, 300 ), self.process_elements)

	-- Normal Looting & chests
	self:add(ml_element:create( "Looting", c_Looting, e_Looting, 275 ), self.process_elements)

	-- Re-Equip Gathering Tools
	--self:add(ml_element:create( "EquippingGatherTool", c_GatherToolsCheck, e_GatherToolsCheck, 265 ), self.process_elements)

	-- Buy & Repair & Vendoring
	self:add(ml_element:create( "VendorRepair", c_createVendorRepairTask, e_createVendorRepairTask, 260 ), self.process_elements)
	self:add(ml_element:create( "VendorSell", c_createVendorSellTask, e_createVendorSellTask, 250 ), self.process_elements)

	--self:add(ml_element:create( "QuickRepairItems", c_quickrepair, e_quickrepair, 240 ), self.process_elements)


	-- DoEvents
	--self:add(ml_element:create( "DoEvent", c_doEvents, e_doEvents, 215 ), self.process_elements) would need a custom c_doEvents to not run away from the spot here

	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 200 ), self.process_elements) -- creates subtask: moveto

	-- Gathering
	--self:add(ml_element:create( "Gathering", c_GatherTask, e_GatherTask, 175 ), self.process_elements) -- creates subtask: gatheringTask

	-- Finish Enemy
	self:add(ml_element:create( "FinishEnemy", c_FinishEnemy, e_FinishEnemy, 150 ), self.process_elements)

	-- UseItem
	self:add(ml_element:create( "UseItem", c_UseItem, e_UseItem, 120 ), self.process_elements)

	-- HandleConversation
	self:add(ml_element:create( "HandleConversation", c_SPHandleConversation, e_SPHandleConversation, 100 ), self.process_elements)

	-- HandleCommune
	self:add(ml_element:create( "HandleCommune", c_HandleCommune, e_HandleCommune, 85 ), self.process_elements)

	-- If a interact contentID / ID2 was given, this will make the bot walk there and interact
	self:add( ml_element:create( "HandleInteract", c_SPHandleInteract, e_SPHandleInteract, 75 ), self.process_elements)

	-- If a Enemy contentID was given, this will make the bot walk there and attack it
	self:add( ml_element:create( "HandleKillEnemy", c_SPHandleKillEnemy, e_SPHandleKillEnemy, 50 ), self.process_elements)


	self:AddTaskCheckCEs()
end
function gw2_task_skillpoint:task_complete_eval()
	-- Check for nearby unfinished HQs
	if ( ml_task_hub:CurrentTask().started == true and ml_task_hub:CurrentTask().mappos ~= nil and ml_task_hub:CurrentTask().pos ~= nil  ) then

		local dist = Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)

		if ( dist < 2000 ) then
			local evList = MapMarkerList("nearest,onmesh,contentID="..GW2.MAPMARKER.Skillpoint)
			if ( evList ) then
				local i,marker = next(evList)
				if ( i and marker and marker.distance < 3000) then
					return false
				end
			end

			-- Check if we completed this SP already
			local evList = MapMarkerList("nearest,onmesh,contentID="..GW2.MAPMARKER.SkillpointComplete)
			if ( evList ) then
				local i,marker = next(evList)
				if ( i and marker and marker.distance < 500) then
					return true
				end
			end


			-- Check for possible "bosses" to kill in order to get the skillpoint
			if ( ml_task_hub:CurrentTask().enemyContentIDs ~= nil and ml_task_hub:CurrentTask().enemyContentIDs ~= "" and  ValidString(ml_task_hub:CurrentTask().enemyContentIDs) ) then
				local TargetList = CharacterList("nearest,onmesh,attackable,maxdistance=3000,selectable,alive,contentID="..ml_task_hub:CurrentTask().enemyContentIDs)
				if ( TableSize(TargetList )> 0) then
					return false
				end
			end

			-- Check for possible "bosses" to talk/interact in order to get the skillpoint
			if ( ml_task_hub:CurrentTask().interactContentIDs ~= nil and ml_task_hub:CurrentTask().interactContentIDs ~= "" and  ValidString(ml_task_hub:CurrentTask().interactContentIDs) ) then
				local TargetList = CharacterList("nearest,onmesh,interactable,maxdistance=3000,selectable,alive,contentID="..ml_task_hub:CurrentTask().interactContentIDs)
				if ( TableSize(TargetList )> 0) then
					return false
				end
			end

			-- We are close to the startpoint of the Skillpoint but no unfinished HQ was found
			d("No undiscovered Skillpoint nearby found, I guess we are done here.")
			ml_task_hub:CurrentTask().completed = true
			return true

		else
			ml_log("Distance to Skillpoint: "..tostring(dist))

		end
	end
	return false
end

function gw2_task_skillpoint:UIInit()
	return true
end
function gw2_task_skillpoint:UIDestroy()

end

function gw2_task_skillpoint.ModuleInit()
	d("gw2_task_skillpoint:ModuleInit")

	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("SP Type","dbSPType","Task_SkillPoint")
		dw:NewField("Conversation Order","dbSPConversation","Task_SkillPoint")
		dw:NewField("Kill ContentIDs","dbSPKillIDs","Task_SkillPoint")
		dw:NewField("Interact ContentIDs","dbSPInteractIDs","Task_SkillPoint")
		dw:NewField("Interact ContentID2s","dbSPInteractID2s","Task_SkillPoint")
		dw:NewField("Useable ItemIDs","dbSPUseItemIDs","Task_SkillPoint")
	end

	ml_task_mgr.AddTaskType(GetString("taskSkillpoint"), gw2_task_skillpoint) -- Allow this task to be selectable in TaskManager
end

-- TaskManager functions
function gw2_task_skillpoint:UIInit_TM()
	--ml_task_mgr.NewField("maxkills", "beer")
	ml_task_mgr.NewCombobox("SP Type", "SPType", GetString("taskTypeInteractKill")..",Commune") -- add more types here later if needed
	ml_task_mgr.NewField("Useable ItemIDs", "usableItemIDs")
	ml_task_mgr.NewField("Conversation Order (Type)", "conversationOrder")
	ml_task_mgr.NewField("Enemy ContentIDs", "enemyContentIDs")
	ml_task_mgr.NewField("Interact ContentIDs", "interactContentIDs")
	ml_task_mgr.NewField("Interact ContentID2s", "interactContentID2s")

end
-- TaskManager function: Checks for custom conditions to start this task, this is checked before the task is selected to be enqueued/created
function gw2_task_skillpoint.CanTaskStart_TM()
	return true
end
-- TaskManager function: Checks for custom conditions to keep this task running, this is checked during the task is actively running
function gw2_task_skillpoint.CanTaskRun_TM()

	-- since this is called independent of the tasksystem, it
	if ( ml_task_hub:CurrentTask().name == GetString("taskSkillpoint") ) then

		if ( ml_global_information.ShowDebug ) then
			dbSPKillIDs = tostring(ml_task_hub:CurrentTask().enemyContentIDs)
			dbSPInteractIDs = tostring(ml_task_hub:CurrentTask().interactContentIDs)
			dbSPInteractID2s = tostring(ml_task_hub:CurrentTask().interactContentID2s)
			dbSPConversation = tostring(ml_task_hub:CurrentTask().conversationOrder)
			dbSPUseItemIDs = tostring(ml_task_hub:CurrentTask().usableItemIDs)
		end
	end

	return true
end

-- Uses an Item which sometimes gives us the skillpoint
c_UseItem = inheritsFrom( ml_cause )
e_UseItem = inheritsFrom( ml_effect )
e_UseItem.item = nil
function c_UseItem:evaluate()
	if ( not ml_global_information.Player_InCombat and ml_task_hub:CurrentTask().usableItemIDs ~= nil and ml_task_hub:CurrentTask().usableItemIDs ~= "") then
		
		for itemid in StringSplit(ml_task_hub:CurrentTask().usableItemIDs,",") do
			
			local IList = Inventory("itemID="..itemid)
			if ( IList ) then
				for id,item in pairs (IList) do
					if ( id and item ) then
						e_UseItem.item = item
						return true
					end
				end
			end
		end
	end
	e_UseItem.item = nil
	return false
end
function e_UseItem:execute()
	ml_log("e_UseItem ")
	if ( e_UseItem.item ~= nil ) then
		d("Using SkillPoint Item")
		e_UseItem.item:Use()
		ml_global_information.Wait(2000)
		e_UseItem.item = nil
		return ml_log(true)
	end
	return ml_log(false)
end


-- Handle conversations by the entered order of the task
c_SPHandleConversation = inheritsFrom( ml_cause )
e_SPHandleConversation = inheritsFrom( ml_effect )
e_SPHandleConversation.lastChatOption = nil
e_SPHandleConversation.nextChatOption = nil
function c_SPHandleConversation:evaluate()
	if ( not ml_global_information.Player_InCombat and Player:IsConversationOpen() ) then

		if ( e_SPHandleConversation.nextChatOption ~= nil ) then
			return true
		end

		if ( ml_task_hub:CurrentTask().conversationOrder ~= nil and ml_task_hub:CurrentTask().conversationOrder ~= "" ) then
			for chatoption in StringSplit(ml_task_hub:CurrentTask().conversationOrder,",") do
				if ( e_SPHandleConversation.lastChatOption == nil ) then
					e_SPHandleConversation.lastChatOption = tonumber(chatoption)
					e_SPHandleConversation.nextChatOption = tonumber(chatoption)
					return true

				else
					if ( chatoption ~= e_SPHandleConversation.lastChatOption ) then
						e_SPHandleConversation.lastChatOption = tonumber(chatoption)
						e_SPHandleConversation.nextChatOption = tonumber(chatoption)
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

	e_SPHandleConversation.lastChatOption = nil
	e_SPHandleConversation.nextChatOption = nil
	return false
end
function e_SPHandleConversation:execute()
	ml_log("e_SPHandleConversation ")

	local options = Player:GetConversationOptions()
	if ( TableSize(options) > 0 ) then

		local index,option = next ( options)
		while ( index and option ) do
			if ( e_SPHandleConversation.nextChatOption ~= nil ) then
				if( option.type == e_SPHandleConversation.nextChatOption) then
					d("Selecting Chatoption by type:"..tostring(e_SPHandleConversation.nextChatOption))
					if ( Player.castinfo.duration == 0 ) then
						Player:SelectConversationOption(e_SPHandleConversation.nextChatOption)
					end
					e_SPHandleConversation.nextChatOption = nil
					if ( ml_task_hub:CurrentTask().SPType == "Commune" ) then
						ml_global_information.Wait(3000)
					else
						ml_global_information.Wait(1200)
					end
					return ml_log(true)
				end
			else
				if ( option.index == 0 ) then
					d("Selecting First Chatoption:"..tostring(option.type))
					if ( Player.castinfo.duration == 0 ) then
						Player:SelectConversationOption(option.type)
					end
					e_SPHandleConversation.nextChatOption = nil
					if ( ml_task_hub:CurrentTask().SPType == "Commune" ) then
						ml_global_information.Wait(3000)
					else
						ml_global_information.Wait(1200)
					end
					return ml_log(true)
				end
			end
			index,option = next ( options,index )
		end

	else
		ml_error("e_SPHandleConversation has no valid options")
	end
	e_SPHandleConversation.lastChatOption = nil
	e_SPHandleConversation.nextChatOption = nil
	return ml_log(false)
end

c_HandleCommune = inheritsFrom( ml_cause )
e_HandleCommune = inheritsFrom( ml_effect )
e_HandleCommune.walkingback = false
e_HandleCommune.commune = false
function c_HandleCommune:evaluate()
	if ( not ml_global_information.Player_InCombat and not Player:IsConversationOpen() ) then
		-- goto our task position
		if ( e_HandleCommune.walkingback ) then return true end

		if ( ml_task_hub:CurrentTask().pos ~= nil ) then
			local startPos = ml_task_hub:CurrentTask().pos
			local dist = Distance3D(startPos.x,startPos.y,startPos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)

			if ( dist > 100 ) then
				--this will make the TM to walk back to the startposition of this task
				e_HandleCommune.commune = false
				return true
			else
				local t = Player:GetInteractableTarget()
				if ( t and t.interactable and t.selectable ) then
					e_HandleCommune.commune = true
					return true
				end
			end
		end
	end
	e_HandleCommune.commune = false
	e_HandleCommune.walkingback = false
	return false
end
function e_HandleCommune:execute()
	ml_log("e_HandleCommune ")
	if ( not e_HandleCommune.commune ) then
		if ( not gw2_unstuck.HandleStuck() ) then
			local navResult = tostring(Player:MoveTo(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,35,false,false,false))
			if (tonumber(navResult) < 0) then
				d("e_HandleCommune result: "..tonumber(navResult))
			else
				e_HandleCommune.walkingback = true
				return ml_log(true)
			end
		end
		e_HandleCommune.walkingback = false
	end

	if ( e_HandleCommune.commune == true ) then
		local t = Player:GetInteractableTarget()
		if ( t and t.interactable and t.selectable ) then
			if ( Player.castinfo.duration == 0 ) then
				Player:Interact(t.id)
			end
			ml_global_information.Wait(2000)
			return true
		end
	end

	return ml_log(false)
end

-- Makes sure we dont walk away too far
c_SPHandleInteract = inheritsFrom( ml_cause )
e_SPHandleInteract = inheritsFrom( ml_effect )
e_SPHandleInteract.lastTarget = nil
e_SPHandleInteract.lastTargetID = nil
e_SPHandleInteract.lastQueryTmr = 0
e_SPHandleInteract.WasChecked = false -- to make sure handleinteract is done before enemy checks
function c_SPHandleInteract:evaluate()

	if ( ml_task_hub:CurrentTask().SPType == GetString("taskTypeInteractKill") or ml_task_hub:CurrentTask().SPType == "Commune" ) then
		local radius = tonumber(ml_task_hub:CurrentTask().radius)
		if ( radius == 0 ) then radius = 8000 end

		-- to prevent hammering the "shortestpath"
		if ( e_SPHandleInteract.lastTarget ~= nil and e_SPHandleInteract.lastTargetID ~= nil and TimeSince(e_SPHandleInteract.lastQueryTmr) < 2000 ) then
			if ( ValidTable(CharacterList:Get(e_SPHandleInteract.lastTargetID)) or ValidTable(GadgetList:Get(e_SPHandleInteract.lastTargetID)) ) then
				return true
			end
		end

		-- dont spam it when no target was found
		if (TimeSince(e_SPHandleInteract.lastQueryTmr) < 1000) then e_SPHandleInteract.WasChecked = false return false end
		e_SPHandleInteract.lastQueryTmr = ml_global_information.Now
		e_SPHandleInteract.WasChecked = true

		if ( ml_task_hub:CurrentTask().interactContentIDs ~= nil and ml_task_hub:CurrentTask().interactContentIDs ~= "" and ValidString(ml_task_hub:CurrentTask().interactContentIDs) ) then

			-- Lets pray that no dumbnut entered bullshit into these ContentID fields -.-
			-- Search Charlist and Gadgetlist for the wanted targets
			local TargetList = CharacterList("shortestpath,onmesh,interactable,selectable,contentID="..string.gsub(ml_task_hub:CurrentTask().interactContentIDs,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then
					local tPos = entry.pos
					if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
						e_SPHandleInteract.lastTarget = entry 
						e_SPHandleInteract.lastTargetID = id
						return true
					end
				end
			end

			local TargetList = GadgetList("shortestpath,onmesh,interactable,selectable,contentID="..string.gsub(ml_task_hub:CurrentTask().interactContentIDs,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then
					local tPos = entry.pos
					if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
						e_SPHandleInteract.lastTarget = entry 
						e_SPHandleInteract.lastTargetID = id
						return true
					end
				end
			end

		end

		if ( ml_task_hub:CurrentTask().interactContentID2s ~= nil  and ml_task_hub:CurrentTask().interactContentID2s ~= "" and ValidString(ml_task_hub:CurrentTask().interactContentID2s) ) then
			-- Search Gadgetlist for the wanted targets
			local TargetList = GadgetList("shortestpath,onmesh,interactable,selectable,contentID2="..string.gsub(ml_task_hub:CurrentTask().interactContentID2s,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then
					local tPos = entry.pos
					if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
						e_SPHandleInteract.lastTarget = entry
						e_SPHandleInteract.lastTargetID = id
						return true
					end
				end
			end
		end
		
		e_SPHandleInteract.lastTarget = nil
		e_SPHandleInteract.lastTargetID = nil
		e_SPHandleInteract.lastQueryTmr = ml_global_information.Now
	end
	return false
end
function e_SPHandleInteract:execute()
	ml_log("HQHandleInteract ")
	if ( e_SPHandleInteract.lastTarget and e_SPHandleInteract.lastTarget.onmesh and e_SPHandleInteract.lastTarget.interactable and e_SPHandleInteract.lastTarget.selectable) then 
		if ( e_SPHandleInteract.lastTarget.isInInteractRange and e_SPHandleInteract.lastTarget.distance < 100) then
				Player:StopMovement()
				local target = Player:GetTarget()
			if (not target or target.id ~= e_SPHandleInteract.lastTarget.id) then
				Player:SetTarget(e_SPHandleInteract.lastTarget.id)
					return true

				else
					ml_log("Interact with Target.. ")
					if ( Player:GetCurrentlyCastedSpell() == ml_global_information.MAX_SKILLBAR_SLOTS ) then
					Player:Interact(e_SPHandleInteract.lastTarget.id)
						-- For TM Conditions
					ml_task_hub:CurrentTask().lastInteractTargetID = e_SPHandleInteract.lastTarget.id				
						ml_global_information.Wait(1000)
					end
					return ml_log(true)
				end

			else
				-- Get in range
			ml_log(" Getting in InteractRange, Distance:"..tostring(math.floor(e_SPHandleInteract.lastTarget.distance)))			
			local ePos = e_SPHandleInteract.lastTarget.pos
			local tRadius = e_SPHandleInteract.lastTarget.radius or 50
				if ( not gw2_unstuck.HandleStuck() ) then
					local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,25+tRadius,false,false,true))
					if (tonumber(navResult) < 0) then
						d("MoveInRange result: "..tonumber(navResult))
					else
						return ml_log(true)
					end
				end
			end
		else
		e_SPHandleInteract.lastTarget = nil
			e_SPHandleInteract.lastTargetID = nil
			e_SPHandleInteract.lastQueryTmr = ml_global_information.Now
		end

	return ml_log(false)
end

-- Search n Kill the wanted Enemies
c_SPHandleKillEnemy = inheritsFrom( ml_cause )
e_SPHandleKillEnemy = inheritsFrom( ml_effect )
e_SPHandleKillEnemy.lastTarget = nil
e_SPHandleKillEnemy.lastTargetID = nil
e_SPHandleKillEnemy.lastQueryTmr = 0
function c_SPHandleKillEnemy:evaluate()

	if ( ml_task_hub:CurrentTask().SPType == GetString("taskTypeInteractKill") ) then
		if ( ml_task_hub:CurrentTask().enemyContentIDs ~= nil and ml_task_hub:CurrentTask().enemyContentIDs ~= "" and  ValidString(ml_task_hub:CurrentTask().enemyContentIDs) ) then
			-- Lets pray that no dumbnut entered bullshit into these ContentID fields -.-

			-- to prevent hammering the "shortestpath"
			if ( e_SPHandleKillEnemy.lastTarget ~= nil and e_SPHandleKillEnemy.lastTargetID ~= nil and TimeSince(e_SPHandleKillEnemy.lastQueryTmr) < 2000 ) then
				if ( ValidTable(CharacterList:Get(e_SPHandleKillEnemy.lastTargetID)) or ValidTable(GadgetList:Get(e_SPHandleKillEnemy.lastTargetID)) ) then
					return true
				end
			end

			-- dont spam it when no target was found
			if (e_SPHandleInteract.WasChecked == false or TimeSince(e_SPHandleKillEnemy.lastQueryTmr) < 1000) then return false end
			e_SPHandleKillEnemy.lastQueryTmr = ml_global_information.Now


			-- Search Charlist and Gadgetlist for the wanted enemies
			local radius = tonumber(ml_task_hub:CurrentTask().radius)
			if ( radius == 0 ) then maxradius = 8000 end
			local TargetList = CharacterList("shortestpath,onmesh,attackable,selectable,alive,contentID="..string.gsub(ml_task_hub:CurrentTask().enemyContentIDs,",",";"))
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then
					local tPos = entry.pos
					if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
						e_SPHandleKillEnemy.lastTarget = entry					
						e_SPHandleKillEnemy.lastTargetID = id
						return true
					end
				end
			end

			local TargetList = GadgetList("shortestpath,onmesh,attackable,selectable,alive,contentID="..string.gsub(ml_task_hub:CurrentTask().enemyContentIDs,",",";"))
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then
					local tPos = entry.pos
					if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
						e_SPHandleKillEnemy.lastTarget = entry					
						e_SPHandleKillEnemy.lastTargetID = id
						return true
					end
				end
			end

		end
		e_SPHandleKillEnemy.lastTarget = nil
		e_SPHandleKillEnemy.lastTargetID = nil
		e_SPHandleKillEnemy.lastQueryTmr = ml_global_information.Now
	end
	return false
end
function e_SPHandleKillEnemy:execute()
	ml_log("HQHandleKillEnemy ")
	if ( e_SPHandleKillEnemy.lastTarget and e_SPHandleKillEnemy.lastTarget.onmesh and e_SPHandleKillEnemy.lastTarget.attackable and e_SPHandleKillEnemy.lastTarget.alive) then 
			Player:StopMovement()
			-- For TM Conditions
		ml_task_hub:CurrentTask().lastEnemyTargetID = e_SPHandleKillEnemy.lastTarget.id
			ml_task_hub:CurrentTask().lastTargetType = "character"

			-- Create new Subtask Combat
			local newTask = gw2_task_combat.Create()
		newTask.targetID = e_SPHandleKillEnemy.lastTarget.id		
		if ( e_SPHandleKillEnemy.lastTarget.isGadget ) then
				newTask.targetType = "gadget"
				ml_task_hub:CurrentTask().lastTargetType = "gadget"
			end


			ml_task_hub:Add(newTask.Create(), IMMEDIATE_GOAL, TP_IMMEDIATE)
			return ml_log(true)

		end

	e_SPHandleKillEnemy.lastTarget = nil
	e_SPHandleKillEnemy.lastTargetID = nil
	e_SPHandleKillEnemy.lastQueryTmr = ml_global_information.Now
	return ml_log(false)
end






RegisterEventHandler("Module.Initalize",gw2_task_skillpoint.ModuleInit)
