if (!isServer and hasInterface) exitWith {};

private ["_marcador","_esMarcador","_exit","_radio","_base","_aeropuerto","_posDestino","_soldados","_vehiculos","_grupos","_roads","_posorigen","_tam","_tipoVeh","_vehicle","_veh","_vehCrew","_grupoVeh","_landPos","_tipoGrupo","_grupo","_soldado","_threatEval","_nombredest"];

_marcador = _this select 0;
_esMarcador = false;
_exit = false;
if (typeName _marcador == typeName "") then
	{
	_esMarcador = true;
	if (_marcador in smallCAmrk) then {_exit = true};
	_nombredest = [_marcador] call localizar;
	}
else
	{
	_cercano = [smallCApos,_marcador] call BIS_fnc_nearestPosition;
	if (_cercano distance _marcador < (distanciaSPWN/2)) then
		{
		_exit = true;
		}
	else
		{
		if (count smallCAmrk > 0) then
			{
			_cercano = [smallCAmrk,_marcador] call BIS_fnc_nearestPosition;
			if (getMarkerPos _cercano distance _marcador < (distanciaSPWN/2)) then {_exit = true};
			};
		};
	};

if (_exit) exitWith {};

if (server getVariable "resourcesAAF" < 0) exitWith {if (_esMarcador) then {[["TaskSucceeded", ["", format ["%1 consolidated",_nombredest]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;}};

_radio = [_marcador] call radioCheck;

if (!_radio) exitWith {if (_esMarcador) then {[["TaskSucceeded", ["", format ["%1 consolidated",_nombredest]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;}};

_base = [_marcador] call findBasesForCA;
_aeropuerto = [_marcador] call findAirportsForCA;

//if (_esMarcador) then {if (_marcador == "puesto_13") then {_base = ""}};

if ((_base == "") and (_aeropuerto == "")) exitWith
	{
	if (_esMarcador) then {[["TaskSucceeded", ["", format ["%1 consolidated",_nombredest]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;}
	};

_posDestino = _this select 0;
if (_esMarcador) then
	{
	_posDestino = getMarkerPos _marcador;
	};

if ((_base == "") and (_aeropuerto != "")) then
	{
	_threatEval = [_posDestino] call AAthreatEval;
	if ((_threatEval > 15) and (not("I_Plane_Fighter_03_CAS_F" in planesAAF))) then
		{
		_aeropuerto = "";
		}
	else
		{
		if ((_threatEval > 10) and (not("I_Plane_Fighter_03_CAS_F" in planesAAF)) and (not("I_Heli_light_03_F" in planesAAF))) then {_aeropuerto = ""};
		};
	};

if (_base != "") then
	{
	_threatEval = [_posDestino] call landThreatEval;
	if ((_threatEval > 15) and (not("I_MBT_03_cannon_F" in vehAAFAT))) then
		{
		_base = "";
		}
	else
		{
		if ((_threatEval > 5) and (not("I_APC_tracked_03_cannon_F" in vehAAFAT)) and (not("I_MBT_03_cannon_F" in vehAAFAT))) then {_base = ""};
		};
	};

if ((_base == "") and (_aeropuerto == "")) exitWith
	{
	if (_esMarcador) then {[["TaskSucceeded", ["", format ["%1 consolidated",_nombredest]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;}
	};


if (_esMarcador) then
	{
	smallCAmrk pushBackUnique _marcador; publicVariable "smallCAmrk";
	}
else
	{
	smallCApos pushBack _marcador;
	};

if (debug) then {player sideChat format ["Nos contraatacan desde %1 o desde el aeropuerto %2 hacia %3", _base, _aeropuerto,_marcador]};

_soldados = [];
_vehiculos = [];
_grupos = [];
_roads = [];

if (_base != "") then
	{
	_posorigen = getMarkerPos _base;
	_tam = 10;
	while {true} do
		{
		_roads = _posorigen nearRoads _tam;
		if (count _roads < 1) then {_tam = _tam + 10};
		if (count _roads > 0) exitWith {};
		};
	_tipoVeh = "";
	if (count vehAAFAT > 1) then
		{
		_vehAAFAT = vehAAFAT;
		if (_threatEval > 3) then {_vehAAFAT = _vehAAFAT - ["I_Truck_02_covered_F"]};
		if ((_threatEval > 5) and (("I_APC_tracked_03_cannon_F" in _vehAAFAT) or ("I_MBT_03_cannon_F" in _vehAAFAT))) then {_vehAAFAT = _vehAAFAT - ["I_APC_Wheeled_03_cannon_F"]};
		_tipoveh = _vehAAFAT call BIS_fnc_selectRandom;
		}
	else
		{
		_tipoVeh = "I_Truck_02_covered_F";
		};
	_road = _roads select 0;
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
	_landPos = [_posdestino,position _road,_threatEval] call findSafeRoadToUnload;
	_tipoGrupo = "";
	if (_tipoVeh != "I_MBT_03_cannon_F") then
		{
		if (_tipoveh == "I_APC_tracked_03_cannon_F") then {_tipogrupo = gruposAAFmid call BIS_fnc_selectRandom} else {_tipogrupo = "HAF_InfSquad"};
		_grupo = [_posorigen,independent, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> _tipogrupo)] call BIS_Fnc_spawnGroup;
		//{[_x] spawn AAFinit;[_x] join _grupoVeh;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados = _soldados + [_x];} forEach units _grupo;
		//deleteGroup _grupo;
		//[_marcador,_grupoVeh] spawn attackDrill;
		{[_x] spawn AAFinit;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados = _soldados + [_x]} forEach units _grupo;
		if (_tipoVeh != "I_Truck_02_covered_F") then
			{
			_grupos = _grupos + [_grupo];
			_Vwp0 = _grupoVeh addWaypoint [_landPos, 0];
			_Vwp0 setWaypointBehaviour "SAFE";
			_Vwp0 setWaypointType "TR UNLOAD";
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
			[_veh,"APC"] spawn inmuneConvoy;
			_veh allowCrewInImmobile true;
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
		_Vwp0 setWaypointType "SAD";
		_veh allowCrewInImmobile true;
		};
	}
else
	{
	_posorigen = getMarkerPos _aeropuerto;
	_planesAAF = planesAAF;
	if (_threatEval > 10) then {_planesAAF = _planesAAF - ["I_Heli_Transport_02_F","I_Heli_light_03_unarmed_F"]};
	if (_threatEval > 15) then {_planesAAF = ["I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"]};
	_tipoveh = _planesAAF call BIS_fnc_selectRandom;
	_vehicle=[_posorigen, random 360,_tipoVeh, independent] call bis_fnc_spawnvehicle;
	_veh = _vehicle select 0;
	_vehCrew = _vehicle select 1;
	_grupoVeh = _vehicle select 2;
	_soldados = _soldados + _vehCrew;
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
		_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';[vehicle this] call smokeCoverAuto"];
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
	};

if (_esMarcador) then
	{
	if (_base != "") then
		{
		_solMax = count _soldados;
		_size = [_marcador] call sizeMarker;
		_tiempo = time + 3600;

		waitUntil {sleep 5; (({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < round (_solMax / 3)) or (_marcador in mrkAAF) or (count ([_size,0,_posdestino,"OPFORSpawn"] call distanceUnits) > 3*(({(alive _x) and (side _x == WEST) and (_x distance _posdestino < _size)} count allUnits))) or (time > _tiempo)};

		if ((({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < round (_solMax / 3)) or (time > _tiempo)) then
			{
			[["TaskSucceeded", ["", format ["%1 consolidated",_nombredest]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
			}
		else
			{
			if (not(_marcador in mrkAAF)) then
				{
				//[_marcador] spawn mrkLOOSE;
				[_marcador] remoteExec ["mrkLOOSE",2];
				};
			};
		};

	smallCAmrk = smallCAmrk - [_marcador]; publicVariable "smallCAmrk";

	waitUntil {sleep 1; not (spawner getVariable _marcador)};
	}
else
	{
	waitUntil {sleep 1; !([distanciaSPWN,1,_posDestino,"BLUFORSpawn"] call distanceUnits)};
	//if (debug) then {stavros sidechat "Despawning"};
	smallCApos = smallCApos - [_marcador];
	};
{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)};
deleteVehicle _x;
} forEach _soldados;
{deleteGroup _x} forEach _grupos;
{
if (!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)) then {deleteVehicle _x};
} forEach _vehiculos;
