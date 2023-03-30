#line 0 "/temp/bin/A3/Functions_F/Configs/fn_loadClass.sqf"















params [["_path", []], ["_default", configFile], "_core"];


#line 1 "//temp/bin/A3/Functions_F/paramsCheck.inc"
#line 0 "//temp/bin/A3/Functions_F/paramsCheck.inc"


#line 19 "/temp/bin/A3/Functions_F/Configs/fn_loadClass.sqf"


if !([_path,_default] isEqualTypeArray [[],configNull]) exitWith {[[_path,_default], "isEqualTypeArray", [[],configNull]] call (missionNamespace getVariable "BIS_fnc_errorParamsType")};

if !(_path isEqualTypeAll "") exitWith {["Error: Path must be ARRAY of STRINGs in %1 on index 0", _this] call BIS_fnc_error; _default};
_path = format ['>> "%1"', _path joinString '" >> "'];

_core = call compile ("missionConfigFile" + _path);
if (isClass _core) exitWith {_core};

_core = call compile ("campaignConfigFile" + _path);
if (isClass _core) exitWith {_core};

_core = call compile ("configFile" + _path);
if (isClass _core) exitWith {_core};

_default
