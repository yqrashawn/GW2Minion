-- Interact with Npc Quest or Skill Point NPC
script = inheritsFrom( ml_task )
script.name = "InteractNpc"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Interact Npc",tostring(identifier).."InteractNpc",GetString("questStepDetails"))
	GUI_NewButton(ml_quest_mgr.stepwindow.name,"Set Npc Id",tostring(identifier).."SetNpcId",GetString("questStepDetails"))
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Conv Number",tostring(identifier).."ConvNum",GetString("questStepDetails"))
		
end

function script:SetData( identifier, tData )
	if ( identifier and tData ) then		
				
		self.Data = tData
		
		if ( self.Data["InteractNpc"] ) then
		_G[tostring(identifier).."InteractNpc"] = self.Data["InteractNpc"]
		end
		if ( self.Data["ConvNum"] ) then
		_G[tostring(identifier).."ConvNum"] = self.Data["ConvNum"]
		end
	end
end

function script:EventHandler( identifier, event, value )
	if ( event == "SetNpcId" ) then
	local t = Player:GetTarget()
		if ( t ) then
			-- Set Data
			self.Data["InteractNpc"] = t.contentID

			-- Update UI fields
			_G[tostring(identifier).."InteractNpc"] = t.contentID
	
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
	
	-- Check if Conversation panel is open,  if open, use option from var ConvNum
	self:add(ml_element:create( "ConversationSelect", self.c_SelectConversation, self.e_SelectConversation, 150 ), self.process_elements)
	
	-- Move to Npc/ SP Challenge  and Interact with it
	self:add(ml_element:create( "InteractNpc", self.c_Interact, self.e_Interact, 110 ), self.process_elements)	
		
	
	self:AddTaskCheckCEs()
end


function script:task_complete_eval()		
	return false
end
function script:task_complete_execute()
   self.completed = true
end

script.c_SelectConversation = inheritsFrom( ml_cause )
script.e_SelectConversation = inheritsFrom( ml_effect )

function script.c_SelectConversation:evaluate() 
	if(tonumber(ml_task_hub:CurrentTask().Data["ConvNum"]) == nil) then
		return false
	end
	
local convOptions = Player:GetConversationOptions()
	if ( convOptions ) then
		return true
	end
	return false
end


function script.e_SelectConversation:execute()
	ml_log("c_Interact")

		local convOptions = Player:GetConversationOptions()
		if ( convOptions ) then
		
			local i,c = next (convOptions)
			if(tonumber(ml_task_hub:CurrentTask().Data["ConvNum"]) == 1) then
				Player:SelectConversationOptionByIndex(tonumber(c.id)-1)  --choose option 1		
				ml_task_hub:CurrentTask().completed = true
			elseif(tonumber(ml_task_hub:CurrentTask().Data["ConvNum"]) == 2) then
				Player:SelectConversationOptionByIndex(tonumber(c.id))  --choose option 2
				ml_task_hub:CurrentTask().completed = true			
			elseif(tonumber(ml_task_hub:CurrentTask().Data["ConvNum"])  ==3) then
				Player:SelectConversationOptionByIndex(tonumber(c.id+1))  --choose option 3
				ml_task_hub:CurrentTask().completed = true
			else
				return false
			end
		end
	return true
end	

-- Cause&Effect
script.c_Interact = inheritsFrom( ml_cause )
script.e_Interact = inheritsFrom( ml_effect )

function script.c_Interact:evaluate() 
	
	if (tonumber(ml_task_hub:CurrentTask().Data["InteractNpc"])) ~= nil then
		return true
	else
		ml_error("Quest InteractNpc Step has no id set!")
	end
	return false
end

function script.e_Interact:execute()
	ml_log("c_Interact")
	local nID = ml_task_hub:CurrentTask().Data["InteractNpc"]
	local npcList = CharacterList("onmesh,contentID="..nID)
		
		if ( TableSize(npcList) > 0) then
			local i, npc = next (npcList)
			if (i and npc) then

				if (not npc.isInInteractRange) then
				-- Move into range of npc
					local tPos = npc.pos
					if ( tPos ) then
						local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,35,false,true,true))		
						if (tonumber(navResult) < 0) then
							ml_error("move to npc result: "..tonumber(navResult))					
						end
						ml_log("Move To npc..")
						return true
					end
				else
	
			
					-- talk to npc
					Player:StopMovement()
					Player:Interact(nID)
	
				end
			end
		end
			if(tonumber(ml_task_hub:CurrentTask().Data["ConvNum"]) == nil) then
				ml_task_hub:CurrentTask().completed = true
			end
		return false
end	


return script