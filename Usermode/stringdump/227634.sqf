#line 0 "/temp/bin/A3/Functions_F/Arrays/fn_removeNestedElement.sqf"




















private ["_array", "_value"];
_array = _this select 0;
_value = _this select 1;

if ((typeName _array) != (typeName [])) exitWith {debugLog "Log: [removeNestedElement] Array (0) should be an Array!"; false};

private ["_path", "_subArray"];

_path = [_array, _value] call BIS_fnc_findNestedElement;


_path resize ((count _path) - 1);
_subArray = [_array, _path] call BIS_fnc_returnNestedElement;


_subArray = _subArray - [_value];


[_array, _path, _subArray] call BIS_fnc_setNestedElement;

true
