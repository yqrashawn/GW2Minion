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
	newinst.targetType = "character" -- change this to "gadget" if needed
	
	newinst.terminateOnAggro = false -- if true, terminates task if curr target has no aggro but others have
	newinst.terminateInWater = true -- in case we ever figure that stuff out
	
    return newinst
end

function gw2_task_combat:Init()
	--d("gw2_task_combat:Init")
	-- ProcessOverWatch() elements
	
	-- Handle Dead
	self:add(ml_element:create( "Dead", c_Dead, e_Dead, 500 ), self.overwatch_elements)	
	
	-- Downed 
	self:add(ml_element:create( "Downed", c_Downed, e_DownedEmpty, 450 ), self.overwatch_elements)
		
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
	--self:add(ml_element:create( "Looting", c_Looting, e_Looting, 275 ), self.process_elements)	walks a looong way while we are getting ass kicked...taking this out for now, combat task should only be active until the enemy dies anyway
	
	-- ReviveNPCs
	--self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 250 ), self.process_elements) -- creates subtask: moveto
	
	-- Attack Target
	self:add(ml_element:create( "AttackTarget", c_AttackTarget, e_AttackTarget, 225 ), self.process_elements) -- creates subtask: moveto
	
	
	
	
	self:AddTaskCheckCEs()
end

function gw2_task_combat.ModuleInit()
	--d("gw2_task_combat:ModuleInit")
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
function c_AttackTarget:evaluate()
			
	if ( ml_task_hub:CurrentTask().targetID ~= nil ) then
		return true
	end
	
	-- our target is gone / we dont have a valid target anymore, finish this task
	ml_task_hub:CurrentTask().completed = true
	ml_task_hub:CurrentTask().targetID = nil
	return false
end
function e_AttackTarget:execute()
	ml_log("e_AttackTarget: ")
	if ( ml_task_hub:CurrentTask().targetID ~= nil ) then 
		
		local target = CharacterList:Get(ml_task_hub:CurrentTask().targetID)
		
		if (ValidTable(target) and target.attackable and target.alive and target.onmesh and ml_global_information.Player_OnMesh) then
			if ( ml_global_information.ShowDebug ) then 
				dbCurrTargetID = target.id or "" 
				dbCurrTargetDist = math.floor(target.distance) 
			end
			if (ml_task_hub:CurrentTask().terminateOnAggro and target.isAggro == false) then
				if (TableSize(CharacterList("onmesh,aggro,attackable,alive,maxdistance=1500,exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))) > 0) then
					d("cancel target, no aggro on current, aggro on other")
					ml_task_hub:CurrentTask().completed = true
					return ml_log(false)
				end
			end
			if (ml_blacklist.CheckBlacklistEntry(GetString("monsters"),target.contentID)) then
				-- target got blacklisted, cancel combat task.
				ml_task_hub:CurrentTask().completed = true
				return ml_log(false)
			elseif (ml_task_hub:CurrentTask().terminateInWater and (Player.swimming == 1 or (target.isCharacter and target.swimming == 1) or (target.isGadget and target.pos and target.pos.z > 40))) then
				-- target or player is in the water, cancel combat task.
				ml_blacklist.AddBlacklistEntry(GetString("monsters"),target.contentID,target.name,ml_global_information.Now+30000)
				ml_task_hub:CurrentTask().completed = true
				return ml_log(false)
			elseif (target.distance > 2500) then
				-- move to target task (stops on not finding target entity in moveto task, entity being dead does not stop it ATM)
				local newTask = gw2_task_moveto.Create()
				newTask.targetPos = target.pos
				newTask.targetID = target.id
				newTask.targetType = ml_task_hub:CurrentTask().targetType
				newTask.terminateInCombat = true
				newTask.stoppingDistance = 2000
				newTask.name = "MoveTo Attackable Target"
				ml_task_hub:CurrentTask():AddSubTask(newTask)
				return ml_log(true)
			else
				-- Let SkillManager handle the rest	
				gw2_skill_manager.Attack(target)
				return ml_log(true)
			end
		else
			-- Target is no longer valid
			ml_task_hub:CurrentTask().completed = true
		end
	else
		ml_error("e_AttackTarget: No valid target")
		ml_task_hub:CurrentTask().completed = true
	end
	return ml_log(false)
end



RegisterEventHandler("Module.Initalize",gw2_task_combat.ModuleInit)