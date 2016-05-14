private ["_unit","_muerto","_killer"];

_unit = _this select 0;

_unit allowFleeing 0;
_unit setSkill 0.7;

_EHkilledIdx = _unit addEventHandler ["killed", {
	_muerto = _this select 0;
	_nul = [1,0,getPos _muerto] remoteExecCall ["citySupportChange",2];
	[_muerto] spawn postmortem;
	//_nul = [-1,0] remoteExecCall ["prestige",2];
	//if (group _muerto == group player) then {arrayids = arrayids + [name _muerto]};
	}];

if (sunOrMoon < 1) then
	{
	if ("acc_pointer_IR" in primaryWeaponItems _unit) then {_unit action ["IRLaserOn", _unit]};
	};