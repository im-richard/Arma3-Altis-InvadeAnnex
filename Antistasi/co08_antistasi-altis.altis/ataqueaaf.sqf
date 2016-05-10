
private ["_objetivos","_marcadores","_base","_objetivo","_cuenta","_aeropuerto","_datos","_prestigeOPFOR","_scoreLand","_scoreAir","_analizado","_garrison","_size","_estaticas"];

_objetivos = [];
_marcadores = [];

if (server getVariable "resourcesAAF" > 0) then {_marcadores = mrkFIA - destroyedCities - controles - colinas - puestosFIA - ["FIA_HQ"]};

_hayCSAT = true;
if (random 100 > (server getVariable "prestigeCSAT")) then
	{
	_marcadores = _marcadores - ciudades;
	_hayCSAT = false;
	};

if (count _marcadores == 0) exitWith {};

if (_hayCSAT) then {_score = 10};
_scoreLand = APCAAFcurrent + (5*tanksAAFcurrent);
_scoreAir = helisAAFcurrent + (5*planesAAFcurrent);
if (_hayCSAT) then {_scoreLand = _scoreLand + 10; _scoreAir = _scoreAir + 10};
//stavros sideChat format ["AAF Land forces: %1. AAF Air forces: %2",_scoreLand,_scoreAir];

{
_objetivo = _x;

_base= [_objetivo,true] call findBasesForCA;
_aeropuerto = [_objetivo,true] call findAirportsForCA;

if (_objetivo in ciudades) then
	{
	_datos = server getVariable _objetivo;
	_prestigeOPFOR = _datos select 2;
	if (_prestigeOPFOR > 0) then {_base = "";_aeropuerto = ""};
	};

if ((_base != "") or (_aeropuerto != "")) then
	{
	_posObjetivo = getMarkerPos _objetivo;
	_scoreNeededLand = 0;
	_scoreNeededAir = 0;
	if (_base != "") then
		{
		if (("launch_I_Titan_short_F" in unlockedWeapons) or ("launch_NLAW_F" in unlockedWeapons)) then {_scoreNeededLand = 3};
		_scoreNeededLand = _scoreNeededLand + 2 * ({(isOnRoad getMarkerPos _x) and (getMarkerPos _x distance _posObjetivo < distanciaSPWN)} count puestosFIA);
		};
	if (_aeropuerto != "") then
		{
		if ("launch_I_Titan_F" in unlockedWeapons) then {_scoreNeededAir = 5};
		};
	{
	if (getMarkerPos _x distance _posObjetivo < distanciaSPWN) then
		{
		_analizado = _x;
		_garrison = garrison getVariable [_analizado,[]];
		if (_base != "") then {_scoreNeededLand = _scoreNeededLand + (2*({(_x == "B_G_Soldier_A_F")} count _garrison)) + (floor((count _garrison)/8))};
		if (_aeropuerto != "") then {_scoreNeededAir = _scoreNeededAir + (floor((count _garrison)/8))};
		_size = [_analizado] call sizeMarker;
		_estaticas = staticsToSave select {_x distance (getMarkerPos _analizado) < _size};
		if (count _estaticas > 0) then
			{
			if (_base != "") then {_scoreNeededLand = _scoreNeededLand + ({typeOf _x == "B_G_Mortar_01_F"} count _estaticas) + (2*({typeOf _x == "B_static_AT_F"} count _estaticas))};
			if (_aeropuerto != "") then {_scoreNeededAir = _scoreNeededAir + ({typeOf _x == "B_HMG_01_high_F"} count _estaticas) + (5*({typeOf _x == "B_static_AA_F"} count _estaticas))}
			};
		};
	} forEach _marcadores;
	if (_scoreNeededLand > _scoreLand) then {_base = ""};
	if (_scoreNeededAir > _scoreAir) then {_aeropuerto = ""};
	//stavros sideChat format ["Marcador: %1. ScoreNeededLand: %2. ScoreLand: %3. ScoreNeededAir: %4. ScoreAir: %5",_objetivo,_scoreNeededLand,_scoreLand,_scoreNeededAir,_scoreAir]; sleep 5;
	if ((_base != "") or (_aeropuerto != "")) then
		{
		_cuenta = 1;
		if ((_objetivo in power) or (_objetivo in fabricas)) then {_cuenta = 4};
		if ((_objetivo in bases) or (_objetivo in aeropuertos)) then {_cuenta = 5};
		if (_objetivo in recursos) then {_cuenta = 3};
		if (_base != "") then
			{
			if (_aeropuerto != "") then {_cuenta = _cuenta *2};
			if (_objetivo == [_marcadores,_base] call bis_fnc_nearestPosition) then {_cuenta = _cuenta *2};
			};
		for "_i" from 1 to _cuenta do
			{
			_objetivos = _objetivos + [_objetivo];
			}
		};
	};

} forEach _marcadores;

if (count _objetivos > 0) then
	{
	_objetivo = _objetivos call BIS_fnc_selectRandom;
	if (not(_objetivo in ciudades)) then {[_objetivo] remoteExec ["combinedCA",HCattack]} else {[_objetivo] remoteExec ["CSATpunish",HCattack]};
	};

