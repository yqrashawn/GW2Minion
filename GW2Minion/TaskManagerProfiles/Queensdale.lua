-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["name"] = "Queensdale";
	["tasks"] = {
		[1] = {
			["enabled"] = "1";
			["type"] = "MoveTo Position";
			["minlvl"] = 0;
			["id"] = 1;
			["maxlvl"] = "80";
			["customVars"] = {
			};
			["partysize"] = 0;
			["mapid"] = 15;
			["minduration"] = 0;
			["name"] = "WP_ShaemoorWaypoint";
			["complete"] = false;
			["maxduration"] = 0;
			["priority"] = 1;
			["cooldown"] = 0;
			["mappos"] = "-16512/17324/-1371";
		};
		[2] = {
			["enabled"] = "1";
			["type"] = "MoveTo Position";
			["minlvl"] = 0;
			["id"] = 2;
			["maxlvl"] = 80;
			["customVars"] = {
			};
			["partysize"] = 0;
			["mapid"] = 15;
			["minduration"] = 0;
			["name"] = "POI_TrainersTerrace";
			["complete"] = false;
			["maxduration"] = 0;
			["priority"] = 2;
			["cooldown"] = 0;
			["mappos"] = "-18959/14484/-839";
		};
		[3] = {
			["enabled"] = "1";
			["type"] = "MoveTo Position";
			["minlvl"] = 0;
			["id"] = 3;
			["maxlvl"] = 80;
			["customVars"] = {
			};
			["partysize"] = 0;
			["mapid"] = 15;
			["minduration"] = 0;
			["name"] = "WP_Fields";
			["complete"] = false;
			["maxduration"] = 0;
			["priority"] = 3;
			["cooldown"] = 0;
			["mappos"] = "-25394/14145/-866";
		};
		[4] = {
			["enabled"] = "1";
			["type"] = "MoveTo Position";
			["minlvl"] = 0;
			["id"] = 4;
			["maxlvl"] = 80;
			["customVars"] = {
			};
			["partysize"] = 0;
			["mapid"] = 15;
			["minduration"] = 0;
			["name"] = "POI_JebsWheatfield";
			["complete"] = false;
			["maxduration"] = 0;
			["priority"] = 4;
			["cooldown"] = 0;
			["mappos"] = "-29539/15816/-846";
		};
		[5] = {
			["enabled"] = "1";
			["type"] = "HeartQuest";
			["minlvl"] = 0;
			["maxlvl"] = "80";
			["id"] = 5;
			["radius"] = "3500";
			["customVars"] = {
				["TM_TASK_interactContentIDs"] = {
					["value"] = "147874";
					["type"] = "Field";
				};
				["TM_TASK_interactContentID2s"] = {
					["value"] = "135266816";
					["type"] = "Field";
				};
				["TM_TASK_enemyContentIDs"] = {
					["value"] = "44322";
					["type"] = "Field";
				};
				["TM_TASK_KillEnemies"] = {
					["value"] = "Interact&Kill";
					["type"] = "ComboBox";
				};
				["TM_TASK_maxInteracts"] = {
					["value"] = "20";
					["type"] = "Numeric";
				};
				["TM_TASK_maxKills"] = {
					["value"] = "10";
					["type"] = "Numeric";
				};
			};
			["partysize"] = 0;
			["mapid"] = 15;
			["minduration"] = 0;
			["name"] = "HQ_Help Diah Tend Her Farm";
			["complete"] = false;
			["maxduration"] = "600";
			["priority"] = 5;
			["cooldown"] = 0;
			["mappos"] = "-28904/14536/-864";
		};
		[6] = {
			["customVars"] = {
				["TM_TASK_subRegion"] = {
					["value"] = "216";
					["type"] = "Field";
				};
				["TM_TASK_interactContentIDs"] = {
					["value"] = "216402";
					["type"] = "Field";
				};
				["TM_TASK_interactContentID2s"] = {
					["value"] = "135266816";
					["type"] = "Field";
				};
				["TM_TASK_KillEnemies"] = {
					["value"] = "Interact&Kill";
					["type"] = "ComboBox";
				};
				["TM_TASK_enemyContentIDs"] = {
					["value"] = "301506,44214";
					["type"] = "Field";
				};
				["TM_TASK_maxInteracts"] = {
					["value"] = "15";
					["type"] = "Numeric";
				};
				["TM_TASK_maxKills"] = {
					["value"] = "20";
					["type"] = "Numeric";
				};
			};
			["radius"] = "4000";
			["minlvl"] = "1";
			["id"] = 6;
			["maxlvl"] = "80";
			["partysize"] = 0;
			["enabled"] = "1";
			["complete"] = true;
			["mapid"] = 15;
			["minduration"] = 0;
			["name"] = "HQ_Help Fisher Travis maintain the river";
			["type"] = "HeartQuest";
			["maxduration"] = "600";
			["priority"] = 6;
			["cooldown"] = "300";
			["mappos"] = "-28362/22339/-237";
		};
		[7] = {
			["enabled"] = "1";
			["radius"] = "4000";
			["minlvl"] = "2";
			["maxlvl"] = "80";
			["id"] = 7;
			["partysize"] = 0;
			["customVars"] = {
				["TM_TASK_subRegion"] = {
					["value"] = "218";
					["type"] = "Field";
				};
				["TM_TASK_interactContentIDs"] = {
					["value"] = "180293,216436";
					["type"] = "Field";
				};
				["TM_TASK_interactContentID2s"] = {
					["value"] = "135266816";
					["type"] = "Field";
				};
				["TM_TASK_enemyContentIDs"] = {
					["value"] = "178571,301489";
					["type"] = "Field";
				};
				["TM_TASK_KillEnemies"] = {
					["value"] = "Interact&Kill";
					["type"] = "ComboBox";
				};
				["TM_TASK_maxInteracts"] = {
					["value"] = "20";
					["type"] = "Numeric";
				};
				["TM_TASK_maxKills"] = {
					["value"] = "20";
					["type"] = "Numeric";
				};
			};
			["complete"] = true;
			["mapid"] = 15;
			["minduration"] = 0;
			["name"] = "HQ_Help Foreman Flannum...";
			["type"] = "HeartQuest";
			["maxduration"] = "800";
			["priority"] = 7;
			["cooldown"] = "300";
			["mappos"] = "-26035/23685/-772";
		};
		[8] = {
			["customVars"] = {
			};
			["radius"] = 0;
			["minlvl"] = "2";
			["id"] = 8;
			["maxlvl"] = "80";
			["enabled"] = "1";
			["partysize"] = 0;
			["complete"] = true;
			["mapid"] = 15;
			["minduration"] = 0;
			["name"] = "Vista_Near Foreman ";
			["type"] = "Vista";
			["maxduration"] = "600";
			["priority"] = 8;
			["cooldown"] = 0;
			["mappos"] = "-31813/28433/-1305";
		};
		[9] = {
			["customVars"] = {
			};
			["superClass"] = nil --[[functions with upvalue not supported]];
			["class"] = nil --[[functions with upvalue not supported]];
			["complete"] = false;
			["mapid"] = 15;
			["priority"] = 9;
			["mappos"] = "-37242/19280/-583";
			["isa"] = nil --[[functions with upvalue not supported]];
			["radius"] = "0";
			["minlvl"] = "0";
			["maxlvl"] = 80;
			["Create"] = nil --[[functions with upvalue not supported]];
			["maxduration"] = "0";
			["minduration"] = 0;
			["name"] = "WP_Orchard Waypoint";
			["id"] = 9;
			["partysize"] = 0;
			["enabled"] = "1";
			["cooldown"] = "0";
			["type"] = "MoveTo Position";
		};
		[10] = {
			["customVars"] = {
			};
			["superClass"] = nil --[[functions with upvalue not supported]];
			["class"] = nil --[[functions with upvalue not supported]];
			["complete"] = false;
			["mapid"] = 15;
			["priority"] = 10;
			["mappos"] = "-38007/21689/-578";
			["isa"] = nil --[[functions with upvalue not supported]];
			["radius"] = 0;
			["minlvl"] = 0;
			["maxlvl"] = 80;
			["Create"] = nil --[[functions with upvalue not supported]];
			["maxduration"] = 0;
			["minduration"] = 0;
			["name"] = "POI_Edas Orchard";
			["id"] = 10;
			["partysize"] = 0;
			["enabled"] = "1";
			["cooldown"] = 0;
			["type"] = "MoveTo Position";
		};
		[11] = {
			["customVars"] = {
				["TM_TASK_subRegion"] = {
					["value"] = "219";
					["type"] = "Field";
				};
				["TM_TASK_interactContentIDs"] = {
					["value"] = "216438";
					["type"] = "Field";
				};
				["TM_TASK_interactContentID2s"] = {
					["value"] = "135266816";
					["type"] = "Field";
				};
				["TM_TASK_KillEnemies"] = {
					["value"] = "Interact&Kill";
					["type"] = "ComboBox";
				};
				["TM_TASK_maxInteracts"] = {
					["value"] = "25";
					["type"] = "Numeric";
				};
				["TM_TASK_enemyContentIDs"] = {
					["value"] = "44300,44168,44255";
					["type"] = "Field";
				};
				["TM_TASK_maxKills"] = {
					["value"] = "25";
					["type"] = "Numeric";
				};
			};
			["superClass"] = nil --[[functions with upvalue not supported]];
			["class"] = nil --[[functions with upvalue not supported]];
			["complete"] = false;
			["mapid"] = 15;
			["priority"] = 11;
			["mappos"] = "-37827/24200/-551";
			["isa"] = nil --[[functions with upvalue not supported]];
			["radius"] = 0;
			["minlvl"] = "3";
			["maxlvl"] = 80;
			["Create"] = nil --[[functions with upvalue not supported]];
			["maxduration"] = "600";
			["minduration"] = 0;
			["name"] = "HQ_Assist Farmer Eda";
			["id"] = 11;
			["partysize"] = 0;
			["enabled"] = "1";
			["cooldown"] = "300";
			["type"] = "HeartQuest";
		};
	};
	["idcounter"] = 11;
	["version"] = 1;
}
return obj1
