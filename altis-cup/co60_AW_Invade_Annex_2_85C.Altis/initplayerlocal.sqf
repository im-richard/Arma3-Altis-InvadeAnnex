/*
	@Author: Richard
	@Organization: Arche Gaming Studios
	@Core: Arma 3
	@Package: Invade and Annex Gamemode
*/

enableSentences FALSE;															
enableSaving [FALSE,FALSE];
player enableFatigue FALSE;

//------------------------------------------------ Handle parameters

for [ {_i = 0}, {_i < count(paramsArray)}, {_i = _i + 1} ] do {
	call compile format
	[
		"PARAMS_%1 = %2",
		(configName ((missionConfigFile >> "Params") select _i)),
		(paramsArray select _i)
	];
};

//------------------- client executions

{_x addCuratorEditableObjects [[player],FALSE];} count allCurators;

_null = [] execvm "scripts\vehicle\crew\crew.sqf"; 								// vehicle HUD
//_null = [] execVM 'scripts\group_manager.sqf';									// group manager
_null = [] execVM "scripts\restrictions.sqf"; 									// gear restrictions and safezone
_null = [] execVM "scripts\pilotCheck.sqf"; 									// pilots only
_null = [] execVM "scripts\jump.sqf";											// jump action
_null = [] execVM "scripts\misc\diary.sqf";										// diary tabs	
_null = [] execVM "scripts\icons.sqf";											// blufor map tracker Quicksilver
_null = [] execVM "scripts\VAclient.sqf";										// Virtual Arsenal
_null = [] execVM "scripts\misc\Intro.sqf";										// AW intro screen
_null = [] execVM "scripts\voice_control\voiceControl.sqf";						// Voice Control
if (PARAMS_HeliRope != 0) then {call compile preprocessFileLineNumbers "scripts\vehicle\fastrope\zlt_fastrope.sqf";};

[] call QS_fnc_respawnPilot;


//-------------------- PVEHs

"addToScore" addPublicVariableEventHandler
{
	((_this select 1) select 0) addScore ((_this select 1) select 1);
};

tawvd_disablenone = false;

//--------------------- Arty Computer and Squad Manager

enableEngineArtillery false;
if (player isKindOf "B_support_Mort_f") then {
	enableEngineArtillery true;
};

["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

//--------------------- Billboard Image Randomiser

	_imageList = [16];
	_bill1 = _imageList call BIS_fnc_selectRandom;
	if (_bill1 == 1) then {Bill_1 setObjectTexture [0,"media\images\billboard16.paa"]};
	
	
	_imageList2 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
	_bill2 = _imageList2 call BIS_fnc_selectRandom;
	if (_bill2 == 1) then {Bill_2 setObjectTexture [0,"media\images\billboard1.paa"]};
	if (_bill2 == 2) then {Bill_2 setObjectTexture [0,"media\images\billboard2.paa"]};
	if (_bill2 == 3) then {Bill_2 setObjectTexture [0,"media\images\billboard3.paa"]};
	if (_bill2 == 4) then {Bill_2 setObjectTexture [0,"media\images\billboard4.paa"]};
	if (_bill2 == 5) then {Bill_2 setObjectTexture [0,"media\images\billboard5.paa"]};
	if (_bill2 == 6) then {Bill_2 setObjectTexture [0,"media\images\billboard6.paa"]};
	if (_bill2 == 7) then {Bill_2 setObjectTexture [0,"media\images\billboard7.paa"]};
	if (_bill2 == 8) then {Bill_2 setObjectTexture [0,"media\images\billboard8.paa"]};
	if (_bill2 == 9) then {Bill_2 setObjectTexture [0,"media\images\billboard9.paa"]};
	if (_bill2 == 10) then {Bill_2 setObjectTexture [0,"media\images\billboard10.paa"]};
	if (_bill2 == 11) then {Bill_2 setObjectTexture [0,"media\images\billboard11.paa"]};
	if (_bill2 == 12) then {Bill_2 setObjectTexture [0,"media\images\billboard12.paa"]};
	if (_bill2 == 13) then {Bill_2 setObjectTexture [0,"media\images\billboard13.paa"]};
	if (_bill2 == 14) then {Bill_2 setObjectTexture [0,"media\images\billboard14.paa"]};

	_imageList3 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
	_bill3 = _imageList3 call BIS_fnc_selectRandom;
	if (_bill3 == 1) then {Bill_3 setObjectTexture [0,"media\images\billboard1.paa"]};
	if (_bill3 == 2) then {Bill_3 setObjectTexture [0,"media\images\billboard2.paa"]};
	if (_bill3 == 3) then {Bill_3 setObjectTexture [0,"media\images\billboard3.paa"]};
	if (_bill3 == 4) then {Bill_3 setObjectTexture [0,"media\images\billboard4.paa"]};
	if (_bill3 == 5) then {Bill_3 setObjectTexture [0,"media\images\billboard5.paa"]};
	if (_bill3 == 6) then {Bill_3 setObjectTexture [0,"media\images\billboard6.paa"]};
	if (_bill3 == 7) then {Bill_3 setObjectTexture [0,"media\images\billboard7.paa"]};
	if (_bill3 == 8) then {Bill_3 setObjectTexture [0,"media\images\billboard8.paa"]};
	if (_bill3 == 9) then {Bill_3 setObjectTexture [0,"media\images\billboard9.paa"]};
	if (_bill3 == 10) then {Bill_3 setObjectTexture [0,"media\images\billboard10.paa"]};
	if (_bill3 == 11) then {Bill_3 setObjectTexture [0,"media\images\billboard11.paa"]};
	if (_bill3 == 12) then {Bill_3 setObjectTexture [0,"media\images\billboard12.paa"]};
	if (_bill3 == 13) then {Bill_3 setObjectTexture [0,"media\images\billboard13.paa"]};
	if (_bill3 == 14) then {Bill_3 setObjectTexture [0,"media\images\billboard14.paa"]};

	_imageList4 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
	_bill4 = _imageList4 call BIS_fnc_selectRandom;
	if (_bill4 == 1) then {Bill_4 setObjectTexture [0,"media\images\billboard1.paa"]};
	if (_bill4 == 2) then {Bill_4 setObjectTexture [0,"media\images\billboard2.paa"]};
	if (_bill4 == 3) then {Bill_4 setObjectTexture [0,"media\images\billboard3.paa"]};
	if (_bill4 == 4) then {Bill_4 setObjectTexture [0,"media\images\billboard4.paa"]};
	if (_bill4 == 5) then {Bill_4 setObjectTexture [0,"media\images\billboard5.paa"]};
	if (_bill4 == 6) then {Bill_4 setObjectTexture [0,"media\images\billboard6.paa"]};
	if (_bill4 == 7) then {Bill_4 setObjectTexture [0,"media\images\billboard7.paa"]};
	if (_bill4 == 8) then {Bill_4 setObjectTexture [0,"media\images\billboard8.paa"]};
	if (_bill4 == 9) then {Bill_4 setObjectTexture [0,"media\images\billboard9.paa"]};
	if (_bill4 == 10) then {Bill_4 setObjectTexture [0,"media\images\billboard10.paa"]};
	if (_bill4 == 11) then {Bill_4 setObjectTexture [0,"media\images\billboard11.paa"]};
	if (_bill4 == 12) then {Bill_4 setObjectTexture [0,"media\images\billboard12.paa"]};
	if (_bill4 == 13) then {Bill_4 setObjectTexture [0,"media\images\billboard13.paa"]};
	if (_bill4 == 14) then {Bill_4 setObjectTexture [0,"media\images\billboard14.paa"]};

	_imageList5 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
	_bill5 = _imageList5 call BIS_fnc_selectRandom;
	if (_bill5 == 1) then {Bill_5 setObjectTexture [0,"media\images\billboard1.paa"]};
	if (_bill5 == 2) then {Bill_5 setObjectTexture [0,"media\images\billboard2.paa"]};
	if (_bill5 == 3) then {Bill_5 setObjectTexture [0,"media\images\billboard3.paa"]};
	if (_bill5 == 4) then {Bill_5 setObjectTexture [0,"media\images\billboard4.paa"]};
	if (_bill5 == 5) then {Bill_5 setObjectTexture [0,"media\images\billboard5.paa"]};
	if (_bill5 == 6) then {Bill_5 setObjectTexture [0,"media\images\billboard6.paa"]};
	if (_bill5 == 7) then {Bill_5 setObjectTexture [0,"media\images\billboard7.paa"]};
	if (_bill5 == 8) then {Bill_5 setObjectTexture [0,"media\images\billboard8.paa"]};
	if (_bill5 == 9) then {Bill_5 setObjectTexture [0,"media\images\billboard9.paa"]};
	if (_bill5 == 10) then {Bill_5 setObjectTexture [0,"media\images\billboard10.paa"]};
	if (_bill5 == 11) then {Bill_5 setObjectTexture [0,"media\images\billboard11.paa"]};
	if (_bill5 == 12) then {Bill_5 setObjectTexture [0,"media\images\billboard12.paa"]};
	if (_bill5 == 13) then {Bill_5 setObjectTexture [0,"media\images\billboard13.paa"]};
	if (_bill5 == 14) then {Bill_5 setObjectTexture [0,"media\images\billboard14.paa"]};

	_imageList6 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
	_bill6 = _imageList6 call BIS_fnc_selectRandom;
	if (_bill6 == 1) then {Bill_6 setObjectTexture [0,"media\images\billboard1.paa"]};
	if (_bill6 == 2) then {Bill_6 setObjectTexture [0,"media\images\billboard2.paa"]};
	if (_bill6 == 3) then {Bill_6 setObjectTexture [0,"media\images\billboard3.paa"]};
	if (_bill6 == 4) then {Bill_6 setObjectTexture [0,"media\images\billboard4.paa"]};
	if (_bill6 == 5) then {Bill_6 setObjectTexture [0,"media\images\billboard5.paa"]};
	if (_bill6 == 6) then {Bill_6 setObjectTexture [0,"media\images\billboard6.paa"]};
	if (_bill6 == 7) then {Bill_6 setObjectTexture [0,"media\images\billboard7.paa"]};
	if (_bill6 == 8) then {Bill_6 setObjectTexture [0,"media\images\billboard8.paa"]};
	if (_bill6 == 9) then {Bill_6 setObjectTexture [0,"media\images\billboard9.paa"]};
	if (_bill6 == 10) then {Bill_6 setObjectTexture [0,"media\images\billboard10.paa"]};
	if (_bill6 == 11) then {Bill_6 setObjectTexture [0,"media\images\billboard11.paa"]};
	if (_bill6 == 12) then {Bill_6 setObjectTexture [0,"media\images\billboard12.paa"]};
	if (_bill6 == 13) then {Bill_6 setObjectTexture [0,"media\images\billboard13.paa"]};
	if (_bill6 == 14) then {Bill_6 setObjectTexture [0,"media\images\billboard14.paa"]};

	_imageList7 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
	_bill7 = _imageList7 call BIS_fnc_selectRandom;
	if (_bill7 == 1) then {Bill_7 setObjectTexture [0,"media\images\billboard1.paa"]};
	if (_bill7 == 2) then {Bill_7 setObjectTexture [0,"media\images\billboard2.paa"]};
	if (_bill7 == 3) then {Bill_7 setObjectTexture [0,"media\images\billboard3.paa"]};
	if (_bill7 == 4) then {Bill_7 setObjectTexture [0,"media\images\billboard4.paa"]};
	if (_bill7 == 5) then {Bill_7 setObjectTexture [0,"media\images\billboard5.paa"]};
	if (_bill7 == 6) then {Bill_7 setObjectTexture [0,"media\images\billboard6.paa"]};
	if (_bill7 == 7) then {Bill_7 setObjectTexture [0,"media\images\billboard7.paa"]};
	if (_bill7 == 8) then {Bill_7 setObjectTexture [0,"media\images\billboard8.paa"]};
	if (_bill7 == 9) then {Bill_7 setObjectTexture [0,"media\images\billboard9.paa"]};
	if (_bill7 == 10) then {Bill_7 setObjectTexture [0,"media\images\billboard10.paa"]};
	if (_bill7 == 11) then {Bill_7 setObjectTexture [0,"media\images\billboard11.paa"]};
	if (_bill7 == 12) then {Bill_7 setObjectTexture [0,"media\images\billboard12.paa"]};
	if (_bill7 == 13) then {Bill_7 setObjectTexture [0,"media\images\billboard13.paa"]};
	if (_bill7 == 14) then {Bill_7 setObjectTexture [0,"media\images\billboard14.paa"]};

	_imageList8 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
	_bill8 = _imageList8 call BIS_fnc_selectRandom;
	if (_bill8 == 1) then {Bill_8 setObjectTexture [0,"media\images\billboard1.paa"]};
	if (_bill8 == 2) then {Bill_8 setObjectTexture [0,"media\images\billboard2.paa"]};
	if (_bill8 == 3) then {Bill_8 setObjectTexture [0,"media\images\billboard3.paa"]};
	if (_bill8 == 4) then {Bill_8 setObjectTexture [0,"media\images\billboard4.paa"]};
	if (_bill8 == 5) then {Bill_8 setObjectTexture [0,"media\images\billboard5.paa"]};
	if (_bill8 == 6) then {Bill_8 setObjectTexture [0,"media\images\billboard6.paa"]};
	if (_bill8 == 7) then {Bill_8 setObjectTexture [0,"media\images\billboard7.paa"]};
	if (_bill8 == 8) then {Bill_8 setObjectTexture [0,"media\images\billboard8.paa"]};
	if (_bill8 == 9) then {Bill_8 setObjectTexture [0,"media\images\billboard9.paa"]};
	if (_bill8 == 10) then {Bill_8 setObjectTexture [0,"media\images\billboard10.paa"]};
	if (_bill8 == 11) then {Bill_8 setObjectTexture [0,"media\images\billboard11.paa"]};
	if (_bill8 == 12) then {Bill_8 setObjectTexture [0,"media\images\billboard12.paa"]};
	if (_bill8 == 13) then {Bill_8 setObjectTexture [0,"media\images\billboard13.paa"]};
	if (_bill8 == 14) then {Bill_8 setObjectTexture [0,"media\images\billboard14.paa"]};

	_imageList9 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
	_bill9 = _imageList9 call BIS_fnc_selectRandom;
	if (_bill9 == 1) then {Bill_9 setObjectTexture [0,"media\images\billboard1.paa"]};
	if (_bill9 == 2) then {Bill_9 setObjectTexture [0,"media\images\billboard2.paa"]};
	if (_bill9 == 3) then {Bill_9 setObjectTexture [0,"media\images\billboard3.paa"]};
	if (_bill9 == 4) then {Bill_9 setObjectTexture [0,"media\images\billboard4.paa"]};
	if (_bill9 == 5) then {Bill_9 setObjectTexture [0,"media\images\billboard5.paa"]};
	if (_bill9 == 6) then {Bill_9 setObjectTexture [0,"media\images\billboard6.paa"]};
	if (_bill9 == 7) then {Bill_9 setObjectTexture [0,"media\images\billboard7.paa"]};
	if (_bill9 == 8) then {Bill_9 setObjectTexture [0,"media\images\billboard8.paa"]};
	if (_bill9 == 9) then {Bill_9 setObjectTexture [0,"media\images\billboard9.paa"]};
	if (_bill9 == 10) then {Bill_9 setObjectTexture [0,"media\images\billboard10.paa"]};
	if (_bill9 == 11) then {Bill_9 setObjectTexture [0,"media\images\billboard11.paa"]};
	if (_bill9 == 12) then {Bill_9 setObjectTexture [0,"media\images\billboard12.paa"]};
	if (_bill9 == 13) then {Bill_9 setObjectTexture [0,"media\images\billboard13.paa"]};
	if (_bill9 == 14) then {Bill_9 setObjectTexture [0,"media\images\billboard14.paa"]};
	
//--------------------- Squad Url Hint

_infoArray = squadParams player;    
_infoSquad = _infoArray select 0;
_squad = _infoSquad select 1;
_infoName = _infoArray select 1;
_name = _infoName select 1; 
_email = _infoSquad select 2;


// replace line below with your Squad xml's email
if (_email == "richard.tanner.dev@gmail.com") then {

_GlobalHint = format["<t align='center' size='2.2' color='#FF0000'>%1<br/></t><t size='1.4' color='#33CCFF'>%2</t><br/>has joined the server, Join us on TeamSpeak at ts.archegamingstudios.net!</t><br/>",_squad,_name];

[_GlobalHint] remoteExec ["AW_fnc_globalHint",0,false];
} else {};