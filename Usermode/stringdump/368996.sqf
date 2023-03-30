{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleCreateProjectile'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleCreateProjectile';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\Effects\functions\fn_moduleCreateProjectile.sqf [BIS_fnc_moduleCreateProjectile]"
#line 1 "A3\modules_f\Effects\functions\fn_moduleCreateProjectile.sqf"
_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

_type = _logic getvariable ["Type","SmokeShell"];
_smoke = createvehicle [_type,position _logic,[],0,"none"];
_smoke setpos position _logic;
};}
