if (!isServer) exitWith {};

private ["_cuentaFail","_texto","_unit","_surrendered","_coste","_armas","_municion","_items","_caja"];

fpsTotal = 0;
fpsCuenta = 0;
_cuentaFail = 0;


while {true} do
	{
	sleep 5;
	if (fpsCuenta > 12) then
		{
		fpsTotal = diag_fps;
		fpsCuenta = 1;
		}
	else
		{
		fpsTotal = fpsTotal + diag_fps;
		fpsCuenta = fpsCuenta + 1;
		};

	if (debug) then {stavros sideChat format ["FPS Av:%1.FPS Lim:%2",fpsTotal / fpsCuenta, minimoFPS]};
	if (diag_fps < minimoFPS) then
		{
		{if ((alive _x) and (side _x == civilian) and (diag_fps < minimoFPS) and (typeOf _x in arrayCivs)) then {deleteVehicle _x; sleep 1}} forEach allUnits;
		if (debug) then {stavros sideChat "Eliminados algunos civiles para incrementar FPS"};
		_cuentaFail = _cuentaFail + 1;
		if (_cuentaFail > 11) then
			{
			if (distanciaSPWN > 1000) then
				{
				distanciaSPWN = distanciaSPWN - 100;
				publicVariable "distanciaSPWN";
				};
			if (civPerc > 0.05) then
				{
				civPerc = civPerc - 0.01;
				publicVariable "civPerc";
				};
			if (minimoFPS > 25) then
				{
				minimoFPS = 25;
				};
			publicVariable "minimoFPS";
			_cuentaFail = 0;
			{if (!alive _x) then {deleteVehicle _x}} forEach vehicles;
			{deleteVehicle _x} forEach allDead;
			_texto = format ["Server has a low FPS average:\n%1\n\nGame settings changed to:\nSpawn Distance: %2 mts\nCiv. Percentage: %3 percent\nFPS Limit established at %4\n\nAll wrecked vehicles and corpses have been deleted",round (fpsTotal/fpsCuenta), distanciaSPWN,civPerc * 100, minimoFPS];
			[[petros,"hint",_texto],"commsMP"] call BIS_fnc_MP;
			allowPlayerRecruit = false; publicVariable "allowPlayerRecruit";
			};
		}
	else
		{
		_cuentaFail = 0;
		if (!allowPlayerRecruit) then {allowPlayerRecruit = true; publicVariable "allowPlayerRecruit"};
		{
		_unit = _x;
		if (_unit getVariable ["OPFORSpawn",false]) then
			{
			if (fleeing _unit) then
				{
				if (alive _unit) then
					{
					_surrendered = _unit getVariable "surrendered";
					if (isNil "_surrendered") then
						{
						if (([100,1,_unit,"BLUFORSpawn"] call distanceUnits) and (vehicle _unit == _unit)) then
							{
							if ((random 1 + (0.1*({_x getVariable ["surrendered",false]} count (units group _unit)))) > _unit skill "courage") then {[_unit] remoteExec ["surrenderAction",_unit]};
							}
						else
							{
							if (_unit == leader group _unit) then
								{
								if (random 1 < 0.1) then
									{
									_enemy = _unit findNearestEnemy _unit;
									if (!isNull _enemy) then
										{
										[position _enemy] remoteExec ["patrolCA",HCattack];
										};
									};
								};
							};
						};
					};
				};
			};
		} forEach allUnits;
		};
	};
