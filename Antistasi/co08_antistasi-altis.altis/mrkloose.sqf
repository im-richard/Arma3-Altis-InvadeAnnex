if (!isServer) exitWith {};

private ["_marcador","_posicion","_mrk","_powerpl","_bandera"];

_marcador = _this select 0;
if (_marcador in mrkAAF) exitWith {};
_posicion = getMarkerPos _marcador;

mrkAAF = mrkAAF + [_marcador];
mrkFIA = mrkFIA - [_marcador];
publicVariable "mrkAAF";
publicVariable "mrkFIA";

garrison setVariable [_marcador,[],true];

_bandera = objNull;
_dist = 10;
while {isNull _bandera} do
	{
	_dist = _dist + 10;
	_banderas = nearestObjects [_posicion, ["FlagCarrier"], _dist];
	_bandera = _banderas select 0;
	};

///[[_bandera,"remove"],"flagaction"] call BIS_fnc_MP;
///sleep 5;
[[_bandera,"take"],"flagaction"] call BIS_fnc_MP;

_mrk = format ["Dum%1",_marcador];
_mrk setMarkerColor "ColorGUER";

if ((not (_marcador in bases)) and (not (_marcador in aeropuertos))) then
	{
	_nul = [10,-10,_posicion] remoteExecCall ["citySupportChange",2];
	if (_marcador in puestos) then
		{
		_mrk setMarkerText "AAF Outpost";
		[["TaskFailed", ["", "Outpost Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		};
	if (_marcador in puertos) then
		{
		_mrk setMarkerText "Sea Port";
		[["TaskFailed", ["", "Sea Port Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		};
	};
if (_marcador in power) then
	{
	_nul = [0,-5] remoteExecCall ["prestige",2];
	_mrk setMarkerText "Power Plant";
	[["TaskFailed", ["", "Powerplant Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
	[_marcador] spawn powerReorg;
	};
if ((_marcador in recursos) or (_marcador in fabricas)) then
	{
	_nul = [10,-10,_posicion] remoteExecCall ["citySupportChange",2];
	_nul = [0,-10] remoteExecCall ["prestige",2];
	_powerpl = [power, _posicion] call BIS_fnc_nearestPosition;
	if (_powerpl in mrkAAF) then
		{
		server SetVariable [_marcador,true,true];
		}
	else
		{
		server SetVariable [_marcador,false,true];
		};
	if (_marcador in recursos) then
		{
		_mrk setMarkerText "Resource";
		[["TaskFailed", ["", "Resource Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		}
	else
		{_mrk setMarkerText "Factory";
		[["TaskFailed", ["", "Factory Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		};
	};

if ((_marcador in bases) or (_marcador in aeropuertos)) then
	{
	_nul = [20,-20,_posicion] remoteExecCall ["citySupportChange",2];
	_mrk setMarkerType "flag_AAF";
	_nul = [0,-10] remoteExecCall ["prestige",2];
	if (_marcador in bases) then
		{
		[["TaskFailed", ["", "Base Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		_mrk setMarkerText "AAF Base";
		server setVariable [_marcador,false,true];
		APCAAFmax = APCAAFmax + 2;
        tanksAAFmax = tanksAAFmax + 1;
		}
	else
		{
		[["TaskFailed", ["", "Airport Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		_mrk setMarkerText "AAF Airport";
		server setVariable [_marcador,false,true];
		planesAAFmax = planesAAFmax + 1;
        helisAAFmax = helisAAFmax + 2;
        };
	};

_size = [_marcador] call sizeMarker;

_staticsToSave = staticsToSave;
{
if ((position _x) distance _posicion < _size) then
	{
	_staticsToSave = _staticsToSave - [_x];
	deleteVehicle _x;
	};
} forEach staticsToSave;

if (not(_staticsToSave isEqualTo staticsToSave)) then
	{
	staticsToSave = _staticsToSave;
	publicVariable "staticsToSave";
	};

_chequeo = false;

for "_i" from 0 to (_bandera addAction ["",""]) do
	{
	if (_i > 0) then {_chequeo = true};
	};

if (_chequeo) then
	{
	//waitUntil {sleep 1; (not(spawner getVariable _marcador)) or (({(alive _x) and (_x distance _posicion < _size) and (not(vehicle _x isKindOf "Air"))} count amigos) + ({(alive _x) and (_x distance _posicion < _size) and (not(vehicle _x isKindOf "Air"))} count NATO) > 3*(count ([_size,0,_posicion,"OPFORSpawn"] call distanceUnits)))};
	waitUntil {sleep 1; (not (spawner getVariable _marcador)) or (({(not(vehicle _x isKindOf "Air"))} count ([_size,0,_posicion,"BLUFORSpawn"] call distanceUnits)) > 3*(count ([_size,0,_posicion,"OPFORSpawn"] call distanceUnits)))};
	if (spawner getVariable _marcador) then
		{
		[_bandera] spawn mrkWIN;
		};
	};