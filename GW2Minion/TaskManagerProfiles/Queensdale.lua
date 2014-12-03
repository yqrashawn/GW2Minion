-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["name"] = "Queensdale";
	["tasks"] = {
		[1] = {
			["customVars"] = {
			};
			["type"] = "MoveTo Position";
			["minlvl"] = 0;
			["maxlvl"] = "80";
			["id"] = 1;
			["enabled"] = "1";
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
			["customVars"] = {
			};
			["type"] = "MoveTo Position";
			["minlvl"] = 0;
			["maxlvl"] = 80;
			["id"] = 2;
			["enabled"] = "1";
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
			["customVars"] = {
			};
			["type"] = "MoveTo Position";
			["minlvl"] = 0;
			["maxlvl"] = 80;
			["id"] = 3;
			["enabled"] = "1";
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
			["customVars"] = {
			};
			["type"] = "MoveTo Position";
			["minlvl"] = 0;
			["maxlvl"] = 80;
			["id"] = 4;
			["enabled"] = "1";
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
			["customVars"] = {
				["TM_TASK_interactContentIDs"] = {
					["value"] = "147874";
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
					["value"] = "44322";
					["type"] = "Field";
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
			["radius"] = "3500";
			["minlvl"] = 0;
			["maxlvl"] = "80";
			["id"] = 5;
			["type"] = "HeartQuest";
			["enabled"] = "1";
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
			["enabled"] = "1";
			["radius"] = "4000";
			["minlvl"] = "1";
			["maxlvl"] = "80";
			["id"] = 6;
			["partysize"] = 0;
			["customVars"] = {
				["TM_TASK_interactContentIDs"] = {
					["value"] = "216402";
					["type"] = "Field";
				};
				["TM_TASK_interactContentID2s"] = {
					["value"] = "135266816";
					["type"] = "Field";
				};
				["TM_TASK_enemyContentIDs"] = {
					["value"] = "301506,44214";
					["type"] = "Field";
				};
				["TM_TASK_KillEnemies"] = {
					["value"] = "Interact&Kill";
					["type"] = "ComboBox";
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
			["complete"] = false;
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
			["customVars"] = {
				["TM_TASK_interactContentIDs"] = {
					["value"] = "180293,216436";
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
					["value"] = "178571,301489";
					["type"] = "Field";
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
			["radius"] = "4000";
			["minlvl"] = "2";
			["id"] = 7;
			["maxlvl"] = "80";
			["enabled"] = "1";
			["partysize"] = 0;
			["complete"] = false;
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
			["superClass"] = nil --[[functions with upvalue not supported]];
			["class"] = nil --[[functions with upvalue not supported]];
			["complete"] = false;
			["mapid"] = 15;
			["priority"] = 8;
			["mappos"] = "-31813/28433/-1305";
			["isa"] = nil --[[functions with upvalue not supported]];
			["radius"] = 0;
			["minlvl"] = "2";
			["maxlvl"] = "80";
			["Create"] = nil --[[functions with upvalue not supported]];
			["maxduration"] = "600";
			["minduration"] = 0;
			["name"] = "Vista_Near Foreman ";
			["id"] = 8;
			["partysize"] = 0;
			["enabled"] = "1";
			["cooldown"] = 0;
			["type"] = "Vista";
		};
	};
	["idcounter"] = 8;
	["version"] = 1;
}
return obj1
