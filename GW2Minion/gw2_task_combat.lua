-- Combat
gw2_task_combat = inheritsFrom(ml_task)
gw2_task_combat.name = GetString("startCombat")

function gw2_task_combat.Create()
	local newinst = inheritsFrom(gw2_task_combat)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
	newinst.targetID = nil
	newinst.targetPos = nil 
	
    return newinst
end

function gw2_task_combat:Init()
	d("gw2_task_combat:Init")
	
	-- Fleeing
	self:add(ml_element:create( "Fleeing", c_fleeToSafety, e_fleeToSafety, 225 ), self.process_elements)
	
	-- Finish Enemy
	self:add(ml_element:create( "FinishEnemy", c_FinishEnemy, e_FinishEnemy, 150 ), self.process_elements)
	
	
	self:AddTaskCheckCEs()
end
-- Gets called after the CnEs are evaluated, if true, calls directly task_complete_execute()
function gw2_task_combat:task_complete_eval()
	-- ID check, not reviving someone check , others ...
	-- ml_global_information.Player_SwimState == GW2.SWIMSTATE.NotInWater
	return false
end
function gw2_task_combat:task_complete_execute()
    
end

function gw2_task_combat.ModuleInit()
	d("gw2_task_combat:ModuleInit")
	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("TargetID","dbCurrTargetID","Task_Combat")
		dw:NewField("TargetDistance","dbCurrTargetDist","Task_Combat")
		
	end
end


RegisterEventHandler("Module.Initalize",gw2_task_combat.ModuleInit)