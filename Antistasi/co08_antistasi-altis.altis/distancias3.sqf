if (!isServer) exitWith{};

//cercanos = [];

debugperf = false;

private ["_tiempo","_marcadores","_mrkAAF","_mrkFIA","_marcador","_posicionMRK"];

_tiempo = time;

while {true} do {
//sleep 0.01;
if (time - _tiempo >= 0.5) then {sleep 0.1} else {sleep 0.5 - (time - _tiempo)};
if (debugperf) then {hint format ["Tiempo transcurrido: %1 para %2 marcadores", time - _tiempo, count marcadores]};
_tiempo = time;
_marcadores = marcadores;
_mrkAAF = mrkAAF;
_mrkFIA = mrkFIA;

waitUntil {!isNil "stavros"};

_amigos = [];
_enemigos = [];
{
if (_x getVariable ["BLUFORSpawn",false]) then
	{
	_amigos pushBack _x;
	if (isPlayer _x) then
		{
		if (!isNull (getConnectedUAV _x)) then
			{
			_amigos pushBack (getConnectedUAV _x);
			};
		};
	}
else
	{
	if (_x getVariable ["OPFORSpawn",false]) then
		{
		_enemigos pushBack _x;
		};
	}
} forEach allUnits;

{
_marcador = _x;

_posicionMRK = getMarkerPos (_marcador);

if (_marcador in _mrkAAF) then
	{
	//if !(spawner getVariable _marcador) then
	if !(spawner getVariable _marcador) then
		{
		if ((({(_x distance _posicionMRK < distanciaSPWN)} count _amigos > 0) or (_marcador in forcedSpawn))) then
			{
			//cercanos pushBack _marcador;
			//publicVariable "cercanos";
			spawner setVariable [_marcador,true,true];
			if (_marcador in colinas) then {[_marcador] remoteExec ["createAAFcolinas",HCGarrisons]} else {
			if (_marcador in ciudades) then {[_marcador] remoteExec ["createCIV",HCciviles]; [_marcador] remoteExec ["createAAFciudades",HCGarrisons]} else {
			if (_marcador in power) then {[_marcador] remoteExec ["createAAFpower",HCGarrisons]} else {
			if (_marcador in bases) then {[_marcador] remoteExec ["createAAFbases",HCGarrisons]} else {
			if (_marcador in controles) then {[_marcador] remoteExec ["createAAFcontroles",HCGarrisons]} else {
			if (_marcador in aeropuertos) then {[_marcador] remoteExec ["createAAFaerop",HCGarrisons]} else {
			if (((_marcador in recursos) or (_marcador in fabricas))) then {[_marcador] remoteExec ["createAAFrecursos",HCGarrisons]} else {
			if ((_marcador in puestos) or (_marcador in puertos)) then {[_marcador] remoteExec ["createAAFpuestos",HCGarrisons]};};};};};};};};
			};
		}
	else
		{
		if (({_x distance _posicionMRK < distanciaSPWN} count _amigos == 0) and (not(_marcador in forcedSpawn))) then
			{
			//cercanos = cercanos - [_marcador];
			//publicVariable "cercanos";
			spawner setVariable [_marcador,false,true];
			};
		};
	}
else
	{
	if !(spawner getVariable _marcador) then
		{
		if ((({_x distance _posicionMRK < distanciaSPWN} count _enemigos > 0) or ({((_x getVariable ["owner",objNull]) == _x) and (_x distance _posicionMRK < distanciaSPWN)} count _amigos > 0) or (_marcador in forcedSpawn))) then
			{
			spawner setVariable [_marcador,true,true];
			if (_marcador in ciudades) then
				{
				if (({((_x getVariable ["owner",objNull]) == _x) and (_x distance _posicionMRK < distanciaSPWN)} count _amigos > 0) or (_marcador in forcedSpawn)) then {[_marcador] remoteExec ["createCIV",HCciviles]};
				[_marcador] remoteExec ["createAAFciudades",HCGarrisons]
				}
			else
				{
				if ((_marcador in recursos) or (_marcador in fabricas)) then {[_marcador] remoteExec ["createFIArecursos",HCGarrisons]} else {
				if ((_marcador in power) or (_marcador == "FIA_HQ")) then {[_marcador] remoteExec ["createFIApower",HCGarrisons]} else {
				if (_marcador in aeropuertos) then {[_marcador] remoteExec ["createNATOaerop",HCGarrisons]} else {
				if (_marcador in bases) then {[_marcador] remoteExec ["createNATObases",HCGarrisons]} else {
				if (_marcador in puestosFIA) then {[_marcador] remoteExec ["createFIApuestos2",HCGarrisons]} else {
				if ((_marcador in puestos) or (_marcador in puertos)) then {[_marcador] remoteExec ["createFIApuestos",HCGarrisons]};};};};};};};
				};
		}
	else
		{
		//if ((({_x distance _posicionMRK < distanciaSPWN} count enemigos == 0) and ({(isPlayer _x) and (_x distance _posicionMRK < distanciaSPWN)} count _amigos == 0)) and (not(_marcador in forcedSpawn)) and (spawner getVariable _marcador)) then
		if ((({_x distance _posicionMRK < distanciaSPWN} count _enemigos == 0) and ({((_x getVariable ["owner",objNull]) == _x) and (_x distance _posicionMRK < distanciaSPWN)} count _amigos == 0)) and (not(_marcador in forcedSpawn))) then
			{
			spawner setVariable [_marcador,false,true];
			};
		};
	};
} forEach _marcadores;

};