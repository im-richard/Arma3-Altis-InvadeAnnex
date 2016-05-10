//if (!isServer) exitWith{};
private ["_groups","_hr","_resourcesFIA","_wp","_grupo","_veh","_salir"];

_groups = _this select 0;
_hr = 0;
_resourcesFIA = 0;
_salir = false;
{
if ((groupID _x == "MineF") or (groupID _x == "Watch")) then {_salir = true};
} forEach _groups;

if (_salir) exitWith {hint "You cannot dismiss Watchpost, Roadblocks or Minefield building squads"};

_pos = getMarkerPos "respawn_west";

{
stavros sideChat format ["Petros, I'm sending %1 back to base", _x];
stavros hcRemoveGroup _x;
_wp = _x addWaypoint [_pos, 0];
_wp setWaypointType "MOVE";
sleep 3} forEach _groups;

sleep 100;

{_grupo = _x;
{

if (alive _x) then
	{
	_hr = _hr + 1;
	_resourcesFIA = _resourcesFIA + (server getVariable (typeOf _x));
	if ((_x != vehicle _x) and (typeOf vehicle _x in vehFIA)) then
		{
		_veh = typeOf vehicle _x;
		if (_veh == "B_G_Mortar_01_F") then {artyFIA synchronizeObjectsRemove [gunner _x]};
		if (alive vehicle _x) then
			{
			_resourcesFIA = _resourcesFIA + ([_veh] call vehiclePrice);
			deleteVehicle (vehicle _x);
			};
		};
	};
deleteVehicle (vehicle _x);
deleteVehicle _x;
} forEach units _grupo;
deleteGroup _grupo;} forEach _groups;
_nul = [_hr,_resourcesFIA] remoteExecCall ["resourcesFIA",2];


