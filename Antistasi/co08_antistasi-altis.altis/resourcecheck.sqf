if (!isServer) exitWith{};

if (isMultiplayer) then {waitUntil {!isNil "switchCom"}};

private ["_texto"];

while {true} do
	{
	sleep 600;//600
	if (isMultiplayer) then {waitUntil {sleep 1; isPlayer stavros}};
	_recAddOPFOR = 0;
	_recAddBLUFOR = 25;//0
	_hrAddBLUFOR = 0;//0
	_popFIA = 0;
	_popAAF = 0;
	_bonusAAF = 1;
	_bonusFIA = 1;
	{
	_ciudad = _x;
	_recAddCiudadOPFOR = 0;
	_recAddCiudadBLUFOR = 0;
	_hrAddCiudad = 0;
	_datos = server getVariable _ciudad;
	_numCiv = _datos select 0;
	_numVeh = _datos select 1;
	//_roads = _datos select 2;
	_prestigeOPFOR = _datos select 2;
	_prestigeBLUFOR = _datos select 3;
	_power = _datos select 4;

	_popFIA = _popFIA + (_numCiv * (_prestigeBLUFOR / 100));
	_popAAF = _popAAF + (_numCiv * (_prestigeOPFOR / 100));
	_multiplicandorec = 1;
	if (not _power) then {_multiplicandorec = 0.5};

	if (_ciudad in destroyedCities) then
		{
		_recAddCiudadOPFOR = 0;
		_recAddCiudadBLUFOR = 0;
		_hrAddCiudad = 0;
		}
	else
		{
		_recAddCiudadOPFOR = ((_numciv * _multiplicandorec*(_prestigeOPFOR / 100)) /3);
		_recAddCiudadBLUFOR = ((_numciv * _multiplicandorec*(_prestigeBLUFOR / 100))/3);
		_hrAddCiudad = (_numciv * (_prestigeBLUFOR / 20000));
		if (_ciudad in mrkFIA) then
			{
			_recAddCiudadOPFOR = (_recAddCiudadOPFOR/2);
			if ((_power) and (_prestigeBLUFOR < 50)) then {[0,1,_ciudad] remoteExecCall ["citySupportChange",2]};
			}
		else
			{
			_recAddCiudadBLUFOR = (_recAddCiudadBLUFOR/2);
			_hrAddCiudad = (_hrAddCiudad/2);
			if ((_power) and (_prestigeOPFOR < 50)) then {[1,0,_ciudad] remoteExecCall ["citySupportChange",2]};
			};
		};
	_recAddOPFOR = _recAddOPFOR + _recAddCiudadOPFOR;
	_recAddBLUFOR = _recAddBLUFOR + _recAddCiudadBLUFOR;
	_hrAddBLUFOR = _hrAddBLUFOR + _hrAddCiudad;
	// revuelta civil!!
	if ((_prestigeOPFOR < _prestigeBLUFOR) and (_ciudad in mrkAAF)) then
		{
		[["TaskSucceeded", ["", format ["%1 joined FIA",[_ciudad, false] call fn_location]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		mrkAAF = mrkAAF - [_ciudad];
		mrkFIA = mrkFIA + [_ciudad];
		publicVariable "mrkAAF";
		publicVariable "mrkFIA";
		_nul = [0,5] remoteExecCall ["prestige",2];
		if (_power) then {_power = false} else {_power = true};
		//_datos = [_numCiv,_numVeh,_roads,_prestigeOPFOR,_prestigeBLUFOR,_power];
		_datos = [_numCiv,_numVeh,_prestigeOPFOR,_prestigeBLUFOR,_power];
		server setVariable [_ciudad,_datos,true];
		_mrkD = format ["Dum%1",_ciudad];
		_mrkD setMarkerColor "colorBLUFOR";
		sleep 5;
		{_nul = [_ciudad,_x] spawn deleteControles} forEach controles;
		};
	if ((_prestigeOPFOR > _prestigeBLUFOR) and (_ciudad in mrkFIA)) then
		{
		[["TaskFailed", ["", format ["%1 joined AAF",[_ciudad, false] call fn_location]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		mrkAAF = mrkAAF + [_ciudad];
		mrkFIA = mrkFIA - [_ciudad];
		publicVariable "mrkAAF";
		publicVariable "mrkFIA";
		_nul = [0,-5] remoteExecCall ["prestige",2];
		if (_power) then {_power = false} else {_power = true};
		//_datos = [_numCiv,_numVeh,_roads,_prestigeOPFOR,_prestigeBLUFOR,_power];
		_datos = [_numCiv,_numVeh,_prestigeOPFOR,_prestigeBLUFOR,_power];
		server setVariable [_ciudad,_datos,true];
		_mrkD = format ["Dum%1",_ciudad];
		_mrkD setMarkerColor "colorGUER";
		sleep 5;
		};
	} forEach ciudades;
	if (_popFIA > _popAAF) then {["end1",true,true,true,true] remoteExec ["BIS_fnc_endMission",0]};
	{
	_fabrica = _x;
	_power = server getVariable _fabrica;
	if ((_power) and (not(_fabrica in destroyedCities))) then
		{
		if (_fabrica in mrkFIA) then {_bonusFIA = _bonusFIA + 0.25};
		if (_fabrica in mrkAAF) then {_bonusAAF = _bonusAAF + 0.25};
		};
	} forEach fabricas;

	{
	_recurso = _x;
	_power = server getVariable _recurso;
	if ((_power) and (not(_recurso in destroyedCities))) then
		{
		if (_recurso in mrkFIA) then {_recAddBLUFOR = _recAddBLUFOR + (300 * _bonusFIA)};
		if (_recurso in mrkAAF) then {_recAddOPFOR = _recAddOPFOR + (300 * _bonusAAF)};
		};
	} forEach recursos;
	if (debug) then {stavros sideChat format ["AAF ha ganado %1 €\n FIA ha ganado %2 €\n Nivel de HR aumenta en %3", _recAddOPFOR,_recAddBLUFOR,_hrAddBLUFOR]};//AAF gana de inicio 7290 euros
	lastIncome = _recAddBLUFOR;
	_hrAddBLUFOR = round _hrAddBLUFOR;
	_recAddBLUFOR = round _recAddBLUFOR;
	_nul = [_hrAddBLUFOR,_recAddBLUFOR] remoteExecCall ["resourcesFIA",2];
	_texto = format ["<t size='0.6' color='#C1C0BB'>Taxes Income.<br/> <t size='0.5' color='#C1C0BB'><br/>Manpower: +%1<br/>Money: +%2 €",_hrAddBLUFOR,_recAddBLUFOR];
	//_updated = false;
	_updated = [] call arsenalManage;
	if (_updated != "") then {_texto = format ["%1<br/>Arsenal Updated<br/><br/>%2",_texto,_updated]};
	[[petros,"income",_texto],"commsMP"] call BIS_fnc_MP;
	_resourcesAAF = server getVariable "resourcesAAF";
	_resourcesAAF = _resourcesAAF + (round _recAddOPFOR);
	server setVariable ["resourcesAAF",_resourcesAAF,true];
	if (isMultiplayer) then {[] spawn assignStavros};
	if ((not(["AtaqueAAF"] call BIS_fnc_taskExists)) and (random 100 < 50)) then {[] call missionRequestAUTO};
	if (AAFpatrols < 3) then {[] remoteExec ["AAFroadPatrol",hcAttack]};
	{
	_veh = _x;
	if ((_veh isKindOf "StaticWeapon") and ({isPlayer _x} count crew _veh == 0) and (alive _veh)) then
		{
		_veh setDamage 0;
		[_veh,1] remoteExec ["setVehicleAmmoDef",_veh];
		};
	} forEach vehicles;
	cuentaCA = cuentaCA - 600;
	publicVariable "cuentaCA";
	if ((cuentaCA < 1) and (diag_fps > minimoFPS)) then
		{
		[1200] remoteExec ["timingCA",2];
		if ((count mrkFIA > 0) and (not(["AtaqueAAF"] call BIS_fnc_taskExists))) then {[] call ataqueAAF};
		};
	sleep 3;
	call AAFeconomics;
	sleep 4;
	[] call FIAradio;
	};