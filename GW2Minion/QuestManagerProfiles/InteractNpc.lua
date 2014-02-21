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

function script:EventHandler( identifier, event )
	if ( event == "SetNpcId" ) then
	local t = Player:GetTarget()
		if ( t ) then
			-- Set Data
			self.Data["InteractNpc"] = t.id		

			-- Update UI fields
			_G[tostring(identifier).."InteractNpc"] = t.id
	
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
	d(Player:Interact(ml_task_hub:CurrentTask().Data["InteractNpc"]))
	ml_task_hub:CurrentTask().completed = true
end	


return script