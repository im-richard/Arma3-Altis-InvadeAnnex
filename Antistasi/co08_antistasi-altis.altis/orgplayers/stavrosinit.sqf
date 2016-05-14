private ["_unit","_grupos","_oldUnit","_oldProviders","_HQ","_providerModule","_used"];
_unit = _this select 0;
_grupos = hcAllGroups stavros;
_oldUnit = stavros;

if (_oldUnit == _unit) exitWith {};
/*
_oldProviders = _oldUnit getVariable ["BIS_SUPP_allProviderModules",[]];
_HQ = _oldUnit getVariable ["BIS_SUPP_HQ",nil];

if ((count _oldProviders) > 0) then {
	{
	_providerModule = _x;
   	{
   	if (typeOf _x == "SupportRequester" && _oldUnit in (synchronizedObjects _x)) then {
   	[_unit, _x, _providerModule] call BIS_fnc_addSupportLink;
   	};
   	}forEach synchronizedObjects _providerModule;
   	}forEach _oldProviders;
	};

{
_used = _oldUnit getVariable [format ["BIS_SUPP_used_%1",_x], 0];
_unit setVariable [format ["BIS_SUPP_used_%1", _x], _used, true]
} forEach ["Artillery","CAS_Heli","CAS_Bombing","UAV","Drop","Transport"];
_unit setVariable ["BIS_SUPP_transmitting", false];
_unit kbAddTopic ["BIS_SUPP_protocol", "A3\Modules_F\supports\kb\protocol.bikb", "A3\Modules_F\supports\kb\protocol.fsm", {call compile preprocessFileLineNumbers "A3\Modules_F\supports\kb\protocol.sqf"}];
if (!(isNil "_HQ")) then
	{
    player setVariable ["BIS_SUPP_HQ", _HQ];
    };
*/
if (!isNil "_grupos") then
  {
  {
  _oldUnit hcRemoveGroup _x;
  } forEach _grupos;
  };
_oldUnit synchronizeObjectsRemove [HC_comandante];
//apoyo synchronizeObjectsRemove [_oldUnit];
HC_comandante synchronizeObjectsRemove [_oldUnit];
stavros = _unit;
publicVariable "stavros";
stavros synchronizeObjectsAdd [HC_comandante];
HC_comandante synchronizeObjectsAdd [stavros];
//apoyo synchronizeObjectsAdd [stavros];
if (!isNil "_grupos") then
  {
  {_unit hcSetGroup [_x]} forEach _grupos;
  };
