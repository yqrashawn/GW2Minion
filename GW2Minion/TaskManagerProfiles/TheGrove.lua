-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["idcounter"] = 50;
	["name"] = "TheGrove";
	["tasks"] = {
		[1] = {
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
			["id"] = 1;
			["mapid"] = 91;
			["mappos"] = "1162/1365/-2659";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Pale Tree's Circle";
			["partysize"] = 0;
			["priority"] = 1;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[2] = {
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
			["id"] = 2;
			["mapid"] = 91;
			["mappos"] = "609/516/-2689";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Upper Commons Waypoint";
			["partysize"] = 0;
			["priority"] = 2;
			["radius"] = 0;
			["type"] = "MoveTo Position";
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
			["mapid"] = 648;
			["mappos"] = "1227/907/-3949";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "The Soul of the Pale Tree";
			["partysize"] = 0;
			["priority"] = 3;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[4] = {
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
			["id"] = 4;
			["mapid"] = 648;
			["mappos"] = "958/2232/-4069";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Ventari's Tablet";
			["partysize"] = 0;
			["priority"] = 4;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[5] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 5;
			["mapid"] = 91;
			["mappos"] = "3713/854/-3516";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "The Quester's Terrace Vista";
			["partysize"] = 0;
			["priority"] = 5;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[6] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 6;
			["mapid"] = 91;
			["mappos"] = "5687/3870/-3253";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Marshaling Field Vista";
			["partysize"] = 0;
			["priority"] = 6;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[7] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "13 14";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "31755";
				};
			};
			["enabled"] = "1";
			["id"] = 7;
			["mapid"] = 91;
			["mappos"] = "3284/3822/-2768";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Speed Boon";
			["partysize"] = 0;
			["priority"] = 7;
			["radius"] = 0;
			["type"] = "Talk";
		};
		[8] = {
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
			["id"] = 8;
			["mapid"] = 91;
			["mappos"] = "-2010/9817/-2777";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Caledon Waypoint";
			["partysize"] = 0;
			["priority"] = 8;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[9] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 9;
			["mapid"] = 91;
			["mappos"] = "7/10394/-3864";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Caledon Path Vista";
			["partysize"] = 0;
			["priority"] = 9;
			["radius"] = 0;
			["type"] = "Vista";
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
			["id"] = 10;
			["mapid"] = 91;
			["mappos"] = "4540/-3415/-1819";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Backroot Tunnel";
			["partysize"] = 0;
			["priority"] = 10;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[11] = {
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
			["id"] = 11;
			["mapid"] = 91;
			["mappos"] = "-3386/1121/-1862";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "The Hidden Shelter";
			["partysize"] = 0;
			["priority"] = 11;
			["radius"] = 0;
			["type"] = "MoveTo Position";
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
			["mapid"] = 91;
			["mappos"] = "-3627/3341/-1920";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Durmand Posting";
			["partysize"] = 0;
			["priority"] = 12;
			["radius"] = 0;
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
			["mapid"] = 91;
			["mappos"] = "-3555/6147/-2229";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Gardenroot Tunnel";
			["partysize"] = 0;
			["priority"] = 13;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[14] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 14;
			["mapid"] = 91;
			["mappos"] = "-2038/5774/-994";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Garden of Dawn Vista";
			["partysize"] = 0;
			["priority"] = 14;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[15] = {
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
			["id"] = 15;
			["mapid"] = 91;
			["mappos"] = "564/5710/-428";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "The House of Aife";
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
			["id"] = 16;
			["mapid"] = 647;
			["mappos"] = "3401/3217/-69";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "The House of Riannoc";
			["partysize"] = 0;
			["priority"] = 16;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[17] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_conversationOrder"] = {
					["type"] = "Field";
					["value"] = "13 14";
				};
				["TM_TASK_interactContentIDs"] = {
					["type"] = "Field";
					["value"] = "23746";
				};
			};
			["enabled"] = "1";
			["id"] = 17;
			["mapid"] = 91;
			["mappos"] = "1620/1190/-41";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Speed Boon";
			["partysize"] = 0;
			["priority"] = 17;
			["radius"] = 0;
			["type"] = "Talk";
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
			["mapid"] = 91;
			["mappos"] = "439/122/-954";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Ronan's Bower Vista";
			["partysize"] = 0;
			["priority"] = 18;
			["radius"] = 0;
			["type"] = "Vista";
		};
		[19] = {
			["complete"] = true;
			["cooldown"] = 0;
			["customVars"] = {
				["TM_TASK_usesTeleport"] = {
					["type"] = "CheckBox";
					["value"] = "0";
				};
			};
			["enabled"] = "1";
			["id"] = 19;
			["mapid"] = 91;
			["mappos"] = "3139/-868/-1112";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "Scholar's Terrace Vista";
			["partysize"] = 0;
			["priority"] = 19;
			["radius"] = 0;
			["type"] = "Vista";
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
					["value"] = "1";
				};
			};
			["enabled"] = "1";
			["id"] = 20;
			["mapid"] = 91;
			["mappos"] = "5362/1526/-389";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "The House of Niamh";
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
			["id"] = 21;
			["mapid"] = 91;
			["mappos"] = "-3476/848/-378";
			["maxduration"] = 0;
			["maxlvl"] = 80;
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "The House of Malomedies";
			["partysize"] = 0;
			["priority"] = 21;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[22] = {
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
			["id"] = 22;
			["mapid"] = 646;
			["mappos"] = "-2913/-1970/-6";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "The House of Caithe";
			["partysize"] = 0;
			["priority"] = 22;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
		[23] = {
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
			["id"] = 23;
			["mapid"] = 91;
			["mappos"] = "1269/-2499/-379";
			["maxduration"] = 0;
			["maxlvl"] = "80";
			["minduration"] = 0;
			["minlvl"] = 0;
			["name"] = "The House of Kahedins";
			["partysize"] = 0;
			["priority"] = 23;
			["radius"] = 0;
			["type"] = "MoveTo Position";
		};
	};
	["version"] = 1;
}
return obj1
