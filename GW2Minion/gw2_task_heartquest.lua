-- This task is for the TaskManager and will try to do the most common HeartQuests...hopefully ^^
gw2_task_heartquest = inheritsFrom(ml_task)
gw2_task_heartquest.name = GetString("taskHeartQuest")

function gw2_task_heartquest.Create()
	local newinst = inheritsFrom(gw2_task_heartquest)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
	-- General fields	
	newinst.startTime = ml_global_information.Now
	newinst.HQType = "Interact&Kill" -- Different types of HQs
	newinst.enemyContentIDs = nil
	newinst.interactContentIDs = nil
	newinst.interactContentID2s = nil
	newinst.currentKills = 0	
	newinst.lastEnemyTargetID = nil
	newinst.lastTargetType = "character"
	newinst.lastInteractTargetID = nil
	newinst.currentInteracts = 0
	newinst.subRegion = nil
	newinst.pickupSkillID = nil
	newinst.pickupTargetIDs = nil
	newinst.checkHQNPCTimer = 0
	
	-- Reset some stuff
	e_StayNearHQ.walkingback = false
	
	

    return newinst
end

function gw2_task_heartquest:Init()

			
	-- Normal elements
	-- Revive Downed/Dead Partymember
	self:add(ml_element:create( "RevivePartyMember", c_RezzPartyMember, e_RezzPartyMember, 375 ), self.process_elements)	-- creates subtask: moveto
	-- Revive other Players
	self:add(ml_element:create( "RevivePlayer", c_reviveDownedPlayersInCombat, e_reviveDownedPlayersInCombat, 350 ), self.process_elements)	-- creates subtask: moveto
	
	-- PickupNUseOnTarget - for items that need to be used on a target, higher placed than aggro..lets pray it works lol
	self:add(ml_element:create( "PickupNUseOnTarget", c_PickupNUseOnTarget, e_PickupNUseOnTarget, 335 ), self.process_elements)
	
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
	
	-- Checks if we have the HQ completed by walking to where the NPC should stand
	self:add(ml_element:create( "CheckHQCompleted", c_CheckHQCompleted, e_CheckHQCompleted, 230 ), self.process_elements)	

	-- DoEvents
	--self:add(ml_element:create( "DoEvent", c_doEvents, e_doEvents, 215 ), self.process_elements) would need a custom c_doEvents to not run away from the spot here
	
	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 200 ), self.process_elements) -- creates subtask: moveto
	
	-- Gathering
	--self:add(ml_element:create( "Gathering", c_GatherTask, e_GatherTask, 175 ), self.process_elements) -- creates subtask: gatheringTask 
		
	-- Finish Enemy
	self:add(ml_element:create( "FinishEnemy", c_FinishEnemy, e_FinishEnemy, 150 ), self.process_elements)
	
	-- Stay near HQ
	self:add(ml_element:create( "StayNearHQ", c_StayNearHQ, e_StayNearHQ, 125 ), self.process_elements)

	-- HandleConversation
	self:add(ml_element:create( "HandleConversation", c_HandleConversation, e_HandleConversation, 100 ), self.process_elements)	
			
	-- If a interact contentID / ID2 was given, this will make the bot walk there and interact
	self:add( ml_element:create( "HandleInteract", c_HQHandleInteract, e_HQHandleInteract, 75 ), self.process_elements)

	-- If a Enemy contentID was given, this will make the bot walk there and attack it
	self:add( ml_element:create( "HandleKillEnemy", c_HQHandleKillEnemy, e_HQHandleKillEnemy, 50 ), self.process_elements)
	
	-- Idle check
	self:add( ml_element:create( "IdleCheck", c_IdleCheck, e_IdleCheck, 25 ), self.process_elements)


	self:AddTaskCheckCEs()
end

function gw2_task_heartquest:task_complete_eval()
	-- Check for nearby unfinished HQs
	if ( ml_task_hub:CurrentTask().started == true and ml_task_hub:CurrentTask().mappos ~= nil and ml_task_hub:CurrentTask().pos ~= nil  ) then
		
		local dist = Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)		
		local maxradius = tonumber(ml_task_hub:CurrentTask().radius)
		if ( maxradius == 0 ) then maxradius = 6000 end
		if ( dist < maxradius ) then
		--d(TableSize(MapMarkerList("onmesh,contentID="..GW2.MAPMARKER.HeartQuest)))
			if ( ml_task_hub:CurrentTask().subRegion ~= nil and tonumber(ml_task_hub:CurrentTask().subRegion) ) then
				
				-- HQs are tricky, there are always 2 markers, 1 permanently available and 1 only available when beeing nearby, representing the connected NPC (where we get the "complete" info from)
				-- Try to get the NPC-Marker first
				local evList = MapMarkerList("onmesh,issubregion")
				local id,marker = next (evList)
				while ( id and marker ) do
					if ( marker.subregionID == tonumber(ml_task_hub:CurrentTask().subRegion) ) then						
						
						if ( marker.contentID == GW2.MAPMARKER.HeartQuest ) then							
							c_CheckHQCompleted.markerPos = nil
							c_CheckHQCompleted.needCompletionCheck = false							
							return false-- we found our unfinished HQ NPC
						
						elseif ( marker.contentID == GW2.MAPMARKER.HeartQuestComplete ) then							
							d("Completed Heartquest with SubRegionID "..tostring(ml_task_hub:CurrentTask().subRegion).." found, exiting task")
							c_CheckHQCompleted.markerPos = nil
							c_CheckHQCompleted.needCompletionCheck = false
							ml_task_hub:CurrentTask().completed = true
							return true -- we found our finished HQ NPC
						end
					end
					id,marker = next(evList,id)					
				end
				
				-- If we are here, it means we are not close enough to the HQ to see the NPC (and completion data)
				-- 1st time this is the case, we walk back to where the HQ position actually is and check if we completed the HQ or not				
				if ( ml_task_hub:CurrentTask().checkHQNPCTimer == 0 ) then
					-- Walk back to HQ
					c_CheckHQCompleted.needCompletionCheck = true
					ml_task_hub:CurrentTask().checkHQNPCTimer = ml_global_information.Now
				
				else
				
					if ( c_CheckHQCompleted.needCompletionCheck == false ) then
						-- we should have visited/found the HQ-NPC by now and the StayNearHQ should move our bot back to the HQtask position
						-- reset the checkHQNPCTimer that makes the bot walk to HQ NPC again after half the HQ task time or 10 minutes
						local nextHQCheck = 600
						if ( tonumber(ml_task_hub:CurrentTask().maxduration) ~= 0 and tonumber(ml_task_hub:CurrentTask().maxduration) > 180 and tonumber(ml_task_hub:CurrentTask().maxduration) < 6000) then
							nextHQCheck = tonumber(ml_task_hub:CurrentTask().maxduration)
						end
						
						if ( (nextHQCheck-(TimeSince(ml_task_hub:CurrentTask().checkHQNPCTimer)/1000)) < 0 ) then
							ml_task_hub:CurrentTask().checkHQNPCTimer = ml_global_information.Now
							c_CheckHQCompleted.needCompletionCheck = true
							d("Walking to HQ for completion check..")
							
						else
							ml_log(", HQ Check: "..tostring(nextHQCheck-(TimeSince(ml_task_hub:CurrentTask().checkHQNPCTimer)/1000)).."s, ")
						end
						
					end					
				end
			
			else
				
				ml_error("No subregion was set in HeartQuest Task, YOU NEED TO SET THE SUBREGION ID!")
				ml_task_hub:CurrentTask().completed = true
				return true
			end
		else
			ml_log("Distance to HQ: "..tostring(dist))
			
		end
	end
	return false
end

function gw2_task_heartquest:UIInit()	
	return true
end
function gw2_task_heartquest:UIDestroy()
	
end

function gw2_task_heartquest.ModuleInit()
	d("gw2_task_heartquest:ModuleInit")

	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("HQ Type","dbHQType","Task_HeartQuest")
		dw:NewField("HQ SubRegionID","dbHQSubRegionID","Task_HeartQuest")
		dw:NewField("Duration","dbHQDuration","Task_HeartQuest")
		dw:NewField("KillCount","dbHQKillcount","Task_HeartQuest")
		dw:NewField("Kill ContentIDs","dbHQKillIDs","Task_HeartQuest")
		dw:NewField("Interact Count","dbHQInteractcount","Task_HeartQuest")
		dw:NewField("Interact ContentIDs","dbHQInteractIDs","Task_HeartQuest")
		dw:NewField("Interact ContentID2s","dbHQInteractID2s","Task_HeartQuest")
	end
	
	ml_task_mgr.AddTaskType(GetString("taskHeartQuest"), gw2_task_heartquest) -- Allow this task to be selectable in TaskManager
end

-- TaskManager functions
function gw2_task_heartquest:UIInit_TM()
	--ml_task_mgr.NewField("maxkills", "beer")
	ml_task_mgr.NewCombobox("HQ Type", "HQType", "Interact&Kill,Pickup&Use") -- add more types here later if needed
	ml_task_mgr.NewField("HQ SubRegionID", "subRegion")
	ml_task_mgr.NewNumeric("Max Kills", "maxKills")
	ml_task_mgr.NewField("Enemy ContentIDs", "enemyContentIDs")
	ml_task_mgr.NewNumeric("Max Interacts", "maxInteracts")
	ml_task_mgr.NewField("Interact ContentIDs", "interactContentIDs")
	ml_task_mgr.NewField("Interact ContentID2s", "interactContentID2s")
	-- Pickup&Use
	-- ml_task_mgr.NewField("Pickup ContentIDs", "pickupSkillID") using the interact contentIDs for now until there is a HQ where this doesnt work ^^
	ml_task_mgr.NewField("Bundle SkillID", "pickupSkillID")
	ml_task_mgr.NewField("Bundle TargetIDs", "pickupTargetIDs")
	

end
-- TaskManager function: Checks for custom conditions to start this task, this is checked before the task is selected to be enqueued/created
function gw2_task_heartquest.CanTaskStart_TM()	
	return true
end
-- TaskManager function: Checks for custom conditions to keep this task running, this is checked during the task is actively running
function gw2_task_heartquest.CanTaskRun_TM()
	
	-- since this is called independent of the tasksystem, it 
	if ( ml_task_hub:CurrentTask().startTime ~= nil ) then
		dbHQDuration = tostring(math.floor((ml_global_information.Now-ml_task_hub:CurrentTask().startTime)/1000))
	end
	
	if ( ml_global_information.ShowDebug ) then 
		dbHQKillIDs = tostring(ml_task_hub:CurrentTask().enemyContentIDs)
		dbHQInteractIDs = tostring(ml_task_hub:CurrentTask().interactContentIDs)
		dbHQInteractID2s = tostring(ml_task_hub:CurrentTask().interactContentID2s)
	end
	-- Check the maxkill counter
	if ( ml_task_hub:CurrentTask().maxKills ~= nil and tonumber(ml_task_hub:CurrentTask().maxKills) and tonumber(ml_task_hub:CurrentTask().maxKills) ~= 0 ) then
			
		if ( ml_global_information.ShowDebug ) then 
			dbHQKillcount = tostring(ml_task_hub:CurrentTask().currentKills).."/"..tostring(ml_task_hub:CurrentTask().maxKills).." Kills"
		end
		
		ml_log(" "..tostring(ml_task_hub:CurrentTask().currentKills).."/"..tostring(ml_task_hub:CurrentTask().maxKills).." Kills")
		
		-- We killed enough
		if ( tonumber(ml_task_hub:CurrentTask().maxKills) <=  ml_task_hub:CurrentTask().currentKills ) then return false end 
				
		-- Check if a targeted enemy got killed meanwhile
		if ( ml_task_hub:CurrentTask().lastEnemyTargetID ~= nil and tonumber(ml_task_hub:CurrentTask().lastEnemyTargetID) ~= nil) then
			local target = nil
			
			if ( ml_task_hub:CurrentTask().lastTargetType == "character" ) then
				target = CharacterList:Get(tonumber(ml_task_hub:CurrentTask().lastEnemyTargetID))
			else
				target = GadgetList:Get(tonumber(ml_task_hub:CurrentTask().lastEnemyTargetID))
			end
			
			if ( not target or not target.alive or not target.attackable) then
				ml_task_hub:CurrentTask().currentKills = tonumber(ml_task_hub:CurrentTask().currentKills) + 1
				ml_task_hub:CurrentTask().lastEnemyTargetID = nil
			end
		end
	end	
			
	
	-- Check the maxinteract counter
	if ( ml_task_hub:CurrentTask().maxInteracts ~= nil and tonumber(ml_task_hub:CurrentTask().maxInteracts)and tonumber(ml_task_hub:CurrentTask().maxInteracts) ~= 0 ) then
			
		if ( ml_global_information.ShowDebug ) then 
			dbHQInteractcount = tostring(ml_task_hub:CurrentTask().currentInteracts).."/"..tostring(ml_task_hub:CurrentTask().maxInteracts).." Interacts"
		end
		
		ml_log(" "..tostring(ml_task_hub:CurrentTask().currentInteracts).."/"..tostring(ml_task_hub:CurrentTask().maxInteracts).." Interacts")
						
		-- We killed enough
		if ( tonumber(ml_task_hub:CurrentTask().maxInteracts) <=  ml_task_hub:CurrentTask().currentInteracts ) then return false end 
				
		-- Check if a targeted enemy got killed meanwhile
		if ( ml_task_hub:CurrentTask().lastInteractTargetID ~= nil and tonumber(ml_task_hub:CurrentTask().lastInteractTargetID) ~= nil) then
						
			local target = GadgetList:Get(tonumber(ml_task_hub:CurrentTask().lastInteractTargetID))
			
			if ( not target ) then 
				target = CharacterList:Get(tonumber(ml_task_hub:CurrentTask().lastInteractTargetID))
			end
			
			if ( not target or not target.selectable or not target.interactable) then
				ml_task_hub:CurrentTask().currentInteracts = tonumber(ml_task_hub:CurrentTask().currentInteracts) + 1
				ml_task_hub:CurrentTask().lastInteractTargetID = nil
			end
		end
	end	
	return true
end

-- Custom c_FightAggro, to help not fuck up pickupnUse types of HQ
c_FightAggroHQ = inheritsFrom( ml_cause )
function c_FightAggroHQ:evaluate()
	
	if ( ml_task_hub:CurrentTask().HQType == "Pickup&Use") then
		if ( e_PickupNUseOnTarget.lastSlotWithOurSkillID == nil ) then
			return c_FightAggro:evaluate()
		end		
	else	
		return c_FightAggro:evaluate()
	end
	return false
end


c_CheckHQCompleted = inheritsFrom( ml_cause )
e_CheckHQCompleted = inheritsFrom( ml_effect )
c_CheckHQCompleted.needCompletionCheck = false
c_CheckHQCompleted.markerPos = nil
function c_CheckHQCompleted:evaluate()
	
	if ( c_CheckHQCompleted.needCompletionCheck ) then
		
		if ( c_CheckHQCompleted.markerPos == nil ) then
		-- get our current HQ marker pos
		
			local evList = MapMarkerList("issubregion")
			local id,marker = next (evList)
			while ( id and marker ) do
				if ( marker.subregionID == tonumber(ml_task_hub:CurrentTask().subRegion) ) then						
					c_CheckHQCompleted.markerPos = marker.pos
					return true
				end
				id,marker = next(evList,id)					
			end
			
			-- no marker with our subregion ID found..we should never be here
			ml_error("HeartQuest SubRegionID "..tostring(ml_task_hub:CurrentTask().subRegion).." could NOT be found, make sure it is correct!")
			c_CheckHQCompleted.needCompletionCheck = true
			
		else
		
			return true
		end
	end
	c_CheckHQCompleted.markerPos = nil
	c_CheckHQCompleted.needCompletionCheck = false
	return false
end
function e_CheckHQCompleted:execute()
	ml_log("Returning to HQ, for completion check")
		
	local dist = Distance3D(c_CheckHQCompleted.markerPos.x,c_CheckHQCompleted.markerPos.y,c_CheckHQCompleted.markerPos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)
	
	if ( dist > 500 ) then
		if ( not gw2_unstuck.HandleStuck() ) then
			local navResult = tostring(Player:MoveTo(c_CheckHQCompleted.markerPos.x,c_CheckHQCompleted.markerPos.y,c_CheckHQCompleted.markerPos.z,250,false,false,false))		
			if (tonumber(navResult) < 0) then					
				d("e_CheckHQCompleted result: "..tonumber(navResult))
			else				
				return ml_log(true)
			end
		end
		ml_task_hub:CurrentTask().checkHQNPCTimer = ml_global_information.Now
	
	else
		-- we arrived at the HQ position
		c_CheckHQCompleted.markerPos = nil
		c_CheckHQCompleted.needCompletionCheck = false
		
	end

	ml_task_hub:CurrentTask().checkHQNPCTimer = ml_global_information.Now
	return ml_log(true)
end


-- Makes sure we stay inside the radius of our Task, near the task position
c_StayNearHQ = inheritsFrom( ml_cause )
e_StayNearHQ = inheritsFrom( ml_effect )
e_StayNearHQ.walkingback = false
e_StayNearHQ.walkingbackRandomPos = nil
function c_StayNearHQ:evaluate()
	
	if ( e_StayNearHQ.walkingback ) then return true end 
	
	if ( ml_task_hub:CurrentTask().pos ~= nil ) then
		local startPos = ml_task_hub:CurrentTask().pos
		local dist = Distance3D(startPos.x,startPos.y,startPos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)
		
		local maxradius = tonumber(ml_task_hub:CurrentTask().radius)
		if ( maxradius == 0 ) then maxradius = 6000 end
		
		if ( dist > maxradius ) then
			--this will make the TM to walk back to the startposition of this task, randomize this pos a bit
			if ( maxradius > 750 ) then
				local rPos = NavigationManager:GetRandomPointOnCircle(startPos.x,startPos.y,startPos.z,250,750)
				if ( rPos ) then
					e_StayNearHQ.walkingbackRandomPos = rPos
				else
					e_StayNearHQ.walkingbackRandomPos = nil
				end
			end
			return true			
		end		
	end
	e_StayNearHQ.walkingbackRandomPos = nil
	e_StayNearHQ.walkingback = false
	return false
end
function e_StayNearHQ:execute()
	ml_log("e_StayNearHQ ")
	if ( not gw2_unstuck.HandleStuck() ) then
		local navResult = 0
		if ( e_StayNearHQ.walkingbackRandomPos ~= nil ) then
			navResult = tostring(Player:MoveTo(e_StayNearHQ.walkingbackRandomPos.x,e_StayNearHQ.walkingbackRandomPos.y,e_StayNearHQ.walkingbackRandomPos.z,100,false,false,false))
		else
			navResult = tostring(Player:MoveTo(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,250,false,false,false))
		end
		if (tonumber(navResult) < 0) then					
			d("e_StayNearHQ result: "..tonumber(navResult))
		else
			e_StayNearHQ.walkingback = true
			ml_task_hub:CurrentTask().checkHQNPCTimer = ml_global_information.Now -- update the timer for HQ check while walking back
			return ml_log(true)
		end
	end
	e_StayNearHQ.walkingback = false
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
					ml_global_information.Wait(1200)
					return ml_log(true)
				end
			else
				if ( option.index == 0 ) then 
					d("Selecting First Chatoption:"..tostring(option.type))
					Player:SelectConversationOption(option.type)
					e_HandleConversation.nextChatOption = nil
					ml_global_information.Wait(1200)
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


-- Handles the usage of items on specific enemies
c_PickupNUseOnTarget = inheritsFrom( ml_cause )
e_PickupNUseOnTarget = inheritsFrom( ml_effect )
e_PickupNUseOnTarget.lastSlotWithOurSkillID = nil
e_PickupNUseOnTarget.lastTargetIDForOurSkillID = nil
e_PickupNUseOnTarget.lastTargetForOurSkillID = nil
function c_PickupNUseOnTarget:evaluate()
	if ( ml_task_hub:CurrentTask().HQType == "Pickup&Use") then
		-- c_HQHandleInteract should have picked up the item we wanted
		
		if ( ml_task_hub:CurrentTask().pickupSkillID ~= nil and ml_task_hub:CurrentTask().pickupSkillID ~= "" and ml_task_hub:CurrentTask().pickupTargetIDs ~= nil and ml_task_hub:CurrentTask().pickupTargetIDs ~= "") then 
		
			local skillready = false
			
			-- Check if we got the bundle/thing picked up by SkillID
			if ( e_PickupNUseOnTarget.lastSlotWithOurSkillID ~= nil and tonumber(e_PickupNUseOnTarget.lastSlotWithOurSkillID) ) then
				-- check if skillID is still there				
				local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_"..e_PickupNUseOnTarget.lastSlotWithOurSkillID])
				if ( skill and skill.skillID == tonumber(ml_task_hub:CurrentTask().pickupSkillID) ) then
					skillready = true
				end
			
			else
				-- Check out current skillset for the skillID we need				
				
				for i = 1, 5, 1 do
					local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_"..i])					
					if (skill and skill.skillID == tonumber(ml_task_hub:CurrentTask().pickupSkillID) ) then
						e_PickupNUseOnTarget.lastSlotWithOurSkillID = i
						skillready = true						
					end
				end
			end
			
			-- Check for targets for our skillID
			if ( skillready ) then
				-- to prevent hammering the "shortestpath"
				if ( ValidTable(CharacterList:Get(e_PickupNUseOnTarget.lastTargetIDForOurSkillID)) or ValidTable(GadgetList:Get(e_PickupNUseOnTarget.lastTargetIDForOurSkillID)) ) then			
					return true				
				end
						
			
				-- Check Gadget & Charlist for target
				local radius = tonumber(ml_task_hub:CurrentTask().radius)
				if ( radius == 0 ) then radius = 8000 end
				local TargetList = CharacterList("shortestpath,onmesh,selectable,alive,contentID="..ml_task_hub:CurrentTask().pickupTargetIDs)
				if ( TargetList ) then
					local id,entry = next(TargetList)
					if (id and entry ) then
						local tPos = entry.pos				 
						if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
							e_PickupNUseOnTarget.lastTargetIDForOurSkillID = id	
							e_PickupNUseOnTarget.lastTargetForOurSkillID = entry
							return true
						end
					end
				end	
				
				local TargetList = GadgetList("shortestpath,onmesh,selectable,alive,contentID="..ml_task_hub:CurrentTask().pickupTargetIDs)
				if ( TargetList ) then
					local id,entry = next(TargetList)
					if (id and entry ) then
						local tPos = entry.pos				 
						if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
							e_PickupNUseOnTarget.lastTargetIDForOurSkillID = id
							e_PickupNUseOnTarget.lastTargetForOurSkillID = entry
							return true
						end
					end
				end	
				local TargetList = GadgetList("shortestpath,onmesh,selectable,alive,contentID2="..ml_task_hub:CurrentTask().pickupTargetIDs)
				if ( TargetList ) then
					local id,entry = next(TargetList)
					if (id and entry ) then
						local tPos = entry.pos				 
						if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
							e_PickupNUseOnTarget.lastTargetIDForOurSkillID = id
							e_PickupNUseOnTarget.lastTargetForOurSkillID = entry
							return true
						end
					end
				end	
			end
		end
	end
	
	e_PickupNUseOnTarget.lastSlotWithOurSkillID = nil
	e_PickupNUseOnTarget.lastTargetIDForOurSkillID = nil	
	return false
end
function e_PickupNUseOnTarget:execute()
	ml_log("e_PickupNUseOnTarget ")
	if ( e_PickupNUseOnTarget.lastTargetForOurSkillID and e_PickupNUseOnTarget.lastTargetForOurSkillID.onmesh and e_PickupNUseOnTarget.lastTargetForOurSkillID.selectable and e_PickupNUseOnTarget.lastTargetForOurSkillID.alive) then 
		
		-- For TM Conditions
		ml_task_hub:CurrentTask().lastInteractTargetID = e_PickupNUseOnTarget.lastTargetIDForOurSkillID
		ml_task_hub:CurrentTask().lastTargetType = "character"
		
		
		-- get skill
		local myskill = nil
		if ( e_PickupNUseOnTarget.lastSlotWithOurSkillID ~= nil and tonumber(e_PickupNUseOnTarget.lastSlotWithOurSkillID) ) then		
			local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. e_PickupNUseOnTarget.lastSlotWithOurSkillID])
			if ( skill and skill.skillID == tonumber(ml_task_hub:CurrentTask().pickupSkillID) ) then
				myskill = skill
			end
		end
		
		
		if ( myskill ) then
		
			-- Try to use the skillID on the target
			if ( e_PickupNUseOnTarget.lastTargetForOurSkillID.isGadget ) then			
				ml_task_hub:CurrentTask().lastTargetType = "gadget"
			end
			
			local attackdistance = myskill.maxRange - 50
			if ( not attackdistance or attackdistance < 154 ) then
				attackdistance = 154
			end
			
			-- Get inrange
			if ( e_PickupNUseOnTarget.lastTargetForOurSkillID.distance > attackdistance ) then
				
				local ePos = e_PickupNUseOnTarget.lastTargetForOurSkillID.pos
				if ( not gw2_unstuck.HandleStuck() ) then					
					
					local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,50,false,false,false))		
					if (tonumber(navResult) < 0) then					
						d("e_PickupNUseOnTarget result: "..tonumber(navResult))
					else
						return ml_log(true)
					end
				end
			
			else
				-- attack
				
				Player:StopMovement()
				local t = Player:GetTarget()
				if ( not t or t.id ~= e_PickupNUseOnTarget.lastTargetIDForOurSkillID ) then
					Player:SetTarget(e_PickupNUseOnTarget.lastTargetIDForOurSkillID)
				else
					
					Player:CastSpell(myskill.slot,e_PickupNUseOnTarget.lastTargetIDForOurSkillID)					
					return ml_log(true)
				end				
				
			end
			
		else
			ml_error("e_PickupNUseOnTarget cant find the needed skill!")
		end
	end
	
	e_PickupNUseOnTarget.lastTargetForOurSkillID = nil
	e_PickupNUseOnTarget.lastTargetIDForOurSkillID = nil	
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
		local TargetList = CharacterList("shortestpath,onmesh,interactable,selectable,contentID="..string.gsub(ml_task_hub:CurrentTask().interactContentIDs,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
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
		
		local TargetList = GadgetList("shortestpath,onmesh,interactable,selectable,contentID="..string.gsub(ml_task_hub:CurrentTask().interactContentIDs,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
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
		local TargetList = GadgetList("shortestpath,onmesh,interactable,selectable,contentID2="..string.gsub(ml_task_hub:CurrentTask().interactContentID2s,",",";")..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
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
	return false
end
function e_HQHandleInteract:execute()
	ml_log("HQHandleInteract ")
	if ( e_HQHandleInteract.lastTarget and e_HQHandleInteract.lastTarget.onmesh and e_HQHandleInteract.lastTarget.interactable and e_HQHandleInteract.lastTarget.selectable) then 
		if ( e_HQHandleInteract.lastTarget.isInInteractRange and e_HQHandleInteract.lastTarget.distance < 120) then
			Player:StopMovement()
			local target = Player:GetTarget()
			if (not target or target.id ~= e_HQHandleInteract.lastTarget.id) then
				Player:SetTarget(e_HQHandleInteract.lastTarget.id)
				return true
				
			else
				ml_log("Interact with Target.. ")
				if ( Player:GetCurrentlyCastedSpell() == ml_global_information.MAX_SKILLBAR_SLOTS ) then	
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
				local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,tRadius,false,false,true))		
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
		if ( radius == 0 ) then radius = 8000 end
		local TargetList = CharacterList("shortestpath,onmesh,attackable,selectable,alive,contentID="..string.gsub(ml_task_hub:CurrentTask().enemyContentIDs,",",";"))
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
		
		local TargetList = GadgetList("shortestpath,onmesh,attackable,selectable,alive,contentID="..string.gsub(ml_task_hub:CurrentTask().enemyContentIDs,",",";"))
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
		
		local TargetList = GadgetList("shortestpath,onmesh,attackable,selectable,alive,contentID2="..string.gsub(ml_task_hub:CurrentTask().enemyContentIDs,",",";"))
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

-- to force moving back to our starting position after xxx seconds of nothing to do
c_IdleCheck = inheritsFrom( ml_cause )
e_IdleCheck = inheritsFrom( ml_effect )
e_IdleCheck.lasttick = ml_global_information.Now
e_IdleCheck.idleTimer = 0
function c_IdleCheck:evaluate()
	
	return true
end
function e_IdleCheck:execute()
	ml_log("e_IdleCheck ")
	if ( TimeSince(e_IdleCheck.lasttick) > 2000 ) then
		-- we did something else before, reset the timer
		e_IdleCheck.idleTimer = 0
		
	else
		-- we are here again, seems our bot just stands around doing nothing, start counting
		if ( e_IdleCheck.idleTimer == 0 ) then 
			e_IdleCheck.idleTimer = ml_global_information.Now
		else
			if (TimeSince(e_IdleCheck.idleTimer) > 10000 ) then
				-- walk back to startposition
				e_StayNearHQ.walkingback = true				
				e_IdleCheck.idleTimer = 0
			end
		end
		
	end	
	e_IdleCheck.lasttick = ml_global_information.Now
	return ml_log(false)
end
RegisterEventHandler("Module.Initalize",gw2_task_heartquest.ModuleInit)
