if (!isServer and hasInterface) exitWith {};

private ["_marcador","_posicion","_escarretera","_tam","_road","_veh","_grupo","_unit","_roadcon"];

_marcador = _this select 0;
_posicion = getMarkerPos _marcador;

_escarretera = false;
if (isOnRoad _posicion) then {_escarretera = true};

if (_escarretera) then
	{
	_tam = 1;

	while {true} do
		{
		_road = _posicion nearRoads _tam;
		if (count _road > 0) exitWith {};
		_tam = _tam + 5;
		};

	_roadcon = roadsConnectedto (_road select 0);
	_dirveh = [_road select 0, _roadcon select 0] call BIS_fnc_DirTo;
	_veh = "B_G_Offroad_01_armed_F" createVehicle getPos (_road select 0);
	_veh setDir _dirveh + 90;
	_veh lock 3;
	_nul = [_veh] spawn VEHinit;
	sleep 1;
	_grupo = [_posicion, WEST, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfTeam_AT")] call BIS_Fnc_spawnGroup;
	_unit = _grupo createUnit ["B_G_Soldier_F", _posicion, [], 0, "NONE"];
	_unit moveInGunner _veh;
	}
else
	{
	_grupo = [_posicion, WEST, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_SniperTeam_M")] call BIS_Fnc_spawnGroup;
	_grupo setBehaviour "STEALTH";
	_grupo setCombatMode "GREEN";
	};

{[_x] spawn FIAinitBASES;} forEach units _grupo;

waitUntil {sleep 1; (not(spawner getVariable _marcador)) or ({alive _x} count units _grupo == 0) or (not(_marcador in puestosFIA))};

if ({alive _x} count units _grupo == 0) then
//if ({alive _x} count units _grupo == 0) then
	{
	puestosFIA = puestosFIA - [_marcador]; publicVariable "puestosFIA";
	mrkFIA = mrkFIA - [_marcador]; publicVariable "mrkFIA";
	marcadores = marcadores - [_marcador]; publicVariable "marcadores";
	_nul = [5,-5,_posicion] remoteExecCall ["citySupportChange",2];
	deleteMarker _marcador;
	if (_escarretera) then
		{
		[["TaskFailed", ["", "Roadblock Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		}
	else
		{
		[["TaskFailed", ["", "Watchpost Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		};
	};

waitUntil {sleep 1; (not(spawner getVariable _marcador)) or (not(_marcador in puestosFIA))};

if (_escarretera) then {deleteVehicle _veh};
{deleteVehicle _x} forEach units _grupo;
deleteGroup _grupo;