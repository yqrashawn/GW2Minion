-- SkillPoint Challenge -> Commune Task
script = inheritsFrom( ml_task )
script.name = "SP_Commune"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Commune ID",tostring(identifier).."ComID",GetString("questStepDetails"))
	GUI_NewButton(ml_quest_mgr.stepwindow.name,"Set Commune ID",tostring(identifier).."SetComID",GetString("questStepDetails"))
	GUI_NewField(ml_quest_mgr.stepwindow.name,"SP ID",tostring(identifier).."SpID",GetString("questStepDetails"))
	GUI_NewButton(ml_quest_mgr.stepwindow.name,"Set SP ID",tostring(identifier).."SetSpID",GetString("questStepDetails"))

end

function script:SetData( identifier, tData )
	if ( identifier and tData ) then		
				
		self.Data = tData
		
		if ( self.Data["ComID"] ) then _G[tostring(identifier).."ComID"] = self.Data["ComID"] end
		if ( self.Data["SpID"] ) then _G[tostring(identifier).."SpID"] = self.Data["SpID"] end
	
		
	end
end

function script:EventHandler( identifier, event )
	if ( event == "SetComID" ) then
	local t = Player:GetTarget()
		if ( t ) then
			-- Set Data
			self.Data["ComID"] = t.contentID	

			-- Update UI fields
			_G[tostring(identifier).."ComID"] = t.contentID
		end
	end
	
	if ( event == "SetSpID" ) then
	local SPList = MapMarkerList("onmesh,maxdistance=4000,type=357")
	local i, sp = next (SPList)
		if (i and sp) then
			-- Set Data
		self.Data["SpID"] = sp.contentID

			--Update UI fields
			_G[tostring(identifier).."SpID"] = sp.contentID
	
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
    -- Check if we are done with the SP
	self:add(ml_element:create( "CheckSPCompletion", self.c_CheckSPCompletion, self.e_CheckSPCompletion, 300 ), self.process_elements)
  
	-- Dead
	self:add(ml_element:create( "Dead", c_dead, e_dead, 290 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 280 ), self.process_elements)
	
	
	-- Aggro
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 220 ), self.process_elements) 
	
	-- Resting
	
	self:add(ml_element:create( "Resting", c_resting, e_resting, 160 ), self.process_elements)
	
	-- Normal Looting
	self:add(ml_element:create( "Looting", c_event_LootCheck, e_Loot, 140 ), self.process_elements)	
	
	--Select the good conv option
	self:add(ml_element:create( "SelectConvOption", c_SelectConversation, e_SelectConversation, 120 ), self.process_elements)
	
	-- Move InRange of Object
	self:add(ml_element:create( "gotoObject", self.c_gotoCommune, self.e_gotoCommune, 100 ), self.process_elements)
	

	self:AddTaskCheckCEs()
end




function script:task_complete_eval()	
	return false
end

function script:task_complete_execute()
   self.completed = true
end


script.c_gotoCommune = inheritsFrom( ml_cause )
script.e_gotoCommune = inheritsFrom( ml_effect )


function script.c_gotoCommune:evaluate()
	if (tonumber(ml_task_hub:CurrentTask().Data["ComID"]) ~= nil )then
		return true
	else
		ml_error("Quest BreakObject Step has no Position set!")
	end
	return false
end


function script.e_gotoCommune:execute()
	ml_log("e_gotoCommune")

		local oID = ml_task_hub:CurrentTask().Data["ComID"]
		local objList = GadgetList("nearest,onmesh,interactable,maxdistance=4000,contentID="..oID)
		
		if ( TableSize(objList) > 0) then
			local i, object = next (objList)
			if (i and object) then
			
				if (not object.isInInteractRange) then
				-- Move into range of Commune gadget
					local tPos = object.pos
					if ( tPos ) then
						local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
						if (tonumber(navResult) < 0) then
							ml_error("move to commune result: "..tonumber(navResult))					
						end
						ml_log("Move To Commune..")
						return true
					end
				else
	
			
					-- Interact with Gadget Commune
					Player:StopMovement()
					d(Player:Interact(ml_task_hub:CurrentTask().Data["ComID"]))
					script.e_SelectConversation:execute()
					
						
				end
				
			end
		end
		
	return ml_log(false)
end

script.c_SelectConversation = inheritsFrom( ml_cause )
script.e_SelectConversation = inheritsFrom( ml_effect )

function script.c_SelectConversation:evaluate() 
	
local convOptions = Player:GetConversationOptions()
	if ( convOptions ) then
		return true
	end
	return false
end


function script.e_SelectConversation:execute()
	ml_log("c_SelectConv")

		local convOptions = Player:GetConversationOptions()
		if ( convOptions ) then
		
			local i,c = next (convOptions)
				Player:SelectConversationOptionByIndex(tonumber(c.id))  --choose option 1		
				mc_global.Wait(10000)
				return false
		end
	return true
end	

script.c_CheckSPCompletion = inheritsFrom( ml_cause )
script.e_CheckSPCompletion = inheritsFrom( ml_effect )

function script.c_CheckSPCompletion:evaluate()
  
	local sID = ml_task_hub:CurrentTask().Data["SpID"]
	local SPList = MapMarkerList("onmesh,maxdistance=4000,type=357,contentID="..sID)

		if ( TableSize(SPList) >0) then
			return false
		end
return true
		
end

function script.e_CheckSPCompletion:execute()
script:task_complete_execute()
end

return script