if (!isServer and hasInterface) exitWith{};

private ["_pos","_marcador","_vehiculos","_grupos","_soldados","_posicion","_busy","_buildings","_grupo","_cuenta","_tipoVeh","_veh","_unit","_arrayVehAAF","_nVeh","_frontera","_spatrol","_size","_listbld","_ang","_mrk","_tipogrupo","_bandera","_tipoB","_perro"];

_marcador = _this select 0;

_vehiculos = [];
_grupos = [];
_soldados = [];
_spatrol = [];

_posicion = getMarkerPos (_marcador);
_pos = [];

_busy = server getVariable _marcador;

_size = [_marcador] call sizeMarker;
_frontera = [_marcador] call isFrontline;
_buildings = nearestObjects [_posicion, listMilBld, _size*1.5];

_grupo = createGroup independent;
_grupos = _grupos + [_grupo];

for "_i" from 0 to (count _buildings) - 1 do
	{
	_building = _buildings select _i;
	_tipoB = typeOf _building;
	if ((_tipoB == "Land_HelipadSquare_F") and (!_frontera)) then
		{
		_veh = createVehicle ["I_Heli_light_03_unarmed_F", position _building, [],0, "CAN_COLLIDE"];
		_veh setDir (getDir _building);
		_vehiculos = _vehiculos + [_veh];
		sleep 1;
		}
	else
		{

		};
	if 	((_tipoB == "Land_Cargo_HQ_V1_F") or (_tipoB == "Land_Cargo_HQ_V2_F") or (_tipoB == "Land_Cargo_HQ_V3_F")) then
		{
		_veh = createVehicle ["I_static_AA_F", (_building buildingPos 8), [],0, "CAN_COLLIDE"];
		_veh setPosATL [(getPos _building select 0),(getPos _building select 1),(getPosATL _veh select 2)];
		_veh setDir (getDir _building);
		_unit = _grupo createUnit ["I_support_MG_F", _posicion, [], 0, "NONE"];
		[_unit] spawn AAFinitBASES;
		_unit moveInGunner _veh;
		_soldados = _soldados + [_unit];
		sleep 1;
		_vehiculos = _vehiculos + [_veh];
		}
	else
		{
		if 	((_tipoB == "Land_Cargo_Patrol_V1_F") or (_tipoB == "Land_Cargo_Patrol_V2_F") or (_tipoB == "Land_Cargo_Patrol_V3_F")) then
			{
			_veh = createVehicle ["I_HMG_01_high_F", (_building buildingPos 1), [], 0, "CAN_COLLIDE"];
			_ang = (getDir _building) - 180;
			_pos = [getPosATL _veh, 2.5, _ang] call BIS_Fnc_relPos;
			_veh setPosATL _pos;
			_veh setDir (getDir _building) - 180;
			_unit = _grupo createUnit ["I_support_MG_F", _posicion, [], 0, "NONE"];
			[_unit] spawn AAFinitBASES;
			_unit moveInGunner _veh;
			_soldados = _soldados + [_unit];
			sleep 1;
			_vehiculos = _vehiculos + [_veh];
			}
		else
			{
			if 	(_tipoB in listbld) then
				{
				_veh = createVehicle ["I_HMG_01_high_F", (_building buildingPos 11), [], 0, "CAN_COLLIDE"];
				_unit = _grupo createUnit ["I_support_MG_F", _posicion, [], 0, "NONE"];
				_unit moveInGunner _veh;
				_soldados = _soldados + [_unit];
				sleep 1;
				_vehiculos = _vehiculos + [_veh];
				_veh = createVehicle ["I_HMG_01_high_F", (_building buildingPos 13), [], 0, "CAN_COLLIDE"];
				_unit = _grupo createUnit ["I_support_MG_F", _posicion, [], 0, "NONE"];
				[_unit] spawn AAFinitBASES;
				_unit moveInGunner _veh;
				_soldados = _soldados + [_unit];
				sleep 1;
				_vehiculos = _vehiculos + [_veh];
				};
			};
		};
	};

_bandera = createVehicle ["Flag_AAF_F", _posicion, [],0, "CAN_COLLIDE"];
_bandera allowDamage false;
[[_bandera,"take"],"flagaction"] call BIS_fnc_MP;
_vehiculos = _vehiculos + [_bandera];
_veh = "I_supplyCrate_F" createVehicle _posicion;
_vehiculos = _vehiculos + [_veh];

_nVeh = round (_size / 30);
if (_nVeh > 4) then {_nVeh = 4};
if ( _nVeh > 0 ) then
	{
	_pos = [_posicion, random (_size / 2),random 360] call BIS_fnc_relPos;
	_cuenta = 0;
	while {(spawner getVariable _marcador) and (_cuenta < _nveh)} do
		{
		_pos = [_posicion] call mortarPos;
		_veh = "I_G_Mortar_01_F" createVehicle _pos;
		_nul=[_veh] execVM "scripts\UPSMON\MON_artillery_add.sqf";
		_unit = _grupo createUnit ["I_support_MG_F", _posicion, [], 0, "NONE"];
		[_unit] spawn AAFinitBASES;
		_unit moveInGunner _veh;
		_soldados = _soldados + [_unit];
		_vehiculos = _vehiculos + [_veh];
		sleep 1;
		_cuenta = _cuenta + 1;
		};
	};

{[_x] spawn AAFVEHinit} forEach _vehiculos;

if ((spawner getVariable _marcador) and _frontera) then
	{
	_roads = _posicion nearRoads _size;
	if (count _roads != 0) then
		{
		_dist = 0;
		_road = objNull;
		{if ((position _x) distance _posicion > _dist) then {_road = _x;_dist = position _x distance _posicion}} forEach _roads;
		_roadscon = roadsConnectedto _road;
		_roadcon = objNull;
		{if ((position _x) distance _posicion > _dist) then {_roadcon = _x}} forEach _roadscon;
		_dirveh = [_roadcon, _road] call BIS_fnc_DirTo;
		_pos = [getPos _road, 7, _dirveh + 270] call BIS_Fnc_relPos;
		_bunker = "Land_BagBunker_Small_F" createVehicle _pos;
		_vehiculos = _vehiculos + [_bunker];
		_bunker setDir _dirveh;
		_pos = getPosATL _bunker;
		_veh = "I_static_AT_F" createVehicle _posicion;
		_vehiculos = _vehiculos + [_veh];
		_veh setPos _pos;
		_veh setDir _dirVeh + 180;
		_unit = _grupo createUnit ["I_support_MG_F", _posicion, [], 0, "NONE"];
		[_unit] spawn AAFinitBASES;
		[_veh] spawn AAFVEHinit;
		_unit moveInGunner _veh;
		_soldados = _soldados + [_unit];
		};
	};

if (!_busy) then
	{
	_arrayVehAAF = vehAAFAT + vehAAFnormal;
	_tipoVeh = "";
	_nVeh = round (_size/30);
	if (_nVeh < 1) then {_nVeh = 1};
	_pos = _posicion;
	_cuenta = 0;
	while {(spawner getVariable _marcador) and (_cuenta < _nveh)} do
		{
		if (diag_fps > minimoFPS) then
			{
			_tipoVeh = _arrayVehAAF call BIS_fnc_selectRandom;
			if (_size > 40) then {_pos = [_posicion, 10, _size/2, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos} else {_pos = _pos findEmptyPosition [10,60,_tipoVeh]};
			_veh = createVehicle [_tipoVeh, _pos, [], 0, "NONE"];
			_veh setDir random 360;
			_vehiculos = _vehiculos + [_veh];
			_nul = [_veh] spawn VEHinit;
			};
		sleep 1;
		_cuenta = _cuenta + 1;
		};
	};

_mrk = createMarkerLocal [format ["%1patrolarea", floor random 100], _posicion];
_mrk setMarkerShapeLocal "RECTANGLE";
_mrk setMarkerSizeLocal [(distanciaSPWN/2),(distanciaSPWN/2)];
_mrk setMarkerTypeLocal "hd_warning";
_mrk setMarkerColorLocal "ColorRed";
_mrk setMarkerBrushLocal "DiagGrid";
_ang = markerDir _marcador;
_mrk setMarkerDirLocal _ang;
if (!debug) then {_mrk setMarkerAlphaLocal 0};
_cuenta = 0;
while {(spawner getVariable _marcador) and (_cuenta < 4)} do
	{
	_tipogrupo = gruposAAFsmall call BIS_fnc_selectRandom;
	while {true} do
		{
		_pos = [_posicion, 150 + (random 350) ,random 360] call BIS_fnc_relPos;
		if (!surfaceIsWater _pos) exitWith {};
		};
	_grupo = [_pos,independent, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> _tipogrupo)] call BIS_Fnc_spawnGroup;
	sleep 1;
	if ((random 10 < 2.5) and (_tipogrupo != "HAF_SniperTeam")) then
		{
		_perro = _grupo createUnit ["Fin_random_F",_pos,[],0,"FORM"];
		[_perro] spawn guardDog;
		};
	_nul = [leader _grupo, _mrk, "SAFE","SPAWNED", "NOVEH2"] execVM "scripts\UPSMON.sqf";
	_grupos = _grupos + [_grupo];
	{[_x] spawn AAFinitBASES; _spatrol = _spatrol + [_x]} forEach units _grupo;
	_cuenta = _cuenta +1;
	};

_grupo = [_posicion, independent, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad")] call BIS_Fnc_spawnGroup;
sleep 1;
_nul = [leader _grupo, _marcador, "SAFE", "RANDOMUP","SPAWNED", "NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
_grupos = _grupos + [_grupo];
{[_x] spawn AAFinitBASES; _soldados = _soldados + [_x]} forEach units _grupo;
_cuenta = 0;
if (_frontera) then {_nveh = _nveh * 2};
while {(spawner getVariable _marcador) and (_cuenta < _nveh)} do
	{
	if (diag_fps > minimoFPS) then
		{
		while {true} do
			{
			_pos = [_posicion, random _size,random 360] call BIS_fnc_relPos;
			if (!surfaceIsWater _pos) exitWith {};
			};
		_grupo = [_pos,independent, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad")] call BIS_Fnc_spawnGroup;
		sleep 1;
		_nul = [leader _grupo, _marcador, "SAFE","SPAWNED", "NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
		_grupos = _grupos + [_grupo];
		{[_x] spawn AAFinitBASES; _soldados = _soldados + [_x]} forEach units _grupo;
		};
	sleep 1;
	_cuenta = _cuenta + 1;
	};

_periodista = objNull;
if ((random 100 < (((server getVariable "prestigeNATO") + (server getVariable "prestigeCSAT"))/10)) and (spawner getVariable _marcador)) then
	{
	_pos = [];
	_grupo = createGroup civilian;
	while {true} do
		{
		_pos = [_posicion, round (random _size), random 360] call BIS_Fnc_relPos;
		if (!surfaceIsWater _pos) exitWith {};
		};
	_periodista = _grupo createUnit ["C_journalist_F", _pos, [],0, "NONE"];
	_nul = [_periodista] spawn CIVinit;
	_grupos pushBack _grupo;
	_nul = [_periodista, _marcador, "SAFE", "SPAWNED","NOFOLLOW", "NOVEH2","NOSHARE","DoRelax"] execVM "scripts\UPSMON.sqf";
	};

if (debug) then {stavros sidechat format ["He creado %1 grupos en %2", count _grupos,_marcador]};

waitUntil {sleep 1; (not (spawner getVariable _marcador)) or (({(not(vehicle _x isKindOf "Air"))} count ([_size,0,_posicion,"BLUFORSpawn"] call distanceUnits)) > 3*({(alive _x) and (!(captive _x)) and (_x distance _posicion < _size)} count _soldados))};

if ((spawner getVariable _marcador) and (not(_marcador in mrkFIA))) then
	{
	[_bandera] remoteExec ["mrkWIN",2];
	};

waitUntil {sleep 1; not (spawner getVariable _marcador)};

{if ((!alive _x) and (not(_x in destroyedBuildings))) then {destroyedBuildings = destroyedBuildings + [position _x]; publicVariableServer "destroyedBuildings"}} forEach _buildings;

{if (alive _x) then {deleteVehicle _x}} forEach _soldados;
{if (alive _x) then {deleteVehicle _x}} forEach _spatrol;
if (!isNull _periodista) then {deleteVehicle _periodista};
{deleteGroup _x} forEach _grupos;
{
if (not(_x in staticsToSave)) then
	{
	if (!([(distanciaSPWN-_size),1,_x,"BLUFORSpawn"] call distanceUnits)) then {deleteVehicle _x};
	};
} forEach _vehiculos;
deleteMarker _mrk;





