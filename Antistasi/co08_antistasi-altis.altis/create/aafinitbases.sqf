private ["_unit","_muerto","_killer","_skill","_caja","_tipo","_chance"];

_unit = _this select 0;

if (typeOf _unit == "Fin_random_F") exitWith {};

_skill = (0.2 + (skillAAF * 0.04));
_unit setSkill (_skill + 0.1);
_aiming = _skill + 0.1;
_spotD = _skill + 0.1;
_spotT = _skill + 0.1;
_cour = _skill + 0.1;
_comm = _skill + 0.1;
_aimingSh = _skill + 0.1;
_aimingSp = _skill + 0.1;
_reload = _skill + 0.1;


_divisor = 20000;
if ("NVGoggles" in unlockedItems) then {_divisor = 8000};

_tipo = typeOf _unit;

if ((_tipo == "I_Sniper_F") or (_tipo == "I_Spotter_F") or (_tipo == "I_Soldier_M_F") or (_tipo == "I_G_Sharpshooter_F")) then
	{
	_aiming = _aiming + 0.2;
	if ((_tipo != "I_G_Sharpshooter_F") or (_tipo == "I_Sniper_F")) then {if (_aiming > 0.35) then {_aiming = 0.35}};
	_spotD = _spotD + 0.2;
	_spotT = _spotT + 0.2;
	_cour = _cour - 0.1;
	_comm = _comm - 0.1;
	_aimingSh = _aimingSh + 0.1;
	_aimingSp = _aimingSp - 0.1;
	_reload = _reload - 0.4;
	_divisor = _divisor - 5000;
	}
else
	{
	if ((_tipo == "I_Soldier_TL_F") or (_tipo == "I_Soldier_SL_F")  or (_tipo == "I_helipilot_F") or (_tipo == "I_pilot_F")) then
		{
		_aiming = _aiming - 0.1;
		if (_aiming > 0.35) then {_aiming = 0.35};
		_spotD = _spotD + 0.1;
		_spotT = _spotT + 0.2;
		_cour = _cour + 0.1;
		_comm = _comm + 0.2;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
		_divisor = _divisor - 5000;
		}
	else
		{
		if ((_tipo == "I_Soldier_AR_F") or (_tipo == "I_support_MG_F")) then
			{
			_aiming = _aiming - 0.1;
			if (_aiming > 0.35) then {_aiming = 0.35};
			_aimingSh = _aimingSh + 0.2;
			_aimingSp = _aimingSp - 0.2;
			_reload = _reload - 0.2;
			if (_tipo == "I_support_MG_F") then
				{
				removeBackpackGlobal _unit;
				};
			}
		else
			{
			if ((_tipo == "I_medic_F") or (_tipo == "I_Soldier_A_F") or (_tipo == "I_Soldier_AAR_F") or (_tipo == "I_Soldier_AAT_F") or (_tipo == "I_Soldier_AAA_F")) then
				{
				_aiming = _aiming - 0.1;
				if (_aiming > 0.35) then {_aiming = 0.35};
				_spotD = _spotD - 0.1;
				_spotT = _spotT - 0.1;
				_aimingSh = _aimingSh - 0.1;
				_aimingSp = _aimingSp - 0.1;
				_reload = _reload - 0.1;
				};
			};
		};
	};

_resourcesAAF = server getVariable "resourcesAAF";
_chance = (_resourcesAAF / _divisor);

if (random 1 > _chance) then
	{
	_unit unassignItem "NVGoggles_INDEP";
	_unit removeItem "NVGoggles_INDEP";
	if (sunOrMoon < 1) then
		{
		_unit unassignItem "acc_pointer_IR";
	    _unit removePrimaryWeaponItem "acc_pointer_IR";
	    _unit addPrimaryWeaponItem "acc_flashlight";
	    _unit enableGunLights "AUTO";
		_spotD = _spotD - 0.4;
        _spotT = _spotT - 0.4;
		};
	}
else
	{
	if (sunOrMoon < 1) then
		{
		if ("acc_pointer_IR" in primaryWeaponItems _unit) then {_unit enableIRLasers true};
		};
	};

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
	_killer = _this select 1;
	_skill = skill _killer;
	_killer setSkill _skill + 0.01;
	if (isPlayer _killer) then
		{
		[1,_killer] call playerScoreAdd;
		if (captive _killer) then
			{
			[_killer,false] remoteExec ["setCaptive",_killer];
			};
		};
	if (vehicle _killer isKindOf "StaticMortar") then
		{
		if (isMultiplayer) then
			{
			{
			if ((_x distance _muerto < 300) and (captive _x)) then {[_x,false] remoteExec ["setCaptive",_x]};
			} forEach playableUnits;
			}
		else
			{
			if ((player distance _muerto < 300) and (captive player)) then {player setCaptive false};
			};
		};
	if ((count weapons _muerto < 1) and (_muerto isKindOf "Man") and (side _killer == west))  then
		{
		_nul = [-1,0] remoteExecCall ["prestige",2];
		_nul = [2,0,getPos _muerto] remoteExecCall ["citySupportChange",2];
		if (isPlayer _killer) then {_killer addRating 1000};
		}
	else
		{
		_coste = server getVariable (typeOf _muerto);
		if (isNil "_coste") then {diag_log format ["Falta incluir a %1 en las tablas de coste",typeOf _muerto]; _coste = 0};
		[-_coste] remoteExecCall ["resourcesAAF",2];
		_nul = [-1,0,getPos _muerto] remoteExecCall ["citySupportChange",2];
		};
	}];
