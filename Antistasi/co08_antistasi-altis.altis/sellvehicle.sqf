private ["_veh", "_coste"];
_veh = cursortarget;
/*
{
if ((_x distance bandera < 10) and (_x!=caja) and (_x!=mapa) and (_x!=cajaveh)) then {_veh = _x}
} forEach vehicles;
*/
if (_veh distance getMarkerPos "respawn_west" > 50) exitWith {hint "Vehicle must be closer than 50 meters to the flag"};

if ({isPlayer _x} count crew _veh > 0) exitWith {hint "In order to sell, vehicle must be empty."};

_tipoVeh = typeOf _veh;
_coste = 0;

if (_tipoVeh in vehNATO) exitWith {hint "You cannot sell NATO vehicles"};

if (_tipoVeh in vehFIA) then {_coste = round (([_tipoVeh] call vehiclePrice)/2)};

if (_tipoVeh in arrayCivVeh) then
	{
	if (_tipoveh == "C_Van_01_fuel_F") then {_coste = 50} else {_coste = 25};
	};
if (_tipoVeh in vehAAFAT) then
	{
	if ((_tipoVeh == "I_APC_tracked_03_cannon_F") or (_tipoVeh == "I_APC_Wheeled_03_cannon_F")) then
		{
		APCAAFcurrent = APCAAFcurrent -1;publicVariable "APCAAFcurrent";call AAFassets;
		_coste = 1000;
		}
	else
		{
		tanksAAFcurrent = tanksAAFcurrent -1;publicVariable "tanksAAFcurrent";call AAFassets;
		_coste = 5000;
		};
	};
if (_tipoVeh in vehAAFnormal) then {_coste = 300};

if (_coste == 0) exitWith {hint "The vehicle you are looking is not suitable in our marketplace"};

_coste = _coste * (1-damage _veh);

[0,_coste] remoteExecCall ["resourcesFIA",2];

if (_veh in staticsToSave) then {staticsToSave = staticsToSave - [_veh]; publicVariable "staticsToSave"};
if (_veh in reportedVehs) then {reportedVehs = reportedVehs - [_veh]; publicVariable "reportedVehs"};

[_veh] call vaciar;

deleteVehicle _veh;

hint "Vehicle Sold";



