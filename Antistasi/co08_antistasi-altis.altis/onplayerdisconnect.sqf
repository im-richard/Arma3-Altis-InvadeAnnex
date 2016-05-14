private ["_unit","_recursos","_hr","_armas","_municion","_items","_pos"];

_unit = _this select 0;

_recursos = 0;
_hr = 0;

_unit setVariable ["score",0,true];
_unit setVariable ["busy",false,true];
_unit setUnitRank "PRIVATE";

if (_unit == stavros) then
	{
	if (((count playableUnits > 0) and (count miembros == 0)) or ({(getPlayerUID _x) in miembros} count playableUnits > 0)) then
		{
		[] spawn assignStavros;
		}
	else
		{
		{_uds = units _x;
			{
			if (alive _x) then
				{
				if (not(_x getVariable "inconsciente")) then
					{
					_recursos = _recursos + (server getVariable (typeOf _x));
					_hr = _hr + 1;
					};
				};
			if (vehicle _x != _x) then
				{
				_veh = vehicle _x;
				_tipoVeh = typeOf _veh;
				if ((_veh isKindOf "StaticWeapon") and (not(_veh in staticsToSave))) then
					{
					_recursos = _recursos + ([_tipoVeh] call vehiclePrice) + ([typeOf (vehicle leader _x)] call vehiclePrice);
					}
				else
					{
					if (_veh distance getmarkerPos "respawn_west" > 50) then
						{
						if ((_x == driver _veh) and (count attachedObjects _veh == 0)) then
							{
							if (_tipoVeh in vehFIA) then {_recursos = _recursos + ([_tipoVeh] call vehiclePrice);};
							if (_tipoVeh in vehAAFnormal) then {_recursos = _recursos + 300};
							if (_tipoVeh in vehAAFAT) then
								{
								if ((_tipoVeh == "I_APC_tracked_03_cannon_F") or (_tipoVeh == "I_APC_Wheeled_03_cannon_F")) then {_recursos = _recursos + 1000} else {_recursos = _recursos + 5000};
								};
							};
						};
					};
				deleteVehicle _veh;
				};
			deleteVehicle _x;
			} forEach _uds;
		} forEach (hcAllGroups stavros);
		};
	if (group petros == group _unit) then {[] spawn buildHQ};
	//waitUntil {(_unit != stavros) and (isPlayer stavros)};
	};
_armas = weapons _unit;
_municion = magazines _unit + [currentMagazine _unit];
_items = (items _unit) + (primaryWeaponItems _unit);
if (hayTFAR) then
	{
	_items pushBack hmd _unit;
	if (backpack _unit != "tf_rt1523g_sage") then {caja addBackpackCargoGlobal [(backpack _unit) call BIS_fnc_basicBackpack,1];};
	}
else
	{
	_items = _items + (assignedItems _unit);
	caja addBackpackCargoGlobal [(backpack _unit) call BIS_fnc_basicBackpack,1];
	};

{caja addWeaponCargoGlobal [_x,1]} forEach _armas;
{caja addMagazineCargoGlobal [_x,1]} forEach _municion;
{caja addItemCargoGlobal [_x,1]} forEach _items;

if ({isPlayer _x} count units group _unit == 0) then
	{
	{_unidad = _x;
	if ((alive _unidad) and (not (_unidad getVariable "inconsciente"))) then
		{
		_tipo = typeOf _unidad;
		_coste = server getVariable _tipo;
		_recursos = _recursos + _coste;
		_hr = _hr +1;
		deleteVehicle _unidad;
		};
	} forEach units group _unit;
	[_hr,_recursos] remoteExecCall ["resourcesFIA",2];
	};

_pos = getPosATL _unit;
_wholder = nearestObjects [_pos, ["weaponHolderSimulated", "weaponHolder"], 2];
{deleteVehicle _x;} forEach _wholder + [_unit];
if (alive _unit) then
	{
	_unit setVariable ["owner",_unit,true];
	_unit setDamage 1;
	};

