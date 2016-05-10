private ["_veh","_tipo"];

_veh = _this select 0;

if ((_veh isKindOf "FlagCarrier") or (_veh isKindOf "Building")) exitWith {};
if (_veh isKindOf "ReammoBox_F") exitWith {[_veh] call cajaAAF};

_tipo = typeOf _veh;

if (((_tipo) in vehAAFnormal) or ((_tipo) in vehAAFAT) or (_tipo == "I_Boat_Armed_01_minigun_F")) then
	{
	if (_veh isKindOf "Truck_F") then
		{
		if (not (_veh isKindOf "I_Truck_02_fuel_F")) then
			{
			_veh addEventHandler ["GetIn",
				{
				_unit = _this select 2;
				_camion = _this select 0;
				if (isPlayer _unit) then
					{
					if ((_this select 1 == "driver") and (_unit getVariable "owner" == _unit)) then {[[_unit,"camion"],"flagaction"] call BIS_fnc_MP};
					};
				}];
			_veh addEventHandler ["GetOut",
				{
				_camion = _this select 0;
				_unit = _this select 2;
				if (isPlayer _unit) then
					{
					if (_this select 1 == "driver") then {[[_unit,"remove"],"flagaction"] call BIS_fnc_MP};
					};
				}];
			};
		};
	if !(_tipo in vehAAFAT) then
		{
		if (_tipo == "I_Truck_02_ammo_F") then
			{
			if (_veh distance getMarkerPos "respawn_west" > 50) then {_nul = [_veh] call cajaAAF};
			};
		_veh addEventHandler ["killed",{[-1500] remoteExecCall ["resourcesAAF",2]}];
		if (_veh isKindOf "Car") then
			{
			_veh addEventHandler ["HandleDamage",{if (((_this select 1) find "wheel" != -1) and (_this select 4=="") and (!isPlayer driver (_this select 0))) then {0;} else {(_this select 2);};}];
			};
		}
	else
		{
		if ((_tipo == "I_APC_tracked_03_cannon_F") or (_tipo == "I_APC_Wheeled_03_cannon_F")) then
			{
			_veh addEventHandler ["killed",{APCAAFcurrent = APCAAFcurrent -1;publicVariable "APCAAFcurrent";call AAFassets;[-2,2,position (_this select 0)] remoteExecCall ["citySupportChange",2]}];
			_veh addEventHandler ["HandleDamage",{private ["_veh"]; _veh = _this select 0; if (!canFire _veh) then {[_veh] call smokeCoverAuto}}];
			}
		else
			{
			if (_tipo == "I_MBT_03_cannon_F") then
				{
				_veh addEventHandler ["killed",{tanksAAFcurrent = tanksAAFcurrent -1;publicVariable "tanksAAFcurrent"; call AAFassets;[-5,5,position (_this select 0)] remoteExecCall ["citySupportChange",2]}];
				_veh addEventHandler ["HandleDamage",{private ["_veh"]; _veh = _this select 0; if (!canFire _veh) then {[_veh] call smokeCoverAuto}}];
				};
			};
		};
	}
else
	{
	if (_tipo in planesAAF) then
		{
		_veh addEventHandler ["GetIn",
			{
			_posicion = _this select 1;
			if (_posicion == "driver") then
				{
				_unit = _this select 2;
				if ((!isPlayer _unit) and (_unit getVariable ["BLUFORSpawn",false])) then
					{
					moveOut _unit;
					hint "Only Humans can pilot an air vehicle";
					};
				};
			}];
		if ((_tipo == "I_Heli_Transport_02_F") or (_tipo == "I_Heli_light_03_unarmed_F")) then
			{
			_veh addEventHandler ["killed",{[-8000] remoteExecCall ["resourcesAAF",2]}];
			}
		else
			{
			if (_veh isKindOf "Helicopter") then {_veh addEventHandler ["killed",{helisAAFcurrent = helisAAFcurrent -1; publicVariable "helisAAFcurrent"; call AAFassets;[1,1] remoteExecCall ["prestige",2]; [-2,2,position (_this select 0)] remoteExecCall ["citySupportChange",2]}]};
			if (_veh isKindOf "Plane") then {_veh addEventHandler ["killed",{planesAAFcurrent = planesAAFcurrent -1; publicVariable "planesAAFcurrent"; call AAFassets;[2,1] remoteExecCall ["prestige",2]; [-5,5,position (_this select 0)] remoteExecCall ["citySupportChange",2]}]};
			};
		}
	else
		{
		if (_tipo == "I_UAV_02_F") then
			{
			_veh addEventHandler ["killed",{[-5000] remoteExecCall ["resourcesAAF",2]}];
			}
		else
			{
			if (_veh isKindOf "StaticWeapon") then
				{
				[[_veh,"steal"],"flagaction"] call BIS_fnc_MP;
				}
			};
		};
	};

[_veh] spawn cleanserVeh;

_veh addEventHandler ["Killed",{[_this select 0] spawn postmortem}];

if ((count crew _veh) > 0) then
	{
	[_veh] spawn VEHdespawner
	}
else
	{
	_veh addEventHandler ["GetIn",
		{
		_veh = _this select 0;
		[_veh] spawn VEHdespawner;
		}
		];
	};