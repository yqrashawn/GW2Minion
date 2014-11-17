gw2_common_functions = {}

function gw2_common_functions.HasBuffs(entity, buffIDs)
    if ( entity ) then
		local buffs = entity.buffs
		if (buffs == nil or TableSize(buffs) == 0) then return false end
			
			for _orids in StringSplit(buffIDs,",") do
				local found = false
				for _andid in StringSplit(_orids,"+") do
					found = false
					for i, buff in pairs(buffs) do
						
						if (buff.buffID == tonumber(_andid)) then 
							found = true
						end
					end
					if (not found) then 
						break
					end
				end
				if (found) then 
					return true 
				end
			end
	end
    return false
end

function gw2_common_functions.BufflistHasBuffs(bufflist, buffIDs)
	
	if (bufflist == nil or TableSize(bufflist) == 0) then return false end
		
	for _orids in StringSplit(buffIDs,",") do
		local found = false
		for _andid in StringSplit(_orids,"+") do
				found = false
			for i, buff in pairs(bufflist) do
				
				if (buff.buffID == tonumber(_andid)) then 
					found = true
				end
			end
			if (not found) then 
				break
			end
		end
		if (found) then 
			return true 
		end
	end
    return false
end

function gw2_common_functions.CountConditions(bufflist)
	local count = 0
	if ( bufflist ) then	
		local i,buff = next(bufflist)
		while i and buff do							
			local bskID = buff.skillID
			if ( bskID and ml_global_information.ConditionsEnum[bskID] ~= nil) then
				count = count + 1
			end
			i,buff = next(bufflist,i)
		end		
	end
	return count
end
function gw2_common_functions.CountBoons(bufflist)
	local count = 0
	if ( bufflist ) then	
		local i,buff = next(bufflist)
		while i and buff do							
			local bskID = buff.skillID
			if ( bskID and ml_global_information.BoonsEnum[bskID] ~= nil) then
				count = count + 1
			end
			i,buff = next(bufflist,i)
		end		
	end
	return count
end

function gw2_common_functions.NecroLeaveDeathshroud()
	if (Player.profession == 8 ) then
		local deathshroud = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_13)
		if ( deathshroud ~= nil and deathshroud.skillID == 10585 and Player:CanCast() and Player:GetCurrentlyCastedSpell() == 17 ) then
			Player:CastSpell(GW2.SKILLBARSLOT.Slot_13)
			return true
		end
	end
	return false
end

function gw2_common_functions.GetPartyMemberByName( name )	
	local partylist = Player:GetParty()
	if ( TableSize(partylist) > 0 ) then
		local index, player  = next( partylist )		
		while ( index ~= nil and player ~= nil ) do
			if (player.name == name) then
				return player
			end
			index, player  = next( partylist,index )
		end	
	end
	return nil
end

function gw2_common_functions.MoveOnlyStraightForward()
	if ( Player:IsMoving() ) then
		local movdirs = Player:GetMovement()
		if (movdirs.left) then
			Player:UnSetMovement(2)
			return true
		elseif (movdirs.right) then 
			Player:UnSetMovement(3)
			return true
		end
	end
	return false
end

function gw2_common_functions.FinishEnemy()    
	if ( ml_global_information.Player_IsMoving == false and ml_global_information.Player_Health.percent > 15 ) then
		local EList = CharacterList("nearest,downed,aggro,attackable,interactable,selectable,maxdistance=150,onmesh")
		if ( EList ) then
			local id,entity = next (EList)
			if ( id and entity ) then
				if ( entity.isInInteractRange ) then
					local t = Player:GetTarget()
					if ( t and t.id == id ) then						
						Player:Interact( id )
						ml_log("Finishing..")						
						ml_global_information.Wait(1000)
						return true						
					end
				end
			end
		end
	end
	return false
end


-- Tries to get a "best target" to attack
function gw2_common_functions.GetBestCharacterTarget( maxrange )
	
	local range = maxrange
	if ( range == nil ) then 
		range = ml_global_information.AttackRange
	end
	
	if ( range < 200 ) then range = 750 end -- extend search range a bit for melee chars
	
	-- Try to get Aggro Enemy with los in range first
	local target = gw2_common_functions.GetCharacterTargetExtended("aggro,onmesh,lowesthealth,los,maxdistance="..tostring(range))
	-- Try to get Aggro Enemy
	if ( not target ) then target = gw2_common_functions.GetCharacterTargetExtended("aggro,onmesh,nearest") end
	-- Try to get Enemy with los in range 
	if ( not target ) then target = gw2_common_functions.GetCharacterTargetExtended("lowesthealth,onmesh,los,maxdistance="..tostring(range)) end
	-- Try to get Enemy without los
	if ( not target ) then target = gw2_common_functions.GetCharacterTargetExtended("shortestpath,onmesh") end
	
	if ( target and target.id ) then
		if ( target.distance < 1500 and target.los ) then
			Player:SetTarget(target.id)
		end
		return target
	else
		
		local currTarget = Player:GetTarget()
		if ( currTarget ~= nil and currTarget.attackable and currTarget.alive ) then
			return target
		end
	end
	return nil 
end
-- Tries to get a "best target" to attack for assist mode (maxdistance limited)
function gw2_common_functions.GetBestCharacterTargetForAssist()
	-- Try to get Enemy with los in range first
	local target = gw2_common_functions.GetCharacterTargetExtended("maxdistance="..tostring(ml_global_information.AttackRange)..",los")
	-- Try to get Enemy without los in range 
	if ( not target ) then target = gw2_common_functions.GetCharacterTargetExtended("maxdistance="..tostring(ml_global_information.AttackRange)) end
	-- Try to get Enemy without los in range + 250
	if ( not target ) then target = gw2_common_functions.GetCharacterTargetExtended("maxdistance="..tostring(ml_global_information.AttackRange + 250)) end
	
	if ( target and target.id ) then
		if ( target.distance < 1500 and target.los ) then
			Player:SetTarget(target.id)
		end
		return target
	else
		
		local currTarget = Player:GetTarget()
		if ( currTarget ~= nil and currTarget.attackable ) then
			return target
		end
	end
	return nil 
end
-- Tries to get a "best aggro target" to attack
function gw2_common_functions.GetBestAggroTarget()
	local range = ml_global_information.AttackRange
	if ( range < 200 ) then range = 750 end -- extend search range a bit for melee chars
	if ( range > 1000 ) then range = 1000 end -- limit search range a bit for ranged chars
	
	-- Try to get Aggro Enemy with los in range first
	local target = gw2_common_functions.GetCharacterTargetExtended("aggro,onmesh,lowesthealth,los,maxdistance="..tostring(range))
	-- Try to get Aggro Enemy
	if ( not target ) then target = gw2_common_functions.GetCharacterTargetExtended("aggro,onmesh,nearest") end
	
	if ( target and target.id ) then
		if ( target.distance < 1500 and target.los ) then
			Player:SetTarget(target.id)
		end
		return target
	else
		
		local currTarget = Player:GetTarget()
		if ( currTarget ~= nil and currTarget.attackable ) then
			return target
		end		
	end
	return nil 
end
function gw2_common_functions.GetCharacterTargetExtended( filterstring )
    if ( filterstring ) then
		filterstring = filterstring..",attackable,alive,noCritter,exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters"))
	else
		filterstring = "attackable,alive,noCritter,exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters"))
	end
	
	-- Only in AssistMode we want to allow these settings
	if (gBotMode == GetString("assistMode")) then
		if (sMmode == "Players Only") then filterstring = filterstring..",player" end		
		if (sMtargetmode == "LowestHealth") then filterstring = filterstring..",lowesthealth" end
		if (sMtargetmode == "Closest") then filterstring = filterstring..",nearest" end
		if (sMtargetmode == "Biggest Crowd") then filterstring = filterstring..",clustered=600" end
	end
	
	local TargetList = CharacterList(filterstring)
	if ( TargetList ) then
		local id,entry = next(TargetList)
		if (id and entry ) then			
			return entry
		end
	end	
	return nil
end





-- trouble with deleting the stupid window while it has events registered, turns out that crashes / fucks stuff up if more than just 1 function is using this dialog with different args
function gw2_common_functions.CreateDialog(name,func)

	local dialog = WindowManager:NewWindow("Dialog",nil,nil,nil,nil,true)
	
	local wSize = {w = 300, h = 100}
	dialog:SetSize(wSize.w,wSize.h)
	dialog:Dock(GW2.DOCK.Center)
	dialog:Focus()
	dialog:SetModal(true)
	dialog:NewField(name,"dialogfieldString",name)
	dialog:Show()
	dialog:UnFold(name)
	
	local bSize = {w = 60, h = 20}
	-- Cancel Button
	local cancel = dialog:NewButton("Cancel","CancelDialog")
	cancel:Dock(0)
	cancel:SetSize(bSize.w,bSize.h)
	cancel:SetPos(((wSize.w - 12) - bSize.w),40)
	RegisterEventHandler("CancelDialog", function() dialog:SetModal(false) dialog:Hide() dialog:Delete() end)
	-- OK Button
	local OK = dialog:NewButton("OK","OKDialog")
	OK:Dock(0)
	OK:SetSize(bSize.w,bSize.h)
	OK:SetPos(((wSize.w - 12) - (bSize.w * 2 + 10)),40)
	RegisterEventHandler("OKDialog", function() if (ValidString(dialogfieldString) == false) then ml_error("Please enter " .. name .. " first.") return false end dialog:SetModal(false) func(dialogfieldString) dialog:Hide() dialog:Delete() return true end)
end
