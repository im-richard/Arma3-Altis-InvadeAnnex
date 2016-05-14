if (!isServer) exitWith {};

private ["_tipo","_posbase","_posibles","_sitios","_exists","_sitio","_pos","_ciudad"];

_tipo = _this select 0;

_posbase = getMarkerPos "respawn_west";
_posibles = [];
_sitios = [];
_exists = false;

_silencio = false;
if (count _this > 1) then {_silencio = true};

if ([_tipo] call BIS_fnc_taskExists) exitWith {if (!_silencio) then {[[petros,"sideChat","I already gave you a mission of this type"],"commsMP"] call BIS_fnc_MP}};

if (_tipo == "AS") then
	{
	//_exists = ["AS"] call BIS_fnc_taskExists;
	//if ("AS" in activeTasks) then {_exists = true};
	//if (!_exists) then {_sitios = bases + ciudades - mrkFIA};
	_sitios = bases + ciudades + colinas - mrkFIA;
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			if ((_pos distance _posbase < 3000) and (not(spawner getVariable _sitio))) then {_posibles = _posibles + [_sitio]};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[[petros,"sideChat","I have no assasination missions for you. Move our HQ closer to the enemy or finish some other assasination missions in order to have better intel"],"commsMP"] call BIS_fnc_MP;
			[[petros,"hint","Assasination Missions require AAF cities, Observation Posts or bases closer than 3Km from your HQ."],"commsMP"] call BIS_fnc_MP;
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in bases) then {[_sitio] remoteExec ["AS_Oficial",HCattack]} else {if (_sitio in ciudades) then {[_sitio] remoteExec ["AS_Traidor",HCattack]} else {[_sitio] remoteExec ["AS_SpecOP",HCattack]}};
		};
	};
if (_tipo == "CON") then
	{
	_sitios = controles + colinas + puestos - mrkFIA;
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			if ((_pos distance _posbase < 3000) and (_sitio in mrkAAF)) then {_posibles = _posibles + [_sitio]};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[[petros,"sideChat","I have no Conquest missions for you. Move our HQ closer to the enemy or finish some other conquest missions in order to have better intel."],"commsMP"] call BIS_fnc_MP;
			[[petros,"hint","Conquest Missions require AAF roadblocks or outposts closer than 3Km from your HQ."],"commsMP"] call BIS_fnc_MP;
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		[_sitio] remoteExec ["CON_Puestos",HCattack];
		};
	};
if (_tipo == "DES") then
	{
	_sitios = aeropuertos + bases + antenas - mrkFIA;
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			if (_sitio in marcadores) then {_pos = getMarkerPos _sitio} else {_pos = getPos _sitio};
			if (_pos distance _posbase < 3000) then
				{
				if (_sitio in marcadores) then
					{
					if (not(spawner getVariable _sitio)) then {_posibles = _posibles + [_sitio]};
					}
				else
					{
					_cercano = [marcadores, getPos _sitio] call BIS_fnc_nearestPosition;
					if (_cercano in mrkAAF) then {_posibles = _posibles + [_sitio]};
					};
				};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[[petros,"sideChat","I have no destroy missions for you. Move our HQ closer to the enemy or finish some other destroy missions in order to have better intel"],"commsMP"] call BIS_fnc_MP;
			[[petros,"hint","Destroy Missions require AAF bases, Radio Towers or airports closer than 3Km from your HQ."],"commsMP"] call BIS_fnc_MP;
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in bases) then {[_sitio] remoteExec ["DES_Vehicle",HCattack]};
		if (_sitio in aeropuertos) then {[_sitio] remoteExec ["DES_Heli",HCattack]};
		if (_sitio in antenas) then {[_sitio] remoteExec ["DES_antena",HCattack]}
		};
	};
if (_tipo == "LOG") then
	{
	_sitios = puestos + ciudades - ["puesto_13"];
	if (random 100 < 20) then {_sitios = _sitios + bancos};
	_sitios = _sitios - mrkFIA;
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			if (_sitio in marcadores) then
				{
				_pos = getMarkerPos _sitio;
				}
			else
				{
				_pos = getPos _sitio;
				};
			if (_pos distance _posbase < 3000) then
				{
				if (_sitio in ciudades) then
					{
					_datos = server getVariable _sitio;
					_prestigeOPFOR = _datos select 2;
					_prestigeBLUFOR = _datos select 3;
					if (_prestigeOPFOR + _prestigeBLUFOR < 100) then
						{
						_posibles pushBack _sitio;
						};
					}
				else
					{
					_posibles = _posibles + [_sitio];
					};
				};
			if (_sitio in bancos) then
				{
				_ciudad = [ciudades, _pos] call BIS_fnc_nearestPosition;
				if (_ciudad in mrkFIA) then {_posibles = _posibles - [_sitio]};
				};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[[petros,"sideChat","I have no logistics missions for you. Move our HQ closer to the enemy or finish some other logistics missions in order to have better intel"],"commsMP"] call BIS_fnc_MP;
			[[petros,"hint","Logistics Missions require AAF Outposts, Cities or Banks closer than 3Km from your HQ."],"commsMP"] call BIS_fnc_MP;
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in ciudades) then {[_sitio] remoteExec ["LOG_Suministros",HCattack]};
		if (_sitio in puestos) then {[_sitio] remoteExec ["LOG_Ammo",HCattack]};
		if (_sitio in bancos) then {[_sitio] remoteExec ["LOG_Bank",HCattack]};
		};
	};
if (_tipo == "RES") then
	{
	_sitios = ciudades + bases + puestos - mrkFIA;
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			if ((_pos distance _posbase < 3000) and (not(spawner getVariable _sitio))) then {_posibles = _posibles + [_sitio]};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[[petros,"sideChat","I have no rescue missions for you. Move our HQ closer to the enemy or finish some other rescue missions in order to have better intel"],"commsMP"] call BIS_fnc_MP;
			[[petros,"hint","Rescue Missions require AAF Cities or Bases closer than 3Km from your HQ."],"commsMP"] call BIS_fnc_MP;
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in ciudades) then {[_sitio] remoteExec ["RES_Refugiados",HCattack]} else {[_sitio] remoteExec ["RES_Prisioneros",HCattack]};
		};
	};
if (_tipo == "CONVOY") then
	{
	_sitios = (bases + aeropuertos - mrkFIA) + ciudades;
	if (count _sitios > 0) then
		{
		for "_i" from 0 to ((count _sitios) - 1) do
			{
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			_base = [_sitio] call findBasesForConvoy;
			if ((_pos distance _posbase < 3000) and (_base !="")) then
				{
				if ((_sitio in ciudades) and (_sitio in mrkFIA)) then
					{
					_datos = server getVariable _sitio;
					_prestigeOPFOR = _datos select 2;
					_prestigeBLUFOR = _datos select 3;
					if (_prestigeOPFOR + _prestigeBLUFOR < 95) then
						{
						_posibles pushBack _sitio;
						};
					}
				else
					{
					_posibles = _posibles + [_sitio];
					};
				};
			};
		};
	if (count _posibles == 0) then
		{
		if (!_silencio) then
			{
			[[petros,"sideChat","I have no Convoy missions for you. Move our HQ closer to the enemy or finish some other rescue missions in order to have better intel"],"commsMP"] call BIS_fnc_MP;
			[[petros,"hint","Convoy Missions require AAF Airports, Bases or Cities closer than 3Km from your HQ, and they must have an idle friendly base in their surroundings."],"commsMP"] call BIS_fnc_MP;
			};
		}
	else
		{
		_sitio = _posibles call BIS_fnc_selectRandom;
		_base = [_sitio] call findBasesForConvoy;
		[_sitio,_base] remoteExec ["CONVOY",HCattack];
		};
	};

if ((count _posibles > 0) and (!_silencio)) then {[[petros,"sideChat","I have a mission for you"],"commsMP"] call BIS_fnc_MP;}

