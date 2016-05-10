if (!isServer) exitWith {};

_origen = _this select 0;
_destino = _this select 1;

_municion= [];
_items = [];
_municion = magazineCargo _origen;
_items = itemCargo _origen;
_armas = [];
_weaponsItemsCargo = weaponsItemsCargo _origen;
_mochis = [];

if (count backpackCargo _origen > 0) then
	{
	{
	_mochis pushBack (_x call BIS_fnc_basicBackpack);
	} forEach backpackCargo _origen;
	};
_contenedores = everyContainer _origen;
if (count _contenedores > 0) then
	{
	for "_i" from 0 to (count _contenedores - 1) do
		{
		//_armas = _armas + (weaponCargo ((_contenedores select _i) select 1));
		_municion = _municion + (magazineCargo ((_contenedores select _i) select 1));
		_items = _items + (itemCargo ((_contenedores select _i) select 1));
		_weaponsItemsCargo = _weaponsItemsCargo + weaponsItemsCargo ((_contenedores select _i) select 1);
		};
	};
if (!isNil "_weaponsItemsCargo") then
	{
	if (count _weaponsItemsCargo > 0) then
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
		} forEach _weaponsItemsCargo;
		};
	};

{if (not(_x in unlockedWeapons)) then {_destino addWeaponCargoGlobal [_x,1]}} forEach _armas;
{if (not (_x in unlockedMagazines)) then {_destino addMagazineCargoGlobal [_x,1]}} forEach _municion;
{if (not(_x in unlockedItems)) then {_destino addItemCargoGlobal [_x,1]}} forEach _items;
{if (not(_x in unlockedBackpacks)) then {_destino addBackpackCargoGlobal [_x,1]}} forEach _mochis;
clearMagazineCargoGlobal _origen;
clearWeaponCargoGlobal _origen;
clearItemCargoGlobal _origen;
clearBackpackCargoGlobal _origen;

if (_destino == caja) then
	{
	_updated = [] call arsenalManage;
	if (_updated != "") then
		{
		_updated = format ["Arsenal Updated<br/><br/>%1",_updated];
		[[petros,"income",_updated],"commsMP"] call BIS_fnc_MP;
		};
	};

if (_destino != caja) then
	{
	[petros,"hint","Truck Loaded"] remoteExec ["commsMP",driver _destino];
	}
else
	{
	if (isMultiplayer) then {{if (_x distance caja < 5) then {[petros,"hint","Ammobox Loaded"] remoteExec ["commsMP",_x]}} forEach playableUnits} else {hint "Ammobox Loaded"};
	};