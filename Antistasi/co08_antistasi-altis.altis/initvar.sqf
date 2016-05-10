//Antistasi var settings
//If some setting can be modified it will be commented with a // after it.
//Make changes at your own risk!!
//You do not have enough balls to make any modification and after making a Bug report because something is wrong. You don't wanna be there. Believe me.
//Not commented lines cannot be changed.
//Don't touch them.
antistasiVersion = "v 0.21.0 Alpha";

debug = false;//debug variable, not useful for everything..

cleantime = 900;//time to delete dead bodies, vehicles etc..
distanciaSPWN = 1200;//initial spawn distance. Less than 1Km makes parked vehicles spawn in your nose while you approach.
musicON = true;
civPerc = 0.2;//initial % civ spawn rate
posHQ = getMarkerPos "respawn_west";
minefieldMrk = [];
staticsToSave = [];
minimoFPS = 15;//initial FPS minimum.
destroyedCities = [];
autoHeal = false;
allowPlayerRecruit = true;
recruitCooldown = 0;
AAFpatrols = 0;//0
planesAAFcurrent = 0;
helisAAFcurrent = 0;
APCAAFcurrent = 0;
tanksAAFcurrent= 0;

arrayCivs = ["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F","C_scientist_F","C_Orestes","C_Nikos","C_Nikos_aged"];//array of possible civs. Only euro types picked (this is Greece). Add any civ classnames you wish here
arrayCivVeh =["C_Hatchback_01_F","C_Hatchback_01_sport_F","C_Offroad_01_F","C_SUV_01_F","C_Van_01_box_F","C_Van_01_fuel_F","C_Van_01_transport_F"];//possible civ vehicles. Add any mod classnames you wish here
gruposAAFsmall = ["HAF_InfSentry","HAF_InfSentry","HAF_InfSentry","HAF_SniperTeam"];
gruposAAFmid = ["HAF_InfTeam_AA","HAF_InfTeam_AT","HAF_InfTeam","HAF_InfTeam","HAF_InfTeam"];
gruposFIAmid = ["IRG_InfTeam","IRG_InfTeam_AA","IRG_InfTeam_AT"];
vehAAFland = ["I_APC_tracked_03_cannon_F","I_MBT_03_cannon_F","I_APC_Wheeled_03_cannon_F","I_MRAP_03_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F","I_Truck_02_fuel_F","I_Truck_02_medical_F","I_Truck_02_box_F","I_Truck_02_ammo_F","I_Truck_02_covered_F"];
vehAAFAT = ["I_Truck_02_covered_F"];
vehAAFnormal = ["I_MRAP_03_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F","I_Truck_02_fuel_F","I_Truck_02_medical_F","I_Truck_02_box_F","I_Truck_02_ammo_F","I_Truck_02_covered_F"];//all cars and trucks from AAF. Add your mod vehicles here, but they will only spawn in bases or airports, not used in convoys or attacks.
//planesAAF = ["I_Heli_Transport_02_F","I_Heli_light_03_F","I_Heli_light_03_unarmed_F","I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"];
planesAAF = ["I_Heli_Transport_02_F","I_Heli_light_03_unarmed_F"];
planesCSAT = ["O_Heli_Light_02_unarmed_F","O_Heli_Attack_02_F"];
planesNATO = ["B_Heli_Light_01_F","B_Heli_Light_01_armed_F","B_Heli_Attack_01_F","B_Heli_Transport_01_camo_F","B_Plane_CAS_01_F","B_Heli_Transport_03_F"];
planesNATOTrans = ["B_Heli_Light_01_F","B_Heli_Transport_01_camo_F","B_Heli_Transport_03_F"];
vehNATO = ["B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_CRV_F","B_APC_Tracked_01_AA_F","B_MBT_01_cannon_F","B_MBT_01_arty_F","B_MBT_01_mlrs_F","B_MRAP_01_F","B_MRAP_01_hmg_F","B_Truck_01_covered_F","B_Truck_01_fuel_F","B_Truck_01_medical_F","B_APC_Wheeled_01_cannon_F","B_MBT_01_TUSK_F"];//all vehicles from NATO. Add your mod vehicles here, but they will only spawn in bases or airports, and players wont be able to mount them.
listMilBld = ["Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F","Land_Cargo_HQ_V1_F","Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V3_F","Land_Cargo_Patrol_V1_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V3_F","Land_HelipadSquare_F"];
listbld = ["Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"];
lamptypes = ["Lamps_Base_F", "PowerLines_base_F","Land_LampDecor_F","Land_LampHalogen_F","Land_LampHarbour_F","Land_LampShabby_F","Land_NavigLight","Land_runway_edgelight","Land_PowerPoleWooden_L_F"];
arrayids = ["Anthis","Costa","Dimitirou","Elias","Gekas","Kouris","Leventis","Markos","Nikas","Nicolo","Panas","Rosi","Samaras","Thanos","Vega"];
if (isMultiplayer) then {arrayids = arrayids + ["protagonista"]};
armasAAF = ["arifle_TRG21_F","arifle_TRG21_GL_F","srifle_GM6_F","LMG_Mk200_F","Binocular","launch_NLAW_F","srifle_DMR_06_olive_F","srifle_EBR_F"];//possible weapons that spawn in AAF ammoboxes
antitanqueAAF = ["launch_I_Titan_F","launch_I_Titan_short_F"];//possible Titan weapons that spawn in AAF ammoboxes
MantitanqueAAF = ["Titan_AT", "Titan_AP", "Titan_AA"];//possible Titan rockets that spawn in AAF ammoboxes
municionAAF = ["200Rnd_65x39_cased_Box","30Rnd_556x45_Stanag","5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag","6Rnd_45ACP_Cylinder","NLAW_F","1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","UGL_FlareGreen_F","1Rnd_Smoke_Grenade_shell","3Rnd_HE_Grenade_shell","HandGrenade","20Rnd_762x51_Mag","9Rnd_45ACP_Mag","30Rnd_9x21_Mag","SmokeShell","Laserbatteries"];//possible magazines that spawn in AAF ammoboxes
minasAAF = ["SLAMDirectionalMine_Wire_Mag","SatchelCharge_Remote_Mag","ClaymoreDirectionalMine_Remote_Mag", "ATMine_Range_Mag","APERSTripMine_Wire_Mag","APERSMine_Range_Mag", "APERSBoundingMine_Range_Mag"];//possible mines that spawn in AAF ammoboxes
itemsAAF = ["FirstAidKit","Medikit","MineDetector","NVGoggles","ToolKit","muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_B","muzzle_snds_H_MG","muzzle_snds_acp","bipod_03_F_oli","muzzle_snds_338_green","muzzle_snds_93mmg_tan","acc_flashlight","Rangefinder","Laserdesignator","ItemGPS","ItemRadio","acc_pointer_IR"];//possible items that spawn in AAF ammoboxes
opticasAAF = ["optic_DMS","optic_LRPS","optic_tws","optic_tws_mg","optic_NVS","optic_Nightstalker","optic_MRCO","optic_SOS","optic_Hamr","optic_Arco","optic_KHS_old","optic_Holosight","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight_smg"];//possible optics that spawn in AAF ammoboxes
armasNATO = ["arifle_MX_F","arifle_MX_GL_F","arifle_MX_SW_F","srifle_EBR_F","srifle_LRR_F","srifle_DMR_03_F","srifle_DMR_02_F","MMG_02_sand_F","arifle_MXM_F","SMG_01_F"];//possible weapons that spawn in NATO ammoboxes
municionNATO = ["30Rnd_65x39_Caseless_mag","30Rnd_65x39_caseless_mag_Tracer","100Rnd_65x39_Caseless_mag","100Rnd_65x39_caseless_mag_Tracer","20Rnd_762x51_Mag","7Rnd_408_Mag","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_tracer_green","11Rnd_45ACP_Mag","1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","UGL_FlareGreen_F","1Rnd_Smoke_Grenade_shell","3Rnd_HE_Grenade_shell","HandGrenade","20Rnd_762x51_Mag","10Rnd_338_Mag","130Rnd_338_Mag"];//possible ammo that spawn in NATO ammoboxes
soldadosFIA = ["B_G_Soldier_F","B_G_Soldier_lite_F","b_g_soldier_unarmed_f","B_G_Soldier_AR_F","B_G_medic_F","B_G_engineer_F","B_G_Soldier_exp_F","B_G_Soldier_GL_F","B_G_Soldier_TL_F","B_G_Soldier_A_F","B_G_Soldier_M_F","B_G_Soldier_LAT_F","B_G_Soldier_SL_F","B_G_officer_F","B_G_Sharpshooter_F"];
soldadosAAF = ["I_Soldier_02_F","I_Soldier_03_F","I_Soldier_04_F","I_soldier_F","I_Soldier_lite_F","I_Soldier_AAR_F","I_crew_F","I_Soldier_A_F","I_Soldier_GL_F","I_Soldier_AR_F","I_Soldier_SL_F","I_Soldier_TL_F","I_Soldier_M_F","I_medic_F","I_Soldier_repair_F","I_Soldier_exp_F","I_engineer_F","I_helicrew_F","I_Spotter_F","I_Soldier_AAR_F","I_Soldier_AAT_F","I_Soldier_AAA_F","I_support_MG_F","I_UAV_AI","I_Soldier_LAT_F","I_Soldier_AT_F","I_Soldier_AA_F","I_helipilot_F","I_pilot_F","I_officer_F","I_Sniper_F","I_G_Sharpshooter_F"];
vehFIA = ["B_G_Quadbike_01_F","B_G_Offroad_01_armed_F","B_HMG_01_high_F","B_G_Offroad_01_F","B_G_Van_01_transport_F","B_G_Boat_Transport_01_F","B_G_Mortar_01_F","B_static_AT_F","B_static_AA_F"];
cascos = ["H_HelmetB","H_HelmetB_camo","H_HelmetB_paint","H_HelmetB_light","H_HelmetB_plain_mcamo","H_HelmetB_plain_blk","H_HelmetSpecB","H_HelmetSpecB_paint1","H_HelmetSpecB_paint2","H_HelmetSpecB_blk","H_HelmetIA","H_HelmetIA_net","H_HelmetIA_camo","H_HelmetB_grass","H_HelmetB_snakeskin","H_HelmetB_desert","H_HelmetB_black","H_HelmetB_sand","H_HelmetB_sand","H_HelmetCrew_O","H_HelmetCrew_I","H_PilotHelmetFighter_B","H_PilotHelmetFighter_O","H_PilotHelmetFighter_I","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O","H_PilotHelmetHeli_I","H_CrewHelmetHeli_B","H_CrewHelmetHeli_O","H_CrewHelmetHeli_I","H_HelmetO_ocamo","H_HelmetLeaderO_ocamo","H_HelmetB_light_grass","H_HelmetB_light_snakeskin","H_HelmetB_light_desert","H_HelmetB_light_black","H_HelmetB_light_sand","H_HelmetO_oucamo","H_HelmetLeaderO_oucamo","H_HelmetSpecO_ocamo","H_HelmetSpecO_blk","H_HelmetSpecO_blk"];
lockedMochis = ["B_AssaultPack_khk","B_AssaultPack_dgtl","B_AssaultPack_rgr","B_AssaultPack_sgg","B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_mcamo","B_Kitbag_mcamo","B_Kitbag_sgg","B_Kitbag_cbr","B_Bergen_sgg","B_Bergen_mcamo","B_Bergen_rgr","B_Bergen_blk","B_FieldPack_blk","B_FieldPack_ocamo","B_FieldPack_oucamo","B_FieldPack_cbr","B_Carryall_ocamo","B_Carryall_mcamo","B_Carryall_oli","B_Carryall_khk","B_Carryall_cbr","B_OutdoorPack_blk","B_OutdoorPack_tan","B_OutdoorPack_blu","B_HuntingBackpack","B_Static_Designator_01_weapon_F","B_UAV_01_backpack_F","I_AA_01_weapon_F","B_AA_01_weapon_F","B_AT_01_weapon_F","I_HMG_01_high_weapon_F","I_Mortar_01_support_F","B_Mortar_01_support_F","I_HMG_01_support_high_F","B_HMG_01_support_high_F","I_Mortar_01_weapon_F","B_Mortar_01_weapon_F","B_HMG_01_support_F"];//possible backpacks that CAN be added to the arsenal.
staticMochis = ["B_Static_Designator_01_weapon_F","B_UAV_01_backpack_F","I_AA_01_weapon_F","B_AA_01_weapon_F","B_AT_01_weapon_F","I_HMG_01_high_weapon_F","I_Mortar_01_support_F","B_Mortar_01_support_F","I_HMG_01_support_high_F","B_HMG_01_support_high_F","I_Mortar_01_weapon_F","B_Mortar_01_weapon_F"];
_vests = ["V_HarnessO_brn","V_HarnessO_gry","V_HarnessOGL_brn","V_HarnessOGL_gry","V_HarnessOSpec_brn","V_HarnessOSpec_gry","V_PlateCarrier1_blk","V_PlateCarrier1_rgr","V_PlateCarrier2_rgr","V_PlateCarrier3_rgr","V_PlateCarrier3_rgr","V_PlateCarrierIA1_dgtl","V_TacVest_brn","V_PlateCarrierIA2_dgtl","V_PlateCarrierIAGL_dgtl","V_PlateCarrierSpec_rgr","V_TacVest_blk","V_TacVest_camo","V_TacVest_khk","V_TacVest_oli","V_TacVestCamo_khk","V_TacVestIR_blk","V_RebreatherIA","G_I_Diving","V_PlateCarrierIAGL_oli","V_Chestrig_oli"];//possible vests that CAN be added to the arsenal.
civUniforms = ["U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_redwhite","U_C_Commoner1_1","U_C_Commoner1_2","U_C_Commoner1_3","U_Rangemaster","U_NikosBody","U_C_Poor_1","U_C_Poor_2","U_C_WorkerCoveralls","U_C_Poor_shorts_1","U_C_Commoner_shorts","U_C_ShirtSurfer_shorts","U_C_TeeSurfer_shorts_1","U_C_TeeSurfer_shorts_2"];
//allMagazines = MantitanqueAAF + municionAAF + municionNATO;


//All weapons, MOD ones included, will be added to this arrays, but it's useless without integration, as if those weapons don't spawn, players won't be able to collect them, and after, unlock them in the arsenal.
allMagazines = [];
_cfgmagazines = configFile >> "cfgmagazines";
for "_i" from 0 to (count _cfgMagazines) -1 do
	{
	_magazine = _cfgMagazines select _i;
	if (isClass _magazine) then
		{
		_nombre = configName (_magazine);
		allMagazines pushBack _nombre;
		};
	};

arifles = [];
srifles = [];
mguns = [];
hguns = [];
mlaunchers = [];
rlaunchers = [];

hayRHS = false;

lockedWeapons = ["Rangefinder","Laserdesignator"];

_allPrimaryWeapons = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 1 } } )
" configClasses ( configFile >> "cfgWeapons" );

_allHandGuns = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 2 } } )
" configClasses ( configFile >> "cfgWeapons" );

_allLaunchers = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 4 } } )
" configClasses ( configFile >> "cfgWeapons" );

{
_nombre = configName _x;
_nombre = [_nombre] call BIS_fnc_baseWeapon;
if (not(_nombre in lockedWeapons)) then
	{
	lockedWeapons pushBack _nombre;
	_weapon = [_nombre] call BIS_fnc_itemType;
	_weaponType = _weapon select 1;
	switch (_weaponType) do
		{
		case "AssaultRifle": {arifles pushBack _nombre};
		case "MachineGun": {mguns pushBack _nombre};
		case "SniperRifle": {srifles pushBack _nombre};
		case "Handgun": {hguns pushBack _nombre};
		case "MissileLauncher": {mlaunchers pushBack _nombre};
		case "RocketLauncher": {rlaunchers pushBack _nombre};
		};

	};
} forEach _allPrimaryWeapons + _allHandGuns + _allLaunchers;
//rhs detection and integration
if ("rhs_weap_akms" in lockedWeapons) then
	{
	hayRHS = true;
	armasAAF = armasAAF + ["rhs_weap_rpg7","rhs_weap_pkm", "rhs_weap_svdp_wd", "rhs_weap_ak74m_gp25","rhs_weap_akms_gp25","hgun_PDW2000_F","hgun_ACPC2_F"];
	municionAAF = municionAAF + ["rhs_100Rnd_762x54mmR","rhs_rpg7_PG7VR_mag","rhs_rpg7_PG7VL_mag","rhs_30Rnd_545x39_AK","rhs_mag_rgd5","rhs_VOG25","rhs_30Rnd_762x39mm","rhs_10Rnd_762x54mmR_7N1","9Rnd_45ACP_Mag","30Rnd_9x21_Mag"];
	opticasAAF = opticasAAF + ["rhs_acc_1pn93_1","rhs_acc_1pn93_2","rhs_acc_pgo7v","rhs_acc_1p29","rhs_acc_pso1m2"];
	itemsAAF = itemsAAF + ["rhs_acc_dtk1l","rhs_acc_pbs1","rhs_acc_tgpa"] + ["rhs_acc_1pn93_1","rhs_acc_1pn93_2","rhs_acc_pgo7v","rhs_acc_1p29","rhs_acc_pso1m2"];
	};
//publicVariable "hayRHS";

injuredSounds =
[
	"a3\sounds_f\characters\human-sfx\Person0\P0_moan_13_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_14_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_15_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_16_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_17_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_18_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_20_words.wss",
	"a3\sounds_f\characters\human-sfx\Person1\P1_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_20_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_21_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_22_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_23_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_24_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_25_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_26_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_27_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_28_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_29_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_30_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_31_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_32_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_33_words.wss",
	"a3\sounds_f\characters\human-sfx\Person2\P2_moan_19_words.wss"
];

missionPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;

ladridos = ["Music\dog_bark01.wss", "Music\dog_bark02.wss", "Music\dog_bark03.wss", "Music\dog_bark04.wss", "Music\dog_bark05.wss","Music\dog_maul01.wss","Music\dog_yelp01.wss","Music\dog_yelp02.wss","Music\dog_yelp03.wss"];

if (!isServer and hasInterface) exitWith {};

AAFpatrols = 0;//0
skillAAF = 0;
smallCAmrk = [];
smallCApos = [];
revelar = false;
/*
AAFaimingAccuracy = 0.13;//0.23
AAFspotDistance = 0.2;//0.6
AAFspotTime = 0.3;//0.7
AAFcourage= 0.2;//0.50
AAFcommanding= 0.30;//0.60
AAFaimingShake=0.20;//0.4
AAFaimingSpeed=0.30;//0.6
AAFreloadSpeed=0.40;//0.9
*/
//Pricing values for soldiers, vehicles
if (!isServer) exitWith {};

{server setVariable [_x,50,true]} forEach ["B_G_Soldier_F","B_G_Soldier_lite_F","b_g_soldier_unarmed_f"];
{server setVariable [_x,100,true]} forEach ["B_G_Soldier_AR_F","B_G_medic_F","B_G_engineer_F","B_G_Soldier_exp_F","B_G_Soldier_GL_F","B_G_Soldier_TL_F","B_G_Soldier_A_F"];
{server setVariable [_x,150,true]} forEach ["B_G_Soldier_M_F","B_G_Soldier_LAT_F","B_G_Soldier_SL_F","B_G_officer_F","B_G_Sharpshooter_F"];
{server setVariable [_x,100,true]} forEach ["I_Soldier_02_F","I_Soldier_03_F","I_Soldier_04_F","I_soldier_F","I_Soldier_lite_F","I_Soldier_AAR_F","I_crew_F","O_crew_F","C_man_1"];
{server setVariable [_x,150,true]} forEach ["I_Soldier_A_F","I_Soldier_GL_F","I_Soldier_AR_F","I_Soldier_SL_F","I_Soldier_TL_F","I_Soldier_M_F","I_medic_F","I_Soldier_repair_F","I_Soldier_exp_F","I_engineer_F","I_helicrew_F","I_Spotter_F","I_Soldier_AAR_F","I_Soldier_AAT_F","I_Soldier_AAA_F","I_support_MG_F","I_UAV_AI"];
{server setVariable [_x,200,true]} forEach ["I_Soldier_SL_F","I_Soldier_LAT_F","I_Soldier_AT_F","I_Soldier_AA_F","I_helipilot_F","I_pilot_F","I_officer_F","I_Sniper_F","I_G_Sharpshooter_F"];

server setVariable ["C_Offroad_01_F",200,true];//200
server setVariable ["C_Van_01_transport_F",600,true];//600
server setVariable ["C_Heli_Light_01_civil_F",12000,true];//12000
server setVariable ["B_G_Quadbike_01_F",100,true];//100
server setVariable ["B_G_Offroad_01_F",200,true];//200
server setVariable ["B_G_Van_01_transport_F",300,true];//300
server setVariable ["B_G_Offroad_01_armed_F",700,true];//700
{server setVariable [_x,400,true]} forEach ["B_HMG_01_high_F","B_G_Boat_Transport_01_F"];//400
{server setVariable [_x,800,true]} forEach ["B_G_Mortar_01_F","B_static_AT_F","B_static_AA_F"];//800
server setVariable ["hr",8,true];//initial HR value
server setVariable ["resourcesFIA",1000,true];//Initial FIA money pool value
server setVariable ["resourcesAAF",0,true];//Initial AAF resources
server setVariable ["skillFIA",0,true];//Initial skill level for FIA soldiers
server setVariable ["prestigeNATO",5,true];//Initial Prestige NATO
server setVariable ["prestigeCSAT",5,true];//Initial Prestige CSAT
prestigeOPFOR = 50;//Initial % support for AAF on each city
if (not cadetMode) then {prestigeOPFOR = 75};//if you play on vet, this is the number
prestigeBLUFOR = 0;//Initial % FIA support on each city
planesAAFmax = 0;
helisAAFmax = 0;
APCAAFmax = 0;
tanksAAFmax = 0;
cuentaCA = 600;//600
lastIncome = 0;
prestigeIsChanging = false;
cityIsSupportChanging = false;
resourcesIsChanging = false;
//The following are the initial weapons and mags unlocked and available in the Arsenal, vanilla or RHS
if (!hayRHS) then
    {
    unlockedWeapons = ["hgun_PDW2000_F","hgun_ACPC2_F","Binocular"];
    unlockedRifles = ["hgun_PDW2000_F"];//standard rifles for AI riflemen, medics engineers etc. are picked from this array. Add only rifles.
    unlockedMagazines = ["9Rnd_45ACP_Mag","30Rnd_9x21_Mag"];
    }
else
    {
    unlockedWeapons = ["rhs_weap_akms","rhs_weap_makarov_pmm","Binocular"];
    unlockedRifles = ["rhs_weap_akms"];//standard rifles for AI riflemen, medics engineers etc. are picked from this array. Add only rifles.
    unlockedMagazines = ["rhs_30Rnd_762x39mm","rhs_mag_9x18_12_57N181S"];
    };
unlockedItems = ["ItemMap","ItemWatch","ItemCompass","FirstAidKit","Medikit","ToolKit","U_BG_Guerilla1_1","U_BG_Guerilla2_1","U_BG_Guerilla2_2","U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_BG_Guerilla3_2","U_BG_leader","H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_grn","H_Booniehat_dirty","H_Cap_oli","H_Cap_blk","H_MilCap_rucamo","H_MilCap_gry","H_BandMask_blk","H_Bandanna_khk","H_Bandanna_gry","H_Bandanna_camo","H_Shemag_khk","H_Shemag_tan","H_Shemag_olive","H_ShemagOpen_tan","H_Beret_grn","H_Beret_grn_SF","H_Watchcap_camo","H_TurbanO_blk","H_Hat_camo","H_Hat_tan","H_Beret_blk","H_Beret_red","H_Beret_02","H_Watchcap_khk","G_Balaclava_blk","G_Balaclava_combat","G_Balaclava_lowprofile","G_Balaclava_oli","G_Bandanna_beast","G_Tactical_Black","G_Aviator","G_Shades_Black","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_salmon","U_C_Poloshirt_tricolour","U_C_Poor_1","U_Rangemaster","U_NikosBody","U_IG_Guerilla3_2","U_OG_Guerilla2_1","U_IG_Guerilla1_1","U_I_G_Story_Protagonist_F","U_I_G_resistanceLeader_F","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_redwhite","U_C_Commoner1_1","U_C_Commoner1_2","U_C_Commoner1_3","U_Rangemaster","U_NikosBody","U_C_Poor_1","U_C_Poor_2","U_C_WorkerCoveralls","U_C_Poor_shorts_1","U_C_Commoner_shorts","U_C_ShirtSurfer_shorts","U_C_TeeSurfer_shorts_1","U_C_TeeSurfer_shorts_2"];//Initial Arsenal available items
unlockedBackpacks = ["B_Carryall_oucamo"];//Initial Arsenal available backpacks
unlockedOptics = [];
garageIsUsed = false;
vehInGarage = [];
destroyedBuildings = []; publicVariable "destroyedBuildings";
reportedVehs = [];
hayTFAR = false;
hayACE = false;
//TFAR detection and config.
if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then
    {
    hayTFAR = true;
    unlockedItems = unlockedItems + ["tf_microdagr","tf_anprc152"];//making this items Arsenal available.
    tf_no_auto_long_range_radio = true; publicVariable "tf_no_auto_long_range_radio";//set to false and players will start with LR radio, uncomment the last line of so.
	//tf_give_personal_radio_to_regular_soldier = false;
	tf_west_radio_code = "";publicVariable "tf_west_radio_code";//to make enemy vehicles usable as LR radio
	tf_east_radio_code = tf_west_radio_code; publicVariable "tf_east_radio_code"; //to make enemy vehicles usable as LR radio
	tf_guer_radio_code = tf_west_radio_code; publicVariable "tf_guer_radio_code";//to make enemy vehicles usable as LR radio
	tf_same_sw_frequencies_for_side = true; publicVariable "tf_same_sw_frequencies_for_side";
	tf_same_lr_frequencies_for_side = true; publicVariable "tf_same_lr_frequencies_for_side";
    //unlockedBackpacks pushBack "tf_rt1523g_sage";//uncomment this if you are adding LR radios for players
    };
//ACE detection and ACE item availability in Arsenal
if (!isNil "ace_medical_level") then
    {
    unlockedItems = unlockedItems + ["ACE_EarPlugs","ACE_RangeCard","ACE_Clacker","ACE_M26_Clacker","ACE_DeadManSwitch","ACE_DefusalKit","ACE_MapTools","ACE_Flashlight_MX991","ACE_Sandbag_empty","ACE_wirecutter","ACE_SpraypaintBlue","ACE_SpraypaintGreen","ACE_SpraypaintRed","ACE_SpraypaintBlack"];
    itemsAAF = itemsAAF + ["ACE_Kestrel4500","ACE_ATragMX"];
    armasNATO = armasNATO + ["ACE_M84"];
    hayACE = true;
    if (ace_medical_level != 0) then
    	{
    	unlockedItems = unlockedItems + ["ACE_atropine","ACE_fieldDressing","ACE_quikclot","ACE_bloodIV_250","ACE_epinephrine","ACE_morphine","ACE_personalAidKit","ACE_plasmaIV_250","ACE_salineIV_250","ACE_tourniquet","ACE_elasticBandage","ACE_packingBandage"];
    	};
   };


allItems = itemsAAF + opticasAAF + _vests + cascos;

if (worldName == "Altis") then
	{
	{server setVariable [_x select 0,_x select 1]} forEach [["Therisa",154],["Zaros",371],["Poliakko",136],["Katalaki",95],["Alikampos",115],["Neochori",309],["Stavros",122],["Lakka",173],["AgiosDionysios",84],["Panochori",264],["Topolia",33],["Ekali",9],["Pyrgos",531],["Orino",45],["Neri",242],["Kore",133],["Kavala",660],["Aggelochori",395],["Koroni",32],["Gravia",291],["Anthrakia",143],["Syrta",151],["Negades",120],["Galati",151],["Telos",84],["Charkia",246],["Athira",342],["Dorida",168],["Ifestiona",48],["Chalkeia",214],["AgiosKonstantinos",39],["Abdera",89],["Panagia",91],["Nifi",24],["Rodopoli",212],["Kalithea",36],["Selakano",120],["Frini",69],["AgiosPetros",11],["Feres",92],["AgiaTriada",8],["Paros",396],["Kalochori",189],["Oreokastro",63],["Ioannina",48],["Delfinaki",29],["Sofia",179],["Molos",188]];
	call compile preprocessFileLineNumbers "roadsDB.sqf";
	};

publicVariable "unlockedWeapons";
publicVariable "unlockedRifles";
publicVariable "unlockedItems";
publicVariable "unlockedOptics";
publicVariable "unlockedBackpacks";
publicVariable "unlockedMagazines";
publicVariable "miembros";
publicVariable "garageIsUsed";
publicVariable "vehInGarage";
publicVariable "reportedVehs";
publicVariable "hayACE";
publicVariable "hayTFAR";

if (isMultiplayer) then {[[petros,"hint","Variables Init Completed"],"commsMP"] call BIS_fnc_MP;};