private ["_resourcesAAF","_prestigeCSAT","_coste","_destroyedCities","_destroyed","_nombre"];

_resourcesAAF = server getVariable "resourcesAAF";

_prestigeCSAT = server getVariable "prestigeCSAT";

if ((_resourcesAAF < 20000) and (_prestigeCSAT > 40)) then
	{
	_resourcesAAF = _resourcesAAF + 20000;
	[0,-20] call prestige;
	};

if (_resourcesAAF < 5000) exitWith {};

_cuenta = count (mrkFIA - puestosFIA - ["FIA_HQ"] - ciudades);

if (_resourcesAAF > 5000) then
	{
	_destroyedCities = destroyedCities - mrkFIA - ciudades;
	if (count _destroyedCities > 0) then
		{
		{
		_destroyed = _x;
		if ((_resourcesAAF > 5000) and (not(spawner getVariable _destroyed))) then
			{
			_resourcesAAF = _resourcesAAF - 5000;
			destroyedCities = destroyedCities - [_destroyed];
			publicVariable "destroyedCities";
			[10,0,getMarkerPos _destroyed] remoteExecCall ["citySupportChange",2];
			[-5,0] remoteExecCall ["prestige",2];
			if (_destroyed in power) then {[_destroyed] call powerReorg};
			_nombre = [_destroyed] call localizar;
			[["TaskFailed", ["", format ["%1 rebuilt by AAF",_nombre]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
			};
		} forEach _destroyedCities;
		}
	else
		{
		if ((count antenasMuertas > 0) and (not(["REP"] call BIS_fnc_taskExists))) then
			{
			{
			if (_resourcesAAF > 5000) exitWith
				{
				_marcador = [marcadores, _x] call BIS_fnc_nearestPosition;
				if ((_marcador in mrkAAF) and (not(spawner getVariable _marcador))) exitWith
					{
					[_marcador,_x] remoteExec ["REP_Antena",HCattack];
					};
				};
			} forEach antenasMuertas;
			};
		};
	};

if (_cuenta == 0) exitWith {};

if (((planesAAFcurrent < planesAAFmax) and (helisAAFcurrent > 3)) and (_cuenta > 6)) then
	{
	if (_resourcesAAF > 35000) then
		{
		if (count planesAAF < 2) then {planesAAF = planesAAF + ["I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"]; publicVariable "planesAAF"};
		planesAAFcurrent = planesAAFcurrent + 1; publicVariable "planesAAFcurrent";
		_resourcesAAF = _resourcesAAF - 35000;
		};
	};
if (((tanksAAFcurrent < tanksAAFmax) and (APCAAFcurrent > 3)) and (_cuenta > 5) and (planesAAFcurrent != 0)) then
	{
	if (_resourcesAAF > 30000) then
		{
		if (not ("I_MBT_03_cannon_F" in vehAAFAT)) then
	        {
	        vehAAFAT = vehAAFAT +  ["I_MBT_03_cannon_F"]; publicVariable "vehAAFAT";
	        };
	    tanksAAFcurrent = tanksAAFcurrent + 1; publicVariable "tanksAAFcurrent";
	    _resourcesAAF = _resourcesAAF - 30000;
		};
    };
if (((helisAAFcurrent < helisAAFmax) and ((helisAAFcurrent < 4) or (planesAAFcurrent > 3))) and (_cuenta > 3)) then
	{
	if (_resourcesAAF > 20000) then
		{
		if (not ("I_Heli_light_03_F" in planesAAF)) then {planesAAF = planesAAF + ["I_Heli_light_03_F"]; publicVariable "planesAAF"};
		helisAAFcurrent = helisAAFcurrent + 1; publicVariable "helisAAFcurrent";
		_resourcesAAF = _resourcesAAF - 20000;
		};
	};
if ((APCAAFcurrent < APCAAFmax) and ((tanksAAFcurrent > 2) or (APCAAFcurrent < 4)) and (_cuenta > 2)) then
	{
	if (_resourcesAAF > 10500) then
		{
		if (not ("I_APC_Wheeled_03_cannon_F" in vehAAFAT)) then
	    	{
	        vehAAFAT = vehAAFAT +  ["I_APC_Wheeled_03_cannon_F"]; publicVariable "vehAAFAT";
	        };
	    if (not ("I_APC_tracked_03_cannon_F" in vehAAFAT)) then
	    	{
	        vehAAFAT = vehAAFAT +  ["I_APC_tracked_03_cannon_F"]; publicVariable "vehAAFAT";
	        };
	    APCAAFcurrent = APCAAFcurrent + 1; publicVariable "APCAAFcurrent";
	    _resourcesAAF = _resourcesAAF - 10500;
		};
	};

if ((skillAAF < (server getVariable "skillFIA") + 2) and (skillAAF < 13)) then
	{
	_coste = 1000 + (1.5*(skillAAF *750));
	if (_coste < _resourcesAAF) then
		{
		skillAAF = skillAAF + 1;
		publicVariable "skillAAF";
		_resourcesAAF = _resourcesAAF - _coste;
		{
		_coste = server getVariable _x;
		_coste = round (_coste + (_coste * (skillAAF/280)));
		server setVariable [_x,_coste,true];
		} forEach soldadosAAF;
		};
	};

_resourcesAAF = round _resourcesAAF;

server setVariable ["resourcesAAF",_resourcesAAF,true];