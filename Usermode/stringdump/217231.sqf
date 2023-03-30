
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_3DENControlsHint'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_3DENControlsHint';
	scriptName _fnc_scriptName;

#line 1 "A3\3DEN\Functions\fn_3DENControlsHint.sqf [BIS_fnc_3DENControlsHint]"
#line 1 "A3\3DEN\Functions\fn_3DENControlsHint.sqf"
#line 1 "a3\3DEN\UI\resincl.inc"












































































































































































































































































































































































































































































































































#line 1 "A3\3DEN\Functions\fn_3DENControlsHint.sqf"










































_display = finddisplay 					313;
_ctrlHint = _display displayctrl 			1044;

_mode = _this param [0,"",[""]];
switch _mode do {
case "loop": {
if !(ctrlshown _ctrlHint) exitwith {};


_fnc_show = {
_lbAdd = _ctrlHint lbadd (_x select 0);
_ctrlHint lbSetTextRight [_lbAdd,_x select 1];
_ctrlHint lbSetPictureRight [_lbAdd,_x select 2];

};


private ["_hoverType","_hoverEntity"];
_hover = get3DENMouseOver;
_hoverType = "";
if (count _hover > 0) then {
_hoverType = _hover select 0;
_hoverEntity = _hover select 1;
};

lbclear _ctrlHint;
_operation = _this param [1,current3DENOperation];
switch _operation do {


case "": {

_selected = +(uinamespace getvariable ["bis_fnc_3DENControlsHint_selected",[0,[0,0,0,0,0,0],[[],[],[],[],[],[]]]]);
_countTotal = _selected select 0;
_countTypes = _selected select 1;
_selectedTypes = _selected select 2;


_countTypesLocal = +_countTypes;
if (_hoverType != "") then {
_typeID = ["Object","Group","Trigger","Waypoint","Logic","Marker","Comment"] find _hoverType;
if (_typeID >= 0) then {
_countTypesLocal set [_typeID,(_countTypesLocal select _typeID) + 1];

_fnc_show foreach [[			(localize "STR_3DEN_Display3DEN_ControlsHint_Move"),						"",			"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_drag_ca.paa",				"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denMove_ca.paa"]];
if (get3DENActionState "togglemap" == 0) then {
_fnc_show foreach [[			(localize "STR_3DEN_Display3DEN_ControlsHint_MoveZ"),					"Alt +",			"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_drag_ca.paa",				"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denMoveZ_ca.paa"]];
};
if ((_countTypesLocal select 0) > 0 || (_countTypesLocal select 2) > 0 || (_countTypesLocal select 4) > 0 || (_countTypesLocal select 0) > 5) then {
_fnc_show foreach [[			(localize "STR_3DEN_Display3DEN_ControlsHint_Rotate"),					(localize "STR_vk_shift" + " +"),			"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_drag_ca.paa",				"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denRotate_ca.paa"]];
};
if (_hoverType == "Object" && {!isnull group _hoverEntity}) then {
_fnc_show foreach [[		(localize "STR_3DEN_Connections_Group"),				"Ctrl +",			"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_drag_ca.paa",			"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denConnectGroup_ca.paa"]];
};
} else {
["'%1' is not a correct entity type!",_hoverType] call bis_fnc_error;
};
};


if (_countTotal > 0 && {{!isnull group _x} count (_selectedTypes select 0) > 0} || {(_countTypes select 1) > 0} || {(_countTypes select 3) > 0}) then {
if (_hoverType == "Object") then {
_fnc_show foreach [[		(localize "STR_3DEN_Display3DEN_ControlsHint_AttachWaypoint"),				(localize "STR_vk_shift" + " +"),				"\a3\3DEN\Data\Displays\Display3DEN\Hint\rmb_ca.paa",				"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denPlaceWaypointAttach_ca.paa"]];
} else {
_fnc_show foreach [[		(localize "STR_3DEN_Display3DEN_ControlsHint_PlaceWaypoint"),				(localize "STR_vk_shift" + " +"),				"\a3\3DEN\Data\Displays\Display3DEN\Hint\rmb_ca.paa",				"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denPlaceWaypoint_ca.paa"]];
};
};

if (_hoverType != "") then {
_fnc_show foreach [[			(localize "STR_3DEN_Display3DEN_ControlsHint_Attributes"),						"2 x",					"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_ca.paa",					"#(argb,8,8,3)color(0,0,0,0)"]];
};
};


case "MoveUnit": {
if (get3DENActionState "togglemap" == 0) then {
_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_MoveZ"),					"Alt +",			"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_drag_ca.paa",				"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denMoveZ_ca.paa"]
];
};
_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Cancel"),					"",				"\a3\3DEN\Data\Displays\Display3DEN\Hint\rmb_ca.paa",					"#(argb,8,8,3)color(0,0,0,0)"]
];
};
case "RotateUnit": {
_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Cancel"),					"",				"\a3\3DEN\Data\Displays\Display3DEN\Hint\rmb_ca.paa",					"#(argb,8,8,3)color(0,0,0,0)"]
];
};


case "CreateObject": {
_place = uinamespace getvariable ["bis_fnc_3DENControlsHint_place",[""]];
_placeClass = _place select 0;
if (_placeClass != "") then {
_mouseButtons = uinamespace getvariable ["bis_fnc_3DENControlsHint_mouseButtons",[false,false]];
if (_mouseButtons select 0) then {


_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Cancel"),					"",				"\a3\3DEN\Data\Displays\Display3DEN\Hint\rmb_ca.paa",					"#(argb,8,8,3)color(0,0,0,0)"]
];

} else {


if (get3DENActionState "SelectWaypointMode" > 0) then {

if (count (get3denselected "object" + get3denselected "group" + get3denselected "waypoint") > 0) then {
if (_hoverType == "Object") then {
_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Attach"),					"",					"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_ca.paa",			"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denPlaceWaypointAttach_ca.paa"],
[			(localize "STR_3DEN_Display3DEN_ControlsHint_AttachMulti"),				"Ctrl +",					"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_ca.paa",		"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denPlaceWaypointAttachMulti_ca.paa"],
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Cancel"),					"",					"\a3\3DEN\Data\Displays\Display3DEN\Hint\rmb_ca.paa",				"#(argb,8,8,3)color(0,0,0,0)"]
];
} else {
_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Place"),					"",					"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_ca.paa",			"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denPlaceWaypoint_ca.paa"],
[			(localize "STR_3DEN_Display3DEN_ControlsHint_PlaceMulti"),				"Ctrl +",					"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_ca.paa",		"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denPlaceWaypointMulti_ca.paa"],
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Cancel"),					"",					"\a3\3DEN\Data\Displays\Display3DEN\Hint\rmb_ca.paa",				"#(argb,8,8,3)color(0,0,0,0)"]
];
};
};
} else {

_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Place"),					"",				"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_ca.paa",					"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denPlace_ca.paa"],
[			(localize "STR_3DEN_Display3DEN_ControlsHint_PlaceMulti"),				"Ctrl +",				"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_ca.paa",				"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denPlaceMulti_ca.paa"]
];
_isVehicle = _place select 1;
if (
get3DENActionState "SelectObjectMode" > 0
&&
_isVehicle
) then {
_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_PlaceEmpty"),				"Alt +",				"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_ca.paa",					"\a3\3DEN\Data\CfgWrapperUI\Cursors\3denPlace_ca.paa"]
];
};
_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Cancel"),					"",				"\a3\3DEN\Data\Displays\Display3DEN\Hint\rmb_ca.paa",					"#(argb,8,8,3)color(0,0,0,0)"]
];
};
};
};
};


default {
_connect = uinamespace getvariable ["bis_fnc_3DENControlsHint_connect",["",""]];
_connectName = _connect select 0;
if (_connectName != "") then {

_connectTexture = _connect select 1;
if (_hoverType == "") then {
_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Disconnect"),				"",				"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_ca.paa",		_connectTexture]
];
} else {
_fnc_show foreach [
[_connectName,				"",				"\a3\3DEN\Data\Displays\Display3DEN\Hint\lmb_ca.paa",		_connectTexture]
];
};
_fnc_show foreach [
[			(localize "STR_3DEN_Display3DEN_ControlsHint_Cancel"),					"",				"\a3\3DEN\Data\Displays\Display3DEN\Hint\rmb_ca.paa",					"#(argb,8,8,3)color(0,0,0,0)"]
];
};
};
};


_posDef = uinamespace getvariable ["bis_fnc_3DENControlsHint_pos",[0,0,0,0]];
_pos = +_posDef;
_pos set [3,(_pos select 3) * lbsize _ctrlHint * 0.1];
_pos set [1,(_pos select 1) - (_pos select 3)];
_ctrlHint ctrlsetposition _pos;
_ctrlHint ctrlcommit 0;
};
case "mousebuttondown";
case "mousebuttonup": {
_mouseButtons = uinamespace getvariable ["bis_fnc_3DENControlsHint_mouseButtons",[false,false]];
_mouseButtons set [(_this select 1) select 1,_mode == "mousebuttondown"];
uinamespace setvariable ["bis_fnc_3DENControlsHint_mouseButtons",_mouseButtons];

};
case "place": {
_data = _this param [1,[]];
_ctrlList = _data select 0;
_path = _data select 1;
_data = if (_ctrlList tvcount _path == 0) then {
_class = _ctrlList tvdata _path;
_isVehicle = if (get3DENActionState "SelectObjectMode" > 0) then {
_simulation = gettext (configfile >> "cfgvehicles" >> _class >> "simulation");
(tolower _simulation) in ["car","carx","tank","tankx","helicopter","helicopterx","helicopterrtd","airplane","airplanex","ship","shipx","submarinex","hovercraftx","motorcycle","parachute","paraglide"]
} else {
false
};
[_class,_isVehicle]
} else {
["",false]
};
uinamespace setvariable ["bis_fnc_3DENControlsHint_place",_data];
["loop","CreateObject"] call bis_fnc_3DENControlsHint;
};
case "select": {
_selectedObject = get3denselected "object";
_selectedGroup = get3denselected "group";
_selectedTrigger = get3denselected "trigger";
_selectedWaypoint = get3denselected "waypoint";
_selectedLogic = get3denselected "logic";
_selectedMarker = get3denselected "marker";

_countObject = count _selectedObject;
_countGroup = count _selectedGroup;
_countTrigger = count _selectedTrigger;
_countWaypoint = count _selectedWaypoint;
_countLogic = count _selectedLogic;
_countMarker = count _selectedMarker;

uinamespace setvariable [
"bis_fnc_3DENControlsHint_selected",
[
_countObject + _countGroup + _countTrigger + _countWaypoint + _countLogic + _countMarker,
[_countObject,_countGroup,_countTrigger,_countWaypoint,_countLogic,_countMarker],
[_selectedObject,_selectedGroup,_selectedTrigger,_selectedWaypoint,_selectedLogic,_selectedMarker]
]
];
};
case "connectStart": {
if (count (_this select 1) == 3) exitwith {["connectEnd",_this select 1] call bis_fnc_3DENControlsHint;}; 

_connectClass = (_this select 1) select 0;
_connectCfg = configfile >> "Cfg3DEN" >> "Connections" >> _connectClass;
_connectName = gettext (_connectCfg >> "displayName");
_connectCursor = gettext (_connectCfg >> "cursor");
_connectCursorTexture = configfile >> "CfgWrapperUI" >> "cursors" >> _connectCursor >> "texture";
uinamespace setvariable ["bis_fnc_3DENControlsHint_connect",[_connectName,_connectCursorTexture]];
};
case "connectEnd": {
uinamespace setvariable ["bis_fnc_3DENControlsHint_connect",["",""]];
};
case "show": {
_ctrlHint ctrlshow true;
profilenamespace setvariable ["display3DEN_ControlsHint",true];
saveprofilenamespace;


_ctrlMouseArea = _display displayctrl 			52;
_handlers = uinamespace getvariable ["bis_fnc_3DENControlsHint_handlers",[]];
_ctrlMouseArea ctrlremoveeventhandler ["mousemoving",_handlers param [0,-1]];
_ctrlMouseArea ctrlremoveeventhandler ["mouseholding",_handlers param [1,-1]];


_mousemoving = _ctrlMouseArea ctrladdeventhandler ["mousemoving",{'loop' call bis_fnc_3DENControlsHint;}];
_mouseholding = _ctrlMouseArea ctrladdeventhandler ["mouseholding",{'loop' call bis_fnc_3DENControlsHint;}];
uinamespace setvariable ["bis_fnc_3DENControlsHint_handlers",[_mousemoving,_mouseholding]];
};
case "hide": {
_ctrlHint ctrlshow false;
profilenamespace setvariable ["display3DEN_ControlsHint",false];
saveprofilenamespace;

_ctrlMouseArea = _display displayctrl 			52;
_handlers = uinamespace getvariable ["bis_fnc_3DENControlsHint_handlers",[]];
_ctrlMouseArea ctrlremoveeventhandler ["mousemoving",_handlers param [0,-1]];
_ctrlMouseArea ctrlremoveeventhandler ["mouseholding",_handlers param [1,-1]];
uinamespace setvariable ["bis_fnc_3DENControlsHint_handlers",nil];
};
case "init": {
_ctrlHint ctrlenable false;
uinamespace setvariable ["bis_fnc_3DENControlsHint_pos",ctrlposition _ctrlHint];
uinamespace setvariable ["bis_fnc_3DENControlsHint_handlers",nil]; 
uinamespace setvariable ["bis_fnc_3DENControlsHint_mouseButtons",[false,false]];

_mode = ["hide","show"] select (profilenamespace getvariable ["display3DEN_ControlsHint",true]);
_mode call bis_fnc_3DENControlsHint;
};
case "toggle": {
_mode = ["hide","show"] select !(ctrlshown _ctrlHint);
_mode call bis_fnc_3DENControlsHint;
};
};
