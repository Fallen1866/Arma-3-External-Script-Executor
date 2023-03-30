#line 0 "/temp/bin/A3/Functions_F/Configs/fn_configPath.sqf"































private _fnc_getNameFromConfig = 
{
	if (_this isEqualTo configFile) exitWith {"configFile"};
	if (_this isEqualTo missionConfigFile) exitWith {"missionConfigFile"};
	if (_this isEqualTo campaignConfigFile) exitWith {"campaignConfigFile"};
	configName _this
};

private _fnc_getConfigHierarchy = 
{
	if (_this isEqualTo []) exitWith {[configNull]};
	
	private _base = _this deleteAt 0 call 
	{
		if (_this isEqualTo "") exitWith {configNull};
		if (_this == "configFile" || {_this == str configFile}) exitWith {configFile};
		if (_this == "missionConfigFile" || {_this == str missionConfigFile}) exitWith {missionConfigFile};
		if (_this == "campaignConfigFile" || {_this == str campaignConfigFile}) exitWith {campaignConfigFile};
		configNull
	};
	
	if (!isNull _base) exitWith {[_base] + (_this apply {_base = _base >> _x; _base})};
	[configNull]
};

params [["_config", -1], "_type", ["_strict", false]];


if !(_config isEqualTypeAny [[], "", configNull]) exitWith {[_this, "isEqualTypeParams", [[], configNull]] call BIS_fnc_errorParamsType};


if (_config isEqualType [] && isNil "_type") then {_type = configNull};


if (isNil "_type") then {_type = []};


if !(_type isEqualTypeAny [[], "", configNull]) exitWith {[_this, "isEqualTypeParams", [[], configNull]] call BIS_fnc_errorParamsType};


if (_strict isEqualTo false && {_config isEqualType _type}) exitWith {_config};

private _cfgArr = [configNull];


if (_config isEqualType configNull && {!isNull _config}) then 
{
	if (isClass _config) exitWith {_cfgArr = configHierarchy _config};
	_cfgArr = str _config splitString "/" call _fnc_getConfigHierarchy;
};


if (_config isEqualType "" && {!(_config isEqualTo "")}) then 
{
	call
	{
		if (_config find ">>" > -1) exitWith 
		{
			_cfgArr = _config splitString " >""'" call _fnc_getConfigHierarchy;
		};
		
		if (_config find "\" > -1) exitWith 
		{
			_cfgArr = _config splitString "/" call _fnc_getConfigHierarchy;
		};
		
		
		_cfgArr = _config splitString " /""'" call _fnc_getConfigHierarchy;
	};
};


if (_strict isEqualTo false && {[_config, _type] isEqualTypeParams [[], ""]}) exitWith 
{
	private _strArr = _config apply {str _x};
	_strArr set [0, _config param [0, ""]];
	_strArr joinString " >> "
};


if (_config isEqualType [] && {_config isEqualTypeAll ""}) then {_cfgArr = +_config call _fnc_getConfigHierarchy};


if (_type isEqualType configNull) exitWith {_cfgArr select (count _cfgArr - 1)};


if (_type isEqualType "") exitWith {([_cfgArr deleteAt 0 call _fnc_getNameFromConfig] + (_cfgArr apply {str (_x call _fnc_getNameFromConfig)})) joinString " >> "};


_cfgArr apply {_x call _fnc_getNameFromConfig}
