-- Salvaging + Settings
gw2_task_follow = inheritsFrom(ml_task)
gw2_task_follow.name = GetString("followmode")

function gw2_task_follow.Create()
	local newinst = inheritsFrom(gw2_task_follow)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
    return newinst
end

function gw2_task_follow:Init()
   -- ml_log("combatAttack_Init->")
	
	--self:add(ml_element:create( "Salvage", c_salvage, e_salvage, 100 ), self.process_elements)
	
	self:AddTaskCheckCEs()
end
function gw2_task_follow:task_complete_eval()	
	
	return false
end

function gw2_task_follow:UIInit()
	d("gw2_task_follow:UIInit")
	local mw = WindowManager:GetWindow(gw2minion.MainWindow.Name)
	if ( mw ) then		
		mw:NewField(GetString("followtarget"),"gFollowTargetName",GetString("followmode"))		
		mw:NewButton(GetString("followtarget"),"gw2_task_follow.FollowTarget",GetString("followmode"))
		RegisterEventHandler("gw2_task_follow.FollowTarget", gw2_task_follow.SetFollowTarget)	
		
		mw:UnFold( GetString("followmode") );
	end
	return true
end
function gw2_task_follow:UIDestroy()
	d("gw2_task_follow:UIDestroy")
	GUI_DeleteGroup(gw2minion.MainWindow.Name, GetString("followmode"))
end

function gw2_task_follow.ModuleInit()
	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("FollowTargetID","gFollowTargetID","Task_Follow")
		dw:NewField("FollowPathSize","gFollowTargetPathSize","Task_Follow")
	end
end
RegisterEventHandler("Module.Initalize",gw2_task_follow.ModuleInit)
ml_global_information.AddBotMode(GetString("followmode"), gw2_task_follow)


-- Button handler for follow current target
function gw2_task_follow.SetFollowTarget()
	local t = Player:GetTarget()
	if ( t ) then
		gFollowTargetName = t.name		
		gFollowTargetID = t.id
	else
		gFollowTargetName = ""
		gFollowTargetID = 0
	end
end


