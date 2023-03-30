
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleTaskCreate'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleTaskCreate';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\Intel\functions\fn_moduleTaskCreate.sqf [BIS_fnc_moduleTaskCreate]"
#line 1 "A3\modules_f\Intel\functions\fn_moduleTaskCreate.sqf"







private [
"_logic",
"_units",
"_activated",
"_owner",
"_taskOwner",
"_ID",
"_title",
"_desc",
"_marker",
"_destination"
];

_logic = _this param [0, objNull, [objNull]];
_units = _this param [1, [], [[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

_owner = _logic getVariable ["Owner", 0];
_ID = _logic getVariable ["ID",""];
if (_ID == "") then {
_ID = vehiclevarname _logic;
if (_ID == "") then {
_ID = format ["task%1",(0 random [position _logic select 0,position _logic select 1]) * 1000000];
};
};
_logic setVariable ["ID",_ID]; 
_IDParent = _logic getVariable ["IDParent",""];
_logic setVariable ["Task", _ID];

_taskOwner = [];
switch _owner do {
case 0: {
_taskOwner = _units;
};
case 1: {
{
_xGroup = group _x;
if !(_xGroup in _taskOwner) then {_taskOwner set [count _taskOwner,_xGroup];};
} foreach _units;
};
case 2: {
{
_xSide = side _x;
if !(_xSide in _taskOwner) then {_taskOwner set [count _taskOwner,_xSide];};
} foreach _units;
};
case 3: {
_taskOwner = true
};
case 4: {_taskOwner = west;};
case 5: {_taskOwner = east;};
case 6: {_taskOwner = resistance;};
case 7: {_taskOwner = civilian;};
};

_title = _logic getVariable ["Title", ""];
_desc = _logic getVariable ["Description", ""];
_marker = _logic getVariable ["Marker", ""];
_destination = _logic getVariable ["Destination", 0];
_state = _logic getVariable ["State", "CREATED"];

private _type = _logic getVariable ["Type", "Default"];
private _alwaysVisible = (_logic getVariable ["AlwaysVisible", 0]) == 1;
private _showNotification = (_logic getVariable ["ShowNotification", 1]) == 1;

[
_taskOwner,
if (_IDParent == "") then {_ID} else {[_ID,_IDParent]},
[_desc,_title,_marker],
switch _destination do {
case 1: {getposatl _logic};
case 2: {if (count _units > 0) then {[_units select 0,true]} else {nil}};
default {nil};
},
_state,
nil,
_showNotification,
_type,
_alwaysVisible
]
call BIS_fnc_taskCreate;
};
