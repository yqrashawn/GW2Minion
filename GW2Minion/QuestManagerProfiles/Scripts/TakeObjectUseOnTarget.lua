-- Interact with object Quest
script = inheritsFrom( ml_task )
script.name = "TakeObjectUseOnTarget"
script.Data = {}
script.CheckBox = "false"

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Take Object ID",tostring(identifier).."InteractObject",GetString("questStepDetails"))
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Use On Target ID",tostring(identifier).."TargetID",GetString("questStepDetails"))
	GUI_NewField(ml_quest_mgr.stepwindow.name,"isHeartQuest",tostring(identifier).."isHQ",GetString("questStepDetails"))
	GUI_NewButton(ml_quest_mgr.stepwindow.name,"Set Object ID",tostring(identifier).."SetObjectID",GetString("questStepDetails"))
	GUI_NewButton(ml_quest_mgr.stepwindow.name,"Set Target ID",tostring(identifier).."SetTargetID",GetString("questStepDetails"))
	GUI_NewButton(ml_quest_mgr.stepwindow.name,"HeartQuest/Not HeartQuest",tostring(identifier).."SetisHQ",GetString("questStepDetails"))
		
end

function script:SetData( identifier, tData )
	if ( identifier and tData ) then		
				
		self.Data = tData
		
		if ( self.Data["InteractObject"] ) then _G[tostring(identifier).."InteractObject"] = self.Data["InteractObject"] end
		if ( self.Data["TargetID"] ) then _G[tostring(identifier).."TargetID"] = self.Data["TargetID"] end
		if ( self.Data["isHQ"] ) then _G[tostring(identifier).."isHQ"] = self.Data["isHQ"] end
		
	end
end


function script:EventHandler( identifier, event, value )
	if ( event == "SetObjectID" ) then
	local t = Player:GetTarget()
		if ( t ) then
			-- Set Data
			self.Data["InteractObject"] = t.contentID	

			-- Update UI fields
			_G[tostring(identifier).."InteractObject"] = t.contentID
		end
	end

	
	if ( event == "SetTargetID" ) then
	local e = Player:GetTarget()
		if ( e ) then
			 --Set Data
			self.Data["TargetID"] = e.contentID

			-- Update UI fields
			_G[tostring(identifier).."TargetID"] = e.contentID
		end
	end
	
	if ( event == "SetisHQ" ) then
		if(script.CheckBox == "false")then
			 --Set Data
			self.Data["isHQ"] = "true"
			script.CheckBox = "true"

			-- Update UI fields
			_G[tostring(identifier).."isHQ"] = "true"
		else
						 --Set Data
			self.Data["isHQ"] = "false"
			script.CheckBox = "false"
			-- Update UI fields
			_G[tostring(identifier).."isHQ"] = "false"
			
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
	self:add(ml_element:create( "Dead", c_dead, e_dead, 300 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 280 ), self.process_elements)
	
	
	-- Aggro
	self:add(ml_element:create( "Aggro", c_gotAggro, e_gotAggro, 180 ), self.process_elements) 
	
	-- Resting
	
	self:add(ml_element:create( "Resting", c_resting, e_resting, 160 ), self.process_elements)
	
	-- Normal Looting
	self:add(ml_element:create( "Looting", c_event_LootCheck, e_Loot, 140 ), self.process_elements)	
	
	--  Move to Object, Take Object, Move to Target, Use Object on Target
	self:add(ml_element:create( "gotoObject", self.c_gotoObject, self.e_gotoObject, 110), self.process_elements)
	
		
	--Check if we are doing HQ and if it is completed
	self:add(ml_element:create( "ChkHQCompletion", self.c_checkHQ, self.e_checkHQ, 100), self.process_elements)
	
			
	
	self:AddTaskCheckCEs()
end




function script:task_complete_eval()	
	return false
end

function script:task_complete_execute()
   self.completed = true
end


script.c_checkHQ = inheritsFrom( ml_cause )
script.e_checkHQ = inheritsFrom( ml_effect )

function script.c_checkHQ:evaluate()
  --checking if we are doing HQ
	if(tostring(ml_task_hub:CurrentTask().Data["isHQ"]) == "false") then
	return false
	end
	
	local HQList = MapMarkerList("onmesh,maxdistance=2800,type=356")

		if ( TableSize(HQList) > 0) then
			return true
		end

	script:task_complete_execute()
	return false
end

function script.e_checkHQ:execute()
	ml_log("e_checkHQ")
	local HQList = MapMarkerList("onmesh,maxdistance=2800,type=356")
	if ( TableSize(HQList) > 0) then
			script.HQdone = false
			return ml_log(true)
	else
		script:task_complete_execute()
	end		
end

script.c_gotoObject = inheritsFrom( ml_cause )
script.e_gotoObject = inheritsFrom( ml_effect )
script.ObjectTook = false
script.Turn = 0


function script.c_gotoObject:evaluate()
	if (tonumber(ml_task_hub:CurrentTask().Data["InteractObject"]) and
		tonumber(ml_task_hub:CurrentTask().Data["TargetID"]) ~= nil) then
		return true
	else
		ml_error("Quest GoToPosition Step has no Position set!")
	end
	return false
end



function script.e_gotoObject:execute()
	ml_log("e_gotoObject")

		local oID = ml_task_hub:CurrentTask().Data["InteractObject"]
		local tID =  ml_task_hub:CurrentTask().Data["TargetID"]
		local objList = GadgetList("nearest,onmesh,interactable,maxdistance=1500,contentID="..oID)
		local targList = CharacterList("nearest,onmesh,interactable,contentid="..tID)
		
		if ( TableSize(objList) > 0) then
			local i, object = next (objList)
			if (i and object and script.ObjectTook == false) then
			
				if (not object.isInInteractRange) then
				-- Move into range of Object
					local tPos = object.pos
					if ( tPos ) then
						local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,35,false,true,true))		
						if (tonumber(navResult) < 0) then
							ml_error("move to object result: "..tonumber(navResult))					
						end
						ml_log("Move To Object..")
						return true
					end
				else
	
			
					-- take the object
					Player:StopMovement()
					Player:Interact(oID)
					script.ObjectTook = true
				end
				
			end
			if ( TableSize(targList) > 0 and script.ObjectTook == true) then
				local c, target = next (targList)
				if (c and target ) then
					if (not target.isInInteractRange) then
					-- Move into range of Target
						local aPos = target.pos
						if ( aPos ) then
							local navResult = tostring(Player:MoveTo(aPos.x,aPos.y,aPos.z,35,false,true,true))		
							if (tonumber(navResult) < 0) then
								ml_error("move to Target location: "..tonumber(navResult))					
							end
							ml_log("Move to Target..")
							return true
						end
					else
	
			
						-- Use Object on target
						Player:StopMovement()
						Player:Interact(tID)
						script.ObjectTook = false
						
						--we check if we are really doing HQ  ifnot , we stop after it arrived at his destination.
						if(tostring(ml_task_hub:CurrentTask().Data["isHQ"]) == "false") then
							script:task_complete_execute()
						end
						return true
					end
				end
			end
		else
		-- This is to prevent the bot to prematuraly stop doing the task if the target can't recieve objects for a short time 
			if(script.Turn <3) then
				mc_global.Wait(5000)
				script.Turn = script.Turn +1
				return true
			end
		end
				
	return ml_log(false)
end

script.c_gotAggro = inheritsFrom( ml_cause )
script.e_gotAggro = inheritsFrom( ml_effect )
function script.c_gotAggro:evaluate()
   -- ml_log("c_Aggro")
    return TableSize(CharacterList("nearest,alive,aggro,attackable,maxdistance=1200,onmesh")) > 0 and ( Inventory.freeSlotCount > 0 or ( Inventory.freeSlotCount == 0 and not mc_ai_vendor.NeedToSell() or TableSize(mc_ai_vendor.GetClosestVendorMarker()) == 0 ))
end
function script.e_gotAggro:execute()
	ml_log("e_Aggro ")
	-- to prevent fighting with food   lol :)
	if(script.ObjectTook == true) then
			Player:SwapWeaponSet()
	end
	
	Player:StopMovement()
	local newTask = mc_ai_combatDefend.Create()
	ml_task_hub:Add(newTask.Create(), REACTIVE_GOAL, TP_ASAP)
end




return script