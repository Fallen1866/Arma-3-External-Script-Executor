#line 0 "/temp/bin/A3/Functions_F/GUI/fn_establishingShot.sqf"




















private ["_tgt", "_txt", "_alt", "_rad", "_ang", "_dir", "_waitTime"];
_tgt = _this param [0, objNull, [objNull, []]];
_txt = _this param [1, "", [""]];
_alt = _this param [2, 500, [500]];
_rad = _this param [3, 200, [200]];
_ang = _this param [4, random 360, [0]];
_dir = _this param [5, round random 1, [0]];
_waitTime = _this param [9, 2, [0]];

BIS_fnc_establishingShot_icons = _this param [6, [], [[]]];

private ["_mode"];
_mode = _this param [7, 0, [0]];

if (_mode == 0) then {
	enableSaving [false, false];
	BIS_missionStarted = nil;
};

private ["_fade"];
_fade = _this param [8, true, [true]];

if (_fade) then {
	["BIS_fnc_establishingShot",false] call BIS_fnc_blackOut;
} else {
	0 fadeSound 0;
	titleCut ["", "BLACK FADED", 10e10];
};


if (isNil "BIS_fnc_establishingShot_fakeUAV") then {
	BIS_fnc_establishingShot_fakeUAV = "Camera" camCreate [10,10,10];
};

BIS_fnc_establishingShot_fakeUAV cameraEffect ["INTERNAL", "BACK"];

cameraEffectEnableHUD true;

private ["_pos", "_coords"];
_pos = if (typeName _tgt == typeName objNull) then {position _tgt} else {_tgt};
_coords = [_pos, _rad, _ang] call BIS_fnc_relPos;
_coords set [2, _alt];

BIS_fnc_establishingShot_fakeUAV camPrepareTarget _tgt;
BIS_fnc_establishingShot_fakeUAV camPreparePos _coords;
BIS_fnc_establishingShot_fakeUAV camPrepareFOV 0.700;
BIS_fnc_establishingShot_fakeUAV camCommitPrepared 0;


BIS_fnc_establishingShot_fakeUAV camPreload 3;


private ["_ppColor"];
_ppColor = ppEffectCreate ["colorCorrections", 1999];
_ppColor ppEffectEnable true;
_ppColor ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [0.8, 0.8, 0.8, 0.65], [1, 1, 1, 1.0]];
_ppColor ppEffectCommit 0;

private ["_ppGrain"];
_ppGrain = ppEffectCreate ["filmGrain", 2012];
_ppGrain ppEffectEnable true;
_ppGrain ppEffectAdjust [0.1, 1, 1, 0, 1];
_ppGrain ppEffectCommit 0;


[] spawn
{
	waitUntil {time > 0};
	showCinemaBorder false;
	enableEnvironment false;
};

private ["_SITREP", "_key"];

if (_mode == 1) then {
	optionsMenuOpened = {
		disableSerialization;
		{(_x call BIS_fnc_rscLayer) cutText ["", "PLAIN"]} forEach ["BIS_layerStatic", "BIS_layerInterlacing"];
	};
} else {
	
	private ["_month", "_day", "_hour", "_minute"];
	_month = str (date select 1);
	_day = str (date select 2);
	_hour = str (date select 3);
	_minute = str (date select 4);

	if (date select 1 < 10) then {_month = format ["0%1", str (date select 1)]};
	if (date select 2 < 10) then {_day = format ["0%1", str (date select 2)]};
	if (date select 3 < 10) then {_hour = format ["0%1", str (date select 3)]};
	if (date select 4 < 10) then {_minute = format ["0%1", str (date select 4)]};

	private ["_time", "_date"];
	_time = format ["%1:%2", _hour, _minute];
	_date = format ["%1-%2-%3", str (date select 0), _month, _day];

	
	
	_SITREP = [
		[_date + " ", ""],
		[_time, "font = 'PuristaMedium'"],
		["", "<br/>"],
		[toUpper _txt, ""]
	];

	disableSerialization;

	waitUntil {!(isNull ([] call BIS_fnc_displayMission))};

	
	_key = format ["BIS_%1.%2_establishingShot", missionName, worldName];

	
	if (!(isNil {uiNamespace getVariable "BIS_fnc_establishingShot_skipEH"})) then {
		([] call BIS_fnc_displayMission) displayRemoveEventHandler ["KeyDown", uiNamespace getVariable "BIS_fnc_establishingShot_skipEH"];
		uiNamespace setVariable ["BIS_fnc_establishingShot_skipEH", nil];
	};

	
	private ["_skipEH"];
	_skipEH = ([] call BIS_fnc_displayMission) displayAddEventHandler [
		"KeyDown",
		format [
			"
				if (_this select 1 == 57) then {
					([] call BIS_fnc_displayMission) displayRemoveEventHandler ['KeyDown', uiNamespace getVariable 'BIS_fnc_establishingShot_skipEH'];
					uiNamespace setVariable ['BIS_fnc_establishingShot_skipEH', nil];

					playSound ['click', true];

					activateKey '%1';
					BIS_fnc_establishingShot_skip = true;
				};

				if (_this select 1 != 1) then {true};
			",
			_key
		]
	];

	uiNamespace setVariable ["BIS_fnc_establishingShot_skipEH", _skipEH];

	
	("BIS_layerEstShot" call BIS_fnc_rscLayer) cutRsc ["RscEstablishingShot", "PLAIN"];

	
	optionsMenuOpened = {
		disableSerialization;
		{(_x call BIS_fnc_rscLayer) cutText ["", "PLAIN"]} forEach ["BIS_layerEstShot", "BIS_layerStatic", "BIS_layerInterlacing"];
	};

	optionsMenuClosed = {
		disableSerialization;
		("BIS_layerEstShot" call BIS_fnc_rscLayer) cutRsc ["RscEstablishingShot", "PLAIN"];
	};

	waitUntil {!(isNull (uiNamespace getVariable "RscEstablishingShot"))};
};


waitUntil {camPreloaded BIS_fnc_establishingShot_fakeUAV || !(isNil "BIS_fnc_establishingShot_skip")};

private ["_drawEH"];

if (isNil "BIS_fnc_establishingShot_skip") then {
	BIS_fnc_establishingShot_playing = true;

	
	BIS_fnc_establishingShot_logic_group = createGroup sideLogic;
	BIS_fnc_establishingShot_logic1 = BIS_fnc_establishingShot_logic_group createUnit ["Logic", [10,10,10], [], 0, "NONE"];
	BIS_fnc_establishingShot_logic2 = BIS_fnc_establishingShot_logic_group createUnit ["Logic", [10,10,10], [], 0, "NONE"];
	BIS_fnc_establishingShot_logic3 = BIS_fnc_establishingShot_logic_group createUnit ["Logic", [10,10,10], [], 0, "NONE"];

	[] spawn {
		scriptName "BIS_fnc_establishingShot: UAV sound loop";

		
		private ["_sound", "_duration"];
		_sound = "UAV_loop";
		_duration = getNumber (configFile >> "CfgSounds" >> _sound >> "duration");

		while {!(isNull BIS_fnc_establishingShot_logic1)} do {
			BIS_fnc_establishingShot_logic1 say _sound;
			sleep _duration;

			if (!(isNull BIS_fnc_establishingShot_logic2)) then {
				BIS_fnc_establishingShot_logic2 say _sound;
				sleep _duration;
			};
		};
	};

	[] spawn {
		scriptName "BIS_fnc_establishingShot: random sounds control";

		while {!(isNull BIS_fnc_establishingShot_logic3)} do {
			
			private ["_sound", "_duration"];
			_sound = format ["UAV_0%1", round (1 + random 8)];
			_duration = getNumber (configFile >> "CfgSounds" >> _sound >> "duration");

			BIS_fnc_establishingShot_logic3 say _sound;

			sleep (_duration + (5 + random 5));
		};
	};

	
	[_pos, _alt, _rad, _ang, _dir] spawn {
		scriptName "BIS_fnc_establishingShot: camera control";

		private ["_pos", "_alt", "_rad", "_ang", "_dir"];
		_pos = _this select 0;
		_alt = _this select 1;
		_rad = _this select 2;
		_ang = _this select 3;
		_dir = _this select 4;

		while {isNil "BIS_missionStarted"} do {
			private ["_coords"];
			_coords = [_pos, _rad, _ang] call BIS_fnc_relPos;
			_coords set [2, _alt];

			BIS_fnc_establishingShot_fakeUAV camPreparePos _coords;
			BIS_fnc_establishingShot_fakeUAV camCommitPrepared 0.5;

			waitUntil {camCommitted BIS_fnc_establishingShot_fakeUAV || !(isNil "BIS_missionStarted")};

			BIS_fnc_establishingShot_fakeUAV camPreparePos _coords;
			BIS_fnc_establishingShot_fakeUAV camCommitPrepared 0;
			
			_ang = if (_dir == 0) then {_ang - 0.5} else {_ang + 0.5};
		};
	};

	sleep 1;

	if (isNil "BIS_fnc_establishingShot_skip") then {
		enableEnvironment true;
		2 fadeSound 1;

		
		("BIS_layerStatic" call BIS_fnc_rscLayer) cutRsc ["RscStatic", "PLAIN"];
		waitUntil {!isNull (uiNamespace getVariable ["RscStatic_display", displayNull]) || !isNil "BIS_fnc_establishingShot_skip"};
		waitUntil {isNull (uiNamespace getVariable ["RscStatic_display", displayNull])  || !isNil "BIS_fnc_establishingShot_skip"};

		if (isNil "BIS_fnc_establishingShot_skip") then {
			
			("BIS_layerInterlacing" call BIS_fnc_rscLayer) cutRsc ["RscInterlacing", "PLAIN"];

			
			if (_fade) then {
				("BIS_fnc_blackOut" call BIS_fnc_rscLayer) cutText ["","PLAIN",10e10];
			} else {
				titleCut ["", "PLAIN"];
			};

			
			optionsMenuClosed = if (_mode == 0) then {
				{
					("BIS_layerEstShot" call BIS_fnc_rscLayer) cutRsc ["RscEstablishingShot", "PLAIN"];
					("BIS_layerInterlacing" call BIS_fnc_rscLayer) cutRsc ["RscInterlacing", "PLAIN"];
				};
			} else {
				{
					("BIS_layerInterlacing" call BIS_fnc_rscLayer) cutRsc ["RscInterlacing", "PLAIN"];
				};
			};

			
			if (count BIS_fnc_establishingShot_icons > 0) then {
				_drawEH = addMissionEventHandler [
					"Draw3D",
					{
						{
							private ["_icon", "_color", "_target", "_sizeX", "_sizeY", "_angle", "_text", "_shadow"];
							_icon = _x param [0, "", [""]];
							_color = _x param [1, [], [[]]];
							_target = _x param [2, [], [[], objNull, grpNull]];
							_sizeX = _x param [3, 1, [1]];
							_sizeY = _x param [4, 1, [1]];
							_angle = _x param [5, random 360, [0]];
							_text = _x param [6, "", [""]];
							_shadow = _x param [7, 0, [0]];

							
							private ["_condition", "_position"];
							_condition = true;
							_position = _target;

							switch (typeName _target) do {
								
								case typeName objNull: {
									_condition = alive _target;
									_position = getPosATL _target;
								};

								
								case typeName grpNull: {
									_condition = {alive _x} count units _target > 0;
									_position = getPosATL leader _target;
								};
							};

							
							if (_condition) then {
								drawIcon3D [_icon, _color, _position, _sizeX, _sizeY, _angle, _text, _shadow];
							};
						} forEach BIS_fnc_establishingShot_icons;
					}
				];
			};

			if (_mode == 0) then {
				
				_key spawn {
					scriptName "BIS_fnc_establishingShot: instructions control";

					disableSerialization;

					private ["_key"];
					_key = _this;

					if (!(isKeyActive _key) && isNil "BIS_fnc_establishingShot_skip") then {
						
						private ["_layerTitlecard"];
						_layerTitlecard = "BIS_layerTitlecard" call BIS_fnc_rscLayer;
						_layerTitlecard cutRsc ["RscDynamicText", "PLAIN"];

						private ["_dispText", "_ctrlText"];
						_dispText = uiNamespace getVariable "BIS_dynamicText";
						_ctrlText = _dispText displayCtrl 9999;

						_ctrlText ctrlSetPosition [
							0 * safeZoneW + safeZoneX,
							0.8 * safeZoneH + safeZoneY,
							safeZoneW,
							safeZoneH
						];

						
						private ["_keyColor"];
						_keyColor = format [
							"<t color = '%1'>",
							(["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet) call BIS_fnc_colorRGBtoHTML
						];

						private ["_skipText"];
						_skipText = format [
							localize "STR_A3_BIS_fnc_titlecard_pressSpace",
							"<t size = '0.75'>",
							_keyColor,
							"</t>",
							"</t>"
						];

						_ctrlText ctrlSetStructuredText parseText _skipText;
						_ctrlText ctrlSetFade 1;
						_ctrlText ctrlCommit 0;

						_ctrlText ctrlSetFade 0;
						_ctrlText ctrlCommit 1;

						
						waitUntil {{!(isNil _x)} count ["BIS_fnc_establishingShot_skip", "BIS_fnc_establishingShot_UAVDone"] > 0};

						
						_ctrlText ctrlSetFade 1;
						_ctrlText ctrlCommit 0;
					};
				};
				
				private ["_time"];
				_time = time + 2;
				waitUntil {time >= _time || !(isNil "BIS_fnc_establishingShot_skip")};

				if (isNil "BIS_fnc_establishingShot_skip") then {
					




















































					
					
					BIS_fnc_establishingShot_SITREP = [
						_SITREP,
						0.015 * safeZoneW + safeZoneX,
						0.015 * safeZoneH + safeZoneY,
						false,
						"<t align = 'left' size = '1.0' font = 'PuristaLight'>%1</t>"
					] spawn BIS_fnc_typeText2;

					waitUntil {scriptDone BIS_fnc_establishingShot_SITREP || !(isNil "BIS_fnc_establishingShot_skip")};
					
					private ["_time"];
					_time = time + _waitTime;
					waitUntil {time >= _time || !(isNil "BIS_fnc_establishingShot_skip")};

					if (isNil "BIS_fnc_establishingShot_skip") then {
						
						BIS_fnc_establishingShot_UAVDone = true;
					};
				};
			};
		};
	};
};

if (_mode == 0) then {
	waitUntil {{!(isNil _x)} count ["BIS_fnc_establishingShot_skip", "BIS_fnc_establishingShot_UAVDone"] > 0};

	
	if (!(isNil {uiNamespace getVariable "BIS_fnc_establishingShot_skipEH"})) then {
		([] call BIS_fnc_displayMission) displayRemoveEventHandler ["KeyDown", uiNamespace getVariable "BIS_fnc_establishingShot_skipEH"];
		uiNamespace setVariable ["BIS_fnc_establishingShot_skipEH", nil];
	};

	
	2 fadeSound 0;

	("BIS_layerStatic" call BIS_fnc_rscLayer) cutRsc ["RscStatic", "PLAIN"];
	waitUntil {!isNull (uiNamespace getVariable ["RscStatic_display", displayNull])};
	waitUntil {isNull (uiNamespace getVariable ["RscStatic_display", displayNull])};
	
	
	if (!(isNil "BIS_fnc_establishingShot_SITREP")) then {
		terminate BIS_fnc_establishingShot_SITREP;
		["", 0, 0, 5, 0, 0, 90] spawn BIS_fnc_dynamicText;
	};

	
	{if (!(isNil _x)) then {deleteVehicle (missionNamespace getVariable _x)}} forEach ["BIS_fnc_establishingShot_logic1", "BIS_fnc_establishingShot_logic2", "BIS_fnc_establishingShot_logic3"];
	if (!(isNil "BIS_fnc_establishingShot_logic_group")) then {deleteGroup BIS_fnc_establishingShot_logic_group};

	
	optionsMenuOpened = nil;
	optionsMenuClosed = nil;

	if (!(isNil "_drawEH")) then {
		removeMissionEventHandler ["Draw3D", _drawEH];
	};

	if (!(isNull (uiNamespace getVariable "RscEstablishingShot"))) then {
		((uiNamespace getVariable "RscEstablishingShot") displayCtrl 2500) ctrlSetFade 1;
		((uiNamespace getVariable "RscEstablishingShot") displayCtrl 2500) ctrlCommit 0;
	};

	{
		private ["_layer"];
		_layer = _x call BIS_fnc_rscLayer;
		_layer cutText ["", "PLAIN"];
	} forEach ["BIS_layerEstShot", "BIS_layerStatic", "BIS_layerInterlacing"];
	
	enableEnvironment false;
	
	if (_fade) then {
		("BIS_fnc_blackOut" call BIS_fnc_rscLayer) cutText ["","BLACK FADED",10e10];
	} else {
		titleCut ["", "BLACK FADED", 10e10];
	};

	sleep 1;

	enableSaving [true, true];

	BIS_fnc_establishingShot_fakeUAV cameraEffect ["TERMINATE", "BACK"];
	camDestroy BIS_fnc_establishingShot_fakeUAV;

	ppEffectDestroy _ppColor;
	ppEffectDestroy _ppGrain;

	
	BIS_fnc_establishingShot_icons = nil;
	BIS_fnc_establishingShot_spaceEH = nil;
	BIS_fnc_establishingShot_skip = nil;
	BIS_fnc_establishingShot_UAVDone = nil;
	
	if (_fade) then {
		["BIS_fnc_establishingShot"] call BIS_fnc_blackIn;
	};
	
	enableEnvironment true;

	
	BIS_missionStarted = true;
	BIS_fnc_establishingShot_playing = false;
};

true
