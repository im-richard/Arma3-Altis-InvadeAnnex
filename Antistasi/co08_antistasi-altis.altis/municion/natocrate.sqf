if (!isServer) exitWith {};

private ["_crate","_cosa","_num","_magazines"];

_crate = _this select 0;
_NATOSupp = _this select 1;

clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;

for "_i" from 0 to round (_NATOSupp/20) do
	{_cosa = armasNATO call BIS_Fnc_selectRandom;
	_num = 1+ (floor random 4);
	_crate addWeaponCargoGlobal [_cosa, _num];
	_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
	_crate addMagazineCargoGlobal [_magazines select 0, _num * 3];
	};
for "_i" from 0 to round (_NATOSupp/20) do
	{
	_cosa = itemsAAF call BIS_Fnc_selectRandom;
	_num = floor random 5;
	_crate addItemCargoGlobal [_cosa, _num];
	};
for "_i" from 0 to round (_NATOSupp/20) do
	{
	_cosa = municionNATO call BIS_Fnc_selectRandom;
	_crate addMagazineCargoGlobal [_cosa, _NATOSupp];
	};
for "_i" from 1 to round (_NATOSupp/33) do
	{
	_cosa = antitanqueAAF call BIS_Fnc_selectRandom;
	_crate addWeaponCargoGlobal [_cosa, 1];
	_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
	_crate addMagazineCargoGlobal [_magazines select 0, 3];
	};

for "_i" from 1 to round (_NATOSupp/33) do
	{
	if (not(_cosa in unlockedItems)) then
		{
		_cosa = opticasAAF call BIS_Fnc_selectRandom;
		_crate addItemCargoGlobal [_cosa, 1 + (floor random 2)];
		};
	};

if (round random 100 < 50) then
	{
	_crate addBackpackCargoGlobal ["B_Static_Designator_01_weapon_F",1];
	}
else
	{
	_crate addBackpackCargoGlobal ["B_UAV_01_backpack_F",1];
	_crate addItemCargoGlobal ["B_UavTerminal",1];
	};
if (hayACE) then
	{
	_crate addMagazineCargoGlobal ["ACE_HuntIR_M203", 3];
	//_crate addBackpackCargoGlobal ["ACE_HuntIR_Box",1];
	_crate addItemCargoGlobal ["ACE_HuntIR_monitor", 1];
	};