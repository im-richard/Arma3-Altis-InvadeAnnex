_unit = _this select 0;
if (player != _unit) exitWith {};

_owner = _unit getVariable ["owner",_unit];

if (_owner == _unit) exitWith {};

selectPlayer _owner;
_unit setVariable ["owner",_owner,true];
{[_x] joinsilent group player} forEach units group player;
group player selectLeader player;
hint "Forced return to original unit";