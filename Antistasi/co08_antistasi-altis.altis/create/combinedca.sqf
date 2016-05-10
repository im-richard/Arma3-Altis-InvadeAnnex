if (!isServer and hasInterface) exitWith {};

private ["_posorigen","_tipogrupo","_nombreorig","_markTsk","_wp1","_soldados","_landpos","_pad","_vehiculos","_wp0","_wp3","_wp4","_wp2","_grupo","_grupos","_tipoveh","_vehicle","_heli","_heliCrew","_grupoheli","_pilotos","_rnd","_resourcesAAF","_nVeh","_tam","_roads","_Vwp1","_road","_veh","_vehCrew","_grupoVeh","_Vwp0","_size","_Hwp0","_grupo1","_uav","_grupouav","_uwp0","_tsk","_vehiculo","_soldado","_piloto","_mrkdestino","_posdestino","_prestigeCSAT","_base","_aeropuerto","_nombredest","_tiempo","_solMax","_nul","_coste","_tipo","_threatEvalAir","_threatEvalLand"];
_mrkdestino = _this select 0;

forcedSpawn = forcedSpawn + [_mrkDestino]; publicVariable "forcedSpawn";

_posdestino = getMarkerPos _mrkDestino;

_grupos = [];
_soldados = [];
_pilotos = [];
_vehiculos = [];

_prestigeCSAT = server getVariable "prestigeCSAT";
//[-8100] remoteExecCall ["resourcesAAF",2];

_base = "";
_base = [_mrkdestino] call findBasesForCA;
_aeropuerto = "";
_aeropuerto = [_mrkdestino] call findAirportsForCA;
if (debug) then {player sidechat format ["Van a atacar %1 desde la base %2 y el aeropuerto %3",_mrkdestino,_base,_aeropuerto]; sleep 3;};

//if (_mrkdestino == "puesto_13") then {_base = ""};

if ((_base=="") and (_aeropuerto=="")) exitWith {};

_CSAT = false;
if ((random 100 < _prestigeCSAT) and (_prestigeCSAT > 19)) then
	{
	if (debug) then {hint format ["CSAT ataca a %1",_mrkDestino]};
	_CSAT = true;
	};

if ((_aeropuerto != "") or _CSAT) then {_threatEvalAir = [_mrkDestino] call AAthreatEval};

if (_base != "") then {_threatEvalLand = [_mrkDestino] call landThreatEval};

_nombredest = [_mrkDestino] call localizar;
_nombreorig = [_aeropuerto] call localizar;
_markTsk = _aeropuerto;

if (_base !="") then
	{
	_nombreorig = [_base] call localizar;
	_markTsk = _base;
	};

[] call playerIsOwner;
_tsk = ["AtaqueAAF",true,[format ["AAF Is attacking from the %1. Intercept them or we may loose a sector",_nombreorig],"AAF Attack",_markTsk],getMarkerPos _markTsk,"CREATED",10,true,true,"Defend"] call BIS_fnc_setTask;
_tiempo = time;

if (_CSAT) then
	{
	_resourcesAAF = server getVariable "resourcesAAF";
	if (_resourcesAAF > 20000) then
		{
		server setVariable ["resourcesAAF",_resourcesAAF - 20000,true];
		_nul = [5,0] remoteExecCall ["prestige",2];
		}
	else
		{
		_nul = [5,-20] remoteExecCall ["prestige",2]
		};
	_posorigen = getMarkerPos "spawnCSAT";
	_posorigen set [2,300];
	for "_i" from 1 to 3 do
		{
		_tipoveh = planesCSAT call BIS_fnc_selectRandom;
		_vehicle=[_posorigen, 0, _tipoveh, EAST] call bis_fnc_spawnvehicle;
		_heli = _vehicle select 0;
		_heliCrew = _vehicle select 1;
		_grupoheli = _vehicle select 2;
		_pilotos = _pilotos + _heliCrew;
		_grupos = _grupos + [_grupoheli];
		_vehiculos = _vehiculos + [_heli];
		[_heli] spawn CSATVEHinit;
		if (_tipoveh != "O_Heli_Light_02_unarmed_F") then
			{
			{[_x] spawn CSATinit} forEach _heliCrew;
			_wp1 = _grupoheli addWaypoint [_posdestino, 0];
			_wp1 setWaypointType "SAD";
			[_heli,"CSAT Air Attack"] spawn inmuneConvoy;
			}
		else
			{
			{_x setBehaviour "CARELESS";} forEach units _grupoheli;
			_grupo = [_posorigen, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_Fnc_spawnGroup;
			{_x assignAsCargo _heli; _x moveInCargo _heli; _soldados = _soldados + [_x]; [_x] spawn CSATinit} forEach units _grupo;
			//[_mrkDestino,_grupo] spawn attackDrill;
			_grupos = _grupos + [_grupo];
			[_heli,"CSAT Air Transport"] spawn inmuneConvoy;
			if ((_mrkdestino in bases) or (_mrkdestino in aeropuertos) or (random 10 < _threatEvalAir)) then
				{
				[_heli,_grupo,_mrkdestino,_threatEvalAir] spawn airdrop;
				}
			else
				{
				if (random 100 < 50) then
					{
					{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _grupoheli;
					_landpos = [];
					_landpos = [_posdestino, 300, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
					_landPos set [2, 0];
					_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
					_vehiculos = _vehiculos + [_pad];
					_wp0 = _grupoheli addWaypoint [_landpos, 0];
					_wp0 setWaypointType "TR UNLOAD";
					_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';[vehicle this] call smokeCoverAuto"];
					[_grupoheli,0] setWaypointBehaviour "CARELESS";
					_wp3 = _grupo addWaypoint [_landpos, 0];
					_wp3 setWaypointType "GETOUT";
					_wp0 synchronizeWaypoint [_wp3];
					_wp4 = _grupo addWaypoint [_posdestino, 1];
					_wp4 setWaypointType "SAD";
					_wp2 = _grupoheli addWaypoint [_posorigen, 1];
					_wp2 setWaypointType "MOVE";
					_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
					[_grupoheli,1] setWaypointBehaviour "AWARE";
					}
				else
					{[_heli,_grupo,_posdestino,_posorigen,_grupoheli] spawn fastropeCSAT;}
				};
			};
		sleep 15;
		};
	[] call playerIsOwner;
	_tsk = ["AtaqueAAF",true,[format ["AAF and CSAT are attacking %2 from the %1. Intercept them or we may loose a sector",_nombreorig,_nombredest],"AAF Attack",_mrkDestino],getMarkerPos _mrkDestino,"CREATED",10,true,true,"Defend"] call BIS_fnc_setTask;
	[["TaskSucceeded", ["", format ["%1 under fire",_nombredest]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
	//bombardeo aereo!!!
	[_mrkDestino] spawn
		{
		private ["_mrkDestino"];
		_mrkDestino = _this select 0;
		for "_i" from 0 to round (random 2) do
			{
			_nul = [_mrkdestino,"O_Plane_CAS_02_F"] spawn airstrike;
			sleep 30;
			};
		if ((_mrkDestino in bases) or (_mrkDestino in aeropuertos)) then
			{
			//Ataque de artillería
			_nul = [_mrkdestino] spawn artilleria;
			};
		};
	};


if (_base != "") then
	{
	_posorigen = getMarkerPos _base;
	server setVariable [_base,true,true];
	_size = [_base] call sizeMarker;
	_nVeh = round (_size/30);
	if (_nVeh < 1) then {_nVeh = 1};
	_roads = [];
	_tam = _size;
	while {true} do
		{
		_roads = _posorigen nearRoads _tam;
		if (count _roads < _nveh) then {_tam = _tam + 50};
		if (count _roads >= _nveh) exitWith {};
		};
	for "_i" from 1 to _nveh do
		{
		_tipoVeh = "";
		if (count vehAAFAT > 1) then
			{
			_vehAAFAT = vehAAFAT;
			if (_i == _nveh) then
				{
				_vehAAFAT = _vehAAFAT - ["I_MBT_03_cannon_F"];
				}
			else
				{
				if (_threatEvalLand > 3) then {_vehAAFAT = _vehAAFAT - ["I_Truck_02_covered_F"]};
				if ((_threatEvalLand > 5) and (("I_APC_tracked_03_cannon_F" in _vehAAFAT) or ("I_MBT_03_cannon_F" in _vehAAFAT))) then {_vehAAFAT = _vehAAFAT - ["I_APC_Wheeled_03_cannon_F"]};
				};
			_tipoveh = _vehAAFAT call BIS_fnc_selectRandom;
			}
		else
			{
			_tipoVeh = "I_Truck_02_covered_F";
			};
		_road = _roads select (_i -1);
		_vehicle=[position _road, random 360,_tipoveh, independent] call bis_fnc_spawnvehicle;
		_veh = _vehicle select 0;
		_vehCrew = _vehicle select 1;
		{[_x] spawn AAFinit} forEach _vehCrew;
		[_veh] spawn AAFVEHinit;
		_grupoVeh = _vehicle select 2;
		_soldados = _soldados + _vehCrew;
		_grupos = _grupos + [_grupoVeh];
		_vehiculos = _vehiculos + [_veh];
		_landPos = [];
		_landPos = [_posdestino,position _road,_threatEvalLand] call findSafeRoadToUnload;
		if (_tipoVeh != "I_MBT_03_cannon_F") then
			{
			if (_tipoveh == "I_APC_tracked_03_cannon_F") then {_tipogrupo = gruposAAFmid call BIS_fnc_selectRandom} else {_tipogrupo = "HAF_InfSquad"};
			_grupo = [_posorigen,independent, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> _tipogrupo)] call BIS_Fnc_spawnGroup;
			//{[_x] spawn AAFinit;[_x] join _grupoVeh;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados pushBack _x;} forEach units _grupo;
			//[_mrkDestino,_grupoVeh] spawn attackDrill;
			//deleteGroup _grupo;
			{[_x] spawn AAFinit;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados pushBack _x;} forEach units _grupo;
			if (_tipoVeh != "I_Truck_02_covered_F") then
				{
				_grupos = _grupos + [_grupo];
				_Vwp0 = _grupoVeh addWaypoint [_landPos, 0];
				_Vwp0 setWaypointBehaviour "SAFE";
				_Vwp0 setWaypointType "TR UNLOAD";
				_Vwp0 setWayPointCompletionRadius (10*_i);
				_Vwp0 setWaypointStatements ["true", "[vehicle this] call smokeCoverAuto"];
				_Vwp1 = _grupoVeh addWaypoint [_posdestino, 1];
				_Vwp1 setWaypointType "SAD";
				_Vwp1 setWaypointBehaviour "COMBAT";
				_Vwp2 = _grupo addWaypoint [_landPos, 0];
				_Vwp2 setWaypointType "GETOUT";
				_Vwp0 synchronizeWaypoint [_Vwp2];
				_Vwp3 = _grupo addWaypoint [_posdestino, 1];
				_Vwp3 setWaypointType "SAD";
				//[_veh] spawn smokeCover;
				_veh allowCrewInImmobile true;
				[_veh,"APC"] spawn inmuneConvoy;
				}
			else
				{
				{[_x] join _grupoVeh} forEach units _grupo;
				deleteGroup _grupo;
				for "_i" from 1 to 8 do
					{
					_soldado = _grupoVeh createUnit [soldadosAAF - ["I_UAV_AI"] call BIS_fnc_selectRandom, _posorigen, [],0, "NONE"];
					[_soldado] spawn AAFinit;
					_soldado assignAsCargo _veh;
					_soldado moveInCargo _veh;
					_soldados pushBack _soldado;
					};
				_grupoVeh selectLeader (units _grupoVeh select 1);
				_Vwp0 = _grupoVeh addWaypoint [_landPos, 0];
				_Vwp0 setWaypointBehaviour "SAFE";
				_Vwp0 setWaypointType "GETOUT";
				_Vwp1 = _grupoVeh addWaypoint [_posdestino, 1];
				_Vwp1 setWaypointType "SAD";
				_Vwp1 setWaypointBehaviour "COMBAT";
				[_veh,"Inf Truck."] spawn inmuneConvoy;
				};
			}
		else
			{
			_Vwp0 = _grupoVeh addWaypoint [_landPos, 0];
			_Vwp0 setWaypointBehaviour "SAFE";
			[_veh,"Tank"] spawn inmuneConvoy;
			_veh allowCrewInImmobile true;
			_Vwp0 setWaypointType "SAD";
			};
		sleep 5;
		};
	};

if (_aeropuerto != "") then
	{
	if (_base != "") then {sleep ((_posorigen distance _posdestino)/16)};
	_posorigen = getMarkerPos _aeropuerto;
	_posorigen set [2,300];
	server setVariable [_aeropuerto,true,true];
	_uav = createVehicle ["I_UAV_02_F", _posorigen, [], 0, "FLY"];
	_vehiculos = _vehiculos + [_uav];
	[_uav] spawn AAFVEHinit;
	[_uav,"UAV"] spawn inmuneConvoy;
	[_uav,_mrkDestino] spawn VANTinfo;
	createVehicleCrew _uav;
	_soldados = _soldados + crew _uav;
	_grupouav = group (crew _uav select 0);
	_grupos = _grupos + [_grupouav];
	{[_x] spawn AAFinit} forEach units _grupoUav;
	_uwp0 = _grupouav addWayPoint [_posdestino,0];
	_uwp0 setWaypointBehaviour "AWARE";
	_uwp0 setWaypointType "MOVE";
	_uav removeMagazines "6Rnd_LG_scalpel";
	sleep 5;

	_tipoveh = "";
	for "_i" from 1 to 3 do
		{
		if (_i == 3) then
			{
			_tipoveh = ["I_Heli_Transport_02_F","I_Heli_light_03_unarmed_F"] call BIS_fnc_selectRandom;
			}
		else
			{
			_planesAAF = planesAAF;
			if ((_threatEvalAir > 10) and ("I_Heli_light_03_F" in planesAAF)) then {_planesAAF = _planesAAF - ["I_Heli_Transport_02_F","I_Heli_light_03_unarmed_F"]};
			if ((_threatEvalAir > 15) and ("I_Plane_Fighter_03_CAS_F" in planesAAF)) then {_planesAAF = ["I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"]};
			_tipoveh = _planesAAF call BIS_fnc_selectRandom;
			};
		_vehicle=[_posorigen, random 360,_tipoveh, independent] call bis_fnc_spawnvehicle;
		_veh = _vehicle select 0;
		_vehCrew = _vehicle select 1;
		_grupoVeh = _vehicle select 2;
		_pilotos = _pilotos + _vehCrew;
		_grupos = _grupos + [_grupoVeh];
		_vehiculos = _vehiculos + [_veh];
		{[_x] spawn AAFinit} forEach units _grupoVeh;
		[_veh] spawn AAFVEHinit;
		if ((_tipoveh != "I_Heli_Transport_02_F") and (_tipoveh != "I_Heli_light_03_unarmed_F")) then
			{
			_Hwp0 = _grupoVeh addWaypoint [_posdestino, 0];
			_Hwp0 setWaypointBehaviour "AWARE";
			_Hwp0 setWaypointType "SAD";
			[_veh,"Air Attack"] spawn inmuneConvoy;
			};

		if (_tipoveh == "I_Heli_light_03_unarmed_F") then
			{
			_grupo = [_posorigen,independent, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam")] call BIS_Fnc_spawnGroup;
			{[_x] spawn AAFinit;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados = _soldados + [_x]} forEach units _grupo;
			//[_mrkDestino,_grupo] spawn attackDrill;
			_grupos = _grupos + [_grupo];
			_landpos = [];
			_landpos = [_posdestino, 300, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
			_landPos set [2, 0];
			_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
			_vehiculos = _vehiculos + [_pad];
			_wp0 = _grupoVeh addWaypoint [_landpos, 0];
			_wp0 setWaypointType "TR UNLOAD";
			_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT'; [vehicle this] call smokeCoverAuto"];
			_wp0 setWaypointBehaviour "CARELESS";
			_wp3 = _grupo addWaypoint [_landpos, 0];
			_wp3 setWaypointType "GETOUT";
			_wp0 synchronizeWaypoint [_wp3];
			_wp4 = _grupo addWaypoint [_posdestino, 1];
			_wp4 setWaypointType "SAD";
			_wp2 = _grupoVeh addWaypoint [_posorigen, 1];
			_wp2 setWaypointType "MOVE";
			_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
			_wp2 setWaypointBehaviour "AWARE";
			[_veh,"Air Transport"] spawn inmuneConvoy;
			};

		if (_tipoveh == "I_Heli_Transport_02_F") then
			{
			_grupo = [_posorigen,independent, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad")] call BIS_Fnc_spawnGroup;
			{[_x] spawn AAFinit;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados = _soldados + [_x]} forEach units _grupo;
			sleep 1;
			//[_mrkDestino,_grupo] spawn attackDrill;
			_grupos = _grupos + [_grupo];
			_grupo1 = [_posorigen,independent, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad")] call BIS_Fnc_spawnGroup;
			{[_x] spawn AAFinit;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados = _soldados + [_x]} forEach units _grupo1;
			//[_mrkDestino,_grupo1] spawn attackDrill;
			_grupos = _grupos + [_grupo1];
			[_veh,_grupo,_grupo1,_posdestino,_posorigen,_grupoVeh] spawn fastropeAAF;
			[_veh,"Air Transport"] spawn inmuneConvoy;
			};
		sleep 15;
		};
	};


_solMax = count _soldados;
_size = [_mrkdestino] call sizeMarker;

_tiempo = _tiempo + 3600;

waitUntil {sleep 5; (({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < round (_solMax / 3)) or ({not(vehicle _x isKindOf "Air")} count ([_size,0,_posdestino,"OPFORSpawn"] call distanceUnits) > 3*(({(alive _x) and (side _x == WEST) and (_x distance _posdestino < _size)} count allUnits))) or (time > _tiempo) or (_mrkDestino in mrkAAF)};

if ((({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < round (_solMax / 3)) or (time > _tiempo)) then
	{
	{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posdestino,"BLUFORSpawn"] call distanceUnits);
	[5,stavros] call playerScoreAdd;
	[] call playerIsOwner;
	if (!_CSAT) then
		{
		_tsk = ["AtaqueAAF",true,[format ["AAF Is attacking from the %1. Intercept them or we may loose a sector",_nombreorig],"AAF Attack",_markTsk],getMarkerPos _markTsk,"SUCCEEDED",10,true,true,"Defend"] call BIS_fnc_setTask;
		}
	else
		{
		_tsk = ["AtaqueAAF",true,[format ["AAF and CSAT are attacking %2 from the %1. Intercept them or we may loose a sector",_nombreorig,_nombredest],"AAF Attack",_mrkDestino],getMarkerPos _mrkDestino,"SUCCEEDED",10,true,true,"Defend"] call BIS_fnc_setTask;
		};
	{_x doMove _posorigen} forEach _soldados;
	if (_base != "") then {[_mrkDestino,_base] spawn minefieldAAF};
	}
else
	{
	[-10,stavros] call playerScoreAdd;
	[] call playerIsOwner;
	if (!_CSAT) then
		{
		_tsk = ["AtaqueAAF",true,[format ["AAF Is attacking from the %1. Intercept them or we may loose a sector",_nombreorig],"AAF Attack",_markTsk],getMarkerPos _markTsk,"FAILED",10,true,true,"Defend"] call BIS_fnc_setTask;
		}
	else
		{
		_tsk = ["AtaqueAAF",true,[format ["AAF and CSAT are attacking %2 from the %1. Intercept them or we may loose a sector",_nombreorig,_nombredest],"AAF Attack",_mrkDestino],getMarkerPos _mrkDestino,"FAILED",10,true,true,"Defend"] call BIS_fnc_setTask;
		};
	if (not(_mrkDestino in mrkAAF)) then
		{
		[_mrkDestino] remoteExec ["mrkLOOSE",2];
		};
	};

forcedSpawn = forcedSpawn - [_mrkDestino]; publicVariable "forcedSpawn";

_nul = [0,_tsk] spawn borrarTask;
[7200] remoteExec ["timingCA",2];

{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)};
deleteVehicle _x;
} forEach _soldados;
{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)};
deleteVehicle _x;
} forEach _pilotos;
{
if (!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)) then {deleteVehicle _x};
} forEach _vehiculos;
{deleteGroup _x} forEach _grupos;

sleep 3600;
if (_base !="") then
	{
	server setVariable [_base,false,true];
	};
if (_aeropuerto !="") then
	{
	server setVariable [_aeropuerto,false,true];
	};

