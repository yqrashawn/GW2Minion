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
	newinst.targetType = "character" -- change this to "gadget" if needed
	
    return newinst
end

function gw2_task_combat:Init()
	d("gw2_task_combat:Init")
	-- ProcessOverWatch() elements
	
	-- Handle Dead
	self:add(ml_element:create( "Dead", c_Dead, e_Dead, 500 ), self.overwatch_elements)	
	-- Handle Downed
	self:add(ml_element:create( "Downed", c_Downed, e_Doened, 450 ), self.overwatch_elements)
	-- Handle Rezz-Target is alive again or gone, deletes the subtask moveto in case it is needed
	self:add(ml_element:create( "RevivePartyMemberOverWatch", c_RezzOverWatchCheck, e_RezzOverWatchCheck, 400 ), self.overwatch_elements)
	
	
	-- Normal Elements
	-- RevivePartyMember
	self:add(ml_element:create( "RevivePartyMember", c_RezzPartyMember, e_RezzPartyMember, 375 ), self.process_elements)	-- creates subtask: moveto
	-- Revive other Players
	self:add(ml_element:create( "RevivePlayer", c_reviveDownedPlayersInCombat, e_reviveDownedPlayersInCombat, 350 ), self.process_elements)	-- creates subtask: moveto
	-- Fleeing
	self:add(ml_element:create( "Fleeing", c_fleeToSafety, e_fleeToSafety, 325 ), self.process_elements)
	
	-- Finish Enemy
	self:add(ml_element:create( "FinishEnemy", c_FinishEnemy, e_FinishEnemy, 300 ), self.process_elements)
		
	-- Normal Looting & chests
	self:add(ml_element:create( "Looting", c_Looting, e_Looting, 275 ), self.process_elements)	
	
	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 250 ), self.process_elements) -- creates subtask: moveto
	
	-- Attack Target
	self:add(ml_element:create( "AttackTarget", c_AttackTarget, e_AttackTarget, 225 ), self.process_elements) -- creates subtask: moveto
	
	
	
	
	self:AddTaskCheckCEs()
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


-- Moveto & Attack Target
c_AttackTarget = inheritsFrom( ml_cause )
e_AttackTarget = inheritsFrom( ml_effect )
e_AttackTarget.target = nil
function c_AttackTarget:evaluate()
			
	if ( ml_task_hub:CurrentTask().targetID ~= nil and ml_task_hub:CurrentTask().targetPos ~= nil ) then
		
		-- check if target  still exist
		if ( ml_task_hub:CurrentTask().targetType == "character" ) then
			e_AttackTarget.target = CharacterList:Get(ml_task_hub:CurrentTask().targetID)
			if ( e_AttackTarget.target ~= nil and e_AttackTarget.target.attackable ) then
				return true
			end
			
		elseif( ml_task_hub:CurrentTask().targetType == "gadget" ) then
			e_AttackTarget.target = GadgetList:Get(ml_task_hub:CurrentTask().targetID)
			if ( e_AttackTarget.target ~= nil and e_AttackTarget.target.attackable ) then
				return true
			end
		end
		
	end
	
	-- our target is gone / we dont have a valid target anymore, finish this task
	ml_task_hub:CurrentTask().completed = true
	ml_task_hub:CurrentTask().targetID = nil
	ml_task_hub:CurrentTask().targetPos = nil
	e_AttackTarget.target = nil
	return false
end
function e_AttackTarget:execute()
	ml_log("e_AttackTarget: ")
	if ( e_AttackTarget.target ~= nil and ml_task_hub:CurrentTask().targetID ~= nil and ml_task_hub:CurrentTask().targetPos ~= nil ) then 
		
		ml_task_hub:CurrentTask().targetPos = e_AttackTarget.target.pos
		
		if ( ml_global_information.ShowDebug ) then 
			dbCurrTargetID = ml_task_hub:CurrentTask().targetID or "" 
			dbCurrTargetDist = math.floor(e_AttackTarget.target.distance) 
		end
		
		-- Move Closer to target with a sub-moveto-task
		if (e_AttackTarget.target.distance > 2500) then
			
			local newTask = gw2_task_moveto.Create()
			newTask.targetPos = ml_task_hub:CurrentTask().targetPos
			newTask.targetID = ml_task_hub:CurrentTask().targetID
			newTask.targetType = ml_task_hub:CurrentTask().targetType
			newTask.stoppingDistance = 1500
			newTask.name = "MoveTo Attackable Target"
			ml_task_hub:CurrentTask():AddSubTask(newTask)
			return ml_log(true)
		
		else
			-- Let SkillManager handle the rest	
			gw2_skill_manager.Attack(e_AttackTarget.target)
			return ml_log(true)
		end
	else
		ml_error("e_AttackTarget: No valid target")
	end
	return ml_log(false)
end



RegisterEventHandler("Module.Initalize",gw2_task_combat.ModuleInit)