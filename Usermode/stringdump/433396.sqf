#line 0 "/temp/bin/A3/Functions_F/Bitwise/fn_bitflagsUnset.sqf"





























#line 1 "//temp/bin/A3/Functions_F/paramsCheck.inc"
#line 0 "//temp/bin/A3/Functions_F/paramsCheck.inc"


#line 30 "/temp/bin/A3/Functions_F/Bitwise/fn_bitflagsUnset.sqf"

if !(_this isEqualTypeParams [0,0]) exitWith {[_this, "isEqualTypeParams", [0,0]] call (missionNamespace getVariable "BIS_fnc_errorParamsType")};

params ["_flagset", "_flags"];

[_flagset, _flags call BIS_fnc_bitwiseNOT] call BIS_fnc_bitwiseAND
