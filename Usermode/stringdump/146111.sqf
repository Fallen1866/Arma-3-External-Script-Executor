
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleHealth'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleHealth';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\ObjectModifiers\functions\fn_moduleHealth.sqf [BIS_fnc_moduleHealth]"
#line 1 "A3\modules_f\ObjectModifiers\functions\fn_moduleHealth.sqf"
private ["_logic","_units","_kindOfWound","_value","_bodyParts"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {


_value = (_logic getvariable ["value",0]) min 1 max 0;
_kindOfWound = _logic getvariable ["bodypart",0];
if (_kindOfWound isequaltype "") then {_kindOfWound = parsenumber _kindOfWound;};

_bodyParts=["Whole body"];
{
_bodyParts=_bodyParts + [configName _x]; 
} foreach ((configfile >> "CfgVehicles" >> "CAManBase" >> "HitPoints") call bis_fnc_subClasses);

if (_kindOfWound==0) then
{
{if (_x isKindOf "CaManBase") then
{				
_x setDamage _value;			
};
} foreach _units
} else {
{if (_x isKindOf "CaManBase") then
{				
_x setHitPointDamage [(_bodyParts select _kindOfWound),_value];			
};
} foreach _units
};
};

true
