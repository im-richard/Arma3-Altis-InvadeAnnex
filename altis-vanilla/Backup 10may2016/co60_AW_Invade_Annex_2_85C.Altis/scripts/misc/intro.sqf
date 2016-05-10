if (playerSide == west) then {
_handle=createdialog "AW_INTRO";
};

if (playerSide == west) then {
	sleep 1800;
	_Ts_Hint = "<t align='center'><t size='2'><t color='#00B2EE'>Join us on TeamSpeak</t><br/><br/>_____________<br/><br/><t size='1.1'><t color='#ffffff'>ts.archegamingstudios.net<br/></t>";
	[_Ts_Hint] remoteExec ["AW_fnc_globalHint",0,false];
	sleep 1800;
	_Ts_Hint = "<t align='center'><t size='1.5'><t color='#ffffff'>To Pilots</t><br/>  <t size='1.1'><br/>Ensure players are picked up. Don't hog the aircraft for yourself.</t>";
	[_Ts_Hint] remoteExec ["AW_fnc_globalHint",0,false];
	sleep 1800;
	_Ts_Hint = "<t align='center'><t size='2'><t color='#00B2EE'>PvE Only Server </t><br/><br/>_____________<br/><br/><t size='1.1'><t color='#ffffff'>Do NOT kill teammates or you will be kicked.<br/></t>";
	[_Ts_Hint] remoteExec ["AW_fnc_globalHint",0,false];
	sleep 1800;
	_Ts_Hint = "<t align='center'><t size='1.5'><t color='#00ffff'>Vote!</t><br/>  <t size='1.1'><br/>Like our server? Vote for us at <br/>  <br/><t color='#ffffff'>http://arma3-servers.net/server/71209/<br/></t>";
	[_Ts_Hint] remoteExec ["AW_fnc_globalHint",0,false];
};
