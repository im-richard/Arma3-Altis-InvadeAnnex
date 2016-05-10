if (player != player getVariable ["owner",player]) exitWith {hint "You cannot go Undercover while you are controlling AI"};
if (captive player) exitWith {hint "You are in Undercover already"};

private ["_compromised","_cambiar","_bases","_arrayCivVeh","_player","_size","_base"];

_cambiar = "";
_bases = bases + puestos + controles;
_arrayCivVeh = arrayCivVeh + ["C_Heli_Light_01_civil_F"];
_compromised = player getVariable "compromised";

if (vehicle player != player) then
	{
	if (not(typeOf(vehicle player) in _arrayCivVeh)) then
		{
		hint "You are not in a civilian vehicle";
		_cambiar = "Init"
		};
	if (vehicle player in reportedVehs) then
		{
		hint "The vehicle you are in has been reported to the enemy. Change your vehicle or renew it in the Garage to become Undercover";
		_cambiar = "Init";
		};
	}
else
	{
	if ((primaryWeapon player != "") or (secondaryWeapon player != "") or (handgunWeapon player != "") or (vest player != "") or (headgear player in cascos) or (hmd player != "") or (not(uniform player in civUniforms))) then
		{
		hint "You cannot become Undercover while showing:\n\nAny weapon in hand\nWearing Vest\nWearing Helmet\nWearing NV Googles\nWearing a Mil Uniform";
		_cambiar = "Init";
		};
	if (dateToNumber date < _compromised) then
		{
		hint "You have been reported in the last 30 minutes and you cannot become Undercover";
		_cambiar = "Init";
		};
	};

if (_cambiar != "") exitWith {};

if ({((side _x== EAST) or (side _x== independent)) and (((_x knowsAbout player > 1.4) and (_X distance player < 500)) or (_x distance player < 350))} count allUnits > 0) exitWith {hint "You cannot become Undercover while some enemies are spotting you"};

_base = [_bases,player] call BIS_fnc_nearestPosition;
_size = [_base] call sizeMarker;
if ((player distance getMarkerPos _base < _size*2) and (_base in mrkAAF)) exitWith {hint "You cannot become Undercover near Bases, Outposts or Roadblocks"};

["Undercover ON",0,0,4,0,0,4] spawn bis_fnc_dynamicText;

player setCaptive true;

_player = player getVariable ["owner",player];
if (_player == leader group _player) then
	{
	{if (!isplayer _x) then {[_x] spawn undercoverAI}} forEach units group _player;
	};

while {_cambiar == ""} do
	{
	sleep 1;
	if (!captive player) then
		{
		_cambiar = "Reported";
		}
	else
		{
		_veh = vehicle _player;
		_tipo = typeOf _veh;
		if (_veh != _player) then
			{
			if (not(_tipo in _arrayCivVeh)) then
				{
				_cambiar = "VNoCivil"
				}
			else
				{
				if (_veh in reportedVehs) then
					{
					_cambiar = "VCompromised"
					}
				else
					{
					if (_tipo != "C_Heli_Light_01_civil_F") then
						{
						if !(isOnRoad position _veh) then
							{
							if (count (_veh nearRoads 50) == 0) then
								{
								if ({((side _x== EAST) or (side _x== independent)) and ((_x knowsAbout player > 1.4) or (_x distance player < 350))} count allUnits > 0) then {_cambiar = "Carretera"};
								};
							};
						};
					};
				}
			}
		else
			{
			if ((primaryWeapon player != "") or (secondaryWeapon player != "") or (handgunWeapon player != "") or (vest player != "") or (headgear player in cascos) or (hmd player != "") or (not(uniform player in civUniforms))) then
				{
				if ({((side _x== EAST) or (side _x== independent)) and ((_x knowsAbout player > 1.4) or (_x distance player < 350))} count allUnits > 0) then {_cambiar = "Vestido2"} else {_cambiar = "Vestido"};
				};
			if (dateToNumber date < _compromised) then
				{
				_cambiar = "Compromised";
				};
			};
		if (_cambiar == "") then
			{
			_base = [_bases,_player] call BIS_fnc_nearestPosition;
			_size = [_base] call sizeMarker;
			if ((_player distance getMarkerPos _base < _size*2) and (_base in mrkAAF)) then
				{
				_cambiar = "Distancia";
				};
			};
		};
	};

if (captive _player) then {_player setCaptive false};

["Undercover OFF",0,0,4,0,0,4] spawn bis_fnc_dynamicText;
switch _cambiar do
	{
	case "Reported":
		{
		hint "You have been reported or spotted by the enemy";
		//_compromised = _player getVariable "compromised";
		if (vehicle _player != _player) then
			{
			//_player setVariable ["compromised",[_compromised select 0,vehicle _player]];
			reportedVehs = reportedVehs + [vehicle _player]; publicVariable "reportedVehs";
			}
		else
			{
			_player setVariable ["compromised",(dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30])];
			};
		};
	case "VNoCivil": {hint "You entered in a non civilian vehicle"};
	case "VCompromised": {hint "You entered in a reported vehicle"};
	case "Carretera":
		{
		hint "You went far from roads and have been spotted";
		reportedVehs = reportedVehs + [vehicle _player]; publicVariable "reportedVehs";
		};
	case "Vestido": {hint "You cannot stay Undercover while showing:\n\nAny weapon in hand\nWearing Vest\nWearing Helmet\nWearing NV Googles\nWearing a Mil Uniform"};
	case "Vestido2":
		{
		hint "You cannot stay Undercover while showing:\n\nAny weapon in hand\nWearing Vest\nWearing Helmet\nWearing NV Googles\nWearing a Mil Uniform.\n\nThe enemy added you to the Wanted list";
		_player setVariable ["compromised",dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30]];
		};
	case "Compromised": {hint "You left your vehicle and you are still in the Wanted list"};
	case "Distancia":
		{
		hint "You have got too close to an enemy Base, Outpost or Roadblock";
		//_compromised = _player getVariable "compromised";
		if (vehicle _player != _player) then
			{
			//_player setVariable ["compromised",[_compromised select 0,vehicle _player]];
			reportedVehs = reportedVehs + [vehicle _player]; publicVariable "reportedVehs";
			}
		else
			{
			_player setVariable ["compromised",(dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30])];
			};
		};
	};
