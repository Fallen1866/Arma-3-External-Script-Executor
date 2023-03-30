
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleDamage'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleDamage';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\ObjectModifiers\functions\fn_moduleDamage.sqf [BIS_fnc_moduleDamage]"
#line 1 "A3\modules_f\ObjectModifiers\functions\fn_moduleDamage.sqf"
private ["_logic","_units","_kindOfWound","_value","_nameOfHitPoint"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {


_value = (_logic getvariable ["value",0]) min 1 max 0;
_nameOfHitPoint = _logic getvariable ["bodypart","0"];



if (_nameOfHitPoint=="0") then
{
{
_veh = vehicle _x;
if (!(_x isKindOf "CaManBase")) then
{				
_veh setDamage _value;			
};
} foreach _units
} else {
{
_veh = vehicle _x;
if (!(_veh isKindOf "CaManBase")) then
{				
_veh setHitPointDamage [_nameOfHitPoint,_value];
};
} foreach _units	
};
};

true
