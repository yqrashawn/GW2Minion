-- GrindMode Behavior
mc_ai_assist = {}
mc_ai_assist.BT = {}

function mc_ai_assist.SelectTargetExtended(maxrange, los)
    
	local filterstring = "attackable,alive,maxdistance="..tostring(maxrange)
	
	if (los == "1") then filterstring = filterstring..",los" end
	if (sMmode == "Players Only") then filterstring = filterstring..",player" end
	if (sMtargetmode == "LowestHealth") then filterstring = filterstring..",lowesthealth" end
	if (sMtargetmode == "Closest") then filterstring = filterstring..",nearest" end
	if (sMtargetmode == "Biggest Crowd") then filterstring = filterstring..",clustered=600" end
	
	local TargetList = CharacterList(filterstring)
	if ( TargetList ) then
		local id,entry = next(TargetList)
		if (id and entry ) then
			d("Target found "..tostring(entry.id) .. " name "..entry.name)
			return entry
		end
	end	
	return nil
end

function mc_ai_assist.SetTargetAssist()
	-- Try to get Enemy with los in range first
	local target = mc_ai_assist.SelectTargetExtended(mc_global.AttackRange, 1)	
	if ( not target ) then target = mc_ai_assist.SelectTargetExtended(mc_global.AttackRange, 0) end
	if ( not target ) then target = mc_ai_assist.SelectTargetExtended(mc_global.AttackRange +250, 0) end
	
	if ( target ) then 
		Player:SetTarget(target.id)
		return mc_skillmanager.AttackTarget( target.id ) 
	else
		return false
	end
end

function mc_ai_assist.moduleinit()
	
	if (Settings.GW2Minion.sMtargetmode == nil) then
		Settings.GW2Minion.sMtargetmode = "None"
	end
	if (Settings.GW2Minion.sMmode == nil) then
		Settings.GW2Minion.sMmode = "Everything"
	end
	GUI_NewComboBox(mc_global.window.name,mc_getstring("sMtargetmode"),"sMtargetmode",mc_getstring("assistMode"),"None,LowestHealth,Closest,Biggest Crowd");
	GUI_NewComboBox(mc_global.window.name,mc_getstring("sMmode"),"sMmode",mc_getstring("assistMode"),"Everything,Players Only")
	
	sMtargetmode = Settings.GW2Minion.sMtargetmode
	sMmode = Settings.GW2Minion.sMmode
	

	
	mc_ai_assist.BT = mc_core.TreeWalker:new("MainBot",nil,    
		
		-- PrioritySelector:Goes top to bottom, picks the first node that returns "true" or "Running" and calls its childnode
		mc_core.PrioritySelector:new(
			-- Dead?
			mc_core.Decorator:new( function() return Player.dead end, mc_core.TRUE ),
						
			-- AoELooting Characters
			mc_core.Decorator:new( function() return TableSize(CharacterList( "nearest,lootable,maxdistance=900" )) > 0 end, function() return Player:AoELoot() end ),
			
			-- AoELooting Gadgets/Chests needed?
			
			-- Valid Target & Attack without target assist
			mc_core.Decorator:new( function() return sMtargetmode == "None" end, function() return mc_skillmanager.AttackTarget( nil ) end ),
			
			mc_core.Decorator:new( function() return sMtargetmode ~= "None" end, mc_ai_assist.SetTargetAssist )
						
		)
	)
	-- Updating the botmode
	mc_global.BotModes[mc_getstring("assistMode")] = mc_ai_assist.BT
end

-- Adding it to our botmodes
if ( mc_global.BotModes ) then
	mc_global.BotModes[mc_getstring("assistMode")] = mc_ai_assist.BT
end 

RegisterEventHandler("Module.Initalize",mc_ai_assist.moduleinit)