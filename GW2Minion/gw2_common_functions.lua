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
