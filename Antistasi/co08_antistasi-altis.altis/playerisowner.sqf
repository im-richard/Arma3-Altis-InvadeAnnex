if (!isMultiplayer) then
	{
	waitUntil {player getVariable ["owner",player] == player}
	}
else
	{
	while {true} do
		{
		{
		if (!isNil "_x") then
			{
			if (isNull _x) then
				{
				if ((_x != _x getVariable ["owner",_x]) and (alive _x)) then
					{
					[_x] remoteExecCall ["vuelveEnTi",_x];
					};
				};
			};
		} forEach playableUnits;
		if ({_x getVariable ["owner",_x] == _x} count playableUnits == count playableUnits) exitWith {};
		//sleep 1;
		};
	/*
	_cuenta = 0;
	waitUntil {sleep 1; _cuenta = _cuenta + 1; ({_x getVariable ["owner",_x] == _x} count playableUnits == count playableUnits) or (_cuenta > 59)};
	if (_cuenta > 59) then
		{
		{
		if ((_x !0 _x getVariable ["owner",_x]) and (alive _x)) then
			{
			removeAllActions _x;
			_owner = _x getVariable ["owner",_x];
			selectPlayer _owner;
			_unit setVariable ["owner",player,true];
			{[_x] joinsilent group player} forEach units group player;
			group player selectLeader player;
			};
		} forEach playableUnits;
		};
	*/
	};
true