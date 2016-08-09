-- Salvaging + Settings
gw2_task_salvage = inheritsFrom(ml_task)
gw2_task_salvage.name = GetString("salvage")

function gw2_task_salvage.Create()
	local newinst = inheritsFrom(gw2_task_salvage)
	
	--ml_task members
	newinst.valid = true
	newinst.completed = false
	newinst.subtask = nil
	newinst.process_elements = {}
	newinst.overwatch_elements = {}
	
	return newinst
end

function gw2_task_salvage:Init()
	-- ml_log("gw2_task_salvage:Init")
	
	self:add(ml_element:create("Salvage",c_salvage,e_salvage,100),self.process_elements)
	
	self:AddTaskCheckCEs()
end
function gw2_task_salvage:task_complete_eval()
	if (gw2_salvage_manager.active) then
		if ( Inventory.freeSlotCount >= 2 ) then
			if (gw2_salvage_manager.haveSalvageTools() == false) then
				if (gw2_salvage_manager.haveSalvagebleItems() == false) then
					d("No items to salvage left")
					ml_log("No items to salvage left")
					return true
				end
				d("No Salvagetools in inventory")
				ml_log("No Salvagetools in inventory")
				return true
			end
		else
			d("Not enough free space in inventory to salvage!")
			ml_log("Not enough free space in inventory to salvage!")
			return true
		end
	else
		d("Salvaging is disabled!")
		ml_log("Salvaging is disabled!")
		return true
	end
	return false
end

function gw2_task_salvage:UIInit()
	d("gw2_task_salvage:UIInit")
	return true
end
function gw2_task_salvage:UIDestroy()
	d("gw2_task_salvage:UIDestroy")
end

function gw2_task_salvage:RegisterDebug()
    d("gw2_task_salvage:RegisterDebug")
end

c_salvage = inheritsFrom( ml_cause )
e_salvage = inheritsFrom( ml_effect )
function c_salvage:evaluate()
	if (gw2_salvage_manager.active and Inventory.freeSlotCount >= 2 and gw2_salvage_manager.haveSalvageTools() and gw2_salvage_manager.haveSalvagebleItems() and gw2_salvage_manager.checkCustomChecks()) then
		return true
	end
	return false
end
function e_salvage:execute()
	--ml_log("e_need_salvage")
	local iList = gw2_salvage_manager.createItemList()
	if (iList) then 
		for _,item in pairs(iList) do
			local tool = gw2_salvage_manager.getBestTool(item)
			if (tool and Player:GetCurrentlyCastedSpell() == ml_global_information.MAX_SKILLBAR_SLOTS) then
				d("Salvaging "..item.name.." with "..tool.name)
				tool:Use(item)
				return ml_log(true)
			end
		end
	end
	return ml_log(false)
end

ml_global_information.AddBotMode(GetString("salvage"), gw2_task_salvage)