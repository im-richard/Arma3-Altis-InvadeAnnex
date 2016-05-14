private ["_veh"];

_veh = _this select 0;

if !(alive _veh) exitWith {};

if (_veh isKindOf "Air") then
	{
	private ["_pos","_humo"];
	for "_i" from 0 to 8 do
		{
		_pos = position _veh getPos [10,_i*40];
		_humo = "SmokeShellPurple" createVehicle [_pos select 0, _pos select 1,getPos _veh select 2];
		};
	}
else
	{
	_veh fire "SmokeLauncher";
	};