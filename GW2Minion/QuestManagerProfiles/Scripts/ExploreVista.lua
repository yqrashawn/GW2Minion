-- Goto Position x,y,z and interact with closest Vista - script for QuestManager
script = inheritsFrom( ml_task )
script.name = "ExploreVista"
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
	
	-- Aggro
	self:add(ml_element:create( "Aggro", c_AggroEx, e_AggroEx, 165 ), self.process_elements) --reactive queue
	
	-- Dont Dive lol
	self:add(ml_element:create( "SwimUP", c_SwimUp, e_SwimUp, 160 ), self.process_elements)
		
	-- Normal Chests	
	self:add(ml_element:create( "LootingChest", c_LootChests, e_LootChests, 155 ), self.process_elements)
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)	

	-- Normal Looting
	self:add(ml_element:create( "Looting", c_LootCheck, e_LootCheck, 130 ), self.process_elements)

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)	
	
	-- Kill Stuff Nearby
	self:add(ml_element:create( "SearchAndKillNearby", c_SearchAndKillNearby, e_SearchAndKillNearby, 115 ), self.process_elements)
	
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
function script.e_goto:execute()
	ml_log("e_goto")
	local pPos = Player.pos
	if (pPos) then
		local dist = Distance3D( ml_task_hub:CurrentTask().Data["GotoX"],ml_task_hub:CurrentTask().Data["GotoY"],ml_task_hub:CurrentTask().Data["GotoZ"],pPos.x,pPos.y,pPos.z)
		ml_log("("..tostring(math.floor(dist))..")")
		if ( dist > 1500 ) then
			--d(tostring(ml_task_hub:CurrentTask().Data["GotoX"]).." "..tostring(ml_task_hub:CurrentTask().Data["GotoY"]).." "..tostring(ml_task_hub:CurrentTask().Data["GotoZ"]))
			local navResult = tostring(Player:MoveTo(ml_task_hub:CurrentTask().Data["GotoX"],ml_task_hub:CurrentTask().Data["GotoY"],ml_task_hub:CurrentTask().Data["GotoZ"],35,false,false,true))		
			if (tonumber(navResult) < 0) then					
				ml_error("e_gotoPosition result: "..tonumber(navResult))					
			end			
			return ml_log(true)
		else
			local MList = MapMarkerList("onmesh,nearest,isvista,maxdistance=1500,exclude_contentid="..mc_blacklist.GetExcludeString(GetString("mapobjects")))
			if ( TableSize(MList) > 0 ) then
				local id,entry = next(MList)
				if id and entry then
					if ( entry.distance < 120 ) then
						local t = Player:GetInteractableTarget()
						if ( t ) then
							d("Interacting with Vista..")
							Player:Interact(t.id)
							mc_global.Wait(2000)
						else
							ml_error("No Vista to Interact nearby ??")
							mc_global.Wait(2000)
						end
					else
						ml_error("Vista not in Range yet, trying to get closer..")
						local mPos = entry.pos
						if ( mPos ) then
							local navResult = tostring(Player:MoveTo(mPos.x,mPos.y,mPos.z,35,false,false,false))
							if (tonumber(navResult) < 0) then					
								ml_error("e_gotoVistaPosition result: "..tonumber(navResult))					
							end
						else
							ml_error("Vista Marker has no position!")
						end						
					end				
				end
			else
				ml_error("Seems there is NO VISTA nearby !!?")
				ml_task_hub:CurrentTask().completed = true				
			end			
		end
	end	
	return ml_log(false)
end


return script