{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleStrategicMapOpen'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleStrategicMapOpen';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\StrategicMap\functions\fn_moduleStrategicMapOpen.sqf [BIS_fnc_moduleStrategicMapOpen]"
#line 1 "A3\modules_f\StrategicMap\functions\fn_moduleStrategicMapOpen.sqf"
private ["_logic","_units","_show"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[player],[[]]];
_activated = _this param [2,true,[true]];

if !(_activated) exitwith {false};
if !(player in _units) exitwith {false};
sleep 0.01;

_overcast = _logic getvariable ["Overcast",""];
_overcast = if (_overcast == "") then {overcast} else {_overcast call bis_fnc_parsenumber};

_isNight = _logic getvariable ["Daytime",""];
_isNight = if (_isNight == "") then {0} else {_isNight call bis_fnc_parsenumber};
_isNight = _isNight > 0;

_coreCount = 0;
_corePos = position _logic;
_markers = [];
_missions = [];
_ORBAT = [];
_images = [];
{
if (typeof _x == "ModuleStrategicMapInit_F") then {
_coreCount = _coreCount + 1;
if (_coreCount == 1) then {

_markers = _x getvariable ["Markers",""];
_markers = call compile ("[" + _markers + "]");
{
switch (typeof _x) do {
case "ModuleStrategicMapMission_F": {
_data = _x getvariable ["data",[]];
if (count _data > 0) then {
_missions set [count _missions,_data];
};
};
case "ModuleStrategicMapORBAT_F": {
_data = _x getvariable ["data",[]];
if (count _data > 0) then {
_ORBAT set [count _ORBAT,_data];
};
};
case "ModuleStrategicMapImage_F": {
_data = _x getvariable ["data",[]];
if (count _data > 0) then {
_images set [count _images,_data];
};
};
};
} foreach (_x call bis_fnc_moduleModules);
};
};
} foreach (_logic call bis_fnc_moduleModules);

if (_coreCount > 0) then {
if (_coreCount > 1) then {["Multiple ""Strategic Map"" modules connected to ""Open Strategic Map"" module (%1), there should be only one."] call bis_fnc_error;};
[
nil,
_corePos,
_missions,
_ORBAT,
_markers,
_images,
_overcast,
_isNight
] spawn {
cuttext ["","black out",0.5];
sleep 0.6;
_this call bis_fnc_strategicMapOpen;
};
} else {
["No ""Strategic Map"" module connected to ""Open Strategic Map"" module (%1).",_logic] call bis_fnc_error;
};

true}
