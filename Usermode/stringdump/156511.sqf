#line 0 "/temp/bin/A3/Functions_F/Arrays/fn_arrayUnShift.sqf"



















#line 1 "//temp/bin/A3/Functions_F/paramsCheck.inc"
#line 0 "//temp/bin/A3/Functions_F/paramsCheck.inc"


#line 20 "/temp/bin/A3/Functions_F/Arrays/fn_arrayUnShift.sqf"

if !(_this isEqualTypeParams [[],nil]) exitWith {[_this, "isEqualTypeParams", [[],nil]] call (missionNamespace getVariable "BIS_fnc_errorParamsType")};

params ["_arr", "_el"];

_el = [_el];
_el append _arr;
_arr resize 0;
_arr append _el;

_arr

