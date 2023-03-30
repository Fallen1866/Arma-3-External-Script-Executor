
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_liveFeedModuleInit'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_liveFeedModuleInit';
	scriptName _fnc_scriptName;

#line 1 "a3\modules_f\livefeed\functions\fn_liveFeedModuleInit.sqf [BIS_fnc_liveFeedModuleInit]"
#line 1 "a3\modules_f\livefeed\functions\fn_liveFeedModuleInit.sqf"











if (isDedicated) exitWith {true};

private ["_module"];
_module = _this param [0, objNull, [objNull]];


private ["_units"];
_units = _module call BIS_fnc_moduleUnits;

if (player in _units) then {

[player, player, player] call BIS_fnc_liveFeed;
};

true
