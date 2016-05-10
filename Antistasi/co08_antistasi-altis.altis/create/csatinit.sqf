private ["_unit","_muerto","_killer","_skill","_caja"];

_unit = _this select 0;

_unit setVariable ["OPFORSpawn",true,true];

_EHkilledIdx = _unit addEventHandler ["killed", {
	_muerto = _this select 0;
	_killer = _this select 1;
	_skill = skill _killer;
	_muerto setVariable ["OPFORSpawn",nil,true];
	[_muerto] spawn postmortem;
	_killer setSkill _skill + 0.01;
	_nul = [-2,2,getPos _muerto] remoteExecCall ["citySupportChange",2];
	if (isPlayer _killer) then
		{
		[1,_killer] call playerScoreAdd;
		if (captive _killer) then
			{
			[_killer,false] remoteExec ["setCaptive",_killer];
			};
		};
	if ((count weapons _muerto < 1) and (_muerto isKindOf "Man") and (side _killer == west))  then
		{
		_nul = [-1,0] remoteExecCall ["prestige",2];
		if (isPlayer _killer) then {_killer addRating 1000};
		};
	}];

if (sunOrMoon < 1) then
	{
	if ("acc_pointer_IR" in primaryWeaponItems _unit) then {_unit action ["IRLaserOn", _unit]};
	};
