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
	self:add(ml_element:create( "HandleConversation", c_HandleConversation, e_HandleConversation, 100 ), self.process_elements)		
	
	-- HandleCommune
	self:add(ml_element:create( "HandleCommune", c_HandleCommune, e_HandleCommune, 85 ), self.process_elements)	
	
	-- If a interact contentID / ID2 was given, this will make the bot walk there and interact
	self:add( ml_element:create( "HandleInteract", c_HQHandleInteract, e_HQHandleInteract, 75 ), self.process_elements)

	-- If a Enemy contentID was given, this will make the bot walk there and attack it
	self:add( ml_element:create( "HandleKillEnemy", c_HQHandleKillEnemy, e_HQHandleKillEnemy, 50 ), self.process_elements)
	

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
c_HandleConversation = inheritsFrom( ml_cause )
e_HandleConversation = inheritsFrom( ml_effect )
e_HandleConversation.lastChatOption = nil
e_HandleConversation.nextChatOption = nil
function c_HandleConversation:evaluate()
	if ( not ml_global_information.Player_InCombat and Player:IsConversationOpen() ) then
		
		if ( e_HandleConversation.nextChatOption ~= nil ) then
			return true
		end
		
		if ( ml_task_hub:CurrentTask().conversationOrder ~= nil and ml_task_hub:CurrentTask().conversationOrder ~= "" ) then
			for chatoption in StringSplit(ml_task_hub:CurrentTask().conversationOrder,",") do
				if ( e_HandleConversation.lastChatOption == nil ) then
					e_HandleConversation.lastChatOption = tonumber(chatoption)
					e_HandleConversation.nextChatOption = tonumber(chatoption)
					return true
					
				else
					if ( chatoption ~= e_HandleConversation.lastChatOption ) then
						e_HandleConversation.lastChatOption = tonumber(chatoption)
						e_HandleConversation.nextChatOption = tonumber(chatoption)
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
	
	e_HandleConversation.lastChatOption = nil
	e_HandleConversation.nextChatOption = nil
	return false
end
function e_HandleConversation:execute()
	ml_log("e_HandleConversation ")
	
	local options = Player:GetConversationOptions()
	if ( TableSize(options) > 0 ) then 
				
		local index,option = next ( options)
		while ( index and option ) do 
			if ( e_HandleConversation.nextChatOption ~= nil ) then
				if( option.type == e_HandleConversation.nextChatOption) then
					d("Selecting Chatoption by type:"..tostring(e_HandleConversation.nextChatOption))
					Player:SelectConversationOption(e_HandleConversation.nextChatOption)
					e_HandleConversation.nextChatOption = nil
					if ( ml_task_hub:CurrentTask().SPType == "Commune" ) then
						ml_global_information.Wait(5000)
					else
						ml_global_information.Wait(1200)
					end
					return ml_log(true)
				end
			else
				if ( option.index == 0 ) then 
					d("Selecting First Chatoption:"..tostring(option.type))
					Player:SelectConversationOption(option.type)
					e_HandleConversation.nextChatOption = nil
					if ( ml_task_hub:CurrentTask().SPType == "Commune" ) then
						ml_global_information.Wait(5000)
					else
						ml_global_information.Wait(1200)
					end
					return ml_log(true)
				end
			end
			index,option = next ( options,index )
		end
		
	else
		ml_error("e_HandleConversation has no valid options")		
	end
	e_HandleConversation.lastChatOption = nil
	e_HandleConversation.nextChatOption = nil
	return ml_log(false)
end

c_HandleCommune = inheritsFrom( ml_cause )
e_HandleCommune = inheritsFrom( ml_effect )
function c_HandleCommune:evaluate()
	if ( ml_task_hub:CurrentTask().SPType == "Commune" and not ml_global_information.Player_InCombat and not Player:IsConversationOpen() ) then
		
		
	end
	
	return false
end
function e_HandleCommune:execute()
	ml_log("e_HandleCommune ")
	
	
	return ml_log(false)
end

-- Makes sure we dont walk away too far
c_HQHandleInteract = inheritsFrom( ml_cause )
e_HQHandleInteract = inheritsFrom( ml_effect )
e_HQHandleInteract.lastTarget = nil
e_HQHandleInteract.lastTargetID = nil
e_HQHandleInteract.lastQueryTmr = 0
e_HQHandleInteract.WasChecked = false -- to make sure handleinteract is done before enemy checks
function c_HQHandleInteract:evaluate()

	if ( ml_task_hub:CurrentTask().SPType == GetString("taskTypeInteractKill") or ml_task_hub:CurrentTask().SPType == "Commune" ) then 
		local radius = tonumber(ml_task_hub:CurrentTask().radius)
		if ( radius == 0 ) then radius = 8000 end
		
		-- to prevent hammering the "shortestpath"
		if ( e_HQHandleInteract.lastTarget ~= nil and e_HQHandleInteract.lastTargetID ~= nil and TimeSince(e_HQHandleInteract.lastQueryTmr) < 2000 ) then
			if ( ValidTable(CharacterList:Get(e_HQHandleInteract.lastTargetID)) or ValidTable(GadgetList:Get(e_HQHandleInteract.lastTargetID)) ) then			
				return true			
			end	
		end
		
		-- dont spam it when no target was found
		if (TimeSince(e_HQHandleInteract.lastQueryTmr) < 1000) then e_HQHandleInteract.WasChecked = false return false end 
		e_HQHandleInteract.lastQueryTmr = ml_global_information.Now
		e_HQHandleInteract.WasChecked = true
		
		if ( ml_task_hub:CurrentTask().interactContentIDs ~= nil and ml_task_hub:CurrentTask().interactContentIDs ~= "" and ValidString(ml_task_hub:CurrentTask().interactContentIDs) ) then
					
			-- Lets pray that no dumbnut entered bullshit into these ContentID fields -.-
			-- Search Charlist and Gadgetlist for the wanted targets
			local TargetList = CharacterList("shortestpath,onmesh,interactable,selectable,contentID="..ml_task_hub:CurrentTask().interactContentIDs..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then
					local tPos = entry.pos				
					if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
						e_HQHandleInteract.lastTarget = entry 
						e_HQHandleInteract.lastTargetID = id					
						return true
					end
				end
			end	
			
			local TargetList = GadgetList("shortestpath,onmesh,interactable,selectable,contentID="..ml_task_hub:CurrentTask().interactContentIDs..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then
					local tPos = entry.pos					
					if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
						e_HQHandleInteract.lastTarget = entry 
						e_HQHandleInteract.lastTargetID = id
						return true
					end
				end
			end	
			
		end
		
		if ( ml_task_hub:CurrentTask().interactContentID2s ~= nil  and ml_task_hub:CurrentTask().interactContentID2s ~= "" and ValidString(ml_task_hub:CurrentTask().interactContentID2s) ) then
			-- Search Gadgetlist for the wanted targets	
			local TargetList = GadgetList("shortestpath,onmesh,interactable,selectable,contentID2="..ml_task_hub:CurrentTask().interactContentID2s..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then				
					local tPos = entry.pos
					if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
						e_HQHandleInteract.lastTarget = entry
						e_HQHandleInteract.lastTargetID = id
						return true
					end
				end
			end	
		end
		
		e_HQHandleInteract.lastTarget = nil
		e_HQHandleInteract.lastTargetID = nil
		e_HQHandleInteract.lastQueryTmr = ml_global_information.Now
	end
	return false
end
function e_HQHandleInteract:execute()
	ml_log("HQHandleInteract ")
	if ( e_HQHandleInteract.lastTarget and e_HQHandleInteract.lastTarget.onmesh and e_HQHandleInteract.lastTarget.interactable and e_HQHandleInteract.lastTarget.selectable) then 
		if ( e_HQHandleInteract.lastTarget.isInInteractRange and e_HQHandleInteract.lastTarget.distance < 100) then
			Player:StopMovement()
			local target = Player:GetTarget()
			if (not target or target.id ~= e_HQHandleInteract.lastTarget.id) then
				Player:SetTarget(e_HQHandleInteract.lastTarget.id)
				return true
				
			else
				ml_log("Interact with Target.. ")
				if ( Player:GetCurrentlyCastedSpell() == 17 ) then	
					Player:Interact(e_HQHandleInteract.lastTarget.id)
					-- For TM Conditions
					ml_task_hub:CurrentTask().lastInteractTargetID = e_HQHandleInteract.lastTarget.id				
					ml_global_information.Wait(1000)					
				end
				return ml_log(true)				
			end
			
		else
			-- Get in range
			ml_log(" Getting in InteractRange, Distance:"..tostring(math.floor(e_HQHandleInteract.lastTarget.distance)))			
			local ePos = e_HQHandleInteract.lastTarget.pos
			local tRadius = e_HQHandleInteract.lastTarget.radius or 50
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
		e_HQHandleInteract.lastTarget = nil
		e_HQHandleInteract.lastTargetID = nil
		e_HQHandleInteract.lastQueryTmr = ml_global_information.Now
	end
	
	return ml_log(false)
end

-- Search n Kill the wanted Enemies
c_HQHandleKillEnemy = inheritsFrom( ml_cause )
e_HQHandleKillEnemy = inheritsFrom( ml_effect )
e_HQHandleKillEnemy.lastTarget = nil
e_HQHandleKillEnemy.lastTargetID = nil
e_HQHandleKillEnemy.lastQueryTmr = 0
function c_HQHandleKillEnemy:evaluate()
	
	if ( ml_task_hub:CurrentTask().SPType == GetString("taskTypeInteractKill") ) then 
		if ( ml_task_hub:CurrentTask().enemyContentIDs ~= nil and ml_task_hub:CurrentTask().enemyContentIDs ~= "" and  ValidString(ml_task_hub:CurrentTask().enemyContentIDs) ) then
			-- Lets pray that no dumbnut entered bullshit into these ContentID fields -.-
			
			-- to prevent hammering the "shortestpath"
			if ( e_HQHandleKillEnemy.lastTarget ~= nil and e_HQHandleKillEnemy.lastTargetID ~= nil and TimeSince(e_HQHandleKillEnemy.lastQueryTmr) < 2000 ) then
				if ( ValidTable(CharacterList:Get(e_HQHandleKillEnemy.lastTargetID)) or ValidTable(GadgetList:Get(e_HQHandleKillEnemy.lastTargetID)) ) then			
					return true			
				end	
			end
			
			-- dont spam it when no target was found
			if (e_HQHandleInteract.WasChecked == false or TimeSince(e_HQHandleKillEnemy.lastQueryTmr) < 1000) then return false end 
			e_HQHandleKillEnemy.lastQueryTmr = ml_global_information.Now
			
			
			-- Search Charlist and Gadgetlist for the wanted enemies
			local radius = tonumber(ml_task_hub:CurrentTask().radius)
			if ( radius == 0 ) then maxradius = 8000 end
			local TargetList = CharacterList("shortestpath,onmesh,attackable,selectable,alive,contentID="..ml_task_hub:CurrentTask().enemyContentIDs)
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then
					local tPos = entry.pos				 
					if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
						e_HQHandleKillEnemy.lastTarget = entry					
						e_HQHandleKillEnemy.lastTargetID = id					
						return true
					end
				end
			end	
			
			local TargetList = GadgetList("shortestpath,onmesh,attackable,selectable,alive,contentID="..ml_task_hub:CurrentTask().enemyContentIDs)
			if ( TargetList ) then
				local id,entry = next(TargetList)
				if (id and entry ) then
					local tPos = entry.pos				 
					if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
						e_HQHandleKillEnemy.lastTarget = entry					
						e_HQHandleKillEnemy.lastTargetID = id
						return true
					end
				end
			end	
			
		end
		e_HQHandleKillEnemy.lastTarget = nil
		e_HQHandleKillEnemy.lastTargetID = nil
		e_HQHandleKillEnemy.lastQueryTmr = ml_global_information.Now
	end
	return false
end
function e_HQHandleKillEnemy:execute()
	ml_log("HQHandleKillEnemy ")
	if ( e_HQHandleKillEnemy.lastTarget and e_HQHandleKillEnemy.lastTarget.onmesh and e_HQHandleKillEnemy.lastTarget.attackable and e_HQHandleKillEnemy.lastTarget.alive) then 
		Player:StopMovement()
		-- For TM Conditions
		ml_task_hub:CurrentTask().lastEnemyTargetID = e_HQHandleKillEnemy.lastTarget.id
		ml_task_hub:CurrentTask().lastTargetType = "character"
		
		-- Create new Subtask Combat
		local newTask = gw2_task_combat.Create()
		newTask.targetID = e_HQHandleKillEnemy.lastTarget.id		
		newTask.targetPos = e_HQHandleKillEnemy.lastTarget.pos
		if ( e_HQHandleKillEnemy.lastTarget.isGadget ) then
			newTask.targetType = "gadget"
			ml_task_hub:CurrentTask().lastTargetType = "gadget"
		end
		
		
		ml_task_hub:Add(newTask.Create(), IMMEDIATE_GOAL, TP_IMMEDIATE)
		return ml_log(true)
		
	end
	
	e_HQHandleKillEnemy.lastTarget = nil
	e_HQHandleKillEnemy.lastTargetID = nil
	e_HQHandleKillEnemy.lastQueryTmr = ml_global_information.Now
	return ml_log(false)
end






RegisterEventHandler("Module.Initalize",gw2_task_skillpoint.ModuleInit)
