if (not([player] call isMember)) exitWith {hint "Only Server Members can recruit AI units"};
private ["_chequeo","_hr","_tipounidad","_coste","_resourcesFIA","_unit"];

if (!allowPlayerRecruit) exitWith {hint "Server is very loaded. \nWait one minute or change FPS settings in order to fulfill this request"};

if (recruitCooldown > time) exitWith {hint format ["You need to wait %1 seconds to be able to recruit units again",round (recruitCooldown - time)]};

if (player != player getVariable ["owner",player]) exitWith {hint "Youy cannot buy units while you are controlling AI"};

_chequeo = false;
{
	if (((side _x == east) or (side _x == independent)) and (_x distance player < 500) and (not(captive _x))) then {_chequeo = true};
} forEach allUnits;

if (_chequeo) exitWith {Hint "You cannot Recruit Units with enemies nearby"};

if (player != leader group player) exitWith {hint "You cannot recruit units as you are not your group leader"};

_hr = server getVariable "hr";

if (_hr < 1) exitWith {hint "You do not have enough HR for this request"};

_tipounidad = _this select 0;

_coste = server getVariable _tipounidad;
if (!isMultiPlayer) then {_resourcesFIA = server getVariable "resourcesFIA"} else {_resourcesFIA = player getVariable "dinero";};

if (_coste > _resourcesFIA) exitWith {hint format ["You do not have enough money for this kind of unit (%1 € needed)",_coste]};


if ((count units group player) + (count units rezagados) > 9) exitWith {hint "Your squad is full or you have too many scattered units with no radio contact"};

_unit = group player createUnit [_tipounidad, position player, [], 0, "NONE"];

if (!isMultiPlayer) then
	{
	_nul = [-1, - _coste] remoteExecCall ["resourcesFIA",2];
	}
else
	{
	_nul = [-1, 0] remoteExecCall ["resourcesFIA",2];
	[- _coste] call resourcesPlayer;
	hint "Soldier Recruited.\n\nRemember: if you use the group menu to switch groups you will lose control of your recruited AI";
	};

[_unit] spawn FIAinit;
_unit disableAI "AUTOCOMBAT";
sleep 1;
petros directSay "SentGenReinforcementsArrived";



