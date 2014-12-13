

--[[
function testfunc(list)
	for global in StringSplit(list,",") do
		d(_G[global])
	end
	return "error message blablablablabla"
end

example usage:

local dialog = gw2_dialog_manager:NewDialog("mofo") -- creates a new dialog(groupname is name?)
dialog:NewLabel("whooop")
dialog:Show()

dialog:NewField("testfieldname","testfieldglobal","")
dialog:NewCheckBox("testcheckboxname","testcheckboxglobal","0")
dialog:NewNumeric("testnumericname","testnumericglobal",1,10,5)
dialog:NewComboBox("testcomboboxname","testcomboboxglobal","None,iRule","iRule")
dialog:NewCheckBox("testcheckboxname2","testcheckboxglobal2","0")
dialog:NewCheckBox("testcheckboxname3","testcheckboxglobal3","0")
dialog:NewCheckBox("testcheckboxname4","testcheckboxglobal4","0")
dialog:SetOkFunction(testfunc)
dialog:Show(true)

local dialog = gw2_dialog_manager:GetDialog("test")
dialog:Show()
]]

gw2_dialog_manager = {}
gw2_dialog_manager.dialogs = {}
local dialogPrototype = {}

function gw2_dialog_manager:NewDialog(name)
	if (ValidString(name) and self.dialogs[name] == nil) then
		local newDialog = {
			name = name,
			windowname = "Dialog " .. name,
			groupname = name,
			okFunction = function() return "dialog has no function for ok set." end,
			deleteFunction = function() return "dialog has no function for delete set." end,
			guiElements = {},
		}
		setmetatable(newDialog, {__index = dialogPrototype})
		self.dialogs[name] = newDialog
		return newDialog
	end
	if (ValidString(name) == false) then error("NewDialog(name), invalid arg: valid string expected.",2) end
end

function gw2_dialog_manager:GetDialog(name)
	if (ValidString(name) and self.dialogs[name]) then
		local newDialog = self.dialogs[name]
		return newDialog
	end
	if (ValidString(name) == false) then error("GetDialog(name), invalid arg: valid string expected.",2) end
end

function gw2_dialog_manager:GetDialogNames()
	local nameTable = {}
	for _,dialog in pairs(self.dialogs) do
		table.insert(nameTable,dialog.name)
	end
	return nameTable
end

--dialogPrototype
function dialogPrototype:SetOkFunction(okFunction)
	if (type(okFunction) == "function") then
		gw2_dialog_manager.dialogs[self.name].okFunction = okFunction
	end
end

function dialogPrototype:SetDeleteFunction(deleteFunction)
	if (type(deleteFunction) == "function") then
		gw2_dialog_manager.dialogs[self.name].deleteFunction = deleteFunction
	end
end

function dialogPrototype:NewField(name,globaleventname,defaultValue)
	local newElement = {
		guitype = "NewField",
		name = name,
		globaleventname = globaleventname,
		defaultValue = defaultValue or "",
	}
	table.insert(gw2_dialog_manager.dialogs[self.name].guiElements,newElement)
end

function dialogPrototype:NewCheckBox(name,globaleventname,defaultValue)
	local newElement = {
		guitype = "NewCheckBox",
		name = name,
		globaleventname = globaleventname,
		defaultValue = defaultValue or "0",
	}
	table.insert(gw2_dialog_manager.dialogs[self.name].guiElements,newElement)
end

function dialogPrototype:NewNumeric(name,globaleventname,minimumval,maximumval,defaultValue)
	local newElement = {
		guitype = "NewNumeric",
		name = name,
		globaleventname = globaleventname,
		minimumval = minimumval,
		maximumval = maximumval,
		defaultValue = defaultValue or minimumval or 0,
	}
	table.insert(gw2_dialog_manager.dialogs[self.name].guiElements,newElement)
end

function dialogPrototype:NewComboBox(name,globaleventname,itemlist,defaultValue)
	local newElement = {
		guitype = "NewComboBox",
		name = name,
		globaleventname = globaleventname,
		itemlist = itemlist or "None",
		defaultValue = defaultValue or "0",
	}
	table.insert(gw2_dialog_manager.dialogs[self.name].guiElements,newElement)
end

function dialogPrototype:NewLabel(name)
	local newElement = {
		guitype = "NewLabel",
		name = name,
	}
	table.insert(gw2_dialog_manager.dialogs[self.name].guiElements,newElement)
end

function dialogPrototype:Create()
	local dialog = WindowManager:GetWindow(self.windowname) -- Get dialog
	local windowHeight = 80 -- Set windowheight and ajust it dynamicly
	for _,newElement in ipairs(self.guiElements) do
		windowHeight = windowHeight + (newElement.guitype == "NewField" and 18 or newElement.guitype == "NewCheckBox" and 18 or newElement.guitype == "NewNumeric" and 22 or newElement.guitype == "NewComboBox" and 18 or newElement.guitype == "NewLabel" and 22)
	end
	local wSize = {w = 300, h = windowHeight}
	local bSize = {w = 60, h = 20}
	if (dialog == nil) then -- no dialog found, create window and buttons.
		dialog = WindowManager:NewWindow(self.windowname,nil,nil,nil,nil,true)
		local OK = dialog:NewButton("OK",self.name .. "OKDialog")
		OK:Dock(0)
		OK:SetSize(bSize.w,bSize.h)
		RegisterEventHandler(self.name .. "OKDialog",function()
				local list = ""
				for _,newElement in ipairs(self.guiElements) do
					list = (list == "" and newElement.globaleventname or list .. "," .. newElement.globaleventname)
				end
				local result = self.okFunction(list)
				if (result == true) then dialog:SetModal(false) dialog:Hide()
				elseif (ValidString(result)) then ml_error(result) end
			end
		)
		local cancel = dialog:NewButton("Cancel",self.name .. "CancelDialog")
		cancel:Dock(0)
		cancel:SetSize(bSize.w,bSize.h)
		RegisterEventHandler(self.name .. "CancelDialog", function() dialog:SetModal(false) dialog:Hide() end)
		
		local delete = dialog:NewButton("Delete",self.name .. "DeleteDialog")
		delete:Dock(0)
		delete:SetSize(bSize.w,bSize.h)
		RegisterEventHandler(self.name .. "DeleteDialog",function()
				local result = self.deleteFunction()
				if (result == true) then dialog:SetModal(false) dialog:Hide()
				elseif (ValidString(result)) then ml_error(result) end
			end
		)
		delete:Hide()
	end
	local OK = dialog:GetControl("OK") -- Set button positions based on window size
	OK:SetPos(((wSize.w - 12) - (bSize.w * 2 + 10)),wSize.h-bSize.h-35)
	local cancel = dialog:GetControl("Cancel")
	cancel:SetPos(((wSize.w - 12) - bSize.w),wSize.h-bSize.h-35)
	local delete = dialog:GetControl("Delete")
	delete:SetPos(0,wSize.h-bSize.h-35)
	dialog:DeleteGroup(self.groupname) -- recreate window elements.
	for _,newElement in ipairs(self.guiElements) do
		if (newElement.guitype == "NewField") then
			dialog:NewField(newElement.name,newElement.globaleventname,self.groupname)
			_G[newElement.globaleventname] = newElement.defaultValue
		elseif (newElement.guitype == "NewCheckBox") then
			dialog:NewCheckBox(newElement.name,newElement.globaleventname,self.groupname)
			_G[newElement.globaleventname] = newElement.defaultValue
		elseif (newElement.guitype == "NewNumeric") then
			dialog:NewNumeric(newElement.name,newElement.globaleventname,self.groupname,newElement.minimumval,newElement.maximumval)
			_G[newElement.globaleventname] = newElement.defaultValue
		elseif (newElement.guitype == "NewComboBox") then
			dialog:NewComboBox(newElement.name,newElement.globaleventname,self.groupname,newElement.itemlist)
			_G[newElement.globaleventname] = newElement.defaultValue
		elseif (newElement.guitype == "NewLabel") then
			dialog:NewLabel(newElement.name)
		end
		dialog:UnFold(self.groupname)
	end
	dialog:Hide()
end

function dialogPrototype:Show(deleteB,cancelB)
	local dialog = WindowManager:GetWindow(self.windowname)
	if (dialog) then
		local windowHeight = 80
		for _,newElement in ipairs(self.guiElements) do
			windowHeight = windowHeight + (newElement.guitype == "NewField" and 18 or newElement.guitype == "NewCheckBox" and 18 or newElement.guitype == "NewNumeric" and 22 or newElement.guitype == "NewComboBox" and 18 or newElement.guitype == "NewLabel" and 22)
		end
		local wSize = {w = 300, h = windowHeight}
		local delete = dialog:GetControl("Delete")
		if (delete) then
			delete:Hide()
			if (deleteB) then delete:Show() end
		end
		if (cancelB) then
			local cancel = dialog:GetControl("Cancel")
			if (cancel) then
				cancel:Disable()
			end
		end
		
		dialog:SetSize(wSize.w,wSize.h)
		dialog:Dock(GW2.DOCK.Center)
		dialog:Focus()
		dialog:SetModal(true)
		dialog:Show()
	else
		self:Create()
		self:Show()
	end
end