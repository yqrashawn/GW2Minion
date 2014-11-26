-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["name"] = "haha";
	["tasks"] = {
		[1] = {
			["customVars"] = {
				["TM_TASK_vodka"] = {
					["value"] = 0;
					["type"] = "Numeric";
				};
				["TM_TASK_whiskey"] = {
					["value"] = "B";
					["type"] = "ComboBox";
				};
				["TM_TASK_beer"] = {
					["value"] = "ffff";
					["type"] = "Field";
				};
			};
			["type"] = "Grind";
			["startMapID"] = "";
			["startMapPosition"] = "";
			["startMapName"] = "";
			["maxDuration"] = 9999;
			["partyPlayerCount"] = 0;
			["minDuration"] = 0;
			["maxLevel"] = 80;
			["minLevel"] = 0;
			["name"] = "firsttasj";
			["completed"] = false;
			["priority"] = 1;
			["id"] = 1;
			["cooldownDuration"] = 0;
		};
		[2] = {
			["customVars"] = {
				["TM_TASK_vodka"] = {
					["value"] = "2";
					["type"] = "Numeric";
				};
				["TM_TASK_whiskey"] = {
					["value"] = "A";
					["type"] = "ComboBox";
				};
				["TM_TASK_beer"] = {
					["value"] = "abc def";
					["type"] = "Field";
				};
			};
			["type"] = "Grind";
			["startMapID"] = "";
			["startMapPosition"] = "";
			["startMapName"] = "";
			["maxDuration"] = 9999;
			["partyPlayerCount"] = 0;
			["minDuration"] = 0;
			["minLevel"] = 0;
			["maxLevel"] = 80;
			["name"] = "secondtask";
			["completed"] = false;
			["priority"] = 2;
			["id"] = 2;
			["cooldownDuration"] = 0;
		};
		[3] = {
			["customVars"] = {
			};
			["type"] = "Gather";
			["startMapID"] = "";
			["startMapPosition"] = "";
			["startMapName"] = "";
			["maxDuration"] = 9999;
			["partyPlayerCount"] = 0;
			["minDuration"] = 0;
			["minLevel"] = 0;
			["maxLevel"] = 80;
			["name"] = "sagg";
			["completed"] = false;
			["priority"] = 3;
			["id"] = 3;
			["cooldownDuration"] = 0;
		};
	};
	["idcounter"] = 3;
	["version"] = 1;
}
return obj1
