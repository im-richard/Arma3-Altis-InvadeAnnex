private ["_camiones","_camion","_armas","_municion","_items","_mochis","_contenedores","_todo"];

_camion = objNull;

if (count _this == 1) then
	{
	_camion = _this select 0;
	}
else
	{
	_camiones = nearestObjects [caja, ["LandVehicle"], 20];
	if (count _camiones < 1) then {_camion = cajaVeh} else {_camion = _camiones select 0};
	};

_armas = weaponCargo _camion;
_municion = magazineCargo _camion;
_items = itemCargo _camion;
_mochis = backpackCargo _camion;
/*
if (count weaponsItemsCargo _camion > 0) then
	{
	{
	_armas pushBack ([(_x select 0)] call BIS_fnc_baseWeapon);
	for "_i" from 1 to (count _x) - 1 do
		{
		_cosa = _x select _i;
		if (typeName _cosa == typeName "") then
			{
			if (_cosa != "") then {_items pushBack _cosa};
			}
		else
			{
			if (typeName (_cosa select 0) == typeName []) then {_municion pushBack (_cosa select 0)};
			}
		};
	} forEach weaponsItemsCargo _camion;
	};

if (count backpackCargo _camion > 0) then
	{
	{
	_mochis pushBack (_x call BIS_fnc_basicBackpack);
	} forEach backpackCargo _camion;
	};
_contenedores = everyContainer _camion;
if (count _contenedores > 0) then
	{
	for "_i" from 0 to (count _contenedores - 1) do
		{
		_armas = _armas + (weaponCargo ((_contenedores select _i) select 1));
		_municion = _municion + (magazineCargo ((_contenedores select _i) select 1));
		_items = _items + (itemCargo ((_contenedores select _i) select 1));
		};
	};
*/
_todo = _armas + _municion + _items + _mochis;

if (count _todo < 1) exitWith
	{
	if (count _this != 1) then {hint "Closest vehicle cargo is empty"};
	};

[_camion,caja] remoteExec ["munitionTransfer",2];