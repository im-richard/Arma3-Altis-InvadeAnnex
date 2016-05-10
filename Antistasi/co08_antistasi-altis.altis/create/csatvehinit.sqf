private ["_veh"];

_veh = _this select 0;

if (_veh isKindOf "Air") then
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
	};

_veh addEventHandler ["killed",{[2,-2] remoteExecCall ["prestige",2]; [-5,5,position (_this select 0)] remoteExecCall ["citySupportChange",2]; [_this select 0] spawn postmortem}];

[_veh] spawn cleanserVeh;

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