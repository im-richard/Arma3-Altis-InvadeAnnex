/*
Author: 

	Quiksilver

Last modified: 

	12/05/2014

Description:

	Main AO mission control
		
______________________________________________*/


if (!isNull enemiesArray) then {
	_Ts_Hint = "Headless Client Connection was lost and has been Re-established. Main AO will now delete and relocate.";
	TsHint = _Ts_Hint; publicVariable "TsHint"; hint parseText TsHint;
	[enemiesArray] spawn QS_fnc_AOdelete;
};
private ["_mission","_missionList","_currentMission","_nextMission","_loopTimeout"];



_loopTimeout = 20;

_missionList = [
	//"regionNW",
	//"regionNE",
	//"regionSW",
	//"regionSE",
	"regionCE"
];

//if (PARAMS_AOReinforcementJet == 1) then {_null = [] execVM "mission\main\CAS.sqf";};		

/*
_currentMission = execVM "mission\main\region\regionCE.sqf";

waitUntil {
	sleep 5;
	scriptDone _currentMission
};
*/

while { true } do {	
	
	_mission = _missionList call BIS_fnc_selectRandom;
	_currentMission = execVM format ["mission\main\region\%1.sqf", _mission];
	
	waitUntil {
		sleep 5;
		scriptDone _currentMission
	};
	sleep _loopTimeout;
};
	
	
