waitUntil {!isNull player};
waitUntil {player == player};
player removeweaponGlobal "itemmap";
player removeweaponGlobal "itemgps";
if (isMultiplayer) then
	{
	[] execVM "briefing.sqf";
	if (!isServer) then
		{
		call compile preprocessFileLineNumbers "initVar.sqf";
		if (!hasInterface) then {call compile preprocessFileLineNumbers "roadsDB.sqf"};
		call compile preprocessFileLineNumbers "initFuncs.sqf";
		};
	};

_isJip = _this select 1;
private ["_colorWest", "_colorEast"];
_colorWest = WEST call BIS_fnc_sideColor;
_colorEast = EAST call BIS_fnc_sideColor;
{
_x set [3, 0.33]
} forEach [_colorWest, _colorEast];
_introShot =
	[
    position petros, // Target position
    "Altis Island", // SITREP text
    50, //  altitude
    50, //  radius
    90, //  degrees viewing angle
    0, // clockwise movement
    [
    	["\a3\ui_f\data\map\markers\nato\o_inf.paa", _colorWest, markerPos "insertMrk", 1, 1, 0, "Insertion Point", 0],
        ["\a3\ui_f\data\map\markers\nato\o_inf.paa", _colorEast, markerPos "towerBaseMrk", 1, 1, 0, "Radio Towers", 0]
    ]
    ] spawn BIS_fnc_establishingShot;

if (isMultiplayer) then {waitUntil {!isNil "initVar"}; diag_log format ["Antistasi MP Client. initVar is public. Version %1",antistasiVersion];};
_titulo = ["A3 - Antistasi","by Barbolani",antistasiVersion] spawn BIS_fnc_infoText;

if (isMultiplayer) then
	{
	player setVariable ["elegible",true,true];
	musicON = false;
	waitUntil {scriptdone _introshot};
	disableUserInput true;
	cutText ["Waiting for Players and Server Init","BLACK",0];
	diag_log "Antistasi MP Client. Waiting for serverInitDone";
	waitUntil {(!isNil "serverInitDone")};
	cutText ["Starting Mission","BLACK IN",0];
	diag_log "Antistasi MP Client. serverInitDone is public";
	}
else
	{
	stavros = player;
	grupo = group player;
	grupo setGroupId ["Stavros","GroupColor4"];
	player setIdentity "protagonista";
	player setUnitRank "COLONEL";
	HC_comandante synchronizeObjectsAdd [player];
	player synchronizeObjectsAdd [HC_comandante];
	waitUntil {(scriptdone _introshot) and (!isNil "serverInitDone")};
	_nul = addMissionEventHandler ["Loaded", {_nul = [] execVM "statistics.sqf";_nul = [] execVM "reinitY.sqf";}]
	};
disableUserInput false;
player addWeaponGlobal "itemmap";
player addWeaponGlobal "itemgps";
player setVariable ["owner",player,true];
player setVariable ["punish",0,true];
player setVariable ["dinero",100,true];
player setVariable ["BLUFORSpawn",true,true];
rezagados = creategroup WEST;
if (!hayACE) then
	{
	[player] execVM "Revive\initRevive.sqf";
	tags = [] execVM "tags.sqf";
	if ((cadetMode) and (isMultiplayer)) then {_nul = [] execVM "playerMarkers.sqf"};
	}
else
	{
	player setVariable ["inconsciente",false,true];
	player addItem "ACE_EarPlugs";
	};
gameMenu = (findDisplay 46) displayAddEventHandler ["KeyDown",teclas];
if (hayRHS) then {_nul = [player] execVM "Municion\RHSdress.sqf"};
//undercover = [] execVM "undercover.sqf";
player setvariable ["compromised",0];
player addEventHandler ["FIRED",
	{
	_player = _this select 0;
	if (captive _player) then
		{
		if ({((side _x== EAST) or (side _x== independent)) and (_x knowsAbout player > 1.4)} count allUnits > 0) then
			{
			_player setCaptive false;
			if (vehicle _player != _player) then
				{
				{if (isPlayer _x) then {[_x,false] remoteExec ["setCaptive",_x]}} forEach ((assignedCargo (vehicle _player)) + (crew (vehicle _player)));
				};
			}
		else
			{
			_ciudad = [ciudades,_player] call BIS_fnc_nearestPosition;
			_size = [_ciudad] call sizeMarker;
			_datos = server getVariable _ciudad;
			if (random 100 < _datos select 2) then
				{
				if (_player distance getMarkerPos _ciudad < _size * 1.5) then
					{
					_player setCaptive false;
					if (vehicle _player != _player) then
						{
						{if (isPlayer _x) then {[_x,false] remoteExec ["setCaptive",_x]}} forEach ((assignedCargo (vehicle _player)) + (crew (vehicle _player)));
						};
					};
				};
			};
		}
	}
	];
player addEventHandler ["WeaponAssembled", {if (not((_this select 1) in staticsToSave)) then {staticsToSave pushBack (_this select 1);publicVariable "staticsToSave";[_this select 1] spawn VEHinit}}];
player addEventHandler ["WeaponDisassembled",
		{
		_bag1 = _this select 1;
		_bag2 = _this select 2;
		//_bag1 = objectParent (_this select 1);
		//_bag2 = objectParent (_this select 2);
		[_bag1] spawn VEHinit;
		[_bag2] spawn VEHinit;
		}
	];

if (isMultiplayer) then
	{
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;//Exec on client
	["InitializeGroup", [player,WEST,true]] call BIS_fnc_dynamicGroups;
	personalGarage = [];
	};
caja addEventHandler ["ContainerOpened",
	{
	_fabricas = count (fabricas - mrkAAF);
	hint format ["Arsenal Unlocking Requirements\n\n\nWeapons: %1\nBackpacks: %5\nMagazines: %2\nOptics: %3\nVests: %3\nOther Items: %4",(12 + (count unlockedWeapons) - (2*_fabricas)),(21 + (2*(count unlockedMagazines)) - (4*_fabricas)),(-63 + (count unlockedItems) - _fabricas),(-53 + (count unlockedItems) - _fabricas),5*(count unlockedBackpacks)];
	}
    ];

if (_isJip) then
	{
	waitUntil {scriptdone _introshot};
	_nul = [] execVM "modBlacklist.sqf";
	player setVariable ["score",0,true];
	player setVariable ["owner",player,true];
	player setVariable ["punish",0,true];
	player setUnitRank "PRIVATE";
	waitUntil {!isNil "posHQ"};
	player setPos posHQ;
	[true] execVM "reinitY.sqf";
	if (not([player] call isMember)) then
		{
		if (serverCommandAvailable "#logout") then
			{
			miembros pushBack (getPlayerUID player);
			publicVariable "miembros";
			hint "You are not in the member's list, but as you are Server Admin, you have been added up. Welcome!"
			}
		else
			{
			hint "Welcome Guest\n\nYou have joined this server as guest";
			caja addEventHandler ["ContainerOpened",
	            {
	            _jugador = _this select 1;
	            if (not([_jugador] call isMember)) then
	                {
	                _jugador setPos position petros;
	                hint "You are not in the Member's List of this Server.\n\nAsk the Commander in order to be allowed to access the HQ Ammobox.\n\nIn the meantime you may use the other box to store equipment and share it with others.";
	                };
	            }
        	];
			};
		};
	if ((count playableUnits == 1) and ([player] call isMember)) then
		{
		[player] call stavrosInit;
		};
	{
	if (_x isKindOf "FlagCarrier") then
		{
		_marcador = [marcadores,getPos _x] call BIS_fnc_nearestPosition;
		if ((not(_marcador in colinas)) and (not(_marcador in controles))) then
			{
			if (_marcador in mrkAAF) then
				{
				_x addAction ["Take the Flag", {[[_this select 0, _this select 1],"mrkWIN"] call BIS_fnc_MP;},nil,0,false,true];
				}
			else
				{
				_flag addAction ["Unit Recruitment", {nul=[] execVM "Dialogs\unit_recruit.sqf";;},nil,0,false,true];
				_flag addAction ["Buy Vehicle", {nul= [] execVM "Dialogs\buy_vehicle.sqf";},nil,0,false,true];
				};
			};
		};
	} forEach vehicles - [bandera,fuego,caja,cajaVeh];
	{
	if (typeOf _x == "b_g_survivor_F") then
		{
		if (!isPlayer (leader group _x)) then
			{
			_x addAction ["Order Refugee to follow me", "AI\liberaterefugee.sqf",nil,0,false,true];
			};
		};
	} forEach allUnits;
	if (petros == leader group petros) then
		{
		removeAllActions petros;
		petros addAction ["Mission Request", {nul=CreateDialog "mission_menu";},nil,0,false,true];
		}
	else
		{
		removeAllActions petros;
		petros addAction ["Build HQ here", {[] spawn buildHQ},nil,0,false,true];
		};
	if ((player == stavros) and (isNil "placementDone") and (isMultiplayer)) then
		{
		_nul = [] execVM "Dialogs\initMenu.sqf";
		if (backpack player == "tf_rt1523g_sage") then
			{
			[caja,["tf_rt1523g_sage"],true] call BIS_fnc_addVirtualBackpackCargo;
			unlockedBackpacks pushBack "tf_rt1523g_sage";
	  		publicVariable "unlockedBackpacks";
	   		};
		}
	else
		{
		_nul = [true] execVM "Dialogs\firstLoad.sqf";
		};
	diag_log "Antistasi MP Client. JIP client finished";
	}
else
	{
	if (isNil "placementDone") then
		{
		if (player == stavros) then
		    {
		    if (isMultiplayer) then
		    	{
		    	HC_comandante synchronizeObjectsAdd [player];
				player synchronizeObjectsAdd [HC_comandante];
		    	_nul = [] execVM "Dialogs\initMenu.sqf";
		    	if (backpack player == "tf_rt1523g_sage") then
		    		{
		    		[caja,["tf_rt1523g_sage"],true] call BIS_fnc_addVirtualBackpackCargo;
		    		unlockedBackpacks pushBack "tf_rt1523g_sage";
		    		publicVariable "unlockedBackpacks";
		    		};
		    	diag_log "Antistasi MP Client. Client finished";
		    	}
		    else
		    	{
		    	miembros = [];
		    	 _nul = [] execVM "Dialogs\firstLoad.sqf";
		    	};
		    };
		};
	};
waitUntil {scriptDone _titulo};

_texto = [];

if (hayTFAR) then
	{
	_texto = ["TFAR Detected\n\nAntistasi detects TFAR in the server config.\nAll players will start with TFAR default radios.\nDefault revive system will shut down radios while players are inconscious.\n\n"];
	};
if (hayACE) then
	{
	_texto = _texto + ["ACE Medical Detected\n\nAntistasi detects ACE medical module installed in the mission.\nThis will disable default revive system and use ACE instead."];
	};
if (hayRHS) then
	{
	_texto = _texto + ["RHS-AFRF Detected\n\nAntistasi detects RHS - AFRF in the server config.\nAAF and Ammoboxes will spawn with weapons and ammo from this Mod.\n\nRecruited AI will count with RHS as basic weapons"];
	};

if (hayTFAR or hayACE or hayRHS) then
	{
	//hint format ["%1",_texto]
	[_texto] spawn
		{
		sleep 0.5;
		_texto = _this select 0;
		"Integrated Mods Detected" hintC _texto;
		hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
			0 = _this spawn {
				_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
				hintSilent "";
			};
			}];
		};
	};

statistics = [] execVM "statistics.sqf";
removeAllActions caja;
_action = caja addaction [localize "STR_A3_Arsenal",
	{
	/*if (!inventario) then
		{*/
		_box = _this select 0;
		_unit = _this select 1;
		[caja,unlockedItems] call BIS_fnc_addVirtualItemCargo;
		[caja,unlockedMagazines] call BIS_fnc_addVirtualMagazineCargo;
		[caja,unlockedWeapons] call BIS_fnc_addVirtualWeaponCargo;
		[caja,unlockedBackpacks] call BIS_fnc_addVirtualBackpackCargo;
		_backpack = backpack _unit;

		if ( _backpack != "" ) then
			{
			_inScope = false;
			{
			if ( isNumber( configFile >> "CfgVehicles" >> _backpack >> _x ) && { getNumber( configFile >> "CfgVehicles" >> _backpack >> _x ) isEqualTo 2 } ) exitWith { true };
			}forEach [ "scope", "scopearsenal" ];
			if !( _inScope ) then
				{
				missionNamespace setVariable [ "bis_fnc_arsenal_data", nil ];
				["Preload"] call BIS_fnc_arsenal;
				_tmpWhitelistBackpacks = ( missionNamespace getVariable "bis_fnc_arsenal_data" ) select 5;
				_tmpWhitelistBackpacks pushBack _backpack;
				};
			};
		["Open",[nil,_box,_unit]] call bis_fnc_arsenal;
		//};
	},
	[],
	6,
	true,
	false,
	"",
	"
	_cargo = _target getvariable ['bis_addVirtualWeaponCargo_cargo',[[],[],[],[]]];
	if ({count _x > 0} count _cargo == 0) then
		{
		_target removeaction (_target getvariable ['bis_fnc_arsenal_action',-1]);
		_target setvariable ['bis_fnc_arsenal_action',nil];
		};
	_condition = _target getvariable ['bis_fnc_arsenal_condition',{true}];
	alive _target && {_target distance _this < 5} && {call _condition}
	"
	];
caja setvariable ["bis_fnc_arsenal_action",_action];
caja addAction ["Transfer Vehicle cargo to Ammobox", "Municion\vaciar.sqf"];
caja addAction ["Move this asset", "moveHQObject.sqf",nil,0,false,true,"","(_this == stavros)"];
/*
inventario = false;
player addEventHandler ["InventoryOpened",
	{
	_control = false;
	if !(isnull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])) then
		{
		_control = true;
		hint "You cannot access the Arsenal while opening another inventory";
		};
	inventario = true;
	_control
	}];
player addEventHandler ["InventoryClosed",
	{
	inventario = false;
	}];
