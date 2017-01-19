local tbl = 
{
	class = "SubTree",
	nodes = 
	{
		
		{
			class = "Action",
			nodes = 
			{
			},
			settings = 
			{
			},
			variables = 
			{
				filename = "tm_UseItem",
				finishcode = "",
				info = "",
				menucode = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
				runcode = "if(table.valid(context.useitems_itemlist)) then\n\t\tlocal itemids = {}\n\t\tfor _,item in pairs(context.useitems_itemlist) do\n\t\t\t\titemids[item.id] = true\n\t\tend\n\n\t\tlocal inventorylist = Inventory(\"\")\n\t\tfor slot,item in pairs(inventorylist) do\n\t\t\t\tif(itemids[item.itemid]) then\n\t\t\t\t\t\td(\"[UseItem]: Using \"..item.name)\n\t\t\t\t\t\titem:Use()\n\t\t\t\t\t\tml_global_information.Wait(500)\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\nend\n\nself:fail()",
				startcode = "",
				subtreeuicode = "",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "tm_UseItem.st",
		finishcode = "context.useitems_itemlist = nil",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.useitems_itemlist = self.settings.itemlist",
		startcode = "",
		subtreeuicode = "if(self.settings.itemlist == nil) then self.settings.itemlist = {} end\nlocal itemfilter = {}\nlocal itemlist = {}\nlocal itemnamelist = {}\n\nlocal items = Inventory(\"\")\nif(table.valid(items)) then\n\t\tfor _,item in pairs(items) do\n\t\t\t\tif(not itemfilter[item.itemid]) then\n\t\t\t\t\t\ttable.insert(itemlist, {id = item.itemid, name = item.name})\n\t\t\t\tend\n\t\tend\n\t\ttable.sort(itemlist, function(a,b) return a.name < b.name end)\n\n\t\tfor _,item in ipairs(itemlist) do\n\t\t\t\ttable.insert(itemnamelist, item.name)\n\t\tend\nend\n\nself.currentitem = GUI:Combo(GetString(\"Inventory item\"),self.currentitem or 1,itemnamelist)\nif(GUI:Button(GetString(\"Add item\"))) then\n\t\tlocal item = itemlist[self.currentitem]\n\t\tlocal found = false\n\t\tfor _,existingitem in pairs(self.settings.itemlist) do\n\t\t\t\tif(item.id == existingitem.id) then found = true end\n\t\tend\n\t\tif(not found) then\n\t\t\t\ttable.insert(self.settings.itemlist, item)\n\t\telse\n\t\t\t\td(\"[UseItem]: Item already in list\")\n\t\tend\nend\n\nGUI:Separator()\n\n\nif(table.valid(self.settings.itemlist)) then\n\t\tGUI:Columns(3)\n\t\tGUI:Text(\"Name\") GUI:NextColumn()\n\t\tGUI:Text(\"Item id\") GUI:NextColumn() GUI:NextColumn()\n\t\tfor i,item in ipairs(self.settings.itemlist) do\n\t\t\t\tGUI:Separator()\n\t\t\t\tGUI:Text(item.name) GUI:NextColumn()\n\t\t\t\tGUI:Text(item.id) GUI:NextColumn()\n\t\t\t\tif(GUI:Button(GetString(\"Remove item##\"..i))) then\n\t\t\t\t\t\ttable.remove(self.settings.itemlist, i)\n\t\t\t\tend\n\t\t\t\tGUI:NextColumn()\n\t\t\t\t\n\t\tend\n\t\tGUI:Columns(1)\nelse\n\t\tGUI:Text(\"No items added\")\nend",
	},
}



return tbl