{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_TwoWingSlideDoorClose'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_TwoWingSlideDoorClose';
	scriptName _fnc_scriptName;

#line 1 "A3\Structures_F\scripts\fn_TwoWingSlideDoorClose.sqf [BIS_fnc_TwoWingSlideDoorClose]"
#line 1 "A3\Structures_F\scripts\fn_TwoWingSlideDoorClose.sqf"








private
[
"_structure",
"_doorA",
"_doorB",
"_targetA",
"_targetB"
];

_structure = param [0, objNull, [objNull]];
_doorA = param [1, "", [""]];
_doorB = param [2, "", [""]];
_targetA = param [3, 0, [0]];
_targetB = param [4, 0, [0]];

if (!((isNull (_structure)) ||
((count (_doorA)) < 1) ||
((count (_doorB)) < 1)
))
then
{
_structure animate [_doorA, _targetA];
_structure animate [_doorB, _targetB];
};}
