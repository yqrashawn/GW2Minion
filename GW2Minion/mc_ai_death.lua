-- Handles Death, respawn and downed fighting
mc_ai_death = {}
mc_ai_death.BT = {}
	
function mc_ai_death.moduleinit()
	

end

function mc_ai_death.todo()
	mc_log("Death")
	d("TODO: handle death")
	return true
end

-- Functions used in the BT need to be defined "above" it!
-- Death BT Tree
mc_ai_death.BT = mc_core.PrioritySelector:new(
	-- Death
	mc_core.Decorator:new( mc_core.TRUE, mc_ai_death.todo )
	-- Aggro
					
)
	
RegisterEventHandler("Module.Initalize",mc_ai_death.moduleinit)