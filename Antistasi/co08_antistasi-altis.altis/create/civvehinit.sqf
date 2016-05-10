private ["_veh"];

_veh = _this select 0;

if (_veh isKindOf "Car") then
	{
	_veh addEventHandler ["HandleDamage",{if (((_this select 1) find "wheel" != -1) and (_this select 4=="") and (!isPlayer driver (_this select 0))) then {0;} else {(_this select 2);};}];
	};

if (_veh isKindOf "Truck_F") then
	{
	if (not (_veh isKindOf "C_Van_01_fuel_F")) then
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

_veh addEventHandler ["GetIn",
	{
	_veh = _this select 0;
	_unit = _this select 2;
	if (not(_veh in reportedVehs)) then
		{
		if (isPlayer _unit) then {[] remoteExec ["undercover",_unit]};
		};
	}
	];

[_veh] spawn cleanserVeh;

_veh addEventHandler ["Killed",{[_this select 0] spawn postmortem}];

if (count crew _veh > 0) then
	{
	sleep 10;
	_veh enableSimulationGlobal false;
	_veh addEventHandler ["GetIn",
		{
		_veh = _this select 0;
		if (!simulationEnabled _veh) then {_veh enableSimulationGlobal true};
		[_veh] spawn VEHdespawner;
		}
		];
	_veh addEventHandler ["HandleDamage",
		{
		_veh = _this select 0;
		if (!simulationEnabled _veh) then {_veh enableSimulationGlobal true};
		}
		];
	};
