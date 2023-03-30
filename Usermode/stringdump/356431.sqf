#line 0 "/temp/bin/A3/Functions_F/Feedback/fn_feedbackInit.sqf"














[] spawn {
	scriptName "fn_feedbackInit_mainLoop";
	
	BIS_ppType = "";
	BIS_fakeDamage = 0.1;
	BIS_add = true;
	BIS_distToFire = 10;
	BIS_performPP = true;			
	BIS_fnc_feedback_damagePP = FALSE;		
	BIS_respawnInProgress = false;  
	BIS_fnc_feedback_testHelper = 0;

	
	BIS_EnginePPReset = false;
	if (isNil {player getVariable "BIS_fnc_feedback_postResetHandler"}) then {
		player setVariable ["BIS_fnc_feedback_postResetHandler", true];
		player addeventhandler ["PostReset",{BIS_EnginePPReset = true;} ];
	};

	
	["HealthPP_blood"] call bis_fnc_rscLayer;
	["HealthPP_dirt"] call bis_fnc_rscLayer;
	["HealthPP_fire"] call bis_fnc_rscLayer;
	["HealthPP_black"] call bis_fnc_rscLayer;

	BIS_pulsingFreq = getnumber (configfile >> "cfgfirstaid" >> "pulsationSoundInterval");    

	BIS_helper = 0.5;
	BIS_applyPP1 = true;
	BIS_applyPP2 = true;
	BIS_applyPP3 = true; 
	BIS_applyPP8 = true; 
	BIS_canStartRed = true; 
	BIS_fnc_feedback_blue = true;	

	BIS_oldDMG = 0;  
	BIS_deltaDMG = 0;
	BIS_oldLifeState = "HEALTHY"; 

	
	
	BIS_TotDesatCC = ppEffectCreate ["ColorCorrections", 1600];
	BIS_TotDesatCC ppEffectAdjust [1,1,0,[0, 0, 0, 0],[1, 1, 1, 1],[0,0,0,0]];  

	
	BIS_blendColorAlpha = 0.0;
	BIS_fnc_feedback_damageCC = ppEffectCreate ["ColorCorrections", 1605];
	

	BIS_fnc_feedback_damageRadialBlur = ppEffectCreate ["RadialBlur", 260];
	BIS_fnc_feedback_damageBlur = ppEffectCreate ["DynamicBlur", 160];

	
	if (isNil {player getVariable "BIS_fnc_feedback_damagePulsingHandler"}) then {
		player setVariable ["BIS_fnc_feedback_damagePulsingHandler", true];
		player addeventhandler ["SoundPlayed",
		{
			if(((_this select 1) == 2) && (damage player >= 0.1) && !BIS_fnc_feedback_damagePP &&  (((uavControl (getConnectedUav player)) select 1) == "")) then
			{
				call BIS_fnc_damagePulsing;
			};
		} ];
	};

	
	BIS_SuffCC = ppEffectCreate ["ColorCorrections", 1610];
	

	
	BIS_SuffCC ppEffectAdjust [1,1,0,[0, 0, 0, 0 ],[1, 1, 1, 1],[0,0,0,0], [-1, -1, 0, 0, 0, 0.001, 0.5]];

	
	

	BIS_SuffRadialBlur = ppEffectCreate ["RadialBlur", 270];
	BIS_SuffBlur = ppEffectCreate ["DynamicBlur", 170];

	BIS_applyPP5 = true;				
	BIS_oldOxygen = 1.0;			

	
	BIS_counter = 1; 					
	BIS_alfa = 0.0;
	BIS_applyPP6 = true;				
	BIS_oldWasBurning = false;		 
	BIS_BurnCC = ppEffectCreate ["ColorCorrections", 1620];
	BIS_BurnWet = ppEffectCreate ["WetDistortion", 400];
	BIS_PP_burnParams = [];
	BIS_PP_burning = false;
	BIS_fnc_feedback_burningTimer = 0;

	
	
	BIS_UncCC = ppEffectCreate ["ColorCorrections", 1603];  
	BIS_UncRadialBlur = ppEffectCreate ["RadialBlur", 280];
	BIS_UncBlur = ppEffectCreate ["DynamicBlur", 180];

	
	BIS_applyPP4 = true; 
	BIS_DeathCC = ppEffectCreate ["ColorCorrections", 1640];
	BIS_DeathRadialBlur = ppEffectCreate ["RadialBlur", 290];
	BIS_DeathBlur = ppEffectCreate ["DynamicBlur", 190];

	
	BIS_oldBleedRemaining = 0;   
	BIS_applyPP7 = true; 
	BIS_BleedCC = ppEffectCreate ["ColorCorrections", 1645];

	
	BIS_HitCC = ppEffectCreate ["ColorCorrections", 1650];
	
	BIS_wasHit = false;
	
	
	if (isNil {player getVariable "BIS_fnc_feedback_hitArrayHandler"}) then {
		player setVariable ["BIS_fnc_feedback_hitArrayHandler", true];
		player addEventHandler ["HandleDamage",{BIS_hitArray = _this; BIS_wasHit = true;} ];
	};

	
	
	BIS_performingDustPP = false;  
	BIS_damageFromExplosion = 0;
	if (isNil {player getVariable "BIS_fnc_feedback_dirtEffectHandler"}) then {
		player setVariable ["BIS_fnc_feedback_dirtEffectHandler", true];
		player addeventhandler ["Explosion",{_null = _this call BIS_fnc_dirtEffect;_this select 1;} ];
	};

	
	BIS_myOxygen = 1.0;

	
	BIS_respawned = false;
	if (isNil {player getVariable "BIS_fnc_feedback_respawnedHandler"}) then {
		player setVariable ["BIS_fnc_feedback_respawnedHandler", true];
		player addEventHandler ["respawn", "BIS_respawned = true"];
	};
	

	
	BIS_teamSwitched = false;
	onTeamSwitch "BIS_teamSwitched = true";
	BIS_teamSwitched = false;  

	
	BIS_fnc_feedback_fatiguePP = false;
	BIS_fnc_feedback_fatigueCC = ppEffectCreate ["ColorCorrections", 1615];
	BIS_fnc_feedback_fatigueRadialBlur = ppEffectCreate ["RadialBlur", 275];
	BIS_fnc_feedback_fatigueBlur = ppEffectCreate ["DynamicBlur", 175];
};
