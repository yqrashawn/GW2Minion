-- Grind
gw2_task_assist = inheritsFrom(ml_task)
gw2_task_assist.name = GetString("assistMode")

function gw2_task_assist.Create()
	local newinst = inheritsFrom(gw2_task_assist)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
    return newinst
end

function gw2_task_assist:Init()
	d("gw2_task_assist:Init")
end

gw2_task_assist.tmr = 0
gw2_task_assist.threshold = 2000
function gw2_task_assist:Process()
	--ml_log("AssistMode_Process->")
		
	if ( ml_global_information.Player_Alive ) then
		
		
		if ( FinishEnemy() == true ) then return end
		
		
		if ( TimeSince(gw2_task_assist.tmr) > 2000 and Player:IsMoving()) then
			gw2_task_assist.tmr = ml_global_information.Now
			gw2_task_assist.threshold = math.random(500,1500)
			gw2_skill_manager.Heal(Player)
		end	
		
		if ( sMtargetmode == "None" ) then
			local target = Player:GetTarget()
			if ( target and target.alive and target.attackable ) then
				gw2_skill_manager.Attack( target )
			end
			
		elseif ( sMtargetmode ~= "None" ) then 
			gw2_task_assist.SetTargetAssist()
		end
	end				
	
end

function gw2_task_assist:UIInit()
	d("gw2_task_assist:UIInit")
	local mw = WindowManager:GetWindow(gw2minion.MainWindow.Name)
	if ( mw ) then		
		mw:NewComboBox(GetString("sMtargetmode"),"sMtargetmode",GetString("assistMode"),"None,LowestHealth,Closest,Biggest Crowd");
		mw:NewComboBox(GetString("sMmode"),"sMmode",GetString("assistMode"),"Everything,Players Only")
		mw:UnFold( GetString("assistMode") );
	end	
	sMtargetmode = Settings.GW2Minion.sMtargetmode
	sMmode = Settings.GW2Minion.sMmode
	return true
end
function gw2_task_assist:UIDestroy()
	d("gw2_task_assist:UIDestroy")
	GUI_DeleteGroup(gw2minion.MainWindow.Name, GetString("assistMode"))
end

function gw2_task_assist:RegisterDebug()
    d("gw2_task_assist:RegisterDebug")
end

function gw2_task_assist.ModuleInit()
	d("gw2_task_assist:ModuleInit")
	if (Settings.GW2Minion.sMtargetmode == nil) then
		Settings.GW2Minion.sMtargetmode = "None"
	end
	if (Settings.GW2Minion.sMmode == nil) then
		Settings.GW2Minion.sMmode = "Everything"
	end
end


function gw2_task_assist.SelectTargetExtended(maxrange, los)
    
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
			ml_log("Attacking "..tostring(entry.id) .. " name "..entry.name)
			return entry
		end
	end	
	return nil
end

function gw2_task_assist.SetTargetAssist()
	-- Try to get Enemy with los in range first
	local target = gw2_task_assist.SelectTargetExtended(ml_global_information.AttackRange, 1)	
	if ( not target ) then target = gw2_task_assist.SelectTargetExtended(ml_global_information.AttackRange, 0) end
	if ( not target ) then target = gw2_task_assist.SelectTargetExtended(ml_global_information.AttackRange + 250, 0) end
	
	if ( target and target.id ) then 
		Player:SetTarget(target.id)
		return gw2_skill_manager.Attack( target ) 		
	else
		
		local currTarget = Player:GetTarget()
		if ( currTarget ~= nil ) then
			return gw2_skill_manager.Attack( currTarget )
		end
		return false
	end
end


ml_global_information.AddBotMode(GetString("assistMode"), gw2_task_assist)
RegisterEventHandler("Module.Initalize",gw2_task_assist.ModuleInit)