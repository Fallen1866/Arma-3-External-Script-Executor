#line 0 "/temp/bin/A3/Functions_F/Modules/fn_moduleInit.sqf"
_logic = _this param [0,objnull,[objnull]];
_mode = _this param [1,"init",[""]];

switch _mode do {
	case "attributesChanged3DEN": {
		[_mode,[_logic]] call (missionnamespace getvariable (_logic getvariable ["bis_fnc_moduleInit_function",{}]));
	};
	case "registeredToWorld3DEN": {
		[_mode,[_logic]] call (missionnamespace getvariable (_logic getvariable ["bis_fnc_moduleInit_function",{}]));
	};
	case "unregisteredFromWorld3DEN": {
		[_mode,[_logic]] call (missionnamespace getvariable (_logic getvariable ["bis_fnc_moduleInit_function",{}]));
	};
	case "connectionChanged3DEN": {
		[_mode,[_logic]] call (missionnamespace getvariable (_logic getvariable ["bis_fnc_moduleInit_function",{}]));
	};
	case "dragged3DEN": {
		[_mode,[_logic]] call (missionnamespace getvariable (_logic getvariable ["bis_fnc_moduleInit_function",{}]));
	};
	case "init": {
		_logic setvariable ["bis_fnc_moduleInit_status",false];
		_logicType = typeof _logic;
		_logic hideobject true;

		
		_functionPriority = getnumber (configfile >> "cfgvehicles" >> _logicType >> "functionPriority");
		_function = gettext (configfile >> "cfgvehicles" >> _logicType >> "function");
		_isGlobal = getnumber (configfile >> "cfgvehicles" >> _logicType >> "isGlobal") > 0;
		_isPersistent = getnumber (configfile >> "cfgvehicles" >> _logicType >> "isPersistent") > 0 || getnumber (configfile >> "cfgvehicles" >> _logicType >> "isGlobal") > 1;		_is3DEN = getnumber (configfile >> "cfgvehicles" >> _logicType >> "is3DEN") > 0;

		
		if (is3DEN && !_is3DEN) exitwith {};

		
		if (_is3DEN) then {
			_logic setvariable ["bis_fnc_moduleInit_function",_function];
			_logic addeventhandler ["attributesChanged3DEN",{[_this select 0,'attributesChanged3DEN'] call bis_fnc_moduleInit;}];
			_logic addeventhandler ["unregisteredFromWorld3DEN",{[_this select 0,'unregisteredFromWorld3DEN'] call bis_fnc_moduleInit;}];
			_logic addeventhandler ["registeredToWorld3DEN",{[_this select 0,'registeredToWorld3DEN'] call bis_fnc_moduleInit;}];
			_logic addeventhandler ["connectionChanged3DEN",{[_this select 0,'connectionChanged3DEN'] call bis_fnc_moduleInit;}];
			_logic addeventhandler ["dragged3DEN",{[_this select 0,'dragged3DEN'] call bis_fnc_moduleInit;}];
		};

		
		_logic setvariable ["bis_fnc_initModules_priroty",abs _functionPriority];
		_logic setvariable ["bis_fnc_initModules_activate",false];

		
		_logic spawn {_this setname "";};

		
		if (!isserver && !_isGlobal) exitwith {_logic setvariable ["bis_fnc_moduleInit_status",true];};

		
		[_logic,_logicType] spawn {
			_fnc_scriptName = "Module Init";
			scriptname _fnc_scriptName;

			_logic = _this select 0;
			_logicType = _this select 1;
			_isCuratorPlaced = !is3DEN && (side group _logic != sidelogic || (group _logic) getvariable ["isCuratorModuleGroup",false]);
			_logic setvariable ["bis_fnc_moduleInit_isCuratorPlaced",_isCuratorPlaced];

			
			_function = gettext (configfile >> "cfgvehicles" >> _logicType >> "function");
			_isTriggerActivated = getnumber (configfile >> "cfgvehicles" >> _logicType >> "isTriggerActivated") > 0;
			_isGlobal = getnumber (configfile >> "cfgvehicles" >> _logicType >> "isGlobal") > 0;
			_isDisposable = getnumber (configfile >> "cfgvehicles" >> _logicType >> "isDisposable") > 0;
			_isPersistent = getnumber (configfile >> "cfgvehicles" >> _logicType >> "isPersistent") > 0 || getnumber (configfile >> "cfgvehicles" >> _logicType >> "isGlobal") > 1;
			_is3DEN = getnumber (configfile >> "cfgvehicles" >> _logicType >> "is3DEN") > 0;

			
			_triggerCount = count (_logic call bis_fnc_moduleTriggers);
			if (isserver) then {
				
				if (time > 0 && {!(_logic getvariable ["bis_fnc_initModules_disableAutoActivation",true])}) then {_logic setvariable ["bis_fnc_initModules_activate",true];};
			} else {
				
				waituntil {getClientState != "MISSION RECEIVED" && getClientState != "GAME LOADED"};

				
				_logic setvariable ["bis_fnc_initModules_activate",!_isTriggerActivated || (_isTriggerActivated && _triggerCount == 0)];
			};

			
			if (_isCuratorPlaced) then {_logic setvariable ["bis_fnc_initModules_activate",true];};

			
			waituntil {_logic getvariable ["bis_fnc_initModules_activate",true] || isnull _logic};
			if (isnull _logic) exitwith {};

			
			if (!isserver && !(_logic getvariable ["bis_fnc_moduleExecute_activate",!_isTriggerActivated])) exitwith {_logic setvariable ["bis_fnc_moduleInit_status",true];};

			
			_isGlobal = _isGlobal && isserver;
			_isTriggerActivated = _isTriggerActivated && isserver;
			_isPersistent = _isPersistent && isserver;

			
			_logicMain = missionnamespace getvariable ["bis_functions_mainscope",objnull];
			_canExecute = true;
			if (isnull _logicMain) then {_canExecute = false; "Functions logic 'BIS_functions_mainscope' is missing" call bis_fnc_error;};
			if (isnull _logic) then {_canExecute = false; "Module logic is missing" call bis_fnc_error;};
			if (_function == "") then {_canExecute = false;};

			
			private ["_time"];
			_time = diag_ticktime;
			if (_canExecute) then {
				_moduleParams = [
					_logic,
					_function,
					[_isGlobal,_isTriggerActivated,_isDisposable,_isPersistent,_isCuratorPlaced,_is3DEN],
					true
				];

				if (!_isCuratorPlaced && !is3DEN) then {
					if (_isTriggerActivated && _triggerCount > 0) then {

						
						_moduleParams set [3,false]; 
						_modules = _logicMain getvariable ["bis_fnc_moduleInit_modules",[]];
						_modules set [count _modules,_moduleParams];
						_logicMain setvariable ["bis_fnc_moduleInit_modules",_modules,true];

						
						_logic setvariable ["BIS_fnc_moduleInit_registered",true,true];

						
						if (isnil "bis_fnc_moduleInit_fsm") then {
							bis_fnc_moduleInit_fsm = [_logic] call bis_fnc_moduleHandle;
						};
					} else {
						_moduleParams call bis_fnc_moduleExecute;
					};
				} else {
					
					_moduleParams call bis_fnc_moduleExecute;
				};
			};

			
			if (isserver && side group _logic == sidelogic) then {
				_category = gettext (configfile >> "cfgvehicles" >> _logicType >> "category");
				_groupOld = group _logic;
				_group = missionnamespace getvariable ["bis_fnc_initModules_" + _category,group _logicMain];
				_ownerID = owner _logic;
				[_logic] joinsilent _group;
				if (count units _groupOld == 0) then {deletegroup _groupOld;};
			};

			
			_logic setvariable ["bis_fnc_moduleInit_status",true];

			_fnc_scriptname = "module";
			["%1 (%2 ms)",_function,(diag_ticktime - _time) * 1000] call bis_fnc_logformat;
		};
	};
};
