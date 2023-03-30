
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleFuel'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleFuel';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\ObjectModifiers\functions\fn_moduleFuel.sqf [BIS_fnc_moduleFuel]"
#line 1 "A3\modules_f\ObjectModifiers\functions\fn_moduleFuel.sqf"
private ["_logic","_units","_kindOfWound","_value","_nameOfHitPoint"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {


_value = (_logic getvariable ["value",0]) min 1 max 0;



{
(vehicle _x) setFuel _value;				
} foreach _units;
};

true
