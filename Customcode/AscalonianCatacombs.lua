-- Custom Code for Ascalonian Catacombs Dungeon, meant to be played with 4-5 bots
dungeonAC = { }

function dungeonAC.ModuleInit() 
	-- Registering our custom code within the wt_core_taskmanager.CustomLuaFunctions table in wt_core_taskmanager.lua	
	if (wt_core_taskmanager ~= nil and wt_core_taskmanager.CustomLuaFunctions ~= nil) then
		wt_debug("Adding Ascalonian Catacombs functions to list")
		table.insert(wt_core_taskmanager.CustomLuaFunctions,dungeonAC.OnUpdate)
	end
end

function dungeonAC.OnUpdate()	
	-- Here I would do conditional checks and add my Custom Tasks to wt_core_taskmanager.Customtask_list	
	if (Player:GetLocalMapID() == 33) then
		local mlist = MapMarkerList("isevent")
		if (mlist ~= nil) then	
			local i,event = next(mlist)
			if (i~=nil and event~=nil) then	
				wt_global_information.MaxAggroDistanceFar = 500
				--TODO: Add ReadyCheck
				if( event.eventID == 2606 and event.type == 159) then -- EventD = 1, charID=346
					dungeonAC.Step1(event)
				elseif(event.eventID == 2607 and event.type == 159) then -- EventD = 0, charID=347
					local step = stepcheck()
					if ( step == 0 ) then
						dungeonAC.Step2(event)
					elseif ( step == 2) then
						dungeonAC.Step2OpenCoffins(event)
					elseif (step == 3 ) then
						dungeonAC.DeactivateTrap(event)
					else
					end
				end			
			end
		end
	end	
end

function stepcheck()
	local result = 0
	local gl = GadgetList("")
	if (gl ~= nil ) then
		-- Check for coffins to open
		local i,g = next(gl)
		while (i~=nil and g~=nil) do
			if (g.health ~= nil and g.type == 14 and g.isselectable == 1 and g.distance < 5000 and g.contentID == 0) then
				result = 2
				break
			end			
			i,g = next(gl,i)
		end
		-- Check for traps to disable
		local i,g = next(gl)
		while (i~=nil and g~=nil) do
			if (g.health == nil and g.type == 14 and g.isselectable == 1 and g.distance < 3000 and g.contentID == 89683) then
				result = 3
				break
			end			
			i,g = next(gl,i)
		end		
	end
	return result
end


function dungeonAC.Step1(event)
	local newtask = inheritsFrom( wt_task )
    newtask.name = "AC Step1"
    newtask.priority = 50
    newtask.position = event.pos
    newtask.done = false
    newtask.last_execution = 0
    newtask.throttle = 500
	newtask.eventID = event.eventID
	newtask.NPC = event.characterID 
		 
    function newtask:execute()
        local mypos = Player.pos
        local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, mypos.x, mypos.y, mypos.z )
        if ( distance > 120 ) then                                             
			if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
                newtask.last_execution = wt_global_information.Now
				Player:MoveTo( newtask.position.x, newtask.position.y, newtask.position.z, 5 )                
            end
            newtask.name = "Walking to NPC, dist: "..(math.floor(distance))
        else
            if (CharacterList:Get(newtask.NPC) ~= nil ) then				
				if ( Player:GetTarget() ~= newtask.NPC) then
					Player:SetTarget(newtask.NPC)
				elseif(not Player:IsConversationOpen() ) then
					Player:Interact( newtask.NPC )
				elseif(Player:IsConversationOpen()) then
					local options = Player:GetConversationOptions()
					nextOption, entry  = next( options )
					while ( nextOption ~= nil ) do
						if( entry == 13 ) then
							Player:SelectConversationOption( 13 )
							break
						elseif( entry == 6) then
							Player:SelectConversationOption( 6 )
							break
						else
							newtask.done = true
							break
						end
						nextOption, entry  = next( options, nextOption )
					end
				end
			end
            
        end
	end
		 
    function newtask:isFinished()
		if ( newtask.done ) then
			return true
		end
		return false
	end    

	wt_debug("AC Step1 Added..")
	wt_core_taskmanager:addCustomtask( newtask )
end

function dungeonAC.Step2(event)
	local newtask = inheritsFrom( wt_task )
    newtask.name = "AC Step2"
    newtask.priority = 50
    newtask.position = event.pos
    newtask.done = false
    newtask.last_execution = 0
    newtask.throttle = 500
	newtask.eventID = event.eventID
	newtask.NPC = event.characterID 
		 
    function newtask:execute()
		local mypos = Player.pos
        local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, mypos.x, mypos.y, mypos.z )
        if ( distance > 120 ) then                                             
			if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
                newtask.last_execution = wt_global_information.Now
				Player:MoveTo( newtask.position.x, newtask.position.y, newtask.position.z, 50 )                
            end
            newtask.name = "Walking to Event, dist: "..(math.floor(distance))
        else
            newtask.done = true       
        end
	end
		 
    function newtask:isFinished()
		if ( newtask.done ) then
			return true
		end
		return false
	end    

	wt_debug("AC Step2 Added..")
	wt_core_taskmanager:addCustomtask( newtask )
end

function dungeonAC.Step2OpenCoffins(event)
	local newtask = inheritsFrom( wt_task )
    newtask.name = "AC Step2 Coffins"
    newtask.priority = 50
    newtask.position = event.pos
    newtask.done = false
    newtask.last_execution = 0
    newtask.throttle = 500
	newtask.eventID = event.eventID
		 
    function newtask:execute()
        local target = nil
		local targetID = nil
		local gl = GadgetList("")
		if (gl ~= nil) then
			local i,g = next(gl)
			while (i~=nil and g~=nil) do
				if (g.health ~= nil and g.type == 14 and g.isselectable == 1 and g.distance < 5000) then
					target = g
					targetID = i
					break
				end			
				i,g = next(gl,i)
			end			
		end
		if (target ~= nil and target.pos ~= nil and targetID ~= nil) then
			if ( target.distance > 120 ) then                                             
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					newtask.last_execution = wt_global_information.Now
					local gpos = target.pos
					Player:MoveTo( gpos.x, gpos.y, gpos.z, 5 )                
				end
				newtask.name = "Walking to target, dist: "..(math.floor(target.distance))
			else
				if ( Player:GetTarget() ~= targetID ) then
					Player:SetTarget(targetID)
				else
					wt_debug("Opening target...")
					Player:Use(targetID)
					newtask.done = true
				end
			end
		else
			Player:MoveTo( -10568, -6930, -1950, 50 )			
		end		
	end
		 
    function newtask:isFinished()
		if ( newtask.done ) then
			return true
		end
		return false
	end    

	wt_debug("AC Step2 opening coffins added..")
	wt_core_taskmanager:addCustomtask( newtask )
end

function dungeonAC.DeactivateTrap(event)
	local newtask = inheritsFrom( wt_task )
    newtask.name = "AC DeactivateTrap"
    newtask.priority = 50
    newtask.position = event.pos
    newtask.done = false
    newtask.last_execution = 0
    newtask.throttle = 500
	newtask.eventID = event.eventID
	newtask.NPC = event.characterID 
		 
    function newtask:execute()
        local target = nil
		local targetID = nil
		local gl = GadgetList("")
		if (gl ~= nil) then
			local i,g = next(gl)
			while (i~=nil and g~=nil) do
				if (g.health == nil and g.type == 14 and g.isselectable == 1 and g.distance < 3000 and g.contentID == 89683) then
					target = g
					targetID = i
					break
				end			
				i,g = next(gl,i)
			end			
		end
		if (target ~= nil and target.pos ~= nil and targetID ~= nil) then
			if ( target.distance > 120 ) then                                             
				if ( (wt_global_information.Now - newtask.last_execution) > newtask.throttle ) then
					newtask.last_execution = wt_global_information.Now
					local gpos = target.pos
					Player:MoveTo( gpos.x, gpos.y, gpos.z, 5 )                
				end
				newtask.name = "Walking to Trap, dist: "..(math.floor(target.distance))
			else
				if ( Player:GetTarget() ~= targetID ) then
					Player:SetTarget(targetID)
				else
					wt_debug("Deactivating Trap...")
					Player:Use(targetID)
					newtask.done = true
				end
			end
		end		
	end
		 
    function newtask:isFinished()
		if ( newtask.done ) then
			return true
		end
		return false
	end    

	wt_debug("AC DeactivateTrap Added..")
	wt_core_taskmanager:addCustomtask( newtask )
end

RegisterEventHandler("Module.Initalize",dungeonAC.ModuleInit)
