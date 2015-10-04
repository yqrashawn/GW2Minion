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
			["priority"] = 1;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14402;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "\"To the Limit!\"";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 6;
			["target"] = {
			};
		};
		[2] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 75;
			};
			["priority"] = 2;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14401;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Mending";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 6;
			["target"] = {
			};
		};
		[3] = {
			["player"] = {
				["minHP"] = 75;
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30189;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Blood Reckoning";
				["radius"] = 0;
				["setRange"] = "0";
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
			["priority"] = 3;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14389;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Healing Signet";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 6;
			["target"] = {
			};
		};
		[5] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 90;
			};
			["priority"] = 4;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 21815;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Defiant Stance";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 6;
			["target"] = {
			};
		};
		[6] = {
			["player"] = {
				["maxPower"] = 0;
				["minHP"] = 0;
				["moving"] = "Moving";
			};
			["priority"] = 5;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14355;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Rage";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 10;
			["target"] = {
			};
		};
		[7] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 600;
				["maxPower"] = 0;
			};
			["priority"] = 6;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 14419;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Battle Standard";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 10;
			["target"] = {
			};
		};
		[8] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 7;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14483;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Rampage";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 10;
			["target"] = {
				["type"] = "Character";
			};
		};
		[9] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 8;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 14528;
				["los"] = "1";
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Banner of Defense";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["maxHP"] = 0;
				["type"] = "Character";
			};
		};
		[10] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 9;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14368;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 1500;
				["name"] = "Frenzy";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
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
			["priority"] = 10;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14392;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 1200;
				["name"] = "Endure Pain";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[12] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 11;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 14407;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Banner of Discipline";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["type"] = "Character";
			};
		};
		[13] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 12;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 14405;
				["los"] = "1";
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Banner of Strength";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["type"] = "Character";
			};
		};
		[14] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 13;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 14408;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Banner of Tactics";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
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
			["priority"] = 14;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14412;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Balanced Stance";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[16] = {
			["player"] = {
				["conditionCount"] = 0;
				["hasBuffs"] = "791";
				["minEndurance"] = 0;
			};
			["priority"] = 15;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14413;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Dolyak Signet";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
				["type"] = "Character";
			};
		};
		[17] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 0;
			};
			["priority"] = 16;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14406;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Berserker Stance";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[18] = {
			["player"] = {
				["conditionCount"] = 1;
			};
			["priority"] = 17;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14372;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "\"Shake It Off!\"";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[19] = {
			["player"] = {
				["conditionCount"] = 3;
			};
			["priority"] = 18;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14479;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Stamina";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[20] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 19;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14403;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "\"For Great Justice!\"";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 9;
			["target"] = {
			};
		};
		[21] = {
			["player"] = {
				["combatState"] = "InCombat";
				["maxPower"] = 0;
				["minPower"] = 0;
			};
			["priority"] = 20;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14400;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Riposte";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[22] = {
			["player"] = {
			};
			["priority"] = 21;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14477;
				["los"] = "0";
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Inspire";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[23] = {
			["player"] = {
				["moving"] = "Moving";
			};
			["priority"] = 22;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14394;
				["los"] = "0";
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Call to Arms";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[24] = {
			["player"] = {
			};
			["priority"] = 23;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14564;
				["los"] = "0";
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Compassionate Banner";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[25] = {
			["player"] = {
			};
			["priority"] = 24;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14495;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Sprint";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[26] = {
			["player"] = {
			};
			["priority"] = 25;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14562;
				["los"] = "0";
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Furious Rally";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[27] = {
			["player"] = {
			};
			["priority"] = 26;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 1175;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Bandage";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[28] = {
			["player"] = {
				["moving"] = "Moving";
			};
			["priority"] = 27;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 14393;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Charge";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[29] = {
			["player"] = {
			};
			["priority"] = 28;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14436;
				["lastSkillID"] = 14477;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Plant Standard";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[30] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
				["maxPower"] = 0;
			};
			["priority"] = 29;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14373;
				["lastSkillID"] = 14356;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Greatsword Slice";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[31] = {
			["player"] = {
			};
			["priority"] = 30;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14371;
				["lastSkillID"] = 14370;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Triple Chop";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "0";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[32] = {
			["player"] = {
			};
			["priority"] = 31;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14487;
				["lastSkillID"] = 14486;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Uppercut";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[33] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 32;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14378;
				["lastSkillID"] = 14377;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Pulverize";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[34] = {
			["player"] = {
				["minPower"] = 0;
			};
			["priority"] = 33;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14365;
				["lastSkillID"] = 14364;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Gash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[35] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 34;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14363;
				["lastSkillID"] = 14365;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Hamstring";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[36] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 35;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14384;
				["lastSkillID"] = 14358;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Hammer Bash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[37] = {
			["player"] = {
			};
			["priority"] = 36;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14439;
				["lastSkillID"] = 14438;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Impale";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[38] = {
			["player"] = {
			};
			["priority"] = 37;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14438;
				["lastSkillID"] = 14437;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Jab";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[39] = {
			["player"] = {
			};
			["priority"] = 38;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14385;
				["lastSkillID"] = 14384;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Hammer Smash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[40] = {
			["player"] = {
			};
			["priority"] = 39;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14486;
				["lastSkillID"] = 14485;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Bash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[41] = {
			["player"] = {
			};
			["priority"] = 40;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14377;
				["lastSkillID"] = 14376;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Mace Bash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[42] = {
			["player"] = {
			};
			["priority"] = 41;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14370;
				["lastSkillID"] = 14369;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Double Chop";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[43] = {
			["player"] = {
			};
			["priority"] = 42;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14374;
				["lastSkillID"] = 14373;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Brutal Strike";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[44] = {
			["player"] = {
				["maxPower"] = 90;
				["minPower"] = 0;
			};
			["priority"] = 44;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14512;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Earthshaker";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[45] = {
			["player"] = {
				["maxPower"] = 90;
				["minPower"] = 0;
			};
			["priority"] = 45;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14514;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Earthshaker";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[46] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 53;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14513;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Earthshaker";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[47] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 54;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14387;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Earthshaker";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[48] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 46;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14396;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Kill Shot";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[49] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 47;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14473;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Kill Shot";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[50] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 48;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14475;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Kill Shot";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[51] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 49;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14474;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Kill Shot";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[52] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 50;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14470;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Forceful Shot";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[53] = {
			["player"] = {
				["maxPower"] = 90;
				["minHP"] = 0;
			};
			["priority"] = 43;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14544;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Forceful Shot";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[54] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 51;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14469;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Forceful Shot";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[55] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 52;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14471;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Forceful Shot";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[56] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 65;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14422;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Eviscerate";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[57] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 55;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14353;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Eviscerate";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "0";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[58] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 66;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14424;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Eviscerate";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[59] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 56;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14423;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Eviscerate";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "0";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[60] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 58;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14545;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Arcing Slice";
				["radius"] = 0;
				["setRange"] = "0";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["type"] = "Character";
			};
		};
		[61] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 59;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14375;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Arcing Slice";
				["radius"] = 0;
				["setRange"] = "0";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["type"] = "Character";
			};
		};
		[62] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 61;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14547;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Arcing Slice";
				["radius"] = 0;
				["setRange"] = "0";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["type"] = "Character";
			};
		};
		[63] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 64;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14546;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Arcing Slice";
				["radius"] = 0;
				["setRange"] = "0";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["type"] = "Character";
			};
		};
		[64] = {
			["player"] = {
				["maxPower"] = 90;
				["minPower"] = 0;
			};
			["priority"] = 60;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14551;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Whirling Strike";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[65] = {
			["player"] = {
				["maxPower"] = 0;
				["minPower"] = 90;
			};
			["priority"] = 62;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14443;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Whirling Strike";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[66] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 71;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14550;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Whirling Strike";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[67] = {
			["player"] = {
				["maxPower"] = 90;
				["minPower"] = 0;
			};
			["priority"] = 63;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14549;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Whirling Strike";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[68] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 67;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14522;
				["isProjectile"] = "1";
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Combustive Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[69] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 68;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14521;
				["isProjectile"] = "1";
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Combustive Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[70] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 69;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14520;
				["isProjectile"] = "1";
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Combustive Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[71] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 70;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14506;
				["isProjectile"] = "1";
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Combustive Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[72] = {
			["player"] = {
			};
			["priority"] = 73;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14427;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Skull Crack";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
				["type"] = "Character";
			};
		};
		[73] = {
			["player"] = {
			};
			["priority"] = 74;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14426;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Skull Crack";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
				["type"] = "Character";
			};
		};
		[74] = {
			["player"] = {
			};
			["priority"] = 75;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14425;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Skull Crack";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
				["type"] = "Character";
			};
		};
		[75] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30435;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Berserk";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[76] = {
			["player"] = {
			};
			["priority"] = 76;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14414;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Skull Crack";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 13;
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
				["type"] = "Character";
			};
		};
		[77] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 77;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14430;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Flurry";
				["radius"] = 0;
				["setRange"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[78] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 72;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14428;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Flurry";
				["radius"] = 0;
				["setRange"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[79] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 57;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14429;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Flurry";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "0";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[80] = {
			["player"] = {
				["maxPower"] = 90;
			};
			["priority"] = 78;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14367;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Flurry";
				["radius"] = 0;
				["setRange"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 13;
			["target"] = {
			};
		};
		[81] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 79;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14516;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Bull's Charge";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[82] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 29852;
				["maxRange"] = 450;
				["minRange"] = 0;
				["name"] = "Arc Divider";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[83] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 29941;
				["maxRange"] = 170;
				["minRange"] = 0;
				["name"] = "Wild Blow";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[84] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30074;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Shattering Blow";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[85] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 29613;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Sundering Leap";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[86] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30258;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Outrage";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[87] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30343;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Head Butt";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[88] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30851;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Decapitate";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[89] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 29923;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Scorched Earth";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[90] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 30879;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Rupturing Smash";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[91] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 29679;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Skull Grinder";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[92] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30682;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Flaming Flurry";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[93] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
			};
			["priority"] = 80;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14575;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "\"On My Mark!\"";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["type"] = "Character";
			};
		};
		[94] = {
			["player"] = {
			};
			["priority"] = 81;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14354;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Bolas";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
				["hasNotBuffs"] = "1122";
				["moving"] = "Moving";
				["type"] = "Character";
			};
		};
		[95] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
			};
			["priority"] = 82;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14409;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Fear Me!\"";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["hasNotBuffs"] = "";
				["type"] = "Character";
			};
		};
		[96] = {
			["player"] = {
			};
			["priority"] = 83;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14502;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Kick";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[97] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 84;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14388;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Stomp";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["hasNotBuffs"] = "905,906";
				["type"] = "Character";
			};
		};
		[98] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 0;
				["minPower"] = 40;
			};
			["priority"] = 85;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14410;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Fury";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[99] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minPower"] = 0;
				["moving"] = "Moving";
			};
			["priority"] = 86;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14404;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Might";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 8;
			["target"] = {
			};
		};
		[100] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 87;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14465;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Repeating Shot";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122\
";
				["type"] = "Character";
			};
		};
		[101] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 88;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14511;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Backbreaker";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
			};
		};
		[102] = {
			["player"] = {
			};
			["priority"] = 89;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14480;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Tsunami Slash";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[103] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 90;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14504;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Pin Down";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
				["type"] = "Character";
			};
		};
		[104] = {
			["player"] = {
			};
			["priority"] = 91;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 19547;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Whirling Axe";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[105] = {
			["player"] = {
			};
			["priority"] = 91;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14399;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Whirling Axe";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[106] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 92;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14362;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Shield Stance";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["enemyNearCount"] = 0;
				["enemyRangeMax"] = 0;
			};
		};
		[107] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 29644;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Gun Flame";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[108] = {
			["player"] = {
			};
			["priority"] = 93;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14556;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Boulder";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
			};
		};
		[109] = {
			["player"] = {
			};
			["priority"] = 94;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14446;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Rush";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["type"] = "Character";
			};
		};
		[110] = {
			["player"] = {
			};
			["priority"] = 95;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14415;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Tremor";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122\
";
			};
		};
		[111] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 96;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14360;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Rifle Butt";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
				["type"] = "Character";
			};
		};
		[112] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 97;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14515;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Hammer Toss";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
				["hasNotBuffs"] = "743,717,1122";
			};
		};
		[113] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 98;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14510;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Bladetrail";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["type"] = "Character";
			};
		};
		[114] = {
			["player"] = {
			};
			["priority"] = 99;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14467;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Knot Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[115] = {
			["player"] = {
			};
			["priority"] = 100;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14395;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Brutal Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[116] = {
			["player"] = {
			};
			["priority"] = 101;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14505;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Smoldering Arrow";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[117] = {
			["player"] = {
			};
			["priority"] = 102;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14501;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Rip";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["conditionCount"] = 0;
				["hasBuffs"] = "19426";
				["moving"] = "Moving";
			};
		};
		[118] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 103;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14554;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Hundred Blades";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[119] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minPower"] = 0;
			};
			["priority"] = 104;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14507;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Counterblow";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
				["type"] = "Character";
			};
		};
		[120] = {
			["player"] = {
			};
			["priority"] = 105;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14498;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Impale";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["type"] = "Character";
			};
		};
		[121] = {
			["player"] = {
			};
			["priority"] = 106;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14490;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Seismic Leap";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[122] = {
			["player"] = {
			};
			["priority"] = 107;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14361;
				["maxRange"] = 450;
				["minRange"] = 0;
				["name"] = "Shield Bash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
			};
		};
		[123] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 108;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14466;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Brutal Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[124] = {
			["player"] = {
			};
			["priority"] = 109;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14481;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Split Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[125] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 110;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14519;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Fan of Fire";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[126] = {
			["player"] = {
			};
			["priority"] = 111;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14472;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Volley";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[127] = {
			["player"] = {
			};
			["priority"] = 112;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14440;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Mariner's Frenzy";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[128] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 113;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14497;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Final Thrust";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[129] = {
			["player"] = {
			};
			["priority"] = 114;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14418;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Dual Strike";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[130] = {
			["player"] = {
			};
			["priority"] = 115;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14518;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Crushing Blow";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[131] = {
			["player"] = {
			};
			["priority"] = 116;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14359;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Staggering Blow";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
			};
		};
		[132] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 117;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14391;
				["los"] = "1";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Vengeance";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 3;
			["target"] = {
				["enemyNearCount"] = 1;
				["enemyRangeMax"] = 400;
				["minHP"] = 0;
			};
		};
		[133] = {
			["player"] = {
			};
			["priority"] = 118;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14489;
				["maxRange"] = 1000;
				["minRange"] = 0;
				["name"] = "Dash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[134] = {
			["player"] = {
			};
			["priority"] = 119;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14398;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Axe";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[135] = {
			["player"] = {
			};
			["priority"] = 120;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14448;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Harpoon Pull";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
			};
		};
		[136] = {
			["player"] = {
			};
			["priority"] = 121;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14482;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Hammer Shock";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[137] = {
			["player"] = {
			};
			["priority"] = 122;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14416;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Aimed Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[138] = {
			["player"] = {
			};
			["priority"] = 123;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14381;
				["isProjectile"] = "1";
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Arcing Arrow";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[139] = {
			["player"] = {
			};
			["priority"] = 124;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14503;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Pommel Bash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[140] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 125;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14441;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Parry";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[141] = {
			["player"] = {
			};
			["priority"] = 126;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14366;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Savage Leap";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[142] = {
			["player"] = {
			};
			["priority"] = 127;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14566;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Whirlwind Banner";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[143] = {
			["player"] = {
			};
			["priority"] = 128;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 14447;
				["maxRange"] = 450;
				["minRange"] = 0;
				["name"] = "Whirlwind Attack";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[144] = {
			["player"] = {
			};
			["priority"] = 129;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14488;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Kick";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
				["hasNotBuffs"] = "905,906,1122";
			};
		};
		[145] = {
			["player"] = {
			};
			["priority"] = 130;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14464;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Kick";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[146] = {
			["player"] = {
			};
			["priority"] = 131;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14386;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Fierce Blow";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[147] = {
			["player"] = {
			};
			["priority"] = 132;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14421;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Cyclone Axe";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[148] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 133;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14561;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Staggering Banner";
				["radius"] = 0;
				["setRange"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 2;
			["target"] = {
				["hasNotBuffs"] = "";
				["type"] = "Character";
			};
		};
		[149] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 134;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14563;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Brutal Banner";
				["radius"] = 0;
				["setRange"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[150] = {
			["player"] = {
				["minPower"] = 40;
			};
			["priority"] = 135;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14557;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Adrenaline Rush";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[151] = {
			["player"] = {
				["minPower"] = 20;
			};
			["priority"] = 136;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14548;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Adrenaline Rush";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[152] = {
			["player"] = {
			};
			["priority"] = 137;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14431;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Dual Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[153] = {
			["player"] = {
			};
			["priority"] = 138;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14552;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Mariner's Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[154] = {
			["player"] = {
			};
			["priority"] = 139;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14432;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Fierce Shot";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[155] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["priority"] = 140;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14463;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Punch";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[156] = {
			["player"] = {
			};
			["priority"] = 141;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14390;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Rock";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[157] = {
			["player"] = {
			};
			["priority"] = 142;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14437;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Stab";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[158] = {
			["player"] = {
			};
			["priority"] = 143;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14494;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Stab";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[159] = {
			["player"] = {
			};
			["priority"] = 144;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14485;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Smash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[160] = {
			["player"] = {
			};
			["priority"] = 145;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14358;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Hammer Swing";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[161] = {
			["player"] = {
			};
			["priority"] = 146;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14356;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Greatsword Swing";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[162] = {
			["player"] = {
			};
			["priority"] = 147;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14376;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Mace Smash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[163] = {
			["player"] = {
			};
			["priority"] = 148;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14369;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Chop";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[164] = {
			["player"] = {
			};
			["priority"] = 149;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 14364;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Sever Artery";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
	};
	["switchSettings"] = {
		["switchOnCooldown"] = 0;
		["switchOnRange"] = "0";
		["switchRandom"] = "1";
	};
}
return obj1
