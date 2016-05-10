if (!isMultiplayer) exitWith {};
if (!(isNil "serverInitDone")) exitWith {};
diag_log "Antistasi MP Server init";
_nul = call compile preprocessFileLineNumbers "initVar.sqf";
initVar = true; publicVariable "initVar";
diag_log format ["Antistasi MP. InitVar done. Version: %1",antistasiVersion];
_nul = call compile preprocessFileLineNumbers "initFuncs.sqf";
diag_log "Antistasi MP Server. Funcs init finished";
_nul = call compile preprocessFileLineNumbers "initZones.sqf";
diag_log "Antistasi MP Server. Zones init finished";
_nul= call compile preprocessFileLineNumbers "initPetros.sqf";

waitUntil {(count playableUnits) > 0};
waitUntil {({(isPlayer _x) and (!isNull _x) and (_x == _x)} count allUnits) == (count playableUnits)};//ya estamos todos
_nul = [] execVM "modBlacklist.sqf";

if (isNil "comandante") then {comandante = (playableUnits select 0)};
if (isNull comandante) then {comandante = (playableUnits select 0)};
{
if (_x!=comandante) then
    {
    _x setVariable ["score", 0,true];
    }
else
    {
    stavros = _x;
    publicVariable "stavros";
    _x setUnitRank "CORPORAL";
    _x setVariable ["score", 25,true];
    };
} forEach playableUnits;
diag_log "Antistasi MP Server. Players are in";

hcArray = [];

//{if (owner _x != owner server) then {hcArray pushBack _x}} forEach entities "HeadlessClient_F";

if (!isNil "HC1") then {hcArray pushBack HC1};
if (!isNil "HC2") then {hcArray pushBack HC2};
if (!isNil "HC3") then {hcArray pushBack HC3};

HCciviles = 2;
HCgarrisons = 2;
HCattack = 2;
if (count hcArray > 0) then
    {
    HCciviles = hcArray select 0;
    HCgarrisons = hcArray select 0;
    HCattack = hcArray select 0;
    diag_log "Antistasi MP Server. Headless Client 1 detected";
    if (count hcArray > 1) then
        {
        HCciviles = hcArray select 1;
        HCattack = hcArray select 1;
        diag_log "Antistasi MP Server. Headless Client 2 detected";
        if (count hcArray > 2) then
            {
            HCciviles = hcArray select 2;
            diag_log "Antistasi MP Server. Headless Client 3 detected";
            };
        };
    };

publicVariable "HCciviles";
publicVariable "HCgarrisons";
publicVariable "HCattack";
publicVariable "hcArray";
lockedWeapons = lockedWeapons - unlockedWeapons;
[caja,unlockedItems,true] call BIS_fnc_addVirtualItemCargo;
[caja,unlockedMagazines,true] call BIS_fnc_addVirtualMagazineCargo;
[caja,unlockedWeapons,true] call BIS_fnc_addVirtualWeaponCargo;
[caja,unlockedBackpacks,true] call BIS_fnc_addVirtualBackpackCargo;
diag_log "Antistasi MP Server. Arsenal config finished";
[[petros,"hint","Server Init Completed"],"commsMP"] call BIS_fnc_MP;

["Initialize"] call BIS_fnc_dynamicGroups;//Exec on Server
addMissionEventHandler ["HandleDisconnect",{[_this select 0] call onPlayerDisconnect;false}];

caja addEventHandler ["ContainerOpened",
    {
    _jugador = _this select 1;
    if (not([_jugador] call isMember)) then
        {
        _jugador setPos position petros;
        "You are not in the Member's List of this Server.\n\nAsk the Commander in order to be allowed to access the HQ Ammobox.\n\nIn the meantime you may use the other box to store equipment and share it with others." remoteExecCall ["hint", _jugador];
        };
    }
];
serverInitDone = true; publicVariable "serverInitDone";
diag_log "Antistasi MP Server. serverInitDone set to true.";

//Advanced Towing Script below
//Arma 3 - Antistasi by Barbolani
//Do whatever you want with this code, but credit me for the thousand hours spent making this.
enableSaving [ false, false ];
if (isServer and (isNil "serverInitDone")) then {skipTime random 24};

if (!isMultiPlayer) then
    {
    [] execVM "briefing.sqf";
    {if ((side _x == west) and (_x != comandante) and (_x != Petros) and (_x != server) and (_x!=garrison) and (_x != carreteras)) then {_grupete = group _x; deleteVehicle _x; deleteGroup _grupete}} forEach allUnits;
    _nul = [] execVM "musica.sqf";
    diag_log "Starting Antistasi SP";
    call compile preprocessFileLineNumbers "initVar.sqf";//this is the file where you can modify a few things.
    diag_log format ["Antistasi SP. InitVar done. Version: %1",antistasiVersion];
    call compile preprocessFileLineNumbers "initFuncs.sqf";
    diag_log "Antistasi SP. Funcs init finished";
    call compile preprocessFileLineNumbers "initZones.sqf";//this is the file where you can transport Antistasi to another island
    diag_log "Antistasi SP. Zones init finished";
    call compile preprocessFileLineNumbers "initPetros.sqf";
    lockedWeapons = lockedWeapons - unlockedWeapons;
    [caja,unlockedItems,true,false] call BIS_fnc_addVirtualItemCargo;
    [caja,unlockedMagazines,true,false] call BIS_fnc_addVirtualMagazineCargo;
    [caja,unlockedWeapons,true,false] call BIS_fnc_addVirtualWeaponCargo;
    [caja,unlockedBackpacks,true,false] call BIS_fnc_addVirtualBackpackCargo;
    HCciviles = 2;
    HCgarrisons = 2;
    HCattack = 2;
    hcArray = [HC1,HC2,HC3];
    serverInitDone = true;
    diag_log "Antistasi SP. serverInitDone is true. Arsenal loaded";
    _nul = [] execVM "modBlacklist.sqf";
    };

waitUntil {(!isNil "saveFuncsLoaded") and (!isNil "serverInitDone")};

if(isServer) then
    {
    _serverHasID = profileNameSpace getVariable ["ss_ServerID",nil];
    if(isNil "_serverHasID") then
        {
        _serverID = str(round((random(100000)) + random 10000));
        profileNameSpace setVariable ["SS_ServerID",_serverID];
        };
    serverID = profileNameSpace getVariable "ss_ServerID";
    publicVariable "serverID";

    waitUntil {!isNil "serverID"};
    waitUntil {!isNil "stavros"};
    waitUntil {isPlayer stavros};
    fpsCheck = [] execVM "fpsCheck.sqf";
    _nul = [caja] call cajaAAF;
    waitUntil {!(isNil "placementDone")};
    distancias = [] spawn distancias3;
    resourcecheck = [] execVM "resourcecheck.sqf";
    };
