-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["idcounter"] = 92;
	["name"] = "Queensdale";
	["tasks"] = {
		[1] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 1;
			["mapid"] = 15;
			["mappos"] = "-16512/17324/-1371";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_ShaemoorWaypoint";
			["partysize"] = 0;
			["priority"] = 1;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[2] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 2;
			["mapid"] = 15;
			["mappos"] = "-18959/14484/-839";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_TrainersTerrace";
			["partysize"] = 0;
			["priority"] = 2;
			["type"] = "MoveTo Position";
		};
		[3] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 3;
			["mapid"] = 15;
			["mappos"] = "-25394/14145/-866";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Fields";
			["partysize"] = 0;
			["priority"] = 3;
			["type"] = "MoveTo Position";
		};
		[4] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 4;
			["mapid"] = 15;
			["mappos"] = "-29539/15816/-846";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_JebsWheatfield";
			["partysize"] = 0;
			["priority"] = 4;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[5] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_KillEnemies"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "44322";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "8958,4284,18083,29589,24128,27505,26261,23433,14662,32346,22465,11370";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "215";
				};
			};
			["enabled"] = "1";
			["id"] = 5;
			["mapid"] = 15;
			["mappos"] = "-29230/15860/-824";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Help Diah Tend Her Farm";
			["partysize"] = 0;
			["priority"] = 5;
			["radius"] = "2500";
			["type"] = "HeartQuest";
		};
		[6] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "";
				};
				["TM_TASK_KillEnemies"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "301506,44214";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "8954,30449,12285,28224,11921,4341,1361,1877,3244,29599";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "216";
				};
			};
			["enabled"] = "1";
			["id"] = 6;
			["mapid"] = 15;
			["mappos"] = "-28362/22339/-237";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "1";
			["name"] = "HQ_Help Fisher Travis maintain the river";
			["partysize"] = 0;
			["priority"] = 6;
			["radius"] = "4000";
			["type"] = "HeartQuest";
		};
		[7] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "";
				};
				["TM_TASK_KillEnemies"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "178571,301489,178572,43522";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "17279,29497,11801,15776,17990,15903,7084,26583,5380,14488,19572,11186";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "218";
				};
			};
			["enabled"] = "1";
			["id"] = 7;
			["mapid"] = 15;
			["mappos"] = "-26035/23685/-772";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "2";
			["name"] = "HQ_Help Foreman Flannum...";
			["partysize"] = 0;
			["priority"] = 7;
			["radius"] = "8000";
			["type"] = "HeartQuest";
		};
		[8] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 8;
			["mapid"] = 15;
			["mappos"] = "-31813/28433/-1305";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "2";
			["name"] = "Vista_Near Foreman ";
			["partysize"] = 0;
			["priority"] = 8;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[9] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 9;
			["mapid"] = 15;
			["mappos"] = "-37242/19280/-583";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Orchard Waypoint";
			["partysize"] = 0;
			["priority"] = 9;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[10] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 10;
			["mapid"] = 15;
			["mappos"] = "-38007/21689/-578";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Edas Orchard";
			["partysize"] = 0;
			["priority"] = 10;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[11] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_KillEnemies"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "44300,44168,44255";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "31376,831,515,12214,25899,26827,18548,19980,4470,16298,25899,28189";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "219";
				};
			};
			["enabled"] = "1";
			["id"] = 11;
			["mapid"] = 15;
			["mappos"] = "-37973/22610/-573";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "3";
			["name"] = "HQ_Assist Farmer Eda";
			["partysize"] = 0;
			["priority"] = 11;
			["radius"] = "5500";
			["type"] = "HeartQuest";
		};
		[12] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 12;
			["mapid"] = 15;
			["mappos"] = "-37282/19264/-583";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "4";
			["name"] = "WP_Orchard Waypoint";
			["partysize"] = 0;
			["priority"] = 12;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[13] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 13;
			["mapid"] = 15;
			["mappos"] = "-37709/13990/-1067";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Mepis Moa Ranch";
			["partysize"] = 0;
			["priority"] = 13;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[14] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_KillEnemies"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43462,301454,43469,301460,43475";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "12195,1479,24531,12363,8241,923,13915";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "220";
				};
			};
			["enabled"] = "1";
			["id"] = 14;
			["mapid"] = 15;
			["mappos"] = "-38402/10954/-1046";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "4";
			["name"] = "HQ_Help Cassie";
			["partysize"] = 0;
			["priority"] = 14;
			["radius"] = "5500";
			["type"] = "HeartQuest";
		};
		[15] = {
			["complete"] = false;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 15;
			["mapid"] = 15;
			["mappos"] = "-36386/6768/-620";
			["maxduration"] = 0;
			["maxlvl"] = "4";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Grindtolvl5";
			["partysize"] = 0;
			["priority"] = 15;
			["radius"] = "0";
			["type"] = "Grind";
		};
		[16] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 16;
			["mapid"] = 15;
			["mappos"] = "-29497/2477/-937";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "5";
			["name"] = "Vista_Bandithaunt Caverns";
			["partysize"] = 0;
			["priority"] = 16;
			["radius"] = "5";
			["type"] = "Vista";
		};
		[17] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 17;
			["mapid"] = 15;
			["mappos"] = "-23141/5929/-2887";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "5";
			["name"] = "POI_Dalins Pumping Station";
			["partysize"] = 0;
			["priority"] = 17;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[18] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 18;
			["mapid"] = 15;
			["mappos"] = "-20536/7733/-2685";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Shaemoor Fields";
			["partysize"] = 0;
			["priority"] = 18;
			["radius"] = "5";
			["type"] = "Vista";
		};
		[19] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 19;
			["mapid"] = 15;
			["mappos"] = "-7707/12199/-1125";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "5";
			["name"] = "WP_Garrison Waypoint";
			["partysize"] = 0;
			["priority"] = 19;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[20] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 20;
			["mapid"] = 15;
			["mappos"] = "-6546/11131/-1744";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "5";
			["name"] = "Vista_Garrison";
			["partysize"] = 0;
			["priority"] = 20;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[21] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43494,232674,47844,8940,24688,13699";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "1343226368";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "26241,23879,31926,31518,20371,7433,8939,886,";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "213";
				};
			};
			["enabled"] = "1";
			["id"] = 21;
			["mapid"] = 15;
			["mappos"] = "-4188/6022/-1242";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "5";
			["name"] = "HQ_Assist_Seraph";
			["partysize"] = 0;
			["priority"] = 21;
			["radius"] = "8000";
			["type"] = "HeartQuest";
		};
		[22] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 22;
			["mapid"] = 15;
			["mappos"] = "-5009/5831/-1272";
			["maxduration"] = 0;
			["maxlvl"] = "6";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Grindtolvl7";
			["partysize"] = 0;
			["priority"] = 22;
			["radius"] = "0";
			["type"] = "Grind";
		};
		[23] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 23;
			["mapid"] = 15;
			["mappos"] = "-6500/2892/-121";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "7";
			["name"] = "WP_Scaver Waypoint";
			["partysize"] = 0;
			["priority"] = 23;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[24] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 24;
			["mapid"] = 15;
			["mappos"] = "-8510/-1358/-390";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "7";
			["name"] = "POI_Altar Brook Trading Post";
			["partysize"] = 0;
			["priority"] = 24;
			["radius"] = "5";
			["type"] = "MoveTo Position";
		};
		[25] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "223760,462659,43494";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "17271,29887,23648,8942,19901,26351,1172,17469,5920,8943,5063,17987,9191,7303,5031";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "214";
				};
			};
			["enabled"] = "1";
			["id"] = 25;
			["mapid"] = 15;
			["mappos"] = "-15599/-2950/-63";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "7";
			["name"] = "HQ_Help Lexi Price";
			["partysize"] = 0;
			["priority"] = 25;
			["radius"] = "0";
			["type"] = "HeartQuest";
		};
		[26] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 26;
			["mapid"] = 15;
			["mappos"] = "-19948/-4909/-482";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Crossing Waypoint";
			["partysize"] = 0;
			["priority"] = 26;
			["radius"] = "6";
			["type"] = "MoveTo Position";
		};
		[27] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 27;
			["mapid"] = 15;
			["mappos"] = "-17485/-5824/-343";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Altar Brook Crossing";
			["partysize"] = 0;
			["priority"] = 27;
			["radius"] = "6";
			["type"] = "MoveTo Position";
		};
		[28] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 28;
			["mapid"] = 15;
			["mappos"] = "-28822/-9854/-227";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "6";
			["name"] = "POI_Bar Curtis Range";
			["partysize"] = 0;
			["priority"] = 28;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[29] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 29;
			["mapid"] = 15;
			["mappos"] = "-34066/-9221/-825";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "6";
			["name"] = "WP_Vale Waypoint";
			["partysize"] = 0;
			["priority"] = 29;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[30] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 30;
			["mapid"] = 15;
			["mappos"] = "-36801/-11906/-1937";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "7";
			["name"] = "Vista_Altars Windings";
			["partysize"] = 0;
			["priority"] = 30;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[31] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 31;
			["mapid"] = 15;
			["mappos"] = "-31178/-19641/-37";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_DuranBrothersDocks";
			["partysize"] = 0;
			["priority"] = 31;
			["radius"] = "5";
			["type"] = "MoveTo Position";
		};
		[32] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 32;
			["mapid"] = 15;
			["mappos"] = "-31705/-20320/-439";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_ClayentFalls";
			["partysize"] = 0;
			["priority"] = 32;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[33] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 33;
			["mapid"] = 15;
			["mappos"] = "-22420/-15851/-1379";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "8";
			["name"] = "WP_Claypool Waypoint";
			["partysize"] = 0;
			["priority"] = 33;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[34] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Pickup&Use";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "0";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "8933";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "8204";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "57164";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "212";
				};
			};
			["enabled"] = "1";
			["id"] = 34;
			["mapid"] = 15;
			["mappos"] = "-21867/-16362/-1395";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "7";
			["name"] = "HQ_Train with the militia";
			["partysize"] = 0;
			["priority"] = 34;
			["radius"] = "1500";
			["type"] = "HeartQuest";
		};
		[35] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "232674,43494,232693,33554976,478444,22316,22317";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "211";
				};
			};
			["enabled"] = "1";
			["id"] = 35;
			["mapid"] = 15;
			["mappos"] = "-11412/-19009/-1367";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "8";
			["name"] = "HQ_Help the Seraph";
			["partysize"] = 0;
			["priority"] = 35;
			["radius"] = "7500";
			["type"] = "HeartQuest";
		};
		[36] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 36;
			["mapid"] = 15;
			["mappos"] = "-4232/-18246/-1367";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "8";
			["name"] = "WP_HeartWoodPass Camp Waypoint";
			["partysize"] = 0;
			["priority"] = 36;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[37] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 37;
			["mapid"] = 15;
			["mappos"] = "-3563/-9504/-128";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "8";
			["name"] = "POI_The Heartwoods";
			["partysize"] = 0;
			["priority"] = 37;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[38] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 38;
			["mapid"] = 15;
			["mappos"] = "3263/-11854/-1145";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "8";
			["name"] = "WP_Phinney Waypoint";
			["partysize"] = 0;
			["priority"] = 38;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[39] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 39;
			["mapid"] = 15;
			["mappos"] = "7193/16671/-38";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Ojons Lumbermill";
			["partysize"] = 0;
			["priority"] = 39;
			["radius"] = "8";
			["type"] = "MoveTo Position";
		};
		[40] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43620,43615,43621,43339,337264,43614,43618,511914";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "17440,14215,938,27836,28857,27655";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "226";
				};
			};
			["enabled"] = "1";
			["id"] = 40;
			["mapid"] = 15;
			["mappos"] = "8510/16311/-96";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "8";
			["name"] = "HQ_Assist Laborer Cardy";
			["partysize"] = 0;
			["priority"] = 40;
			["radius"] = "6000";
			["type"] = "HeartQuest";
		};
		[41] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 41;
			["mapid"] = 15;
			["mappos"] = "21269/18218/-1488";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "9";
			["name"] = "POI_Queens Forest";
			["partysize"] = 0;
			["priority"] = 41;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[42] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 42;
			["mapid"] = 15;
			["mappos"] = "14880/8493/-1522";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "8";
			["name"] = "POI_Kappas Corral";
			["partysize"] = 0;
			["priority"] = 42;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[43] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 43;
			["mapid"] = 15;
			["mappos"] = "14442/8689/-1505";
			["maxduration"] = "0";
			["maxlvl"] = "9";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Grindtolvl10";
			["partysize"] = 0;
			["priority"] = 43;
			["radius"] = "0";
			["type"] = "Grind";
		};
		[44] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43272,540546";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "228174";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "227";
				};
			};
			["enabled"] = "1";
			["id"] = 44;
			["mapid"] = 15;
			["mappos"] = "17637/18649/-965";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "9";
			["name"] = "HQ_Assist Hunter Block";
			["partysize"] = 0;
			["priority"] = 44;
			["radius"] = "12000";
			["type"] = "HeartQuest";
		};
		[45] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "283692";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "228";
				};
			};
			["enabled"] = "1";
			["id"] = 45;
			["mapid"] = 15;
			["mappos"] = "30400/20588/-21";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "9";
			["name"] = "HQ_Grind_AssitFisherman Will";
			["partysize"] = 0;
			["priority"] = 45;
			["radius"] = "7000";
			["type"] = "HeartQuest";
		};
		[46] = {
			["complete"] = true;
			["cooldown"] = "5";
			["customVars"] = {
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "206768";
				};
				["TM_TASK_tIDuration"] = {
					["type"] = "Numeric";
					["value"] = "3";
				};
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 46;
			["mapid"] = 15;
			["mappos"] = "35172/21859/-559";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "6";
			["name"] = "I_Erase_Graffiti_1";
			["partysize"] = 0;
			["priority"] = 46;
			["radius"] = "0";
			["type"] = "Interact";
		};
		[47] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "206768";
				};
				["TM_TASK_tIDuration"] = {
					["type"] = "Numeric";
					["value"] = "3";
				};
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 47;
			["mapid"] = 15;
			["mappos"] = "35341/20948/-576";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "I_Erase_Graffiti_II";
			["partysize"] = 0;
			["priority"] = 47;
			["radius"] = 0;
			["type"] = "Interact";
		};
		[48] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "206768";
				};
				["TM_TASK_tIDuration"] = {
					["type"] = "Numeric";
					["value"] = "3";
				};
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 48;
			["mapid"] = 15;
			["mappos"] = "36050/21961/-595";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "I_Erase_Graffiti_III";
			["partysize"] = 0;
			["priority"] = 48;
			["radius"] = 0;
			["type"] = "Interact";
		};
		[49] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "540913";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "2526";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "222";
				};
			};
			["enabled"] = "1";
			["id"] = 49;
			["mapid"] = 15;
			["mappos"] = "34395/21453/-557";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "HQ_Help the citizens of Beetletun";
			["partysize"] = 0;
			["priority"] = 49;
			["radius"] = "6000";
			["type"] = "HeartQuest";
		};
		[50] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 50;
			["mapid"] = 15;
			["mappos"] = "37242/21398/-840";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "WP_Beetletun Waypoint";
			["partysize"] = 0;
			["priority"] = 50;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[51] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 51;
			["mapid"] = 15;
			["mappos"] = "37853/18823/-904";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "Vista_Shire of Beetletun";
			["partysize"] = 0;
			["priority"] = 51;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[52] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 52;
			["mapid"] = 15;
			["mappos"] = "28882/10112/-1166";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "POI_BeetletunFarms";
			["partysize"] = 0;
			["priority"] = 52;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[53] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 53;
			["mapid"] = 15;
			["mappos"] = "15059/5934/-2036";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "Vista_Krytan Freeholds";
			["partysize"] = 0;
			["priority"] = 53;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[54] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 54;
			["mapid"] = 15;
			["mappos"] = "17611/5566/-1436";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "WP_Krytan";
			["partysize"] = 0;
			["priority"] = 54;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[55] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 55;
			["mapid"] = 15;
			["mappos"] = "18610/1223/-1432";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "POI_Monastery";
			["partysize"] = 0;
			["priority"] = 55;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[56] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "44150,43494,232674";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "30562,18287,17401,8945";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "225";
				};
			};
			["enabled"] = "1";
			["id"] = 56;
			["mapid"] = 15;
			["mappos"] = "18578/20/-1434";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "HQ_Keep the monastery";
			["partysize"] = 0;
			["priority"] = 56;
			["radius"] = "7000";
			["type"] = "HeartQuest";
		};
		[57] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 57;
			["mapid"] = 15;
			["mappos"] = "26540/1311/-1708";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "POI_KrytanHoltland";
			["partysize"] = 0;
			["priority"] = 57;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[58] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 58;
			["mapid"] = 15;
			["mappos"] = "30629/4010/-1171";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "WP_Tunwatch Redoubt Waypoint";
			["partysize"] = 0;
			["priority"] = 58;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[59] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 59;
			["mapid"] = 15;
			["mappos"] = "31665/765/-1892";
			["maxduration"] = 0;
			["maxlvl"] = "11";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Grindtolvl12";
			["partysize"] = 0;
			["priority"] = 59;
			["radius"] = "0";
			["type"] = "Grind";
		};
		[60] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43494,232674,43492,478444";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "44575";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "221";
				};
			};
			["enabled"] = "1";
			["id"] = 60;
			["mapid"] = 15;
			["mappos"] = "37618/-5845/-2887";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "12";
			["name"] = "HQ_Protect Beetletun farmers";
			["partysize"] = 0;
			["priority"] = 60;
			["radius"] = "15000";
			["type"] = "HeartQuest";
		};
		[61] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 61;
			["mapid"] = 15;
			["mappos"] = "39667/-5355/-3057";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "12";
			["name"] = "POI_Salmas Heath";
			["partysize"] = 0;
			["priority"] = 61;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[62] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 62;
			["mapid"] = 15;
			["mappos"] = "29861/-7230/-3625";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "12";
			["name"] = "POI_Orlaf Escarpments";
			["partysize"] = 0;
			["priority"] = 62;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[63] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 63;
			["mapid"] = 15;
			["mappos"] = "28762/-817/-2699";
			["maxduration"] = 0;
			["maxlvl"] = "12";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Grindtolvl13";
			["partysize"] = 0;
			["priority"] = 63;
			["radius"] = "8000";
			["type"] = "Grind";
		};
		[64] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43494,232674,43492";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "223";
				};
			};
			["enabled"] = "1";
			["id"] = 64;
			["mapid"] = 15;
			["mappos"] = "33263/-20301/-2238";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "12";
			["name"] = "HQ_Unite the ettins";
			["partysize"] = 0;
			["priority"] = 64;
			["radius"] = "3000";
			["type"] = "HeartQuest";
		};
		[65] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "Commune";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "243782";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 65;
			["mapid"] = 15;
			["mappos"] = "35157/-20316/-2289";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "SP_Tamini Place of Power";
			["partysize"] = 0;
			["priority"] = 65;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[66] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 66;
			["mapid"] = 15;
			["mappos"] = "27561/-23441/-2281";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "12";
			["name"] = "POI_Taminn Footholds";
			["partysize"] = 0;
			["priority"] = 66;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[67] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
			};
			["enabled"] = "1";
			["id"] = 67;
			["mapid"] = 15;
			["mappos"] = "37895/21536/-953";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "MovetoSPBeetle";
			["partysize"] = 0;
			["priority"] = 67;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[68] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "267540";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "267540";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 68;
			["mapid"] = 15;
			["mappos"] = "39980/22901/-1084";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "SP_Beetletun";
			["partysize"] = 0;
			["priority"] = 68;
			["radius"] = 0;
			["type"] = "Skillpoint";
		};
		[69] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
			};
			["enabled"] = "1";
			["id"] = 69;
			["mapid"] = 15;
			["mappos"] = "-7565/12254/-1133";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "MoveToSPScavenger";
			["partysize"] = 0;
			["priority"] = 69;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[70] = {
			["complete"] = true;
			["cooldown"] = "0";
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "Commune";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "19445";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 70;
			["mapid"] = 15;
			["mappos"] = "-5636/6384/-1272";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "SP_Scaver Plateau";
			["partysize"] = 0;
			["priority"] = 70;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[71] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "45413";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "45413";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 71;
			["mapid"] = 15;
			["mappos"] = "1358/6887/-2325";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "SP_Chhk the Windmill King";
			["partysize"] = 0;
			["priority"] = 71;
			["radius"] = 0;
			["type"] = "Skillpoint";
		};
		[72] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
			};
			["enabled"] = "1";
			["id"] = 72;
			["mapid"] = 15;
			["mappos"] = "-28170/-5745/-834";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "MovetoSPBandit";
			["partysize"] = 0;
			["priority"] = 72;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[73] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43469,301457";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "135270912";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "240811";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 73;
			["mapid"] = 15;
			["mappos"] = "-29312/-3945/-1338";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "SP_Bandit Loot";
			["partysize"] = 0;
			["priority"] = 73;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[74] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "22";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "135270400";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "26991";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "22375";
				};
				["TM_TASK_waitingTime"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 74;
			["mapid"] = 15;
			["mappos"] = "-40814/-4799/-2805";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "SP_Take a Glob";
			["partysize"] = 0;
			["priority"] = 74;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[75] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
			};
			["enabled"] = "1";
			["id"] = 75;
			["mapid"] = 15;
			["mappos"] = "2898/-11490/-1090";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "MoveToWP";
			["partysize"] = 0;
			["priority"] = 75;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[76] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 76;
			["mapid"] = 15;
			["mappos"] = "13095/-24613/-270";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "WP_Godslost Swamp";
			["partysize"] = 0;
			["priority"] = 76;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[77] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 77;
			["mapid"] = 15;
			["mappos"] = "11108/-12840/18";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "POI_Godslost Swamp";
			["partysize"] = 0;
			["priority"] = 77;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[78] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 78;
			["mapid"] = 15;
			["mappos"] = "11518/-11686/-1198";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "Vista_Godslost Swamp";
			["partysize"] = 0;
			["priority"] = 78;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[79] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 79;
			["mapid"] = 15;
			["mappos"] = "17557/-10779/-44";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "POI_Godslost Swamp2";
			["partysize"] = 0;
			["priority"] = 79;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[80] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_randomTargetPosition"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "1";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 80;
			["mapid"] = 15;
			["mappos"] = "20626/-10645/-76";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "WP_godslostSwamp";
			["partysize"] = 0;
			["priority"] = 80;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[81] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "544,193445,43942,43954,9198,8944";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "43455";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = "0";
				};
				["TM_TASK_pickupSkillID"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "224";
				};
			};
			["enabled"] = "1";
			["id"] = 81;
			["mapid"] = 15;
			["mappos"] = "13712/-8581/-71";
			["maxduration"] = "1000";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "HQ_Help historian Garrod";
			["partysize"] = 0;
			["priority"] = 81;
			["radius"] = "8000";
			["type"] = "HeartQuest";
		};
		[82] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 82;
			["mapid"] = 15;
			["mappos"] = "30175/-3084/-2598";
			["maxduration"] = "0";
			["maxlvl"] = "14";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Grindtolvl15";
			["partysize"] = 0;
			["priority"] = 82;
			["radius"] = "0";
			["type"] = "Grind";
		};
	};
	["version"] = 1;
}
return obj1
