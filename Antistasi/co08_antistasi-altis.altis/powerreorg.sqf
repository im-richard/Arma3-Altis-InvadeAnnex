private ["_marcador","_ciudad","_pos","_power","_datos","_powered","_numCiv","_numVeh","_roads","_prestigeOPFOR","_prestigeBLUFOR","_sitio"];

_marcador = _this select 0;

{
_ciudad = _x;
_pos = getMarkerPos _x;
_power = [power,_pos] call BIS_fnc_nearestPosition;
if (_power == _marcador) then
	{
	_datos = server getVariable _ciudad;
	if (_marcador in destroyedCities) then
		{
		_powered = false;
		[-10,-10,_pos] remoteExecCall ["citySupportChange",2];
		}
	else
		{
		_powered = _datos select 4;
		if (_marcador in mrkFIA) then
			{
			if ((_ciudad in mrkFIA) and (not _powered)) then
				{
				//hint format ["You achieved to bring power to %1, more people there supports our cause",_ciudad];
				[-10,10,_pos] remoteExecCall ["citySupportChange",2];
				_nul = [5,0] remoteExecCall ["prestige",2];
				_powered = true;
				};
			if ((_ciudad in mrkAAF) and (_powered)) then
				{
				//hint format ["You cutted off power to %1, less people support AAF there",_ciudad];
				[-10,0,_pos] remoteExecCall ["citySupportChange",2];
				_nul = [-5,0] remoteExecCall ["prestige",2];
				_powered = false;
				};
			};
		if (_marcador in mrkAAF) then
			{
			if ((_ciudad in mrkFIA) and (_powered)) then
				{
				//hint format ["AAF has cut off power to %1, less people there supports our cause",_ciudad];
				[0,-10,_pos] remoteExecCall ["citySupportChange",2];
				_nul = [5,0] remoteExecCall ["prestige",2];
				_powered = false;
				};
			if ((_ciudad in mrkAAF) and (not _powered)) then
				{
				//hint format ["AAF managed to recover power suply to %1, more people support AAF there",_ciudad];
				[10,0,_pos] remoteExecCall ["citySupportChange",2];
				_powered = true;
				};
			};
		};
	//_datos = server getVariable _ciudad;
	_numCiv = _datos select 0;
	_numVeh = _datos select 1;
	//_roads = _datos select 2;
	_prestigeOPFOR = _datos select 2;
	_prestigeBLUFOR = _datos select 3;

	_datos = [_numCiv,_numVeh,_prestigeOPFOR,_prestigeBLUFOR,_powered];
	server setVariable [_ciudad,_datos,true];
	[_ciudad,_powered] spawn apagon;
	};
} forEach ciudades;

_marcadores = fabricas + recursos;
{
_sitio = _x;
_pos = getMarkerPos _x;
_power = [power,_pos] call BIS_fnc_nearestPosition;
if (_power == _marcador) then
	{
	if (_marcador in destroyedCities) then
		{
		_powered = false;
		[-10,-10,_pos] remoteExecCall ["citySupportChange",2];
		}
	else
		{
	//_datos = server getVariable _sitio;
		_powered = server getVariable _sitio;
		if (_marcador in mrkFIA) then
			{
			if ((_sitio in mrkFIA) and (not _powered)) then
				{
				//_ciudad = [ciudades,_pos] call BIS_fnc_nearestPosition;
				//hint format ["You managed to take power to our resources near %1. They will be more productive from now",_ciudad];
				_powered = true;
				};
			if ((_sitio in mrkAAF) and (_powered)) then
				{
				//_ciudad = [ciudades,_pos] call BIS_fnc_nearestPosition;
				//hint format ["You cutted off power to AAF resources near %1. They will be less productive from now",_ciudad];
				_powered = false;
				};
			};
		if (_marcador in mrkAAF) then
			{
			if ((_sitio in mrkFIA) and (_powered)) then
				{
				//_ciudad = [ciudades,_pos] call BIS_fnc_nearestPosition;
				//hint format ["AAF cutted off power supply to our resources near %1. They will be less productive from now",_ciudad];
				_powered = false;
				};
			if ((_sitio in mrkAAF) and (not _powered)) then
				{
				//_ciudad = [ciudades,_pos] call BIS_fnc_nearestPosition;
				//hint format ["AAF managed to recover power suply to resources near %1. They will be more productive from now",_ciudad];
				_powered = true;
				};
			};
		};
	server setVariable [_sitio,_powered,true];
	[_sitio,_powered] spawn apagon;
	};
} forEach _marcadores;