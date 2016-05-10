private ["_unit","_muerto","_killer","_skill"];

_unit = _this select 0;

[_unit] call initRevive;

_unit allowFleeing 0;
_skillFIA = server getVariable "skillFIA";
_skill = 0.2 + (_skillFIA * 0.04);
_unit setSkill (_skill + 0.1);
_aiming = _skill + 0.1;
_spotD = _skill + 0.1;
_spotT = _skill + 0.1;
_cour = _skill + 0.1;
_comm = _skill + 0.1;
_aimingSh = _skill + 0.1;
_aimingSp = _skill + 0.1;
_reload = _skill + 0.1;

_tipo = typeOf _unit;
//_emptyUniform = false;
_skillSet = 0;

if (not("ItemRadio" in unlockedItems)) then {_unit unlinkItem "ItemRadio"};

switch _tipo do
	{
	case "B_G_Soldier_LAT_F":
		{
		if ("launch_I_Titan_short_F" in unlockedWeapons) then
			{
			for "_i" from 1 to ({_x == "RPG32_F"} count magazines _unit) do
				{
				_unit removeMagazine "RPG32_F";
				};
			_unit removeMagazine "RPG32_HE_F";
			_unit removeWeaponGlobal "launch_RPG32_F";
			[_unit, "launch_I_Titan_short_F", 4, 0] call BIS_fnc_addWeapon;
			}
		else
			{
			if ("launch_NLAW_F" in unlockedWeapons) then
				{
				for "_i" from 1 to ({_x == "RPG32_F"} count magazines _unit) do
					{
					_unit removeMagazine "RPG32_F";
					};
				_unit removeMagazine "RPG32_HE_F";
				_unit removeWeaponGlobal "launch_RPG32_F";
				[_unit, "launch_NLAW_F", 4, 0] call BIS_fnc_addWeapon;
				}
			else
				{
				if (hayRHS) then
					{
					for "_i" from 1 to ({_x == "RPG32_F"} count magazines _unit) do
						{
						_unit removeMagazine "RPG32_F";
						};
					_unit removeMagazine "RPG32_HE_F";
					_unit removeWeaponGlobal "launch_RPG32_F";
					[_unit, "rhs_weap_rpg7", 4, 0] call BIS_fnc_addWeapon;
					if (count unlockedOptics > 0) then
						{
						_compatibles = [secondaryWeapon _unit] call BIS_fnc_compatibleItems;
						_posibles = [];
						{
						if (_x in _compatibles) then {_posibles pushBack _x};
						} forEach unlockedOptics;
						_unit addSecondaryWeaponItem (_posibles call BIS_fnc_selectRandom);
						};
					};
				};
			};
		[_unit,true,true,true,false] call randomRifle;
		};
	case "B_G_Soldier_F":
		{
		[_unit,true,true,true,true] call randomRifle;
		if (loadAbs _unit < 340) then
			{
			if ((random 20 < _skillFIA) and ("launch_I_Titan_F" in unlockedWeapons)) then
				{
				_unit addbackpack "B_AssaultPack_blk";
				[_unit, "launch_I_Titan_F", 2, 0] call BIS_fnc_addWeapon;
				removeBackpack _unit;
				}
			else
				{
				if ((random 20 < _skillFIA) and ("launch_NLAW_F" in unlockedWeapons)) then
					{
					_unit addbackpack "B_AssaultPack_blk";
					if (hayRHS) then {[_unit, "rhs_weap_rpg7", 2, 0] call BIS_fnc_addWeapon;} else {[_unit, "launch_RPG32_F", 2, 0] call BIS_fnc_addWeapon};
					removeBackPack _unit;
					};
				};
			};
		};
	case "B_G_Soldier_GL_F":
		{
		if (hayRHS) then
			{
			removeAllItemsWithMagazines _unit;
			[_unit,false,true,true,true] call randomRifle;
			for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_762x39mm"; _unit addItemToVest "rhs_VOG25";};
			_unit addWeapon "rhs_weap_akms_gp25";
			}
		else
			{
			[_unit,false,true,true,false] call randomRifle;
			};
		};
	case "B_G_Soldier_lite_F":
		{
		[_unit,true,true,true,true] call randomRifle;
		_skillSet = 1;
		};
	case "b_g_soldier_unarmed_f":
		{
		_skilleSet = 1;
		};
	case "B_G_Soldier_SL_F":
		{
		[_unit,false,true,true,false] call randomRifle;
		_skillSet = 2;
		if (hayRHS) then
			{
			removeAllItemsWithMagazines _unit;
			for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_545x39_AK"; _unit addItemToVest "rhs_VOG25";};
			_unit addWeapon "rhs_weap_ak74m_gp25";
			_unit addPrimaryWeaponItem "rhs_acc_1p29";
			_unit addItemToVest "SmokeShell";
			_unit addItemToVest "SmokeShell";
			};
		};
	case "B_G_Soldier_TL_F":
		{
		[_unit,false,true,true,false] call randomRifle;
		_skillSet = 3;
		if (hayRHS) then
			{
			removeAllItemsWithMagazines _unit;
			for "_i" from 1 to 6 do {_unit addItemToVest "rhs_30Rnd_545x39_AK"; _unit addItemToVest "rhs_VOG25";};
			_unit addWeapon "rhs_weap_ak74m_gp25";
			_unit addPrimaryWeaponItem "rhs_acc_1p29";
			_unit addItemToVest "SmokeShell";
			_unit addItemToVest "SmokeShell";
			};
		};
	case "B_G_Soldier_AR_F":
		{
		if (hayRHS) then
			{
			[_unit,false,true,true,true] call randomRifle;
			removeAllItemsWithMagazines _unit;
			_unit removeWeaponGlobal (primaryWeapon _unit);
			_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
			_unit addWeaponGlobal "rhs_weap_pkm";
			_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
			_unit addMagazine ["rhs_100Rnd_762x54mmR", 100];
			_emptyUniform = true;
			}
		else
			{
			[_unit,false,true,true,false] call randomRifle;
			};
		_skillSet = 4;
		};
	case "B_G_medic_F":
		{
		_skillSet = 5;
		[_unit,true,true,true,false] call randomRifle;
		};
	case "B_G_engineer_F":
		{
		_skillSet = 5;
		[_unit,true,true,true,false] call randomRifle;
		};
	case "B_G_Soldier_exp_F":
		{
		_skillSet = 5;
		[_unit,true,true,true,false] call randomRifle;
		_unit addmagazine "ATMine_Range_Mag";
		};
	case "B_G_Soldier_A_F":
		{
		_skillSet = 5;
		[_unit,true,true,true,false] call randomRifle;
		};
	case "B_G_Soldier_M_F":
		{
		if (("srifle_GM6_F" in unlockedWeapons) or (hayRHS)) then
			{
			for "_i" from 1 to ({_x == "30Rnd_556x45_Stanag"} count magazines _unit) do
				{
				_unit removeMagazine "30Rnd_556x45_Stanag";
				};
			_unit removeWeaponGlobal (primaryWeapon _unit);
			if ("srifle_GM6_F" in unlockedWeapons) then {[_unit, "srifle_GM6_SOS_F", 8, 0] call BIS_fnc_addWeapon} else {[_unit, "rhs_weap_svdp_wd", 8, 0] call BIS_fnc_addWeapon; _unit addPrimaryWeaponItem "rhs_acc_pso1m2";}
			};
		_skillSet = 6;
		};
	case "B_G_Sharpshooter_F":
		{
		_skillSet = 6;
		};
	};

switch _skillSet do
	{
	case 0:
		{
		_aiming = _aiming -0.2;
		_aimingSh = _aimingSh - 0.2;
		_aimingSp = _aimingSp - 0.2;
		_reload = _reload - 0.2;
		};
	case 1:
		{
		_aiming = _aiming -0.1;
		_spotD = _spotD - 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp + 0.2;
		_reload = _reload + 0.1;
		};
	case 2:
		{
		_aiming = _aiming - 0.1;
		_spotD = _spotD + 0.2;
		_spotT = _spotT + 0.2;
		_cour = _cour + 0.1;
		_comm = _comm + 0.2;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.2;
		};
	case 3:
		{
		_aiming = _aiming + 0.1;
		_spotD = _spotD + 0.1;
		_spotT = _spotT + 0.1;
		_cour = _cour + 0.1;
		_comm = _comm + 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
		};
	case 4:
		{
		_aiming = _aiming - 0.1;
		_aimingSh = _aimingSh + 0.2;
		_aimingSp = _aimingSp - 0.2;
		_reload = _reload - 0.2;
		};
	case 5:
		{
		_aiming = _aiming - 0.1;
		_spotD = _spotD - 0.1;
		_spotT = _spotT - 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
		};
	case 6:
		{
		_aiming = _aiming + 0.2;
		_spotD = _spotD + 0.4;
		_spotT = _spotT + 0.2;
		_cour = _cour - 0.1;
		_comm = _comm - 0.1;
		_aimingSh = _aimingSh + 0.1;
		_aimingSp = _aimingSp + 0.1;
		_reload = _reload - 0.4;
		};
	};

_unit selectWeapon ( primaryWeapon _unit );

if (sunOrMoon < 1) then
	{
	if ("NVGoggles" in unlockedItems) then
		{
		_unit linkItem "NVGoggles";
		if ("acc_pointer_IR" in unlockedItems) then
			{
			_unit addPrimaryWeaponItem "acc_pointer_IR";
	        _unit assignItem "acc_pointer_IR";
	        _unit enableIRLasers true;
			};
		}
	else
		{
		if ("acc_flashlight" in unlockedItems) then
			{
			_unit unassignItem "acc_pointer_IR";
	        _unit removePrimaryWeaponItem "acc_pointer_IR";
	        _unit addPrimaryWeaponItem "acc_flashlight";
	        //_unit assignItem "acc_flashlight";
	        _unit enableGunLights "AUTO";
	        _spotD = _spotD - 0.2;
	        _spotT = _spotT - 0.2;
	    	};
		};
	};

if ((_tipo != "B_G_Soldier_M_F") and (_tipo != "B_G_Sharpshooter_F")) then {if (_aiming > 0.35) then {_aiming = 0.35}};
_unit setskill ["aimingAccuracy",_aiming];
_unit setskill ["spotDistance",_spotD];
_unit setskill ["spotTime",_spotT];
_unit setskill ["courage",_cour];
_unit setskill ["commanding",_comm];
_unit setskill ["aimingShake",_aimingSh];
_unit setskill ["aimingSpeed",_aimingSp];
_unit setskill ["reloadSpeed",_reload];

_EHkilledIdx = _unit addEventHandler ["killed", {
	_muerto = _this select 0;
	[_muerto] spawn postmortem;
	_nul = [0,-1,getPos _muerto] remoteExecCall ["citySupportChange",2];
	}];

