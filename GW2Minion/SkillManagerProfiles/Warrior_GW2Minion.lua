-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["name"] = "GW2Minion";
	["profession"] = 2;
	["professionSettings"] = {
		["elementalist"] = {
		};
		["engineer"] = {
		};
	};
	["skills"] = {
		[1] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14402;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "\"To the Limit!\"";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 6;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[2] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14401;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Mending";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 6;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[3] = {
			["player"] = {
				["minHP"] = 75;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30189;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Blood Reckoning";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 0;
			};
			["target"] = {
			};
		};
		[4] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 10;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14389;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Healing Signet";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 6;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[5] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 90;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 21815;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Defiant Stance";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[6] = {
			["player"] = {
				["maxPower"] = 0;
				["minHP"] = 0;
				["moving"] = "Moving";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14355;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Rage";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 10;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[7] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 600;
				["maxPower"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 14419;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Battle Standard";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 10;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[8] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14483;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Rampage";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 10;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[9] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 14528;
				["los"] = true;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Banner of Defense";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
				["maxHP"] = 0;
				["type"] = "Character";
			};
		};
		[10] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14368;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 1500;
				["name"] = "Frenzy";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
				["maxHP"] = 10;
				["type"] = "Character";
			};
		};
		[11] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 40;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14392;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 1200;
				["name"] = "Endure Pain";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[12] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 14407;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Banner of Discipline";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[13] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 14405;
				["los"] = true;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Banner of Strength";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[14] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 14408;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Banner of Tactics";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[15] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
				["hasBuffs"] = "872,791,727";
				["minHP"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14412;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Balanced Stance";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[16] = {
			["player"] = {
				["conditionCount"] = 0;
				["hasBuffs"] = "791";
				["minEndurance"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14413;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Dolyak Signet";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[17] = {
			["player"] = {
				["conditionCount"] = 2;
				["maxPower"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 29940;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Flames of War";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[18] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14406;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Berserker Stance";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[19] = {
			["player"] = {
				["conditionCount"] = 1;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14372;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "\"Shake It Off!\"";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[20] = {
			["player"] = {
				["conditionCount"] = 3;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14479;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Stamina";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[21] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14403;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "\"For Great Justice!\"";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[22] = {
			["player"] = {
				["combatState"] = "InCombat";
				["maxPower"] = 0;
				["minPower"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14400;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Riposte";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[23] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14477;
				["los"] = false;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Inspire";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[24] = {
			["player"] = {
				["moving"] = "Moving";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14394;
				["los"] = false;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Call to Arms";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[25] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14564;
				["los"] = false;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Compassionate Banner";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[26] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14495;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Sprint";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[27] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14562;
				["los"] = false;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Furious Rally";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[28] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 1175;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Bandage";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[29] = {
			["player"] = {
				["moving"] = "Moving";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 14393;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Charge";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[30] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14436;
				["lastSkillID"] = 14477;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Plant Standard";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 5;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[31] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14373;
				["lastSkillID"] = 14356;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Greatsword Slice";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[32] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14371;
				["lastSkillID"] = 14370;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Triple Chop";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
				["slowCast"] = false;
			};
			["target"] = {
			};
		};
		[33] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14487;
				["lastSkillID"] = 14486;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Uppercut";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[34] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14378;
				["lastSkillID"] = 14377;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Pulverize";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[35] = {
			["player"] = {
				["minPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14365;
				["lastSkillID"] = 14364;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Gash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[36] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14363;
				["lastSkillID"] = 14365;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Hamstring";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[37] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14384;
				["lastSkillID"] = 14358;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Hammer Bash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[38] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14439;
				["lastSkillID"] = 14438;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Impale";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[39] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14438;
				["lastSkillID"] = 14437;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Jab";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[40] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14385;
				["lastSkillID"] = 14384;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Hammer Smash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[41] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14486;
				["lastSkillID"] = 14485;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Bash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[42] = {
			["player"] = {
				["combatState"] = "InCombat";
				["maxPower"] = 99;
			};
			["skill"] = {
				["castOnSelf"] = false;
				["groundTargeted"] = false;
				["id"] = 30435;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Berserk";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
				["enemyNearCount"] = 0;
				["enemyRangeMax"] = 0;
			};
		};
		[43] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14377;
				["lastSkillID"] = 14376;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Mace Bash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[44] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14370;
				["lastSkillID"] = 14369;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Double Chop";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[45] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14374;
				["lastSkillID"] = 14373;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Brutal Strike";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[46] = {
			["player"] = {
				["maxPower"] = 90;
				["minPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14512;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Earthshaker";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[47] = {
			["player"] = {
				["maxPower"] = 90;
				["minPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14514;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Earthshaker";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[48] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14513;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Earthshaker";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[49] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14387;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Earthshaker";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[50] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14396;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Kill Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[51] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14473;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Kill Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[52] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14475;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Kill Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[53] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14474;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Kill Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[54] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14470;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Forceful Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[55] = {
			["player"] = {
				["maxPower"] = 90;
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14544;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Forceful Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[56] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14469;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Forceful Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[57] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14471;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Forceful Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[58] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14422;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Eviscerate";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[59] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14353;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Eviscerate";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = false;
			};
			["target"] = {
			};
		};
		[60] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14424;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Eviscerate";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[61] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14423;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Eviscerate";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = false;
			};
			["target"] = {
			};
		};
		[62] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14545;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Arcing Slice";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
				["stopsMovement"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[63] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14375;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Arcing Slice";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
				["stopsMovement"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[64] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14547;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Arcing Slice";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
				["stopsMovement"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[65] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14546;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Arcing Slice";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
				["stopsMovement"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[66] = {
			["player"] = {
				["maxPower"] = 90;
				["minPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14551;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Whirling Strike";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[67] = {
			["player"] = {
				["maxPower"] = 0;
				["minPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14443;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Whirling Strike";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[68] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14550;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Whirling Strike";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[69] = {
			["player"] = {
				["maxPower"] = 90;
				["minPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14549;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Whirling Strike";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[70] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14522;
				["isProjectile"] = true;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Combustive Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[71] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14521;
				["isProjectile"] = true;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Combustive Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[72] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14520;
				["isProjectile"] = true;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Combustive Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[73] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14506;
				["isProjectile"] = true;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Combustive Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[74] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14427;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Skull Crack";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
				["type"] = "Character";
			};
		};
		[75] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14426;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Skull Crack";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
				["type"] = "Character";
			};
		};
		[76] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14425;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Skull Crack";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
				["type"] = "Character";
			};
		};
		[77] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14414;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Skull Crack";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
			};
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
				["type"] = "Character";
			};
		};
		[78] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14430;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Flurry";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[79] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14428;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Flurry";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[80] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14429;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Flurry";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["slowCast"] = false;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[81] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14367;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Flurry";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 13;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[82] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14516;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Bull's Charge";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[83] = {
			["player"] = {
				["maxPower"] = 99;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29852;
				["maxRange"] = 450;
				["minRange"] = 0;
				["name"] = "Arc Divider";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[84] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29941;
				["maxRange"] = 170;
				["minRange"] = 0;
				["name"] = "Wild Blow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
				["enemyNearCount"] = 0;
				["enemyRangeMax"] = 0;
				["hasNotBuffs"] = "36298";
				["type"] = "Character";
			};
		};
		[85] = {
			["player"] = {
				["minPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30074;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Shattering Blow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
				["enemyNearCount"] = 0;
				["enemyRangeMax"] = 0;
				["type"] = "Character";
			};
		};
		[86] = {
			["player"] = {
				["minPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 29613;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Sundering Leap";
				["radius"] = 180;
				["setRange"] = true;
				["slot"] = 1;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[87] = {
			["player"] = {
				["combatState"] = "InCombat";
				["maxPower"] = 0;
				["minHP"] = 0;
				["minPower"] = 90;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 30258;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Outrage";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 1;
			};
			["target"] = {
				["enemyNearCount"] = 1;
				["enemyRangeMax"] = 240;
				["type"] = "Either";
			};
		};
		[88] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30343;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Head Butt";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[89] = {
			["player"] = {
				["maxPower"] = 99;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30851;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Decapitate";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[90] = {
			["player"] = {
				["maxPower"] = 99;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29923;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Scorched Earth";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[91] = {
			["player"] = {
				["maxPower"] = 99;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 30879;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Rupturing Smash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[92] = {
			["player"] = {
				["maxPower"] = 99;
				["minPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29679;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Skull Grinder";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[93] = {
			["player"] = {
				["maxPower"] = 99;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30682;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Flaming Flurry";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[94] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14575;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "\"On My Mark!\"";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[95] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14354;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Bolas";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
				["hasNotBuffs"] = "1122";
				["maxHP"] = 0;
				["moving"] = "Moving";
				["type"] = "Character";
			};
		};
		[96] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14409;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Fear Me!\"";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
				["hasNotBuffs"] = "";
				["type"] = "Character";
			};
		};
		[97] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14502;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Kick";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[98] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14388;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Stomp";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906";
				["type"] = "Character";
			};
		};
		[99] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 0;
				["minPower"] = 40;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14410;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Fury";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[100] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minPower"] = 0;
				["moving"] = "Moving";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14404;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Might";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[101] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14465;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Repeating Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122\
";
				["type"] = "Character";
			};
		};
		[102] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14511;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Backbreaker";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
			};
		};
		[103] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14480;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Tsunami Slash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[104] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14504;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Pin Down";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
				["type"] = "Character";
			};
		};
		[105] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 19547;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Whirling Axe";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[106] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14399;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Whirling Axe";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[107] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14362;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Shield Stance";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 5;
				["slowCast"] = true;
			};
			["target"] = {
				["enemyNearCount"] = 0;
				["enemyRangeMax"] = 0;
			};
		};
		[108] = {
			["player"] = {
				["maxPower"] = 99;
				["minPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29644;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Gun Flame";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[109] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14556;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Boulder";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
				["slowCast"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
			};
		};
		[110] = {
			["player"] = {
				["conditionCount"] = 0;
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29940;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Flames of War";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[111] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14446;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Rush";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[112] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14415;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Tremor";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122\
";
			};
		};
		[113] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14360;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Rifle Butt";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[114] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14515;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Hammer Toss";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
			};
		};
		[115] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29845;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Blaze Breaker";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[116] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14510;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Bladetrail";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[117] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14467;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Knot Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[118] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14395;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Brutal Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[119] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14505;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Smoldering Arrow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[120] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14501;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Rip";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["conditionCount"] = 0;
				["hasBuffs"] = "19426";
				["moving"] = "Moving";
			};
		};
		[121] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14554;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Hundred Blades";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[122] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14507;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Counterblow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[123] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14498;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Impale";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[124] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14490;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Seismic Leap";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[125] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14361;
				["maxRange"] = 450;
				["minRange"] = 0;
				["name"] = "Shield Bash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
			};
		};
		[126] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14466;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Brutal Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[127] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14481;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Split Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[128] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14519;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Fan of Fire";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[129] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14472;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Volley";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[130] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14440;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Mariner's Frenzy";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[131] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14497;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Final Thrust";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[132] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14418;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Dual Strike";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[133] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14518;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Crushing Blow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[134] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14359;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Staggering Blow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
			};
		};
		[135] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14391;
				["los"] = true;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Vengeance";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
				["slowCast"] = true;
			};
			["target"] = {
				["enemyNearCount"] = 1;
				["enemyRangeMax"] = 400;
				["minHP"] = 0;
			};
		};
		[136] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14489;
				["maxRange"] = 1000;
				["minRange"] = 0;
				["name"] = "Dash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[137] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14398;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Axe";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[138] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14448;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Harpoon Pull";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
			};
		};
		[139] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14482;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Hammer Shock";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[140] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14416;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Aimed Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[141] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14381;
				["isProjectile"] = true;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Arcing Arrow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[142] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14503;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Pommel Bash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[143] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14441;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Parry";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[144] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14366;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Savage Leap";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[145] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14566;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Whirlwind Banner";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[146] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14447;
				["maxRange"] = 450;
				["minRange"] = 0;
				["name"] = "Whirlwind Attack";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[147] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14488;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Kick";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
			};
		};
		[148] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14464;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Kick";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[149] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14386;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Fierce Blow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[150] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14421;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Cyclone Axe";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[151] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14561;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Staggering Banner";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["stopsMovement"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "";
				["type"] = "Character";
			};
		};
		[152] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14563;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Brutal Banner";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[153] = {
			["player"] = {
				["minPower"] = 40;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14557;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Adrenaline Rush";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[154] = {
			["player"] = {
				["minPower"] = 20;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14548;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Adrenaline Rush";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[155] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14431;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Dual Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[156] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14552;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Mariner's Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[157] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14432;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Fierce Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[158] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14463;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Punch";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[159] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14390;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Rock";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[160] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14437;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Stab";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[161] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14494;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Stab";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[162] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14485;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Smash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[163] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14358;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Hammer Swing";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[164] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14356;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Greatsword Swing";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[165] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14376;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Mace Smash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[166] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14369;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Chop";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[167] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14364;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Sever Artery";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
	};
	["switchSettings"] = {
		["switchWeapons"] = true;
	};
}
return obj1
