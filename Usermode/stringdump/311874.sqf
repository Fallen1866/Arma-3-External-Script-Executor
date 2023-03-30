#line 0 "/temp/bin/A3/Functions_F/Misc/fn_jukebox.sqf"





















private ["_function", "_parameters"];
_function	= _this param [0, "initialize", [""]];
_parameters	= _this param [1, [], [[]]];


switch (_function) do {
	











	case "initialize" : {
		
		private ["_musicStealth", "_musicCombat", "_musicSafe", "_volume", "_transition"];
		_musicStealth	= _parameters param [0, ["readContainerFromConfig", ["stealth"]] call BIS_fnc_jukebox, [[]]];
		_musicCombat	= _parameters param [1, ["readContainerFromConfig", ["combat"]] call BIS_fnc_jukebox, [[]]];
		_musicSafe	= _parameters param [2, ["readContainerFromConfig", ["safe"]] call BIS_fnc_jukebox, [[]]];
		_volume		= _parameters param [3, 0.2, [0]];
		_transition	= _parameters param [4, 5, [0]];
		_radius		= _parameters param [5, 500, [0]];
		_executionRate	= _parameters param [6, 5, [0]];
		_noRepeat	= _parameters param [7, true, [true]];
		
		
		if (["isInitialized"] call BIS_fnc_jukeBox) then {
			
			["terminate"] call BIS_fnc_jukeBox;
			
			
			"Re-initializing jukebox" call BIS_fnc_log;
		};
		
		
		private "_onEachFrame";
		_onEachFrame = addMissionEventHandler ["Draw3D", {
			
			["onEachFrame"] call BIS_fnc_jukeBox;
		}];
		
		
		private "_loaded";
		_loaded = addMissionEventHandler ["Loaded", {
			
			private "_music";
			_music = ["selectMusic"] call BIS_fnc_jukeBox;
			
			
			["playMusic", [_music]] call BIS_fnc_jukeBox;
			
			
			["[BIS_fnc_jukebox] Mission loaded, playing music: %1", _music] call BIS_fnc_logFormat;
		}];
		
		
		private "_musicStart";
		_musicStart = addMusicEventHandler ["MusicStart", {
			
			private "_music";
			_music = _this param [0, "", [""]];
			
			
			missionNameSpace setVariable ["BIS_jukeBox_music", _music];
			
			
			["[BIS_fnc_jukebox] Music started: %1", _music] call BIS_fnc_logFormat;
		}];
		
		
		private "_musicStop";
		_musicStop = addMusicEventHandler ["MusicStop", {
			
			private "_music";
			_music = ["selectMusic"] call BIS_fnc_jukeBox;
			
			
			["playMusic", [_music]] call BIS_fnc_jukeBox;
			
			
			["[BIS_fnc_jukebox] Music stopped: %1", _music] call BIS_fnc_logFormat;
		}];
		
		
		missionNameSpace setVariable ["BIS_jukeBox_initialized", true];
		
		
		missionNameSpace setVariable ["BIS_jukeBox_musicStealth", _musicStealth];
		missionNameSpace setVariable ["BIS_jukeBox_musicCombat", _musicCombat];
		missionNameSpace setVariable ["BIS_jukeBox_musicSafe", _musicSafe];
		
		
		missionNameSpace setVariable ["BIS_jukeBox_volume", _volume];
		missionNameSpace setVariable ["BIS_jukeBox_transition", _transition];
		missionNameSpace setVariable ["BIS_jukeBox_radius", _radius];
		missionNameSpace setVariable ["BIS_jukeBox_executionRate", _executionRate];
		missionNameSpace setVariable ["BIS_jukeBox_noRepeat", _noRepeat];
		
		
		missionNameSpace setVariable ["BIS_jukeBox_onEachFrame", _onEachFrame];
		missionNameSpace setVariable ["BIS_jukeBox_loaded", _loaded];
		missionNameSpace setVariable ["BIS_jukeBox_musicStart", _musicStart];
		missionNameSpace setVariable ["BIS_jukeBox_musicStop", _musicStop];
		
		
		missionNameSpace setVariable ["BIS_jukeBox_status", ["status"] call BIS_fnc_jukeBox];
		
		
		missionNameSpace setVariable ["BIS_jukeBox_musicChanging", false];
		
		
		missionNameSpace setVariable ["BIS_jukeBox_music", ["selectMusic"] call BIS_fnc_jukeBox];
		
		
		["playMusic", [missionNameSpace getVariable ["BIS_jukeBox_music", ""]]] call BIS_fnc_jukeBox;
		
		
		["Jukebox started with music: %1", missionNameSpace getVariable "BIS_jukeBox_music"] call BIS_fnc_logFormat;
		"JukeBox initialized" call BIS_fnc_log;
	};
	
	


	case "terminate" : {
		
		removeMissionEventHandler ["Draw3D", missionNameSpace getVariable "BIS_jukeBox_onEachFrame"];
		removeMissionEventHandler ["Loaded", missionNameSpace getVariable "BIS_jukeBox_loaded"];
		removeMusicEventHandler ["MusicStart", missionNameSpace getVariable "BIS_jukeBox_musicStart"];
		removeMusicEventHandler ["MusicStop", missionNameSpace getVariable "BIS_jukeBox_musicStop"];
		
		
		{
			missionNameSpace setVariable [_x, nil];
		} forEach [
			"BIS_jukeBox_initialized",
			"BIS_jukeBox_onEachFrame",
			"BIS_jukeBox_loaded",
			"BIS_jukeBox_musicStart",
			"BIS_jukeBox_musicStop",
			"BIS_jukeBox_status",
			"BIS_jukeBox_musicStealth",
			"BIS_jukeBox_musicCombat",
			"BIS_jukeBox_musicSafe",
			"BIS_jukeBox_volume",
			"BIS_jukeBox_transition",
			"BIS_jukeBox_radius",
			"BIS_jukeBox_executionRate",
			"BIS_jukeBox_noRepeat",
			"BIS_jukeBox_forceBehaviour",
			"BIS_jukeBox_musicChanging",
			"BIS_jukeBox_music"
		];
		
		
		"JukeBox terminated" call BIS_fnc_log;
	};
	
	case "readContainerFromConfig" : {
		
		private ["_themeWanted"];
		_themeWanted = _parameters param [0, "", [""]];
		
		
		
		private "_container";
		_container = [];
		
		
		
		{
			
			_track = _x;
			
			
			if (isClass _track) then {
				
				private ["_class", "_theme"];
				_class = configName _track;
				_theme = getText (configFile >> "CfgMusic" >> _class >> "theme");
				
				
				
				if (_theme == _themeWanted) then {
					_container set [count _container, _class];
				};
			};
		} forEach ((configFile >> "CfgMusic") call BIS_fnc_returnChildren);
		
		
		_container;
	};
	
	


	case "isInitialized" : {
		if (!isNil { missionNameSpace getVariable "BIS_jukeBox_initialized" }) then {
			true;
		} else {
			false;
		};
	};
	
	




	case "forceBehaviour" : {
		
		private "_behaviour";
		_behaviour = _parameters param [0, "", [""]];
		
		
		if (_behaviour == "stealth" || _behaviour == "combat" || _behaviour == "safe") then {
			
			missionNameSpace setVariable ["BIS_jukeBox_forceBehaviour", _behaviour];
			
			
			["Behaviour is now forced: %1", _behaviour] call BIS_fnc_logFormat;
		} else {
			
			missionNameSpace setVariable ["BIS_jukeBox_forceBehaviour", nil];
			
			
			"Behaviour is not forced anymore" call BIS_fnc_log;
		};
	};
	
	




	case "status" : {
		private "_status";
		_status = if (!isNil { missionNameSpace getVariable "BIS_jukeBox_forceBehaviour" }) then {
			missionNameSpace getVariable "BIS_jukeBox_forceBehaviour";
		} else {
			switch (true) do {
				case (["isStealth"] call BIS_fnc_jukeBox) : { "stealth"; };
				case (["isCombat"] call BIS_fnc_jukeBox) : { "combat"; };
				case (["isSafe"] call BIS_fnc_jukeBox) : { "safe"; };
				case DEFAULT { "error"; };
			};
		};
		
		
		_status;
	};
	
	


	case "randomMusic" : {
		
		private ["_container"];
		_container = _parameters param [0, [], [[]]];
		
		
		private "_musicCurrent";
		_musicCurrent = missionNameSpace getVariable ["BIS_jukebox_music", ""];
		
		
		private "_noRepeat";
		_noRepeat = missionNameSpace getVariable ["BIS_jukebox_noRepeat", true];
		
		
		private "_musicNew";
		_musicNew = "";
		
		
		if (count _container > 1) then {
			
			if (_noRepeat && { _musicCurrent in _container }) then {
				_container = _container - [_musicCurrent];
			};
			
			
			_musicNew = _container call BIS_fnc_selectRandom;
		} else {
			if (count _container > 0) then {
				
				_musicNew = _container select 0;
			};
		};
		
		
		_musicNew;
	};
	
	




	case "selectMusic" : {
		
		private ["_musicStealth", "_musicCombat", "_musicSafe"];
		_musicStealth	= missionNameSpace getVariable ["BIS_jukebox_musicStealth", []];
		_musicCombat	= missionNameSpace getVariable ["BIS_jukebox_musicCombat", []];
		_musicSafe	= missionNameSpace getVariable ["BIS_jukebox_musicSafe", []];
		
		
		private "_status";
		_status = ["status"] call BIS_fnc_jukeBox;
		
		
		private "_musicNew";
		_musicNew = switch (_status) do {
			case "stealth" : { ["randomMusic", [_musicStealth]] call BIS_fnc_jukebox; };
			case "combat" : { ["randomMusic", [_musicCombat]] call BIS_fnc_jukebox; };
			case "safe" : { ["randomMusic", [_musicSafe]] call BIS_fnc_jukebox; };
			case DEFAULT { ""; };
		};
		
		
		["Selecting music: %1", _musicNew] call BIS_fnc_logFormat;
		
		
		_musicNew;
	};
	
	




	case "playMusic" : {
		
		private ["_music"];
		_music = _parameters param [0, ["selectMusic"] call BIS_fnc_jukeBox, [""]];
		
		
		private ["_volume", "_transition"];
		_volume		= missionNameSpace getVariable ["BIS_jukeBox_volume", 0.2];
		_transition	= missionNameSpace getVariable ["BIS_jukeBox_transition", 5];
		
		
		if (_music != "") then {
			
			missionNameSpace setVariable ["BIS_jukeBox_musicChanging", true];
			
			
			_transition fadeMusic 0;
			
			
			private "_fade";
			_fade = [_music, _transition, _volume] spawn {
				scriptName "Jukebox: Fade thread";
				
				
				private ["_music", "_transition", "_volume"];
				_music		= _this param [0, "", [""]];
				_transition	= _this param [1, 5, [0]];
				_volume		= _this param [2, 0.2, [0]];
				
				
				sleep _transition;
				
				
				_transition fadeMusic _volume;
				
				
				playMusic _music;
				
				
				
				sleep (_transition * 2);
				
				
				missionNameSpace setVariable ["BIS_jukeBox_musicChanging", false];
				
				
				"[BIS_fnc_jukebox] Changing music done" call BIS_fnc_log;
			};
			
			
			["Changing music: %1", _music] call BIS_fnc_logFormat;
		} else {
			
			"Unable to change music, given string is empty, this might be because of an empty behaviour music container" call BIS_fnc_log;
		};
	};
	
	




	case "nearEnemies" : {
		
		private "_radius";
		_radius = missionNameSpace getVariable ["BIS_jukeBox_radius", 500];
		
		
		private "_enemies";
		_enemies = [];
		
		{
			private "_enemy";
			_enemy = _x;
			
			if (side group player getFriend side group _enemy < 0.6 && { _x distance _enemy < _radius } count units group player > 0) then {
				_enemies set [count _enemies, _enemy];
			};
		} forEach allUnits;
		
		
		_enemies;
	};
	
	


	case "hasContact" : {
		private "_hasContact";
		_hasContact = false;
		
		{
			private "_enemy";
			_enemy = _x;
			
			if ({ _x knowsAbout _enemy >= 2 } count units group player > 0) exitWith {
				_hasContact = true;
			};
		} forEach (["nearEnemies"] call BIS_fnc_jukeBox);
		
		
		_hasContact;
	};
	
	


	case "isContact" : {
		private "_isContact";
		_isContact = false;
		
		{
			private "_enemy";
			_enemy = _x;
			
			if ({ _enemy knowsAbout _x >= 2 } count units group player > 0) exitWith {
				_isContact = true;
			};
		} forEach (["nearEnemies"] call BIS_fnc_jukeBox);
		
		
		_isContact;
	};
	
	


	case "isStealth" : {
		private ["_isContact", "_hasContact"];
		_isContact 	= ["isContact"] call BIS_fnc_jukeBox;
		_hasContact	= ["hasContact"] call BIS_fnc_jukeBox;
		
		private "_isStealth";
		_isStealth = _hasContact && !_isContact;
		
		
		_isStealth;
	};
	
	


	case "isCombat" : {
		private ["_isContact", "_hasContact"];
		_isContact = ["isContact"] call BIS_fnc_jukeBox;
		_hasContact = ["hasContact"] call BIS_fnc_jukeBox;
		
		private "_isCombat";
		_isCombat = _hasContact && _isContact;
		
		
		_isCombat;
	};
	
	


	case "isSafe" : {
		private ["_isStealth", "_isCombat"];
		_isStealth 	= ["isStealth"] call BIS_fnc_jukeBox;
		_isCombat 	= ["isCombat"] call BIS_fnc_jukeBox;
		
		private "_isSafe";
		_isSafe = !_isStealth && !_isCombat;
		
		
		_isSafe;
	};
	
	




	case "onEachFrame" : {
		
		private "_executionRate";
		_executionRate = missionNameSpace getVariable ["BIS_jukeBox_executionRate", 5];
		
		private "_lastCheckTime";
		_lastCheckTime = missionNameSpace getVariable ["BIS_jukeBox_loopTime", 0];
		
		private "_nextCheckTime";
		_nextCheckTime = _lastCheckTime + _executionRate;
		
		private "_timeNow";
		_timeNow = time;
		
		if (_timeNow >= _nextCheckTime) then {
			
			missionNameSpace setVariable ["BIS_jukeBox_loopTime", _timeNow];
			
			
			private "_statusNew";
			_statusNew = ["status"] call BIS_fnc_jukeBox;
			
			
			private "_statusOld";
			_statusOld = missionNameSpace getVariable ["BIS_jukeBox_status", "error"];
			
			
			private "_musicChanging";
			_musicChanging = missionNameSpace getVariable ["BIS_jukeBox_musicChanging", false];
			
			
			
			if (_statusNew != _statusOld && !_musicChanging) then {
				
				missionNameSpace setVariable ["BIS_jukeBox_status", _statusNew];
				
				
				["playMusic"] call BIS_fnc_jukeBox;
				
				
				["StatusNew: %1, StatusOld: %2", _statusNew, _statusOld] call BIS_fnc_logFormat;
			};
		};
	};
	
	


	case DEFAULT {
		
		["Function (%1) is invalid", _function] call BIS_fnc_error;
	};
};

