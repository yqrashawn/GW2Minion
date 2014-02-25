-- Interact with Npc Quest
script = inheritsFrom( ml_task )
script.name = "InteractNpc"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Interact Npc",tostring(identifier).."InteractNpc",GetString("questStepDetails"))
	GUI_NewButton(ml_quest_mgr.stepwindow.name,"Set Npc Id",tostring(identifier).."SetNpcId",GetString("questStepDetails"))
		
end

function script:SetData( identifier, tData )
	if ( identifier and tData ) then		
				
		self.Data = tData
		
		if ( self.Data["InteractNpc"] ) then
		_G[tostring(identifier).."InteractNpc"] = self.Data["InteractNpc"]
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
	self:add(ml_element:create( "InteractNpc", self.c_Interact, self.e_Interact, 110 ), self.process_elements)	
	
	self:AddTaskCheckCEs()
end


function script:task_complete_eval()		
	return false
end
function script:task_complete_execute()
   self.completed = true
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
	local npcList = CharacterList("onmesh,interactable,contentID="..nID)
		
		if ( TableSize(npcList) > 0) then
			local i, npc = next (npcList)
			if (i and npc) then
			
				if (not npc.isInInteractRange) then
				-- Move into range of npc
					local tPos = npc.pos
					if ( tPos ) then
						local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
						if (tonumber(navResult) < 0) then
							ml_error("move to object result: "..tonumber(navResult))					
						end
						ml_log("Move To npc..")
						return true
					end
				else
	
			
					-- talk to object
					Player:StopMovement()
					Player:Interact(nID)
					ml_task_hub:CurrentTask().completed = true
				end
			end
		end
		return false
end	


return script