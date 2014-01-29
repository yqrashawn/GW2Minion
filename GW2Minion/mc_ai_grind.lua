-- GrindMode Behavior
mc_ai_grind = {}
mc_ai_grind.BT = {}
mc_ai_grind.SearchAndKillBT = {}




function mc_ai_grind.moduleinit()
	-- Never add a predicate or child function like this "mc_core.FALSE()" , always "mc_core.FALSE", or you will call the function instead of passing its name  !!
	
	-- PrioritySelector:Goes top to bottom, picks the first node where the predicate returns "true", then it calls its childnode until a false or true is returned
	-- If a child node reports 'failure', the PrioritySelector moves to the next child node, and asks for its status. 
	-- If a child node reports 'success', the PrioritySelector reports 'success' to the tree-walker, and the rest of the PrioritySelector's children will not be evaluated. 
	mc_ai_grind.SearchAndKillBT = mc_core.PrioritySelector:new(
		
		-- If the Decorator's predicate evaluates to false, then 'failure' is reported to the tree-walker. 
		-- If the Decorator's predicate evaluates to 'true', then the associated child node is evaluated, and the child node's return value is reported to the tree-walker. 
		-- In general, a Decorator is used in conjunction with some form of Selector container. 
		-- Dead?
		mc_core.Decorator:new( function() return Player.dead end, mc_ai_death.BT ),
					
		-- AoELooting Characters
		mc_core.Decorator:new( function() return TableSize(CharacterList( "nearest,lootable,maxdistance=900" )) > 0 end, function() return Player:AoELoot() end ),
		
		-- AoELooting Gadgets/Chests needed
		
		-- Normal Looting
		
		-- Aggro
		mc_core.Decorator:new( function() return TableSize(CharacterList("nearest,alive,aggro,attackable,maxdistance=1200,onmesh")) > 0 end, mc_ai_combat.DefendBT ),
		
		-- Gathering
		mc_core.Decorator:new( function() return (Inventory.freeSlotCount > 0 and TableSize(GadgetList("onmesh,gatherable,maxdistance=4000")) > 0) end, mc_ai_gathering.gatheringBT ),
		
		
		-- Repair
			
		-- Vendoring
		
		-- Killsomething nearby					
		mc_core.Decorator:new( function() return TableSize(CharacterList("alive,attackable,onmesh,maxdistance=3500")) > 0 end, mc_ai_combat.SearchAndKillBT )
		
	)
		
	
	mc_ai_grind.BT = mc_core.TreeWalker:new("MainBot",nil,    
		
		-- Randomly pick next maingoal and pursue it			
		mc_core.RandomSelector:new(	
				
			-- Events
							
			-- Explore
				
			-- Killsomething nearby		(RepeatUntil(predicate,child,targettime): repeat child() until predicate() true or targettime (in seconds) passed)				
			mc_core.RepeatUntil:new( function() return TableSize(CharacterList("alive,attackable,onmesh,maxdistance=3500")) == 0 end, mc_ai_grind.SearchAndKillBT, math.random(60,240))
		
		)
	)
	-- Updating the botmode
	mc_global.BotModes[mc_getstring("grindMode")] = mc_ai_grind.BT
end

-- Adding it to our botmodes
if ( mc_global.BotModes ) then
	mc_global.BotModes[mc_getstring("grindMode")] = mc_ai_grind.BT
end 

RegisterEventHandler("Module.Initalize",mc_ai_grind.moduleinit)