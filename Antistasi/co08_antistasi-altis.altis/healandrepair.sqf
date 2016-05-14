
private ["_posHQ"];
_posHQ = getMarkerPos "respawn_west";

{if ((side _x == west) and (_x distance _posHQ < 150)) then {_x setDamage 0}} forEach allUnits;
{
if (_x distance _posHQ < 150)
	then
	{
	_x setDamage 0;
	//_x setVehicleAmmoDef 1;
	[_x,1] remoteExec ["setVehicleAmmoDef",_x];
	};
} forEach vehicles;

hint "All nearby units and vehicles have been healed or repaired. Near vehicles have been rearmed at full load."