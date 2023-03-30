#line 0 "/temp/bin/A3/Functions_F/Configs/fn_classMagazine.sqf"

















params ["_magazine"];


#line 1 "//temp/bin/A3/Functions_F/paramsCheck.inc"
#line 0 "//temp/bin/A3/Functions_F/paramsCheck.inc"


#line 21 "/temp/bin/A3/Functions_F/Configs/fn_classMagazine.sqf"
if !([_magazine] isEqualTypeArray [""]) exitWith {[[_magazine], "isEqualTypeArray", [""]] call (missionNamespace getVariable "BIS_fnc_errorParamsType")};

private _class = configFile >> "CfgMagazines" >> _magazine;

if (isClass _class) then {_class} else {configNull};
