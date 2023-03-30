#line 0 "/temp/bin/A3/Functions_F/Arrays/fn_maxDiffArray.sqf"
















#line 1 "//temp/bin/A3/Functions_F/paramsCheck.inc"
#line 0 "//temp/bin/A3/Functions_F/paramsCheck.inc"


#line 17 "/temp/bin/A3/Functions_F/Arrays/fn_maxDiffArray.sqf"
if !(_this isEqualTypeParams [[]]) exitWith {[_this, "isEqualTypeParams", [[]]] call (missionNamespace getVariable "BIS_fnc_errorParamsType")};

params ["_arr"];
if !(_arr isEqualTypeAll 0) exitWith {[_arr, "isEqualTypeAll", 0] call (missionNamespace getVariable "BIS_fnc_errorParamsType")};

_arr = +_arr;

_arr sort false;

(_arr select 0) - (_arr select count _arr - 1)
