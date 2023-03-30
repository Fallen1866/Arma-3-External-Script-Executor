#line 0 "/temp/bin/A3/Functions_F/GUI/fn_initDisplay.sqf"



























if (_this isEqualTo []) exitWith
{
	{
		{
			if (getNumber (_x >> "scriptIsInternal") isEqualTo 0) then 
			{ 
				_scriptName = getText (_x >> "scriptName");
				_scriptPath = getText (_x >> "scriptPath");
				
				if (_scriptName isEqualTo "" || _scriptPath isEqualTo "") exitWith 
				{
					[
						'Undefined param(s) [scriptPath: "%2", scriptName: "%3"] while trying to init display "%1"', 
						configName _x, 
						_scriptPath, 
						_scriptName
					] 
					call BIS_fnc_logFormat;
				};
				
				_script = _scriptName + "_script";
				
				if (uiNamespace getVariable [_script, 0] isEqualType {}) exitWith {}; 
				
				uiNamespace setVariable 
				[
					_script,
					compileScript [
						format ["%1%2.sqf", getText (configFile >> "CfgScriptPaths" >> _scriptPath), _scriptName],
						true, 
						format ["scriptName '%1'; _fnc_scriptName = '%1'; ", _scriptName] 
					]
				];
			};
		} 
		forEach ("isText (_x >> 'scriptPath')" configClasses _x);
	} 
	forEach
	[
		configFile,
		configFile >> "RscTitles",
		configFile >> "RscInGameUI",
		configFile >> "Cfg3DEN" >> "Attributes"
	];

	nil
};


with uiNamespace do
{
	params 
	[
		["_mode", "", [""]],
		["_params", []],
		["_class", "", [""]],
		["_path", "default", [""]],
		["_register", true, [true, 0]]
	];

	_display = _params param [0, displayNull];
	if (isNull _display) exitWith {nil};

	if (_register isEqualType true) then {_register = parseNumber _register};
	if (_register > 0) then 
	{
		_varDisplays = _path + "_displays";
		_displays = (uiNamespace getVariable [_varDisplays, []]) - [displayNull];

		if (_mode == "onLoad") exitWith 
		{
			
			_display setVariable ["BIS_fnc_initDisplay_configClass", _class];
			uiNamespace setVariable [_class, _display];
			
			_displays pushBackUnique _display;
			uiNamespace setVariable [_varDisplays, _displays];
			
			if !(uiNamespace getVariable ["BIS_initGame", false]) then 
			{
				
				
				uiNamespace setVariable ["BIS_initGame", _path == "GUI" && {ctrlIdd _x >= 0} count _displays > 1];
			};
			
			[missionNamespace, "OnDisplayRegistered", [_display, _class]] call BIS_fnc_callScriptedEventHandler;
		};
		
		if (_mode == "onUnload") exitWith 
		{
			
			_displays = _displays - [_display];
			uiNamespace setVariable [_varDisplays, _displays];
			
			[missionNamespace, "OnDisplayUnregistered", [_display, _class]] call BIS_fnc_callScriptedEventHandler;
		};
		
	};
	
	
	if (!cheatsEnabled) exitWith 
	{
		[_mode, _params, _class] call (uiNamespace getVariable (_class + "_script"));
		nil
	};

	
	uinamespace setvariable 
	[
		_class + "_script",
		compileScript [
			format ["%1%2.sqf", getText (configFile >> "CfgScriptPaths" >> _path), _class],
			true, 
			format ["scriptName '%1'; _fnc_scriptName = '%1'; ", _class] 
		]
	];
	
	
	if !(uiNamespace getVariable ["BIS_disableUIscripts", false]) then 
	{
		[_mode, _params, _class] call (uiNamespace getVariable (_class + "_script"));
		nil
	};
};
