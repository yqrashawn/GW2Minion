-- Goto Position x,y,z and interact with closest Vista - script for QuestManager
script = inheritsFrom( ml_task )
script.name = "DoSkillChallenge"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	-- You need to create the ScriptUI Elements exactly like you see here, the "event" needs to start with "tostring(identifier).." and the group needs to be GetString("questStepDetails")
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Goto X",tostring(identifier).."GotoX",GetString("questStepDetails"))
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Goto Y",tostring(identifier).."GotoY",GetString("questStepDetails"))
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Goto Z",tostring(identifier).."GotoZ",GetString("questStepDetails"))		
end

function script:SetData( identifier, tData )
	-- Save the data in our script-"instance" aka global variables and set the UI elements
	if ( identifier and tData ) then		
		--d("script:SetData: "..tostring(identifier))
				
		self.Data = tData
		
		-- Update the script UI (make sure the Data assigning to a _G is NOT nil! else crashboooombang!)
		if ( self.Data["GotoX"] ) then _G[tostring(identifier).."GotoX"] = self.Data["GotoX"] end
		if ( self.Data["GotoY"] ) then _G[tostring(identifier).."GotoY"] = self.Data["GotoY"] end
		if ( self.Data["GotoZ"] ) then _G[tostring(identifier).."GotoZ"] = self.Data["GotoZ"] end
	end
end

function script:EventHandler( identifier, event, value )
	-- for extended UI event handling, gets called when a scriptUI element is pressed	
	if ( event == "SetPosition" ) then
		local pPos = Player.pos
		if ( pPos ) then
			-- Set Data
			self.Data["GotoX"] = pPos.x		
			self.Data["GotoY"] = pPos.y
			self.Data["GotoZ"] = pPos.z
			-- Update UI fields
			_G[tostring(identifier).."GotoX"] = pPos.x
			_G[tostring(identifier).."GotoY"] = pPos.y
			_G[tostring(identifier).."GotoZ"] = pPos.z
		end
	end
	
end

--******************
-- ml_Task Functions
--******************
script.valid = true
script.completed = false
script.subtask = nil
script.process_elements = {}
script.overwatch_elements = {} 

function script:Init()
    -- Add Cause&Effects here
	-- Dead?
	self:add(ml_element:create( "Dead", c_dead, e_dead, 225 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 200 ), self.process_elements)
	
	-- AoELooting Characters
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 175 ), self.process_elements)
			
	-- Normal Chests	
	self:add(ml_element:create( "LootingChest", c_LootChests, e_LootChests, 155 ), self.process_elements)
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)	

	-- Normal Looting
	self:add(ml_element:create( "Looting", c_LootCheck, e_LootCheck, 130 ), self.process_elements)

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)	
	
	-- Aggro
	self:add(ml_element:create( "Aggro", self.c_Aggro, e_Aggro, 115 ), self.process_elements)
		
	-- Kill Stuff Nearby
	self:add(ml_element:create( "SearchAndKillNearby", c_SearchAndKillNearby, e_SearchAndKillNearby, 112 ), self.process_elements)
		
	-- GoTo Position
	self:add(ml_element:create( "GoToPosition", self.c_goto, self.e_goto, 110 ), self.process_elements)	
	
	self:AddTaskCheckCEs()
end


function script:task_complete_eval()		
	return false
end
function script:task_complete_execute()
   self.completed = true
end


script.c_Aggro = inheritsFrom( ml_cause )
function script.c_Aggro:evaluate() 	
	local pPos = Player.pos
	if (pPos and 
		tonumber(ml_task_hub:CurrentTask().Data["GotoX"]) ~= nil and
		tonumber(ml_task_hub:CurrentTask().Data["GotoY"]) ~= nil and
		tonumber(ml_task_hub:CurrentTask().Data["GotoZ"]) ~= nil and
		Distance3D( ml_task_hub:CurrentTask().Data["GotoX"],ml_task_hub:CurrentTask().Data["GotoY"],ml_task_hub:CurrentTask().Data["GotoZ"],pPos.x,pPos.y,pPos.z) > 3000
		) then		
		return Player.health.percent > 90 and TableSize(CharacterList("nearest,alive,aggro,attackable,maxdistance=1200,onmesh")) > 0 and ( Inventory.freeSlotCount > 0 or ( Inventory.freeSlotCount == 0 and not mc_ai_vendor.NeedToSell() or TableSize(mc_ai_vendor.GetClosestVendorMarker()) == 0 ))
	else
		return TableSize(CharacterList("nearest,alive,aggro,attackable,maxdistance=1200,onmesh")) > 0 and ( Inventory.freeSlotCount > 0 or ( Inventory.freeSlotCount == 0 and not mc_ai_vendor.NeedToSell() or TableSize(mc_ai_vendor.GetClosestVendorMarker()) == 0 ))
	end
	return false
end

-- Cause&Effect
script.c_goto = inheritsFrom( ml_cause )
script.e_goto = inheritsFrom( ml_effect )
function script.c_goto:evaluate() 	
	
	if (tonumber(ml_task_hub:CurrentTask().Data["GotoX"]) ~= nil and
		tonumber(ml_task_hub:CurrentTask().Data["GotoY"]) ~= nil and
		tonumber(ml_task_hub:CurrentTask().Data["GotoZ"]) ~= nil) then
		return true
	else
		ml_error("Quest GoToPosition Step has no Position set!")
	end
	return false
end
script.e_goto.tmr = 0
script.e_goto.threshold = 2000
script.e_goto.waittmr = 0
function script.e_goto:execute()
	ml_log("e_gotoSkillChallenge")
	local pPos = Player.pos
	if (pPos) then
		local dist = Distance3D( ml_task_hub:CurrentTask().Data["GotoX"],ml_task_hub:CurrentTask().Data["GotoY"],ml_task_hub:CurrentTask().Data["GotoZ"],pPos.x,pPos.y,pPos.z)
		ml_log("("..tostring(math.floor(dist))..")")
		if ( dist > 2500 ) then
			--d(tostring(ml_task_hub:CurrentTask().Data["GotoX"]).." "..tostring(ml_task_hub:CurrentTask().Data["GotoY"]).." "..tostring(ml_task_hub:CurrentTask().Data["GotoZ"]))
			MoveOnlyStraightForward()
			local navResult = tostring(Player:MoveTo(ml_task_hub:CurrentTask().Data["GotoX"],ml_task_hub:CurrentTask().Data["GotoY"],ml_task_hub:CurrentTask().Data["GotoZ"],35,false,false,true))		
			if (tonumber(navResult) < 0) then					
				d("e_gotoPosition result: "..tonumber(navResult))					
			end

			if ( mc_global.now - script.e_goto.tmr > script.e_goto.threshold ) then
				script.e_goto.tmr = mc_global.now
				script.e_goto.threshold = math.random(1000,5000)
				mc_skillmanager.HealMe()
			end				
			return ml_log(true)
		else
			c_Aggro.threshold = 99 -- sorry I'm lazy
			
			-- We already did this Skillmanager Quest
			if ( TableSize(MapMarkerList("onmesh,nearest,contentID=174711,maxdistance=1500")) > 0 ) then 
				d("We already finished this Skillpointchallenge!")
				ml_task_hub:CurrentTask().completed = true
			end
			
			local MList = MapMarkerList("onmesh,nearest,contentID=168712,maxdistance=3000,exclude_contentid="..mc_blacklist.GetExcludeString(GetString("mapobjects")))
			
			
				if ( TableSize(MList) > 0 ) then
					local id,entry = next(MList)
					if id and entry then
						if ( entry.distance <= 145 ) then
							
							local convOptions = Player:GetConversationOptions()
							if ( convOptions ) then
								Player:SelectConversationOptionByIndex(0)  --choose option 1		
								mc_global.Wait(5000)
								
							else
								-- SkillChallenge is a Character
								if ( entry.characterID > 0 ) then
									local t = Player:GetTarget()
									if ( t == nil or t.id ~= entry.characterID ) then
										Player:SetTarget(entry.characterID)
									else
										ml_log("Interacting with SkillChallenge ")									
										Player:Interact(t.id)									
										mc_global.Wait(5000)
									end						
								else
								-- Skillchallenge just needs to be used
									local objList = GadgetList("nearest,onmesh,interactable,maxdistance=750")		
									if ( TableSize(objList) > 0) then
										local i, object = next (objList)
										if (i and object) then
											d("Interacting with SKillChallenge-Point ")
											Player:Interact(object.id)
											mc_global.Wait(5000)
										end
									end
								end
							end
						else
							ml_log("SkillChallenge not in Range yet, trying to get closer..")
							local mPos = entry.pos
							if ( mPos ) then
								if ( c_DestroyGadget:evaluate() ) then e_DestroyGadget:execute() return end
								MoveOnlyStraightForward()
								local navResult = tostring(Player:MoveTo(mPos.x,mPos.y,mPos.z,35,false,false,false))
								if (tonumber(navResult) < 0) then					
									d("e_gotoSkillChallengePosition result: "..tonumber(navResult))					
								end
							else
								ml_error("SkillChallenge Marker has no position!")
							end						
						end				
					end
				else
				
					-- Somes skill markers cahnge to events, try interacting with closest.should be the thing we want
					local convOptions = Player:GetConversationOptions()
					if ( convOptions ) then
						Player:SelectConversationOptionByIndex(0)  --choose option 1		
						mc_global.Wait(1000)
						return
					else
						local t = Player:GetInteractableTarget()
						if ( t ) then
							d("Interacting with SkillChallenge-Guy ")
							Player:Interact(t.id)
							mc_global.Wait(1000)
							return
						end
					end
					
					-- waiting a bit more, sometimes these dudes stealth away -.-
					if ( script.e_goto.waittmr == 0 or Player.inCombat == true) then 
						script.e_goto.waittmr = mc_global.now 
					elseif ( mc_global.now - script.e_goto.waittmr > 5000 ) then
						d("Seems there is NO Skillpointchallenge Marker nearby, we should have finished this one!")
						ml_task_hub:CurrentTask().completed = true
					end
				end
		end
	end	
	return ml_log(false)
end


return script