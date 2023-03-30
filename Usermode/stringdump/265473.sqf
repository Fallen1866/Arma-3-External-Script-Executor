#line 0 "/temp/bin/A3/Functions_F/Feedback/fn_flamesEffect.sqf"















BIS_oldWasBurning = true;
BIS_applyPP6 = false; 


[] spawn
{
	scriptName "fn_flamesEffect_mainLoop";
	
	disableSerialization;
	if (isnil {uinamespace getvariable "RscHealthTextures"}) then {uinamespace setvariable ["RscHealthTextures",displaynull]};
	
	if (isnull (uinamespace getvariable "RscHealthTextures")) then {(["HealthPP_fire"] call bis_fnc_rscLayer) cutrsc ["RscHealthTextures","plain"]};
	
	
	private ["_ctrl", "_pos", "_text_1", "_text_2", "_text_3", "_text_4", "_text_5", "_text_6", "_text_7", "_text_8", "_text_9", "_text_10", "_texture"]; 
	
	for "_i" from 1 to 10 do {
		
		
		
		
		
		_ctrl = (uinamespace getvariable "RscHealthTextures") displayctrl (1200+_i);
		
		
		
		
		_pos = [safezoneX,safezoneY,safezoneW,safezoneH];
		
		
		_ctrl ctrlsetposition _pos;
		_ctrl ctrlsetfade 0.5;
		_ctrl ctrlcommit 0;
		debugLog str _ctrl;
		sleep 0.04;
		
		_ctrl ctrlsetfade 1;
		_ctrl ctrlcommit 0;
	};
	
	
	
	
	























	
	sleep (0.4 + random 2);

	BIS_applyPP6 = true;  
};







































