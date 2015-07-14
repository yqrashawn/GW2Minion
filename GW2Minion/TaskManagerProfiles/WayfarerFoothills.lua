-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["idcounter"] = 72;
	["name"] = "WayfarerFoothills";
	["tasks"] = {
		[1] = {
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
					["value"] = "455";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 1;
			["mapid"] = 28;
			["mappos"] = "-3132/-20148/-6512";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "SP_Issomir";
			["partysize"] = 0;
			["priority"] = 1;
			["radius"] = "0";
			["type"] = "Skillpoint";
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
					["value"] = "43906";
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
					["value"] = "56";
				};
			};
			["enabled"] = "1";
			["id"] = 2;
			["mapid"] = 28;
			["mappos"] = "-2631/-28737/-2576";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Honor_Raven";
			["partysize"] = 0;
			["priority"] = 2;
			["radius"] = "4000";
			["type"] = "HeartQuest";
		};
		[3] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "-1005/-24787/-4487";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Heart_of_Raven";
			["partysize"] = 0;
			["priority"] = 3;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[4] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 4;
			["mapid"] = 28;
			["mappos"] = "-2291/-26309/-5053";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Raven";
			["partysize"] = 0;
			["priority"] = 4;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[5] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "496/-30310/-1577";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "WP_Heroes_Moot";
			["partysize"] = 0;
			["priority"] = 5;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[6] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 6;
			["mapid"] = 28;
			["mappos"] = "7822/-28006/-41";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "POI_Heart_of_Bear";
			["partysize"] = 0;
			["priority"] = 6;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[7] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "301474,421045";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "1337,24545,13921,31373,19274,5203,31717,31213,19580,31498,19349,5208,29342";
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
					["value"] = "55";
				};
			};
			["enabled"] = "1";
			["id"] = 7;
			["mapid"] = 28;
			["mappos"] = "7854/-28027/-40";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Honor_Bear";
			["partysize"] = 0;
			["priority"] = 7;
			["radius"] = "4000";
			["type"] = "HeartQuest";
		};
		[8] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 8;
			["mapid"] = 28;
			["mappos"] = "9100/-26099/-1882";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Bear";
			["partysize"] = 0;
			["priority"] = 8;
			["radius"] = "0";
			["type"] = "Vista";
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
			["mapid"] = 28;
			["mappos"] = "17681/-32228/26";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "4";
			["name"] = "POI_Horstras_Refuge";
			["partysize"] = 0;
			["priority"] = 9;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[10] = {
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
					["value"] = "45415";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "45415";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 10;
			["mapid"] = 28;
			["mappos"] = "18144/-33423/-14";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "SP_Marga";
			["partysize"] = 0;
			["priority"] = 10;
			["radius"] = "0";
			["type"] = "Skillpoint";
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
					["value"] = "43514,168537,301456,446744,19423,43285";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "19275,21258";
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
					["value"] = "59";
				};
			};
			["enabled"] = "1";
			["id"] = 11;
			["mapid"] = 28;
			["mappos"] = "13581/-32759/-218";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Disrupt_Grawl";
			["partysize"] = 0;
			["priority"] = 11;
			["radius"] = "5000";
			["type"] = "HeartQuest";
		};
		[12] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 12;
			["mapid"] = 28;
			["mappos"] = "10886/-36006/-98";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Grawlenfjord";
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
					["value"] = "1";
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
			["id"] = 13;
			["mapid"] = 28;
			["mappos"] = "18971/-41622/-607";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Drakkerjorg";
			["partysize"] = 0;
			["priority"] = 13;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[14] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 14;
			["mapid"] = 28;
			["mappos"] = "1692/-43706/-477";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Heart_of_Wolf";
			["partysize"] = 0;
			["priority"] = 14;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[15] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "429298,421045,396370,19276,301474,301478";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "18883,4551,19366,31603,5227,4994,9669";
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
					["value"] = "54";
				};
			};
			["enabled"] = "1";
			["id"] = 15;
			["mapid"] = 28;
			["mappos"] = "1689/-45805/-1015";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Honor_Wolf";
			["partysize"] = 0;
			["priority"] = 15;
			["radius"] = "10000";
			["type"] = "HeartQuest";
		};
		[16] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "-2885/-51722/-2045";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Alpenzure";
			["partysize"] = 0;
			["priority"] = 16;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[17] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 17;
			["mapid"] = 28;
			["mappos"] = "-1527/-42985/-951";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Outcast";
			["partysize"] = 0;
			["priority"] = 17;
			["radius"] = 0;
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
			["mapid"] = 28;
			["mappos"] = "-18309/-49505/-1313";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Maulensk";
			["partysize"] = 0;
			["priority"] = 18;
			["radius"] = "0";
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
					["value"] = "0";
				};
				["TM_TASK_smoothTurns"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 19;
			["mapid"] = 28;
			["mappos"] = "-18081/-49175/41";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "MoveToNextTask";
			["partysize"] = 0;
			["priority"] = 19;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[20] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "-8454/-37081/-4220";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Snowleopard";
			["partysize"] = 0;
			["priority"] = 20;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[21] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "13,14";
				};
				["TM_TASK_conversationType"] = {
					["type"] = "ComboBox";
					["value"] = "Type";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "44595";
				};
			};
			["enabled"] = "0";
			["id"] = 21;
			["mapid"] = 28;
			["mappos"] = "-8215/-37270/-4252";
			["maxduration"] = "0";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "PRE_HQ_Shaman Sigarr";
			["partysize"] = 0;
			["priority"] = 21;
			["radius"] = "3000";
			["type"] = "Talk";
		};
		[22] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Pickup&Use";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "232687";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "44365";
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
					["value"] = "57";
				};
			};
			["enabled"] = "1";
			["id"] = 22;
			["mapid"] = 28;
			["mappos"] = "-8787/-36651/-4135";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Snowleopard";
			["partysize"] = 0;
			["priority"] = 22;
			["radius"] = "5000";
			["type"] = "HeartQuest";
		};
		[23] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "44183";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "145699";
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
					["value"] = "63";
				};
			};
			["enabled"] = "1";
			["id"] = 23;
			["mapid"] = 28;
			["mappos"] = "-3593/-11070/-1407";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Help_Brijani";
			["partysize"] = 0;
			["priority"] = 23;
			["radius"] = "3500";
			["type"] = "HeartQuest";
		};
		[24] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "1719/-7844/-1163";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Taigan";
			["partysize"] = 0;
			["priority"] = 24;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[25] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 25;
			["mapid"] = 28;
			["mappos"] = "-12009/-13572/-5936";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Osenfold";
			["partysize"] = 0;
			["priority"] = 25;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[26] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 26;
			["mapid"] = 28;
			["mappos"] = "-8919/-16925/-7223";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Gaetrta";
			["partysize"] = 0;
			["priority"] = 26;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[27] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 27;
			["mapid"] = 28;
			["mappos"] = "-7068/-17155/-7270";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Gaerta_Summit";
			["partysize"] = 0;
			["priority"] = 27;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[28] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "-16564/-7318/-4920";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Haivoissen_Kenning";
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
			["mapid"] = 28;
			["mappos"] = "-9911/-6118/-5833";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Haivoissen";
			["partysize"] = 0;
			["priority"] = 29;
			["radius"] = 0;
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
					["value"] = "0";
				};
				["TM_TASK_useWaypoint"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 30;
			["mapid"] = 28;
			["mappos"] = "-11840/-6466/-4944";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "MoveToNextTask";
			["partysize"] = 0;
			["priority"] = 30;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[31] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "-1457/-3854/-1637";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Frostcreek_Steading";
			["partysize"] = 0;
			["priority"] = 31;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[32] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 32;
			["mapid"] = 28;
			["mappos"] = "7377/-5145/-931";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Victor's_Point";
			["partysize"] = 0;
			["priority"] = 32;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[33] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Pickup&Use";
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
					["value"] = "12291,25782,19474,3451,8752,10323,25449,20092,14483,3457,5175,10323,27339,9951,3211,11725,12686,13638,7925,10699";
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
					["value"] = "6661";
				};
				["TM_TASK_pickupTargetIDs"] = {
					["type"] = "Field";
					["value"] = "44585,44584";
				};
				["TM_TASK_subRegion"] = {
					["type"] = "Field";
					["value"] = "64";
				};
			};
			["enabled"] = "1";
			["id"] = 33;
			["mapid"] = 28;
			["mappos"] = "7190/-5701/-902";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Entertain_Children";
			["partysize"] = 0;
			["priority"] = 33;
			["radius"] = "5000";
			["type"] = "HeartQuest";
		};
		[34] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "12964/-14622/-896";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Darkriven";
			["partysize"] = 0;
			["priority"] = 34;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[35] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 35;
			["mapid"] = 28;
			["mappos"] = "15192/-6157/-4086";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Darkriver";
			["partysize"] = 0;
			["priority"] = 35;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[36] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "17032/-5106/-4656";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Hermit_Watch";
			["partysize"] = 0;
			["priority"] = 36;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[37] = {
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
					["value"] = "551353";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "551353";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 37;
			["mapid"] = 28;
			["mappos"] = "17920/-4403/-4707";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "SP_Blane";
			["partysize"] = 0;
			["priority"] = 37;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[38] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 38;
			["mapid"] = 28;
			["mappos"] = "-12693/5277/-3653";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Zelechor";
			["partysize"] = 0;
			["priority"] = 38;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[39] = {
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
					["value"] = "472911";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "472911";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 39;
			["mapid"] = 28;
			["mappos"] = "-15537/5313/-3686";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "SP_Burrison";
			["partysize"] = 0;
			["priority"] = 39;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[40] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 40;
			["mapid"] = 28;
			["mappos"] = "-11246/4683/-5450";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Zelechor";
			["partysize"] = 0;
			["priority"] = 40;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[41] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "44195";
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
					["value"] = "69";
				};
			};
			["enabled"] = "1";
			["id"] = 41;
			["mapid"] = 28;
			["mappos"] = "-4176/8019/-3653";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Help_Albin";
			["partysize"] = 0;
			["priority"] = 41;
			["radius"] = "5000";
			["type"] = "HeartQuest";
		};
		[42] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 42;
			["mapid"] = 28;
			["mappos"] = "746/4630/-3020";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Twinspur_Haven";
			["partysize"] = 0;
			["priority"] = 42;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[43] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 43;
			["mapid"] = 28;
			["mappos"] = "7463/2944/-5552";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Twinspur";
			["partysize"] = 0;
			["priority"] = 43;
			["radius"] = "0";
			["type"] = "Vista";
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
					["value"] = "43875,546756,418603,421045,396370,301478,429298,24534,7560,20739,8347,25327,5638,13259,25734,18466,19671,9201,28006,14224";
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
					["value"] = "65";
				};
			};
			["enabled"] = "1";
			["id"] = 44;
			["mapid"] = 28;
			["mappos"] = "2677/8616/-3621";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Help_Lionguard";
			["partysize"] = 0;
			["priority"] = 44;
			["radius"] = "5000";
			["type"] = "HeartQuest";
		};
		[45] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "12036/8517/-2783";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Vendrake_Homestead";
			["partysize"] = 0;
			["priority"] = 45;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[46] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 46;
			["mapid"] = 28;
			["mappos"] = "16337/13361/-2563";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Heart_of_Corruption";
			["partysize"] = 0;
			["priority"] = 46;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[47] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 47;
			["mapid"] = 28;
			["mappos"] = "9043/20512/-3311";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Krennaks_Homestead";
			["partysize"] = 0;
			["priority"] = 47;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[48] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "-7301/22688/-4272";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Halvaunt";
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
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "-6344/19494/-3811";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Edenvar's Homestead";
			["partysize"] = 0;
			["priority"] = 49;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[50] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 50;
			["mapid"] = 28;
			["mappos"] = "-6142/15791/-4339";
			["maxduration"] = 0;
			["maxlvl"] = "9";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Grindtolvl10";
			["partysize"] = 0;
			["priority"] = 50;
			["radius"] = "8000";
			["type"] = "Grind";
		};
		[51] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "19454,232677,232689,43510";
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
					["value"] = "66";
				};
			};
			["enabled"] = "1";
			["id"] = 51;
			["mapid"] = 28;
			["mappos"] = "-12374/14801/-4964";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Help_Miners";
			["partysize"] = 0;
			["priority"] = 51;
			["radius"] = "40000";
			["type"] = "HeartQuest";
		};
		[52] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 52;
			["mapid"] = 28;
			["mappos"] = "-1591/22868/-5647";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Wurmhowl";
			["partysize"] = 0;
			["priority"] = 52;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[53] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "522820,301492,43514,43875,301474,301492,301456,421045,301478,480582,43979,27068,19199";
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
					["value"] = "67";
				};
			};
			["enabled"] = "1";
			["id"] = 53;
			["mapid"] = 28;
			["mappos"] = "13555/20842/-2784";
			["maxduration"] = "600";
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Fight_Dragon_Corruption";
			["partysize"] = 0;
			["priority"] = 53;
			["radius"] = "15000";
			["type"] = "HeartQuest";
		};
		[54] = {
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
					["value"] = "43979,216787";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "493435";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 54;
			["mapid"] = 28;
			["mappos"] = "16744/21984/-2871";
			["maxduration"] = "0";
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "SP_Corrupted_Spike";
			["partysize"] = 0;
			["priority"] = 54;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[55] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "5397/29847/-3319";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Lostvyrm_Cave";
			["partysize"] = 0;
			["priority"] = 55;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[56] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 56;
			["mapid"] = 28;
			["mappos"] = "8394/29736/-2891";
			["maxduration"] = 0;
			["maxlvl"] = "11";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Grindtolvl12";
			["partysize"] = 0;
			["priority"] = 56;
			["radius"] = "0";
			["type"] = "Grind";
		};
		[57] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_SPType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "23";
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
					["value"] = "3706";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "22429";
				};
			};
			["enabled"] = "1";
			["id"] = 57;
			["mapid"] = 28;
			["mappos"] = "7136/27423/-1133";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "SP_Aging_Ale_Barrels";
			["partysize"] = 0;
			["priority"] = 57;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[58] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "44271,301474,346613,44272";
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
					["value"] = "62";
				};
			};
			["enabled"] = "1";
			["id"] = 58;
			["mapid"] = 28;
			["mappos"] = "10707/28608/-2771";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Help_Kevach";
			["partysize"] = 0;
			["priority"] = 58;
			["radius"] = "6000";
			["type"] = "HeartQuest";
		};
		[59] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "-5030/32241/-4677";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Crossroads_Haven";
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
					["value"] = "43979,301474,421236,43875,301492,421045,301478,429298,396267,544,26350";
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
					["value"] = "60";
				};
			};
			["enabled"] = "1";
			["id"] = 60;
			["mapid"] = 28;
			["mappos"] = "-3963/28629/-4696";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Crossroads_Haven";
			["partysize"] = 0;
			["priority"] = 60;
			["radius"] = "50000";
			["type"] = "HeartQuest";
		};
		[61] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 61;
			["mapid"] = 28;
			["mappos"] = "-3966/27756/-4693";
			["maxduration"] = 0;
			["maxlvl"] = "12";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Grindtolvl13";
			["partysize"] = 0;
			["priority"] = 61;
			["radius"] = "0";
			["type"] = "Grind";
		};
		[62] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 62;
			["mapid"] = 28;
			["mappos"] = "14416/38330/-4835";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Dolyak_Pass";
			["partysize"] = 0;
			["priority"] = 62;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[63] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "382298,44271";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "190651";
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
					["value"] = "68";
				};
			};
			["enabled"] = "1";
			["id"] = 63;
			["mapid"] = 28;
			["mappos"] = "15307/38089/-4944";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Help_Maxtar";
			["partysize"] = 0;
			["priority"] = 63;
			["radius"] = "10000";
			["type"] = "HeartQuest";
		};
		[64] = {
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
					["value"] = "469183";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 64;
			["mapid"] = 28;
			["mappos"] = "15730/49042/-6396";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "SP_Ancient_Cave_Spring";
			["partysize"] = 0;
			["priority"] = 64;
			["radius"] = "0";
			["type"] = "Skillpoint";
		};
		[65] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "10427/48652/-7762";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Solitude";
			["partysize"] = 0;
			["priority"] = 65;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[66] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_HQType"] = {
					["type"] = "ComboBox";
					["value"] = "Interact&Kill";
				};
				["TM_TASK_enemyContentIDs"] = {
					["type"] = "Field";
					["value"] = "421045,301478,301492,301474,43979,396370,536871456,544,24534,17795";
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
					["value"] = "61";
				};
			};
			["enabled"] = "1";
			["id"] = 66;
			["mapid"] = 28;
			["mappos"] = "3773/42761/-6209";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "HQ_Challenge_Jormag_Minions";
			["partysize"] = 0;
			["priority"] = 66;
			["radius"] = "9000";
			["type"] = "HeartQuest";
		};
		[67] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 67;
			["mapid"] = 28;
			["mappos"] = "1500/42080/-8221";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "Vista_Solitude";
			["partysize"] = 0;
			["priority"] = 67;
			["radius"] = "0";
			["type"] = "Vista";
		};
		[68] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["mapid"] = 28;
			["mappos"] = "955/46672/-7411";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "POI_Dragonblest Hold";
			["partysize"] = 0;
			["priority"] = 68;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[69] = {
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
					["value"] = "429298,171613";
				};
				["TM_TASK_interactContentID2s"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
				["TM_TASK_usableItemIDs"] = {
					["type"] = "Field";
					["value"] = "";
				};
			};
			["enabled"] = "1";
			["id"] = 69;
			["mapid"] = 28;
			["mappos"] = "-3006/46868/-8610";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "SP_Bjords_Banner";
			["partysize"] = 0;
			["priority"] = 69;
			["radius"] = 0;
			["type"] = "Skillpoint";
		};
		[70] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_randomMovement"] = {
					["type"] = "CheckBox";
					["value"] = "1";
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
			["id"] = 70;
			["mapid"] = 28;
			["mappos"] = "-12829/40747/-4483";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = "0";
			["name"] = "WP_Dawnrise";
			["partysize"] = 0;
			["priority"] = 70;
			["radius"] = "0";
			["type"] = "MoveTo Position";
		};
		[71] = {
			["complete"] = false;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_maxKills"] = {
					["type"] = "Numeric";
					["value"] = 0;
				};
			};
			["enabled"] = "1";
			["id"] = 71;
			["mapid"] = 28;
			["mappos"] = "205/43665/-7236";
			["maxduration"] = 0;
			["maxlvl"] = "14";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Grindtolvl15";
			["partysize"] = 0;
			["priority"] = 71;
			["radius"] = 0;
			["type"] = "Grind";
		};
	};
	["version"] = 1;
}
return obj1
