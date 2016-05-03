/*
| Author: 
|
|	Quiksilver.
|_____
|
| Description: 
|	
|	Created: 26/11/2013.
|	Last modified:29/10/2014.
|	Coded for I&A and hosted on allfps.com.au servers.
|	You may use and edit the code.
|	You may not remove any entries from Credits without first removing the relevant author's contributions, 
|	or asking permission from the mission authors/contributors.
|	You may not remove the Credits tab, without consent of Ahoy World or allFPS.
| 	Feel free to re-format or make it look better.
|_____
|
| Usage: 
|	
|	Search below for the diary entries you would like to edit. 
|	DiarySubjects appear in descending order when player map is open.
|	DiaryRecords appear in ascending order when selected.
|_____
|
| Credit:
|
|	Invade & Annex 2.00 was developed by Rarek [ahoyworld.co.uk] with hundreds of hours of work 
|	The current version was developed by Quiksilver with hundreds more hours of work.
|	
|	Contributors: Razgriz33 [AW], Jester [AW], Kamaradski [AW], David [AW], chucky [allFPS].
|	
|	Please be respectful and do not remove credit.
|______________________________________________________________*/

if (!hasInterface) exitWith {};

waitUntil {!isNull player};

player createDiarySubject ["rules", "Rules"];
player createDiarySubject ["mods", "Mods"];
player createDiarySubject ["teamspeak", "Teamspeak"];
player createDiarySubject ["faq", "FAQ"];
player createDiarySubject ["changelog", "Change Log"];
player createDiarySubject ["credits", "Credits"];

//-------------------------------------------------- Rules

player createDiaryRecord ["rules",
[
"Enforcement",
"
<br />The purpose of the above rules are to ensure a fun and relaxing environment for public players.
<br />
<br />Server rules are in place merely as a means to that end.
<br />
<br />Guideline for enforcement:
<br />
<br />-	Innocent rule violation and disruptive behavior: 
<br />
<br />		= Verbal / Written request to cease, or warning.
<br /> 
<br />-	Minor or first-time rule violation:
<br />
<br />		= Kick, or 0 - 3 day ban.
<br />
<br />-	Serious or repetitive rule violation: 
<br />
<br />		= 3 - 7 day ban.
<br />
<br />-	Administrative ban (hack/exploit/verbal abuse/serious offense):
<br />
<br />		= permanent or 30 day.
<br />
<br />
<br />The above is subject to discretion.
"
]];

player createDiaryRecord ["rules",
[
"General",
"
<br />1. Hacking and mission exploitation will not be tolerated.
<br />2. Intentional team-killing will not be tolerated.
<br />3. Excessive, unintentional team-killing may result in a Kick/Temp ban.
<br />4. Unnecessary destruction of BLUFOR vehicles will not be tolerated.
<br />5. Verbal abuse and bullying will not be tolerated. 
<br />6. Firing a weapon on base--unless at an enemy--may result in a Kick/Temp ban.
<br />7. Griefing and obstructive play will not be tolerated.
<br />8. Excessive mic spamming, especially of Side and Global channels, will not be tolerated.
<br />9. A server moderator or admin's word is final.
<br />10. Landing inside of the main spawn may result in a warning or kick.
<br />
<br />If you see a player in violation of the above, contact a moderator or admin (teamspeak).
"
]];

//-------------------------------------------------- Mods

player createDiaryRecord ["mods",
[
"Serverside",
"
<br /> Mods currently running on server (subject to change without notice):<br /><br />

<br />- None at this time. 
"
]];

player createDiaryRecord ["mods",
[
"Mods Allowed",
"
<br /> Mods currently allowed (subject to change without notice):<br /><br />

<br />- CBA - 1.00 beta5 - Required to run the below mods.
		http://www.armaholic.com/page.php?id=18768<br /><br />
		
<br />- JSRS - 2.0 and 2.1 - Enhanced sounds and audio.
		http://www.armaholic.com/page.php?id=22150<br /><br />
		
<br />- Blastcore - R3 - Enhanced visual effects.
		http://www.armaholic.com/page.php?id=23899<br /><br />
		
<br />- ShackTac Fireteam HUD - v140302 - Situational awareness HUD
		http://www.armaholic.com/page.php?id=9936<br /><br />

<br />- VTS Weapon resting - v05 - Simulates 'bipod' and weapon resting.
		http://www.armaholic.com/page.php?id=20817
"
]];

//-------------------------------------------------- Teamspeak

player createDiaryRecord ["teamspeak",
[
"TS3",
"
<br /> Teamspeak:<br /><br />
<br /> http://www.teamspeak.com/?page=downloads
"
]];

player createDiaryRecord ["teamspeak",
[
"AHOY WORLD",
"
<br /> Address: ts.ahoyworld.co.uk
<br />
<br /> Visitors and guests welcome!
"
]];

//-------------------------------------------------- FAQ

player createDiaryRecord ["faq",
[
"UAVs",
"
<br /> In the Control Tower at base, a UAV Operator can now recycle the UAV crew on one of the computer terminals.
<br /><br />
<br /><font size='16'>Q:</font> Can I use the UAVs?<br />
<br /><font size='16'>A:</font> Yes, however you must be in the UAV Operator role and you must have a UAV Terminal.
<br />
<br />
<br /><font size='16'>Q:</font> Why do the UAVs keep exploding?<br />
<br /><font size='16'>A:</font> When the bomb-equipped UAVs are first connected to, the Gunner AI fires its weapons. Until it's fixed, here is a guide for you.<br />
<br /> To safely connect to the MQ4A Greyhawk UAV:<br />
<br />	1. Enter action menu (mouse scroll), click 'Open UAV Terminal'.
<br />	2. Right-click on the UAV you wish to control, on the terminal map.
<br />	3. Click 'Connect Terminal to UAV'.
<br /><br /> [IMPORTANT] Do NOT click 'Take Control' button in UAV Terminal.<br />
<br />	4. Esc out of the UAV terminal.
<br />	5. Enter action menu (mouse scroll) again.
<br />	6. [IMPORTANT] Select 'Take UAV TURRET controls'.<br />
<br />
<br />	It is now safe to 'Take Control' of the UAV.
<br />
<br />
<br /><font size='16'>Q:</font> Why can't I connect to the UAV?<br />
<br /><font size='16'>A:</font> Sometimes the UAVs are still connected to the prior Operators Terminal. If he disconnects or dies, sometimes the Terminal does not delete properly. The only solution at this time is to destroy the UAV, and you yourself must respawn.
"
]];

player createDiaryRecord ["faq",
[
"Squads",
"
<br /><font size='16'>Q:</font> How do I join a squad?<br />
<br /><font size='16'>A:</font> 
<br /> 1. Hold 'T'.
<br /> 2. While holding T, use your scroll wheel to interact.
<br /> 3. You can interact with the person you are looking at, or those within a 5m radius.
<br />
<br /> * Xeno's Squad Management tool had to be removed at request of the script author.
"
]];

player createDiaryRecord ["faq",
[
"FOBs",
"
<br />Coming soon ...
"
]];

player createDiaryRecord ["faq",
[
"Bipod",
"
<br /><font size='16'>Q:</font> How do I deploy bipod?<br />
<br /><font size='16'>A:</font> Open the Mods tab and look for VTS weaponresting. 
<br /> 1. Download and follow the instructions.
<br /> 2. Use when you are in a stable firing position.
<br /> 3. Default keys: Ctrl + Spacebar
<br />
<br /> ArmA 3 does not have integrated bipod function, so we have to use community-created mods to simulate.
"
]];

player createDiaryRecord ["faq",
[
"Medics",
"
<br /><font size='16'>Q:</font> Why can't I heal him?<br />
<br /><font size='16'>A:</font> There are three conditions you must pass in order to revive a fallen comrade. 
<br /> 1. You must be in a Medic / Paramedic role.
<br /> 2. You must have a Medkit.
<br /> 3. You must have at least one First Aid Kit.
"
]];

player createDiaryRecord ["faq",
[
"Mortars",
"
<br /><font size='16'>Q:</font> Can I use the Mortars?
<br /><font size='16'>A:</font> Yes, However if you are not in the mortar gunner role you will not have acess to the Artillery Computer.<br />
<br /><font size='16'>Q:</font> How do I use the Mortar without the computer?
<br /><font size='16'>A:</font> You have to manually find the target with the sight. Here are some steps to use the mortar. 
<br /> 1. Press the F key to select the firing distance.
<br /> 2. If you are in line-of-sight just put the cursor on the target and use the page up and page down keys to change the elevation.
<br /> 3. Fire!<br /> 
<br /><font size='16'>Here is a youtube video that can explain in more detail.<br />
<br /> https://www.youtube.com/watch?v=SCCvXfwzeAU
"
]];

//-------------------------------------------------- Change Log

player createDiaryRecord ["changelog",
[
"2.79",
"
<br />- [CHANGED] Hummingbird texture.
<br />- [CHANGED] 1 Ghosthawk changed to a helcat.
<br />- [CHANGED] Pawnee should now have a different texture.
<br />- [CHANGED] Changelog.
<br />- [TWEAKED] Pawnee side mission spawn rate increased.
<br />- [TWEAKED] Wipeout and Neophron now have 60 flares.
<br />- [TWEAKED] Some minor things added at spawn.
<br />- [ADDED] Minigun Dispersion.
<br />- [ADDED] Mortar to side mission reward.
<br />- [ADDED] LaForte to Zeus.
<br />- [ADDED] Spartan program.
<br />- [ADDED] New AO's.
<br />- [ADDED] Speed of sound to accepted mods.
<br />- [ADDED] Tao Folding Map to accepted mods.
<br />- [ADDED] Helmet Mounted Displays Mod to accepted mods.
<br />- [ADDED] Midrange Terrain Texture to accepted mods.
<br />- [ADDED] Rule against landing helicopters in the main spawn.
<br />- [FIXED] Exploit where jet could bypass 5 minutes repair timer.
"
]];

player createDiaryRecord ["changelog",
[
"2.79A",
"
<br />- [ADDED] AH-9 Pawnee GAU - 19 variant to side missions rewards.
<br />- [ADDED] Rabbit to side missions rewards (used to spawn GAU-19).
<br />- [FIXED] Mortar side mission reward should no longer be restricted.
<br />- [FIXED] Secure Chopper side missions should now work.
<br />- [FIXED] Minigun dispersion to Ghosthawk turrets.
"
]];

player createDiaryRecord ["changelog",
[
"2.79B",
"
<br />- [CHANGED] Now Use Quiksilver's player markers.
<br />- [CHANGED] Rifleman (AT) is now a Missile Spec. (AT).
<br />- [ADDED] All players may now revive when within 5 meters of a Medical HEMTT.
<br />- [ADDED] New Medivac LZ.
<br />- [ADDED] Combat Life Saviour Team.
<br />- [ADDED] Arsenal is back on the VASman.
"
]];

player createDiaryRecord ["changelog",
[
"2.79D",
"
<br />- [FIXED] Rifleman(AT) should now be fixed again.
<br />- [FIXED] Artillery should now fire.
<br />- [TWEAKED] Player Icons should now display further away.
<br />- [TWEAKED] Players now need a FAK to revive at a Medical HEMTT.
<br />- [TWEAKED] Tweaked some aspects of BTC to improve performance.
<br />- [CHANGED] All playable units should now be attached to Zues.
<br />- [ADDED] 5th pilot slot and helicopter.
<br />- [ADDED] Bobcat is now at spawn.
<br />- [ADDED] Quick save option for gear.
"
]];

player createDiaryRecord ["changelog",
[
"2.79F",
"
<br />- [TWEAKED] Some behind the scenes stuff.
<br />- [ADDED] Some parameters for better before mission customization.
"
]];

player createDiaryRecord ["changelog",
[
"2.80",
"
<br />- [ADDED] CH-47 Huron to helicopters.
<br />- [ADDED] Mi-290 Taru to Side mission rewards.
<br />- [ADDED] Huron crate spawner.
"
]];

player createDiaryRecord ["changelog",
[
"2.80A",
"
<br />- [CHANGED] Reverted back to Quicksilver's icons.
<br />- [REMOVED] Defend AO.
<br />- [FIXED] Rearm UAV.sqf was re-added.
"
]];

player createDiaryRecord ["changelog",
[
"2.81",
"
<br />- [ADDED] CAP(close air patrol) buzzard now spawns at mission start with 10 min respawn.
<br />- [ADDED] Headless Client (please report fps changes to our forums).
<br />- [TWEAKED] Enemy Jets should now have a lower AI setting.
<br />- [FIXED] UAV's now spawn with ammo again.
<br />- [FIXED] The supply crates should not spawn in properly.
"
]];

player createDiaryRecord ["changelog",
[
"2.81A",
"
<br />- [ADDED] Mortar Gunner role has been added.
<br />- [TWEAKED] Offloaded more AI to the HC.
<br />- [TWEAKED] Spawn chances for AH-9 Pawnee and AH-9 Pawnee GAU-19 increased.
<br />- [CHANGED] SM Reward Mortar is now attached to the bed of a truck.
<br />- [CHANGED] UAV Operator is now in the same squad as the Mortar Gunner.
<br />- [CHANGED] Artillery Computer has been disabled for all players except for the Mortar Gunner.
"
]];

player createDiaryRecord ["changelog",
[
"2.81B",
"
<br />- [TWEAKED] Spawn rates of Jets in Side mission rewards.
<br />- [TWEAKED] Moved TS markers to be more in yo face.
<br />- [TWEAKED] Added VAS, VA, and view distance to man standing in pilot spawn.
<br />- [TWEAKED] Headless Client Public Variable now in init player local.
<br />- [CHANGED] Base Protection changed to a HintC.
<br />- [ADDED] Pancake to Spartan Program.
<br />- [ADDED] Ahoy World Intro added.
<br />- [FIXED] Repair pad at AAF Airfield no longer repairs planes.
"
]];

player createDiaryRecord ["changelog",
[
"2.81C",
"
<br />- [FIXED] Issue with Intro Popup and Headless Client (hopefully).
<br />- [FIXED] Minor script error for the fuel canister.
"
]];

player createDiaryRecord ["changelog",
[
"2.81D",
"
<br />- [FIXED] Issue with Intro Popup and Headless Client (hopefully)(for real this time).
<br />- [ADDED] Billboards.
"
]];

player createDiaryRecord ["changelog",
[
"2.81E",
"
<br />- [FIXED] Removed headlessclient variable from initPlayerLocal.
"
]];

player createDiaryRecord ["changelog",
[
"2.81F",
"
<br />- [FIXED] headlessclient variable is in init now.
<br />- [ADDED] Chon is now Spartan.
<br />- [ADDED] Ahoy EU 3 advertisement.
"
]];
player createDiaryRecord ["changelog",
[
"2.81G",
"
<br />- [FIXED] HeadlessClient (If it is still not fixed I will cry).
"
]];

player createDiaryRecord ["changelog",
[
"2.82",
"
<br />- [CHANGED] AO enemies now spawn using DAC zones.
"
]];

player createDiaryRecord ["changelog",
[
"2.82A",
"
<br />- [CHANGED] AO enemies now use a mix of DAC and old method.
<br />- [ADDED] Mattadee to Spartan.
<br />- [ADDED] Hint for AW Members that joined.
"
]];

player createDiaryRecord ["changelog",
[
"2.82B",
"
<br />- [FIXED] Typo in hint for members.
<br />- [TWEAKED] DAC AI.
"
]];

player createDiaryRecord ["changelog",
[
"2.82C",
"
<br />- [FIXED] Script Error in initPlayerLocal (wrong slashes).
<br />- [ADDED] Cam Shake fix added to VAS Man.
"
]];

player createDiaryRecord ["changelog",
[
"2.82D",
"
<br />- [TWEAKED] Minor script tweaks.
"
]];

player createDiaryRecord ["changelog",
[
"2.82E",
"
<br />- [ADDED] Marksman DLC weapons are restricted to the respective classes.
<br />- [CHANGED] Thermal Optics are restricted to Squad Leaders.
<br />- [CHANGED] Orca to Hellcat.
"
]];

player createDiaryRecord ["changelog",
[
"2.83",
"
<br />- [REMOVED] DAC AI to the AO.
<br />- [ADDED] Headless Client should now properly work, however, still issues if it has to reconnect.
"
]];


player createDiaryRecord ["changelog",
[
"2.83B",
"
<br />- [REMOVED] DAC.
<br />- [REMOVED] Pancake from spartan.
<br />- [TWEAKED] Hellcat changed to Ghost-Hwak.
<br />- [ADDED] BIS's group management.
"
]];


player createDiaryRecord ["changelog",
[
"2.83E",
"
<br />- [TWEAKED] Spawn chances for reward vehicles.
<br />- [ADDED] Pawnee with GMG to SM rewards.
"
]];

player createDiaryRecord ["changelog",
[
"2.83F",
"
<br />- [CHANGED] BillBoards at spawn now choose a random image when you load.
"
]];

player createDiaryRecord ["changelog",
[
"2.83G",
"
<br />- [ADDED] More Billboards.
"
]];

player createDiaryRecord ["changelog",
[
"2.83J",
"
<br />- [ADDED] Stuff.
"
]];

player createDiaryRecord ["changelog",
[
"2.84",
"
<br />- [REMOVED] Lots of PublicVaraiables.
<br />- [FIXED] Statics should not be deleted as harshly.
<br />- [ADDED] Billboards.
"
]];

player createDiaryRecord ["changelog",
[
"2.85",
"
<br />- [FIXED] GMG Technical.
<br />- [ADDED] FOB and FOB mission system.
"
]];

player createDiaryRecord ["changelog",
[
"2.85A",
"
<br />- [FIXED] FOB trucks should now Despawn.
<br />- [ADDED] Utility for zues to stop Main AO.
"
]];
//-------------------------------------------------- Credits

player createDiaryRecord ["credits",
[
"I & A",
"
<br />Mission authors:<br /><br />

		- <font size='16'>Rarek</font> - Ahoy World (ahoyworld.co.uk)<br /><br />
		- <font size='16'>Quiksilver</font><br />
		
<br />Contributors:<br /><br />
		- Jester - Ahoy World (ahoyworld.co.uk)<br />
		- Razgriz33 - Ahoy World (ahoyworld.co.uk)<br />
		- Kamaradski - Ahoy World (ahoyworld.co.uk)<br />
		- BACONMOP - Ahoy World (ahoyworld.co.uk)<br />
		- chucky - All FPS (allfps.com.au)<br /><br />
		
<br />Other:<br /><br />
		VAS<br />
		- Kronzky<br />
		- Sa-Matra<br />
		- Dslyecxi<br /><br />
		=BTC= Revive<br />
		- Giallustio<br />
		- Edited by Quiksilver<br/><br />
		EOS<br />
		- BangaBob<br /><br />
		Squad Manager<br />
		- aeroson<br /> <br />
		TAW View Distance<br />
		- Tonic<br /> <br />
		aw_fnc<br />
		- Alex Wise<br /><br />
		SHK Taskmaster<br />
		- Shuko<br /><br />
		Fast rope<br />
		- Zealot<br /><br />
		Map and GPS Icons (Soldier Tracker)<br />
		- Quiksilver<br /><br />
		Jump<br />
		- ProGamer<br /><br />
		Safe zone<br />
		- Bake<br />
		DAC<br />
		- Silola<br />
"
]];