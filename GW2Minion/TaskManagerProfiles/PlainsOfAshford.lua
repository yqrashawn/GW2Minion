-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["idcounter"] = 87;
	["name"] = "PlainsOfAshford";
	["tasks"] = {
		[1] = {
			["complete"] = false;
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
			["id"] = 1;
			["mapid"] = 19;
			["mappos"] = "-42468/9181/-2035";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_SmokeStead";
			["partysize"] = 0;
			["priority"] = 1;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[2] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "477127,44417,525268";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "11277,11293,";
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
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "348";
				};
			};
			["enabled"] = "1";
			["id"] = 2;
			["mapid"] = 19;
			["mappos"] = "-43961/11455/-1604";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Tolona";
			["partysize"] = 0;
			["priority"] = 2;
			["radius"] = 0;
			["type"] = "HeartQuest";
		};
		[3] = {
			["complete"] = false;
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
			["id"] = 3;
			["mapid"] = 19;
			["mappos"] = "-42961/19003/-2186";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Greysteel_Armory";
			["partysize"] = 0;
			["priority"] = 3;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[4] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43615,43614";
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
					["value"] = 0;
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
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
					["value"] = "347";
				};
			};
			["enabled"] = "1";
			["id"] = 4;
			["mapid"] = 19;
			["mappos"] = "-44398/19568/-2190";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Rid_The_training";
			["partysize"] = 0;
			["priority"] = 4;
			["radius"] = 0;
			["type"] = "HeartQuest";
		};
		[5] = {
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
			["id"] = 5;
			["mapid"] = 19;
			["mappos"] = "-46112/22037/-2802";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Mocks_Niche";
			["partysize"] = 0;
			["priority"] = 5;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[6] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43721,43720";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "28820";
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
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "98";
				};
			};
			["enabled"] = "1";
			["id"] = 6;
			["mapid"] = 19;
			["mappos"] = "-37941/14365/-1880";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Help_Crucibis";
			["partysize"] = 0;
			["priority"] = 6;
			["radius"] = 0;
			["type"] = "HeartQuest";
		};
		[7] = {
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
			["id"] = 7;
			["mapid"] = 19;
			["mappos"] = "-32249/10221/-1879";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Wrecking_Yard";
			["partysize"] = 0;
			["priority"] = 7;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[8] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "301495";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "11289,6083,12113,26324,12219,19214,12129";
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
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "101";
				};
			};
			["enabled"] = "1";
			["id"] = 8;
			["mapid"] = 19;
			["mappos"] = "-32249/10221/-1879";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Help_Scar";
			["partysize"] = 0;
			["priority"] = 8;
			["radius"] = "3000";
			["type"] = "HeartQuest";
		};
		[9] = {
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
			["id"] = 9;
			["mapid"] = 19;
			["mappos"] = "-27682/14745/-1405";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "MovetoVista";
			["partysize"] = 0;
			["priority"] = 9;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[10] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 10;
			["mapid"] = 19;
			["mappos"] = "-25376/17133/-1045";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Feritas";
			["partysize"] = 0;
			["priority"] = 10;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[11] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "44204,44216";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "23682,28045,12124,14879,11614,12208,12605,18063,14727,1555";
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
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "100";
				};
			};
			["enabled"] = "1";
			["id"] = 11;
			["mapid"] = 19;
			["mappos"] = "-27207/17576/17";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Protect_Fisher";
			["partysize"] = 0;
			["priority"] = 11;
			["radius"] = "3000";
			["type"] = "HeartQuest";
		};
		[12] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43720,43721301494";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "9234,9891,7670,31043,1410,14395,12220,19120,17374,2307";
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
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "102";
				};
			};
			["enabled"] = "1";
			["id"] = 12;
			["mapid"] = 19;
			["mappos"] = "-22399/18279/-508";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Latera";
			["partysize"] = 0;
			["priority"] = 12;
			["radius"] = "4000";
			["type"] = "HeartQuest";
		};
		[13] = {
			["complete"] = false;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 13;
			["mapid"] = 19;
			["mappos"] = "-26916/13978/-1119";
			["maxduration"] = 0;
			["maxlvl"] = "5";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Grindtolvl6";
			["partysize"] = 0;
			["priority"] = 13;
			["radius"] = "0";
			["type"] = "Grind";
		};
		[14] = {
			["complete"] = false;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "16";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "208865";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "208865";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 14;
			["mapid"] = 19;
			["mappos"] = "-43432/20259/-2355";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "5";
			["name"] = "SP_Titus";
			["partysize"] = 0;
			["priority"] = 14;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[15] = {
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
			["id"] = 15;
			["mapid"] = 19;
			["mappos"] = "-40691/777/-1646";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_ThreeLegionsCurt";
			["partysize"] = 0;
			["priority"] = 15;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[16] = {
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
			["id"] = 16;
			["mapid"] = 19;
			["mappos"] = "-34238/-845/-1800";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_VirsGate";
			["partysize"] = 0;
			["priority"] = 16;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[17] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43455,43437,43447,43438,43448,43456";
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
					["value"] = 0;
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
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
					["value"] = "96";
				};
			};
			["enabled"] = "1";
			["id"] = 17;
			["mapid"] = 19;
			["mappos"] = "-30714/4320/-1276";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Bryllana";
			["partysize"] = 0;
			["priority"] = 17;
			["radius"] = "6000";
			["type"] = "HeartQuest";
		};
		[18] = {
			["complete"] = false;
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
			["id"] = 18;
			["mapid"] = 19;
			["mappos"] = "-25581/8880/-1617";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Feritas";
			["partysize"] = 0;
			["priority"] = 18;
			["radius"] = 0;
			["type"] = "MoveTo Position";
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
			["id"] = 19;
			["mapid"] = 19;
			["mappos"] = "-17843/1108/-2080";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Temperus_Point";
			["partysize"] = 0;
			["priority"] = 19;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[20] = {
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
			["id"] = 20;
			["mapid"] = 19;
			["mappos"] = "-22452/2308/-17";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Barradin";
			["partysize"] = 0;
			["priority"] = 20;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[21] = {
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
			["id"] = 21;
			["mapid"] = 19;
			["mappos"] = "-34882/-7970/-1774";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Sharptail";
			["partysize"] = 0;
			["priority"] = 21;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[22] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 22;
			["mapid"] = 19;
			["mappos"] = "-32529/-7040/-2975";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Vista_Sharptail";
			["partysize"] = 0;
			["priority"] = 22;
			["radius"] = 0;
			["type"] = "Vista";
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
			["id"] = 23;
			["mapid"] = 19;
			["mappos"] = "-34107/-13631/-1058";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Decimus";
			["partysize"] = 0;
			["priority"] = 23;
			["radius"] = 0;
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
			["id"] = 24;
			["mapid"] = 19;
			["mappos"] = "-32478/-20014/-2024";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Langmar_Estate";
			["partysize"] = 0;
			["priority"] = 24;
			["radius"] = "0";
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
					["value"] = "43453,43456,43455,544525,43447,43438,43454";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "11282";
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
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "97";
				};
			};
			["enabled"] = "1";
			["id"] = 25;
			["mapid"] = 19;
			["mappos"] = "-34129/-13720/-1072";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Sharptracker";
			["partysize"] = 0;
			["priority"] = 25;
			["radius"] = "4500";
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
			["id"] = 26;
			["mapid"] = 19;
			["mappos"] = "-18370/13495/-2047";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Calhaans_Haunt";
			["partysize"] = 0;
			["priority"] = 26;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[27] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43453,43456,43455,544525,43447,43438,43454,43448,443437,88144";
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
					["value"] = 0;
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
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
					["value"] = "104";
				};
			};
			["enabled"] = "1";
			["id"] = 27;
			["mapid"] = 19;
			["mappos"] = "-18384/13480/-2047";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Blood_Legion";
			["partysize"] = 0;
			["priority"] = 27;
			["radius"] = "5000";
			["type"] = "HeartQuest";
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
			["id"] = 28;
			["mapid"] = 19;
			["mappos"] = "-8262/18206/-2288";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Martyr";
			["partysize"] = 0;
			["priority"] = 28;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[29] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 29;
			["mapid"] = 19;
			["mappos"] = "-12222/3682/-2693";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Vista_Charrs_Triumph";
			["partysize"] = 0;
			["priority"] = 29;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[30] = {
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
			["id"] = 30;
			["mapid"] = 19;
			["mappos"] = "-13173/-2143/-2022";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Charrs_Triumph";
			["partysize"] = 0;
			["priority"] = 30;
			["radius"] = 0;
			["type"] = "MoveTo Position";
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
			["mapid"] = 19;
			["mappos"] = "-21572/-4896/-2120";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Exterminatus";
			["partysize"] = 0;
			["priority"] = 31;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[32] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43720,43721,246646,232696";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "24944,7662,13139,20939,14333,12213,22219";
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
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "103";
				};
			};
			["enabled"] = "1";
			["id"] = 32;
			["mapid"] = 19;
			["mappos"] = "-16184/-3976/-1493";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Defend_Iron_Legion";
			["partysize"] = 0;
			["priority"] = 32;
			["radius"] = "6000";
			["type"] = "HeartQuest";
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
			["id"] = 33;
			["mapid"] = 19;
			["mappos"] = "-19844/-15839/-2116";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Igni_Castrum";
			["partysize"] = 0;
			["priority"] = 33;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[34] = {
			["Create"] = nil --[[thread]]
;
			["class"] = nil --[[thread]]
;
			["complete"] = false;
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
			["id"] = 34;
			["isa"] = nil --[[thread]]
;
			["mapid"] = 19;
			["mappos"] = "-12891/-12372/-332";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Adorea";
			["partysize"] = 0;
			["priority"] = 34;
			["radius"] = 0;
			["superClass"] = nil --[[thread]]
;
			["type"] = "MoveTo Position";
		};
		[35] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 35;
			["mapid"] = 19;
			["mappos"] = "-16682/-10232/-925";
			["maxduration"] = 0;
			["maxlvl"] = "8";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Grindtolvl9";
			["partysize"] = 0;
			["priority"] = 35;
			["radius"] = 0;
			["type"] = "Grind";
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
			["id"] = 36;
			["mapid"] = 19;
			["mappos"] = "-1988/-10344/-1732";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Ashford";
			["partysize"] = 0;
			["priority"] = 36;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[37] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "536988,44203,44218,43528,43527,490479,43526,43527";
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
					["value"] = 0;
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
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
					["value"] = "107";
				};
			};
			["enabled"] = "1";
			["id"] = 37;
			["mapid"] = 19;
			["mappos"] = "-7987/-5521/-2319";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Paenula";
			["partysize"] = 0;
			["priority"] = 37;
			["radius"] = "0";
			["type"] = "HeartQuest";
		};
		[38] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "16";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "176141";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "176141";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 38;
			["mapid"] = 19;
			["mappos"] = "-5142/-7702/-1985";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "SP_Centurio_Micka";
			["partysize"] = 0;
			["priority"] = 38;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[39] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 39;
			["mapid"] = 19;
			["mappos"] = "-10577/-20187/-1466";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Vista_Adorea";
			["partysize"] = 0;
			["priority"] = 39;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[40] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 40;
			["mapid"] = 19;
			["mappos"] = "-13247/-11694/-378";
			["maxduration"] = 0;
			["maxlvl"] = "9";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Grindtolvl10";
			["partysize"] = 0;
			["priority"] = 40;
			["radius"] = 0;
			["type"] = "Grind";
		};
		[41] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "6";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "212298";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "32514";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 41;
			["mapid"] = 19;
			["mappos"] = "-15200/-23978/-1255";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "10";
			["name"] = "SP_Flame_Legion_Effigy";
			["partysize"] = 0;
			["priority"] = 41;
			["radius"] = 0;
			["type"] = "Skillpoint";
		};
		[42] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43440,43453,43456,43455,544525,43447,43438,43454";
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
					["value"] = 0;
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
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
					["value"] = "106";
				};
			};
			["enabled"] = "1";
			["id"] = 42;
			["mapid"] = 19;
			["mappos"] = "3684/-2934/-696";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Help_Gavros";
			["partysize"] = 0;
			["priority"] = 42;
			["radius"] = "6500";
			["type"] = "HeartQuest";
		};
		[43] = {
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
			["id"] = 43;
			["mapid"] = 19;
			["mappos"] = "-1092/-1205/-674";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Area_Abbey_Ruins";
			["partysize"] = 0;
			["priority"] = 43;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[44] = {
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
			["id"] = 44;
			["mapid"] = 19;
			["mappos"] = "-138/5964/-1969";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Spirit_Hunter";
			["partysize"] = 0;
			["priority"] = 44;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[45] = {
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
			["id"] = 45;
			["mapid"] = 19;
			["mappos"] = "-1115/15274/-1355";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Deadgos_Lair";
			["partysize"] = 0;
			["priority"] = 45;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[46] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 46;
			["mapid"] = 19;
			["mappos"] = "-285/8128/-1601";
			["maxduration"] = 0;
			["maxlvl"] = "10";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Grinddtolvl11";
			["partysize"] = 0;
			["priority"] = 46;
			["radius"] = "0";
			["type"] = "Grind";
		};
		[47] = {
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
			["id"] = 47;
			["mapid"] = 19;
			["mappos"] = "3082/12743/-12";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Shards_of_War";
			["partysize"] = 0;
			["priority"] = 47;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[48] = {
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
			["id"] = 48;
			["mapid"] = 19;
			["mappos"] = "8820/13016/-2306";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Ghostsummit";
			["partysize"] = 0;
			["priority"] = 48;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[49] = {
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
			["id"] = 49;
			["mapid"] = 19;
			["mappos"] = "12702/12908/-1370";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Ascalon_Catacombs";
			["partysize"] = 0;
			["priority"] = 49;
			["radius"] = 0;
			["type"] = "MoveTo Position";
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
			["id"] = 50;
			["mapid"] = 19;
			["mappos"] = "16076/6605/-1153";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Swordcross_Outpost";
			["partysize"] = 0;
			["priority"] = 50;
			["radius"] = 0;
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
			["mapid"] = 19;
			["mappos"] = "14057/3437/-1906";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Vistaa_Swordcross";
			["partysize"] = 0;
			["priority"] = 51;
			["radius"] = 0;
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
			["id"] = 52;
			["mapid"] = 19;
			["mappos"] = "24385/6990/-511";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Phasmatis";
			["partysize"] = 0;
			["priority"] = 52;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[53] = {
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
			["id"] = 53;
			["mapid"] = 19;
			["mappos"] = "22909/-8873/-88";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Irondock_Shipyard";
			["partysize"] = 0;
			["priority"] = 53;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[54] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "44204,44216,327328";
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
					["value"] = 0;
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
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
					["value"] = "109";
				};
			};
			["enabled"] = "1";
			["id"] = 54;
			["mapid"] = 19;
			["mappos"] = "22905/-8891/-85";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Assist_Sesto";
			["partysize"] = 0;
			["priority"] = 54;
			["radius"] = "3000";
			["type"] = "HeartQuest";
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
			["id"] = 55;
			["mapid"] = 19;
			["mappos"] = "43082/-7165/-1342";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Duskrend_Overlook";
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
					["value"] = "458978,43945";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "12187,9708,28632,15471,7652,21374,10678";
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
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "110";
				};
			};
			["enabled"] = "1";
			["id"] = 56;
			["mapid"] = 19;
			["mappos"] = "40965/-16184/0";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Researcher_Irkz";
			["partysize"] = 0;
			["priority"] = 56;
			["radius"] = "5000";
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
			["id"] = 57;
			["mapid"] = 19;
			["mappos"] = "30219/-17805/-103";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Loreclawq";
			["partysize"] = 0;
			["priority"] = 57;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[58] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxGather"] = {
					["type"] = "Numeric";
					["value"] = "8";
				};
			};
			["enabled"] = "1";
			["id"] = 58;
			["mapid"] = 19;
			["mappos"] = "29361/-21655/-786";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Gather_Potatoes";
			["partysize"] = 0;
			["priority"] = 58;
			["radius"] = "1000";
			["type"] = "Gather";
		};
		[59] = {
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
			["id"] = 59;
			["mapid"] = 19;
			["mappos"] = "22947/-21262/-1095";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Camp_Cairan";
			["partysize"] = 0;
			["priority"] = 59;
			["radius"] = "0";
			["type"] = "MoveTo Position";
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
					["value"] = "43525,43528,43526,43527,8325";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "5208,25258";
				};
				["TM_TASK_maxInteracts"] = {
					["type"] = "Numeric";
					["value"] = 0;
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
					["value"] = "108";
				};
			};
			["enabled"] = "1";
			["id"] = 60;
			["mapid"] = 19;
			["mappos"] = "21886/-20097/-1065";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Mai";
			["partysize"] = 0;
			["priority"] = 60;
			["radius"] = "6500";
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
			["id"] = 61;
			["mapid"] = 19;
			["mappos"] = "26398/-18060/-1821";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "MovetoVista";
			["partysize"] = 0;
			["priority"] = 61;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[62] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 62;
			["mapid"] = 19;
			["mappos"] = "23902/-15209/-1952";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Vista_Loreclaws";
			["partysize"] = 0;
			["priority"] = 62;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[63] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "8770";
				};
				["TM_TASK_tIDuration"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 63;
			["mapid"] = 19;
			["mappos"] = "24052/-15178/-1950";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Diving_Goolges";
			["partysize"] = 0;
			["priority"] = 63;
			["radius"] = "0";
			["type"] = "Interact";
		};
		[64] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 64;
			["mapid"] = 19;
			["mappos"] = "40862/-15271/-4";
			["maxduration"] = 0;
			["maxlvl"] = "12";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Grindtolvl13";
			["partysize"] = 0;
			["priority"] = 64;
			["radius"] = 0;
			["type"] = "Grind";
		};
		[65] = {
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
			["id"] = 65;
			["mapid"] = 19;
			["mappos"] = "38567/3783/-1364";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Watchcrag_Tower";
			["partysize"] = 0;
			["priority"] = 65;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[66] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 66;
			["mapid"] = 19;
			["mappos"] = "39123/1889/-1576";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Vista_Watchcrag_Tower";
			["partysize"] = 0;
			["priority"] = 66;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[67] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "462980,43581,378361,12202,4204,12802,4400,25791,7817,2487,3578,30651,1355,7645";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "26410,15094,20479,20415";
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
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "111";
				};
			};
			["enabled"] = "1";
			["id"] = 67;
			["mapid"] = 19;
			["mappos"] = "40517/5188/-1254";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Androchus";
			["partysize"] = 0;
			["priority"] = 67;
			["radius"] = "12500";
			["type"] = "HeartQuest";
		};
		[68] = {
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
			["id"] = 68;
			["mapid"] = 19;
			["mappos"] = "43749/10433/-1825";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Stonecrag_Kraal_Disabled";
			["partysize"] = 0;
			["priority"] = 68;
			["radius"] = "0";
			["type"] = "MoveTo Position";
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
			["id"] = 69;
			["mapid"] = 19;
			["mappos"] = "45878/21228/-1966";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Movetosafespot";
			["partysize"] = 0;
			["priority"] = 69;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[70] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 70;
			["mapid"] = 19;
			["mappos"] = "45512/21495/-1942";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Vista_Humans_Lament";
			["partysize"] = 0;
			["priority"] = 70;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[71] = {
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
			["id"] = 71;
			["mapid"] = 19;
			["mappos"] = "32183/20084/-1500";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Foefire_Heart";
			["partysize"] = 0;
			["priority"] = 71;
			["radius"] = 0;
			["type"] = "MoveTo Position";
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
			["id"] = 72;
			["mapid"] = 19;
			["mappos"] = "26163/19752/-1436";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Ascalon_City";
			["partysize"] = 0;
			["priority"] = 72;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[73] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43447,43454,43437,43453,43455,43438";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "7658,6070,6797,14647";
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
					["value"] = "";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "112";
				};
			};
			["enabled"] = "1";
			["id"] = 73;
			["mapid"] = 19;
			["mappos"] = "32257/19519/-1411";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Ghyrtratus";
			["partysize"] = 0;
			["priority"] = 73;
			["radius"] = 0;
			["type"] = "HeartQuest";
		};
		[74] = {
			["complete"] = false;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 74;
			["mapid"] = 19;
			["mappos"] = "32396/19636/-1422";
			["maxduration"] = 0;
			["maxlvl"] = "13";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Grindtolvl14";
			["partysize"] = 0;
			["priority"] = 74;
			["radius"] = 0;
			["type"] = "Grind";
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
					["value"] = "0";
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
			["mapid"] = 19;
			["mappos"] = "36317/22925/-3722";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Movetosafespot";
			["partysize"] = 0;
			["priority"] = 75;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[76] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_eventID"] = {
					["type"] = "Numeric";
					["value"] = "4711";
				};
				["TM_TASK_eventMaxTaskTimer"] = {
					["type"] = "Numeric";
					["value"] = "60";
				};
			};
			["enabled"] = "1";
			["id"] = 76;
			["mapid"] = 19;
			["mappos"] = "36305/22925/-3710";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WaitForAggroReset";
			["partysize"] = 0;
			["priority"] = 76;
			["radius"] = "1";
			["type"] = "Do Events";
		};
		[77] = {
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
					["value"] = "774";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 77;
			["mapid"] = 19;
			["mappos"] = "36507/22693/-3690";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "SP_Ruins_of_Ascalon";
			["partysize"] = 0;
			["priority"] = 77;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[78] = {
			["complete"] = false;
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
					["value"] = "43604";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "0";
			["id"] = 78;
			["mapid"] = 19;
			["mappos"] = "31018/13286/761";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "SP_Ruins_Underwater_Disabled";
			["partysize"] = 0;
			["priority"] = 78;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[79] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 79;
			["mapid"] = 19;
			["mappos"] = "23042/18426/-2222";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Vista_Ruins_of_Ascalon";
			["partysize"] = 0;
			["priority"] = 79;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[80] = {
			["complete"] = false;
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
			["id"] = 80;
			["mapid"] = 19;
			["mappos"] = "19861/17020/-1432";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Viewing_HIll";
			["partysize"] = 0;
			["priority"] = 80;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[81] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "16";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "304776,304782";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "12544";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 81;
			["mapid"] = 19;
			["mappos"] = "1485/-5435/-1165";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "13";
			["name"] = "SP_Etheral_Vanguard";
			["partysize"] = 0;
			["priority"] = 81;
			["radius"] = 0;
			["type"] = "Skillpoint";
		};
		[82] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 82;
			["mapid"] = 19;
			["mappos"] = "4479/17170/-2466";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Shards_of_War";
			["partysize"] = 0;
			["priority"] = 82;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[83] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "43522,43520,43782,";
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
					["value"] = 0;
				};
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
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
					["value"] = "105";
				};
			};
			["enabled"] = "1";
			["id"] = 83;
			["mapid"] = 19;
			["mappos"] = "8289/19083/-1465";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "HQ_Help_Sagum";
			["partysize"] = 0;
			["priority"] = 83;
			["radius"] = "8000";
			["type"] = "HeartQuest";
		};
		[84] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 84;
			["mapid"] = 19;
			["mappos"] = "8029/18830/-1415";
			["maxduration"] = 0;
			["maxlvl"] = "14";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Grindtolvl15";
			["partysize"] = 0;
			["priority"] = 84;
			["radius"] = "0";
			["type"] = "Grind";
		};
	};
	["version"] = 1;
}
return obj1
