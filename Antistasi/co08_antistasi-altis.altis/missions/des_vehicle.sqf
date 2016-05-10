if (!isServer and hasInterface) exitWith{};

private ["_marcador","_posicion","_fechalim","_fechalimnum","_nombredest","_tipoVeh","_texto","_camionCreado","_size","_pos","_veh","_grupo","_unit"];

_marcador = _this select 0;
_posicion = getMarkerPos _marcador;

_tiempolim = 120;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_nombredest = [_marcador] call localizar;

_tipoVeh = "";
_texto = "";

if ("I_MBT_03_cannon_F" in vehAAFAT) then {_tipoVeh = "I_MBT_03_cannon_F"; _texto = "AAF Tank"} else {_tipoVeh = "O_MBT_02_arty_F"; _texto = "CSAT Artillery"};
[] call playerIsOwner;
_tsk = ["DES",true,[format ["We know an enemy armor (%4) is stationed in %1. It is a good chance to destroy or steal it before it causes more damage. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_texto],"Steal or Destroy Armor",_marcador],_posicion,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
_camionCreado = false;

waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (spawner getVariable _marcador)};

if (spawner getVariable _marcador) then
	{
	_camionCreado = true;
	_size = [_marcador] call sizeMarker;
	_pos = [];
	if (_size > 40) then {_pos = [_posicion, 10, _size, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos} else {_pos = _posicion findEmptyPosition [10,60,_tipoVeh]};
	_veh = createVehicle [_tipoVeh, _pos, [], 0, "NONE"];
	_veh allowdamage false;
	_veh setDir random 360;
	if (_tipoVeh == "I_MBT_03_cannon_F") then {_nul = [_veh] spawn AAFVEHinit} else {_nul = [_veh] spawn CSATVEHinit};

	_grupo = createGroup independent;

	sleep 5;
	_veh allowDamage true;

	for "_i" from 1 to 3 do
		{
		_unit = _grupo createUnit ["I_crew_F", _pos, [], 0, "NONE"];
		[_unit] spawn AAFinit;
		sleep 2;
		};
	waitUntil {sleep 1;({leader _grupo knowsAbout _x > 1.4} count ([distanciaSPWN,0,leader _grupo,"BLUFORSpawn"] call distanceUnits) > 0) or (dateToNumber date > _fechalimnum) or (not alive _veh) or ({_x getVariable ["BLUFORSpawn",false]} count crew _veh > 0)};

	if ({leader _grupo knowsAbout _x > 1.4} count ([distanciaSPWN,0,leader _grupo,"BLUFORSpawn"] call distanceUnits) > 0) then {_grupo addVehicle _veh;};

	waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (not alive _veh) or ({_x getVariable ["BLUFORSpawn",false]} count crew _veh > 0)};

	if ((not alive _veh) or ({_x getVariable ["BLUFORSpawn",false]} count crew _veh > 0)) then
		{
		[] call playerIsOwner;
		_tsk = ["DES",true,[format ["We know an enemy armor (%4) is stationed in a %1. It is a good chance to steal or destroy it before it causes more damage. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_texto],"Steal or Destroy Armor",_marcador],_posicion,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
		[0,300] remoteExecCall ["resourcesFIA",2];
		[-10,0,_posicion] remoteExecCall ["citySupportChange",2];
		[2,0] remoteExecCall ["prestige",2];
		if (_tipoVeh == "O_MBT_02_arty_F") then {[3,3] remoteExecCall ["prestige",2]; [-10,10,_posicion] remoteExecCall ["citySupportChange",2];};
		[1200] remoteExec ["timingCA",2];
		{if (_x distance _veh < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
		[5,stavros] call playerScoreAdd;
		};
	};
if (dateToNumber date > _fechalimnum) then
	{
	[] call playerIsOwner;
	_tsk = ["DES",true,[format ["We know an enemy armor (%4) is stationed in a %1. It is a good chance to steal or destroy it before it causes more damage. Do it before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_texto],"Steal or Destroy Armor",_marcador],_posicion,"FAILED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	[-5,-100] remoteExecCall ["resourcesFIA",2];
	[5,0,_posicion] remoteExecCall ["citySupportChange",2];
	if (_tipoVeh == "O_MBT_02_arty_F") then {[0,-3] remoteExecCall ["prestige",2]; [0,5,_posicion] remoteExecCall ["citySupportChange",2];};
	[-600] remoteExec ["timingCA",2];
	[-10,stavros] call playerScoreAdd;
	};

_nul = [1200,_tsk] spawn borrarTask;

waitUntil {sleep 1; not (spawner getVariable _marcador)};

if (_camionCreado) then
	{
	{deleteVehicle _x} forEach units _grupo;
	deleteGroup _grupo;
	if (!([distanciaSPWN,1,_veh,"BLUFORSpawn"] call distanceUnits)) then {deleteVehicle _veh};
	};
