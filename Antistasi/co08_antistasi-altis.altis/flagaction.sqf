private ["_flag","_tipo"];

if (isDedicated) exitWith {};

_flag = _this select 0;
_tipo = _this select 1;

switch _tipo do
	{
	case "take": {removeAllActions _flag; _flag addAction ["Take the Flag", {[[_this select 0, _this select 1],"mrkWIN"] call BIS_fnc_MP;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "unit": {_flag addAction ["Unit Recruitment", {nul=[] execVM "Dialogs\unit_recruit.sqf";;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "vehicle": {_flag addAction ["Buy Vehicle", {nul = createDialog "vehicle_option";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "mission": {petros addAction ["Mission Request", {nul=CreateDialog "mission_menu";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "camion": {_flag addAction ["Transfer Ammobox to Truck", "Municion\transfer.sqf",nil,0,false,true]};
	case "remove":
	{
	//removeAllActions _flag
	for "_i" from 0 to (_flag addAction ["",""]) do
		{
		_flag removeAction _i;
		};
	};
	case "refugiado": {_flag addAction ["Order Refugee to follow me", "AI\liberaterefugee.sqf",nil,0,false,true]};
	case "prisionero": {_flag addAction ["Liberate POW", "AI\liberatePOW.sqf",nil,0,false,true]};
	case "interrogar": {_flag addAction ["Interrogate", "AI\interrogar.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "capturar": {_flag addAction ["Offer join FIA", "AI\capturar.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "buildHQ": {_flag addAction ["Build HQ here", {[] spawn buildHQ},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "seaport": {_flag addAction ["Buy Boat", "REINF\buyBoat.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "steal": {_flag addAction ["Steal Static", "REINF\stealStatic.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "garage": {if (isMultiplayer) then {_flag addAction ["Personal Garage", {nul = [true] spawn garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};};
	};