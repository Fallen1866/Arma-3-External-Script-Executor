{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleEditTerrainObject'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleEditTerrainObject';
	scriptName _fnc_scriptName;

#line 1 "A3\Modules_F\Environment\EditTerrainObject\init.sqf [BIS_fnc_moduleEditTerrainObject]"
#line 1 "A3\Modules_F\Environment\EditTerrainObject\init.sqf"
#line 1 "A3\Modules_F\Environment\EditTerrainObject\defines.inc"

































































#line 1 "A3\Modules_F\Environment\EditTerrainObject\init.sqf"






if (!isServer) exitWith {};

private _mode = param [0,"",[""]];
private _input = param [1,[],[[]]];
private _module = _input param [0,objNull,[objNull]];








switch _mode do
{
case "eh_draw3d":
{
private _module = ((get3DENSelected "logic") select {typeOf _x == "ModuleEditTerrainObject_F"}) param [0,objNull];
if (isNull _module) exitWith {};

private _building = _module getVariable ["#building",objNull];

if (isNull _building) exitWith {};


private _bbox = (missionNamespace getVariable [str _building + "#bbox",[]]);
if (count _bbox == 0) then
{
_bbox = ["getBuildingBBox",[_module,_building]] call bis_fnc_moduleEditTerrainObject;
(missionNamespace setVariable [str _building + "#bbox",_bbox]);
};
{drawLine3D _x} forEach _bbox;


private _doorPositions = (missionNamespace getVariable [str _building + "#doorPositions",nil]);
if (isNil{_doorPositions}) then
{
_doorPositions = ["getBuildingDoors",[_module,_building]] call bis_fnc_moduleEditTerrainObject;
(missionNamespace setVariable [str _building + "#doorPositions",_doorPositions]);
};

if (count _doorPositions == 0) exitWith {};

private _doorFlags = _building getVariable ["#doorFlags", 						[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];


_module = getPos _module; _module set [2,1];
_building = getPos _building; _building set [2,1];
drawLine3D [_module,_building,							[1,0,1,1]];


if (get3DENCamera distance _building > 						50) exitWith {};

private ["_icon","_state","_color"];

{
_state = _doorFlags select _forEachIndex;

_icon = [						"\A3\Modules_F\Data\EditTerrainObject\icon3d_doorClosed32_ca.paa",						"\A3\Modules_F\Data\EditTerrainObject\icon3d_doorLocked32_ca.paa",						"\A3\Modules_F\Data\EditTerrainObject\icon3d_doorOpened32_ca.paa"] select _state;
_color = [													[0.8,0.8,0.8,0.8],													[1,0,1,1]			,													[1,0,1,1]] select _state;

drawIcon3D ["", _color, _x, 0.6, -0.85, 0, str (_forEachIndex + 1), 2, 0.045, "RobotoCondensedBold","right",false];
drawIcon3D [_icon, _color, _x, 0.8, 0.8, 0, "", 2];
}
forEach _doorPositions;
};


case "init":
{

private _ehBuildingChanged = missionNamespace getVariable ["bis_fnc_moduleEditTerrainObject_ehBuildingChanged",-1];
if (_ehBuildingChanged == -1) then
{
_ehBuildingChanged = addMissionEventHandler ["BuildingChanged",
{
params ["_previous","_current","_isRuin"];

private _parent = objNull;
private _child = objNull;


if ((_previous getVariable ["#instanceType",						-1]) + (_current getVariable ["#instanceType",						-1]) == -2) then
{
_previous setVariable ["#instanceType",							0];
_current setVariable ["#instanceType",							1];

_parent = _previous;
_child = _current;
}
else
{
if (_previous getVariable ["#instanceType",						-1] == 							0) then
{
_current setVariable ["#instanceType",							1];

_parent = _previous;
_child = _current;
}
else
{
if (_current getVariable ["#instanceType",						-1] == 							0) then
{
_previous setVariable ["#instanceType",							1];

_parent = _current;
_child = _previous;
}
else
{

};
};
};


_current setVariable ["#child",_child];
_current setVariable ["#parent",_parent];
_previous setVariable ["#child",_child];
_previous setVariable ["#parent",_parent];


private _varName = _previous getVariable ["#name",""];
if (_varName != "") then
{
_current setVariable ["#name",_varName];
missionNamespace setVariable [_varName,_current,true];
};


if (!isNull _parent) then
{
private _initCode = _previous getVariable ["#initServer",""];
if (_initCode != "") then
{
_current setVariable ["#initServer",""];
_current call compile _initCode;
};
};


if (!isNull _parent) then
{
private _initCode = _previous getVariable ["#init",""];
if (_initCode != "") then
{
_current setVariable ["#init",""];

[_current,compile _initCode] remoteExecCall ["bis_fnc_call", 0, true];
};
};


private _allowDamage = _previous getVariable ["#allowDamage",true];
if (!_allowDamage) then
{
_current allowDamage _allowDamage;
_current setVariable ["#allowDamage",_allowDamage];
};


private _doorFlags = _parent getVariable ["#doorFlags", 						[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];

{
_current setVariable [format ["bis_disabled_door_%1", _forEachIndex + 1], [0,1,0] select _x];_current animateSource [format ["door_%1_sound_source", _forEachIndex + 1], [0,0,1] select _x, true];_current animateSource [format ["door_%1_noSound_source", _forEachIndex + 1], [0,0,1] select _x, true];;
}
forEach _doorFlags;
}];

missionNamespace setVariable ["bis_fnc_moduleEditTerrainObject_ehBuildingChanged",_ehBuildingChanged];
};

if (!is3DEN) then
{

private _building = ["getBuilding",[_module]] call bis_fnc_moduleEditTerrainObject;
if (isNull _building) exitWith {};


private _doorFlags = ["decodeDoorFlags",[_module]] call bis_fnc_moduleEditTerrainObject;
_building setVariable ["#doorFlags", _doorFlags];

{
_building setVariable [format ["bis_disabled_door_%1", _forEachIndex + 1], [0,1,0] select _x];_building animateSource [format ["door_%1_sound_source", _forEachIndex + 1], [0,0,1] select _x, true];_building animateSource [format ["door_%1_noSound_source", _forEachIndex + 1], [0,0,1] select _x, true];;
}
forEach _doorFlags;


private _value = _module getVariable ["#state",							0];

if (_value in [							1,							2,							3]) then
{
private _noHitzone1 = !isClass(configfile >> "CfgVehicles" >> typeOf _building >> "HitPoints" >> "Hitzone_1_hitpoint");
private _noHitzone2 = !isClass(configfile >> "CfgVehicles" >> typeOf _building >> "HitPoints" >> "Hitzone_2_hitpoint");

switch (_value) do
{
case 							1:
{
if (_noHitzone1) then
{
_value = 							0;
};
};
case 							2:
{
if (_noHitzone2) then
{
_value = 							0;
};
};
case 							3:
{
if (_noHitzone1 || _noHitzone2) then
{
_value = 							0;
};
};
};
};


private _varName = _module getVariable ["#name",""];
if (_varName != "") then
{
if (_value in [							-1,							0,							5]) then
{
missionNamespace setVariable [_varName,_building,true];
}
else
{
_building setVariable ["#name",_varName];
};
};

private _initCode = _module getVariable ["#initServer",""];
if (_initCode != "") then
{
if (_value in [							-1,							0,							5]) then
{
_building call compile _initCode;
}
else
{
_building setVariable ["#initServer",_initCode];
};
};

private _allowDamage = _module getVariable ["#allowDamage",true];
if (!_allowDamage) then
{
if (_value in [							-1,							0,							5]) then
{
_building allowDamage _allowDamage;
}
else
{
_building setVariable ["#allowDamage",_allowDamage];
};
};


private _initCode = _module getVariable ["#init",""];
if (_initCode != "") then
{
if (_value in [							-1,							0,							5]) then
{
[_building,compile _initCode] remoteExecCall ["bis_fnc_call", 0, true];
}
else
{
_building setVariable ["#init",_initCode];
};
};


switch (_value) do
{
case 							4:
{
_building setDamage [1,false];
};
case 							1:
{
_building setHitpointDamage ["Hitzone_1_hitpoint",1,false];
};
case 							2:
{
_building setHitpointDamage ["Hitzone_2_hitpoint",1,false];
};
case 							3:
{
_building setHitpointDamage ["Hitzone_1_hitpoint",1,false];
_building setHitpointDamage ["Hitzone_2_hitpoint",1,false];
};
case 							5:
{
_building hideObjectGlobal true;
_building allowDamage false;
};
default
{
_building setDamage [0,false];
};
};


deleteVehicle _module;
}
else
{

private _ehDraw3D = missionNamespace getVariable ["bis_fnc_moduleEditTerrainObject_ehDraw3D",-1];
if (_ehDraw3D == -1) then
{
_ehDraw3D = addMissionEventHandler ["Draw3D",{["eh_draw3d"] call bis_fnc_moduleEditTerrainObject}];
missionNamespace setVariable ["bis_fnc_moduleEditTerrainObject_ehDraw3D",_ehDraw3D];
};
};
};

case "attributesChanged3DEN":
{
private _initialized = _module getVariable ["#initialized",false];
if (!_initialized) then
{
["init",[_module]] call bis_fnc_moduleEditTerrainObject;
_module setVariable ["#initialized",true];
};


_building = ["getBuilding",[_module]] call bis_fnc_moduleEditTerrainObject;
_module setVariable ["#building",_building];


private _buildingPrev = _module getVariable ["#buildingPrev",objNull];
if (!isNull _buildingPrev && {_building != _buildingPrev}) then
{
_buildingPrev setDamage [0,false];
_buildingPrev hideObjectGlobal false;
(missionNamespace setVariable [str _buildingPrev + "#managedBy",objNull]);


_buildingPrev setVariable ["#doorFlags", nil];
for "_doorID" from 							1 to 							24 do
{
_buildingPrev animateSource [format ["door_%1_sound_source", _doorID-1 + 1], [0,0,1] select 						0		, false];_buildingPrev animateSource [format ["door_%1_noSound_source", _doorID-1 + 1], [0,0,1] select 						0		, false];;
};
};


if (isNull _building) exitWith {};


private _bbox = (missionNamespace getVariable [str _building + "#bbox",[]]);
if (count _bbox == 0) then
{
_bbox = ["getBuildingBBox",[_module,_building]] call bis_fnc_moduleEditTerrainObject;
(missionNamespace setVariable [str _building + "#bbox",_bbox]);
};


private _doorPositions = (missionNamespace getVariable [str _building + "#doorPositions",[]]);
if (count _doorPositions == 0) then
{
_doorPositions = ["getBuildingDoors",[_module,_building]] call bis_fnc_moduleEditTerrainObject;
(missionNamespace setVariable [str _building + "#doorPositions",_doorPositions]);
};


(missionNamespace setVariable [str _building + "#managedBy",_module]);


private _buildingPos = getPos _building; _buildingPos set [2,0];
_module set3DENAttribute ["position",_buildingPos];


private _value = (_module get3DENAttribute "#state") param [0,							0];
private _valuePrev = _module getVariable ["#valuePrev",							-1];


private _doorFlags = ["decodeDoorFlags",[_module]] call bis_fnc_moduleEditTerrainObject;
_building setVariable ["#doorFlags", _doorFlags];


{
_building animateSource [format ["door_%1_sound_source", _forEachIndex + 1], [0,0,1] select _x, false];_building animateSource [format ["door_%1_noSound_source", _forEachIndex + 1], [0,0,1] select _x, false];;
}
forEach _doorFlags;


private _child = _building getVariable ["#child",objNull];
if (isNull objNull && {_child != _building}) then
{
_child setVariable ["#doorFlags", _doorFlags];

{
_child animateSource [format ["door_%1_sound_source", _forEachIndex + 1], [0,0,1] select _x, false];_child animateSource [format ["door_%1_noSound_source", _forEachIndex + 1], [0,0,1] select _x, false];;
}
forEach _doorFlags;
};

if (_value != _valuePrev || _building != _buildingPrev) then
{
_building setDamage [0,false];
_building hideObjectGlobal false;

switch (_value) do
{
case 							4:
{
_building setDamage [1,false];
};
case 							1:
{
_building setHitpointDamage ["Hitzone_1_hitpoint",1,false];
};
case 							2:
{
_building setHitpointDamage ["Hitzone_2_hitpoint",1,false];
};
case 							3:
{
_building setHitpointDamage ["Hitzone_1_hitpoint",1,false];
_building setHitpointDamage ["Hitzone_2_hitpoint",1,false];
};
case 							5:
{
_building hideObjectGlobal true;
};
};

_module setVariable ["#valuePrev",_value];
_module setVariable ["#buildingPrev",_building];
};
};

case "registeredToWorld3DEN":
{


};

case "unregisteredFromWorld3DEN":
{

private _building = _module getVariable ["#buildingPrev",objNull];
_building setDamage [0,false];
_building hideObjectGlobal false;
(missionNamespace setVariable [str _building + "#managedBy",objNull]);


_building setVariable ["#doorFlags", nil];
for "_doorID" from 							1 to 							24 do
{
_building animateSource [format ["door_%1_sound_source", _doorID-1 + 1], [0,0,1] select 						0		, false];_building animateSource [format ["door_%1_noSound_source", _doorID-1 + 1], [0,0,1] select 						0		, false];;
};


private _modules = (all3DENEntities param [3,[]]) select {typeOf _x == "ModuleEditTerrainObject_F" && {_x != _module}};
if (count _modules == 0) then
{
private _ehDraw3D = missionNamespace getVariable ["bis_fnc_moduleEditTerrainObject_ehDraw3D",-1];

if (_ehDraw3D != -1) then
{
removeMissionEventHandler ["Draw3D",_ehDraw3D];

missionNamespace setVariable ["bis_fnc_moduleEditTerrainObject_ehDraw3D",-1];
};
};
};

case "connectionChanged3DEN":
{


};

case "dragged3DEN":
{
private _building = ["getBuilding",[_module]] call bis_fnc_moduleEditTerrainObject;

_module setVariable ["#building",_building];
};

case "getBuilding":
{
private _filter = _module getVariable ["#filter",0];
private _filterFlags = _filter call bis_fnc_decodeFlags2;
private _objectMapTypes = [];

{
if (_x == 1) then
{
_objectMapTypes append ([						["BUILDING","HOUSE","CHURCH","CHAPEL","FUELSTATION","HOSPITAL","RUIN","BUNKER"],							["WALL","FENCE"],					["TREE","SMALL TREE","BUSH"],							["ROCK","ROCKS","FOREST BORDER","FOREST TRIANGLE","FOREST SQUARE","CROSS","FORTRESS","FOUNTAIN","VIEW-TOWER","LIGHTHOUSE","QUAY","HIDE","BUSSTOP","ROAD","FOREST","TRANSMITTER","STACK","TOURISM","WATERTOWER","TRACK","MAIN ROAD","POWER LINES","RAILWAY","POWERSOLAR","POWERWAVE","POWERWIND","SHIPWRECK","TRAIL"]] select _forEachIndex);
};
}
forEach _filterFlags;

if (count _objectMapTypes == 0) exitWith {objNull};

private _buildings = nearestTerrainObjects [_module,_objectMapTypes,						25,true,true];


_buildings = _buildings select {_x distance2D _module < 						25};


_buildings = _buildings select {_m = (missionNamespace getVariable [str _x + "#managedBy",objNull]); isNull _m || {_module == _m}};


private _selected = _buildings param [0,objNull];

_selected
};

case "getBuildingDoors":
{
private _building = _input param [1,objNull,[objNull]];
if (isNull _building) exitWith {[]};


private _cfg = configfile >> "CfgVehicles" >> typeOf _building >> "UserActions";

if !(isClass _cfg) exitWith {[]};

private _positions = [];
private _position = "";

for "_doorID" from 							1 to 							24 do
{
_position = getText(_cfg >> format["OpenDoor_%1",_doorID] >> "position");

if (_position == "") exitWith {};

_positions pushBack _position;
};

if (count _positions == 0) exitWith {[]};

_positions = _positions apply {_building modelToWorld (_building selectionPosition _x)};

_positions
};

case "getBuildingBBox":
{
private _building = _input param [1,objNull,[objNull]];
if (isNull _building) exitWith {[]};

private _bbox = boundingBoxReal _building;
_bbox params ["_point1","_point2"];

_point1 params ["_x1","_y1","_z1"];
_point2 params ["_x2","_y2","_z2"];










private _edges =
[
[		(_building modelToWorldVisual [_x1,_y1,_z1]),		(_building modelToWorldVisual [_x2,_y1,_z1]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x2,_y1,_z1]),		(_building modelToWorldVisual [_x2,_y1,_z2]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x2,_y1,_z2]),		(_building modelToWorldVisual [_x1,_y1,_z2]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x1,_y1,_z2]),		(_building modelToWorldVisual [_x1,_y1,_z1]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x1,_y2,_z1]),		(_building modelToWorldVisual [_x2,_y2,_z1]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x2,_y2,_z1]),		(_building modelToWorldVisual [_x2,_y2,_z2]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x2,_y2,_z2]),		(_building modelToWorldVisual [_x1,_y2,_z2]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x1,_y2,_z2]),		(_building modelToWorldVisual [_x1,_y2,_z1]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x1,_y1,_z1]),		(_building modelToWorldVisual [_x1,_y2,_z1]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x2,_y1,_z1]),		(_building modelToWorldVisual [_x2,_y2,_z1]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x2,_y1,_z2]),		(_building modelToWorldVisual [_x2,_y2,_z2]),							[1,0,1,1]],
[		(_building modelToWorldVisual [_x1,_y1,_z2]),		(_building modelToWorldVisual [_x1,_y2,_z2]),							[1,0,1,1]]
];

_edges
};


case "encodeDoorFlags":
{
private _flags = _input param [1,						[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[]]];










private _value = [(_flags select [0,8]) call bis_fnc_encodeFlags4,(_flags select [8,8]) call bis_fnc_encodeFlags4,(_flags select [16,8]) call bis_fnc_encodeFlags4];

_value
};


case "decodeDoorFlags":
{
private _value = _input param [1,_module getVariable ["#doorStates",[0,0,0]],[123,[]]];
private _flags = [];


if (_value isEqualType 123) then
{
_flags = ([_value,							24] call bis_fnc_decodeFlags2) apply {if (_x == 0) then {						0		} else {						2		}};
}

else
{
{_flags append ([_x,							8] call bis_fnc_decodeFlags4);} forEach _value;
};

_flags
};

case "objectDoors_onMouseButtonUp":
{
(_input select 1) params ["_ctrlAttribute","_mouseButton","","","_shiftKey","_ctrlKey","_altKey"];










private _state = _ctrlAttribute getVariable ["#state",						0		];

if (_shiftKey || _ctrlKey || _altKey) then
{
_state = switch (true) do
{
case _altKey: {						2		};
case _shiftKey: {						1		};
case _ctrlKey: {						0		};
};
}
else
{
if (_mouseButton == 0) then
{
_state = [						0		,						1		,						2		] select ((_state + 1) % 3);
}
else
{
_state = 						0		;
};
};

_ctrlAttribute setVariable ["#state",_state];
_ctrlAttribute ctrlSetText ([						"\A3\Modules_F\Data\EditTerrainObject\textureDoor_closed_ca.paa",						"\A3\Modules_F\Data\EditTerrainObject\textureDoor_locked_ca.paa",						"\A3\Modules_F\Data\EditTerrainObject\textureDoor_opened_ca.paa"] select _state);
_ctrlAttribute ctrlSetTooltip ([						(localize "STR_a3_to_editTerrainObject21"),						(localize "STR_a3_to_editTerrainObject23"),						(localize "STR_a3_to_editTerrainObject22")] select _state);
};

case "objectDoors_attributeLoad":
{
private _ctrlAttribute = _input param [1,controlNull,[controlNull]];
private _value = _input param [2,0,[123,[]]];

private _flags = ["decodeDoorFlags",[_module,_value]] call bis_fnc_moduleEditTerrainObject;

private _ctrlCheckboxes = _ctrlAttribute controlsGroupCtrl 100;

{
private _ctrlCheckbox = _ctrlCheckboxes controlsGroupCtrl (101+_forEachIndex);

if (_x != 0) then
{
_ctrlCheckbox setVariable ["#state",_x];
_ctrlCheckbox ctrlSetText ([						"\A3\Modules_F\Data\EditTerrainObject\textureDoor_closed_ca.paa",						"\A3\Modules_F\Data\EditTerrainObject\textureDoor_locked_ca.paa",						"\A3\Modules_F\Data\EditTerrainObject\textureDoor_opened_ca.paa"] select _x);
};

_ctrlCheckbox ctrlSetTooltip ([						(localize "STR_a3_to_editTerrainObject21"),						(localize "STR_a3_to_editTerrainObject23"),						(localize "STR_a3_to_editTerrainObject22")] select _x);
}
forEach _flags;

private _building = ["getBuilding",[_module]] call bis_fnc_moduleEditTerrainObject;
private _available = if (isNull _building) then
{
0
}
else
{
getNumber(configfile >> "CfgVehicles" >> typeOf _building >> "numberOfDoors")
};

_available = _available min 							24;

for "_doorID" from 1 to 							24 do
{
_ctrlCheckbox = _ctrlCheckboxes controlsGroupCtrl (100+_doorID);
if (_doorID <= _available) then {_ctrlCheckbox ctrlSetFade 0} else {_ctrlCheckbox ctrlSetFade 0.85};
_ctrlCheckbox ctrlCommit 0;
};
};

case "objectDoors_attributeSave":
{
private _ctrlAttribute = _input param [1,controlNull,[controlNull]];
private _ctrlCheckboxes = _ctrlAttribute controlsGroupCtrl 100;

private _flags = [];

for "_idc" from 101 to (100+							24) do
{
_flags pushBack ((_ctrlCheckboxes controlsGroupCtrl _idc) getVariable ["#state",						0		]);
};

private _value = ["encodeDoorFlags",[_module,_flags]] call bis_fnc_moduleEditTerrainObject;

_value
};

case "objectTypeFilter_attributeLoad":
{
private _ctrlAttribute = _input param [1,controlNull,[controlNull]];
private _value = _input param [2,1,[123]];

private _ctrlCheckboxes = _ctrlAttribute controlsGroupCtrl 100;
private _flags = _value call bis_fnc_decodeFlags2;

{
if (_x == 1) then
{
private _ctrlCheckbox = _ctrlCheckboxes controlsGroupCtrl (101+_forEachIndex);
_ctrlCheckbox cbSetChecked true;
};
}
forEach _flags;
};
case "objectTypeFilter_attributeSave":
{
private _ctrlAttribute = _input param [1,controlNull,[controlNull]];
private _ctrlCheckboxes = _ctrlAttribute controlsGroupCtrl 100;
private _flags = [];
private _value = 0;

for "_idc" from 101 to 104 do
{
if (cbChecked(_ctrlCheckboxes controlsGroupCtrl _idc)) then
{
_flags pushBack 1;
}
else
{
_flags pushBack 0;
};
};

_value = _flags call bis_fnc_encodeFlags2;

_value
};

case "objectState_attributeLoad":
{
private _ctrlAttribute = _input param [1,controlNull,[controlNull]];
private _value = _input param [2,1,[123]];

private _ctrlCheckboxes = _ctrlAttribute controlsGroupCtrl 100;
private _ctrlCheckbox = _ctrlCheckboxes controlsGroupCtrl (101+_value);

private _building = ["getBuilding",[_module]] call bis_fnc_moduleEditTerrainObject;

private _noHitzone1 = !isClass(configfile >> "CfgVehicles" >> typeOf _building >> "HitPoints" >> "Hitzone_1_hitpoint");
private _noHitzone2 = !isClass(configfile >> "CfgVehicles" >> typeOf _building >> "HitPoints" >> "Hitzone_2_hitpoint");

if (_noHitzone1) then
{
(_ctrlCheckboxes controlsGroupCtrl 102) ctrlSetFade 0.85;
(_ctrlCheckboxes controlsGroupCtrl 102) ctrlCommit 0;
};
if (_noHitzone2) then
{
(_ctrlCheckboxes controlsGroupCtrl 103) ctrlSetFade 0.85;
(_ctrlCheckboxes controlsGroupCtrl 103) ctrlCommit 0;
};
if (_noHitzone1 || _noHitzone2) then
{
(_ctrlCheckboxes controlsGroupCtrl 104) ctrlSetFade 0.85;
(_ctrlCheckboxes controlsGroupCtrl 104) ctrlCommit 0;
};

_ctrlCheckbox cbSetChecked true;
};
case "objectState_attributeSave":
{
private _ctrlAttribute = _input param [1,controlNull,[controlNull]];
private _ctrlCheckboxes = _ctrlAttribute controlsGroupCtrl 100;
private _flags = [];
private _value = 0;

for "_idc" from 101 to 106 do
{
if (cbChecked(_ctrlCheckboxes controlsGroupCtrl _idc)) exitWith {_value = _idc - 101;};
};

_value
};
case "objectState_onCheckedChanged":
{
private _ctrlCheckboxData = _input param [1,[],[[]]];
private _ctrlCheckbox = _ctrlCheckboxData param [0,controlNull,[controlNull]];
private _ctrlCheckboxes = ctrlParentControlsGroup _ctrlCheckbox;

for "_idc" from 101 to 106 do
{
(_ctrlCheckboxes controlsGroupCtrl _idc) cbSetChecked false;
};

_ctrlCheckbox cbSetChecked true;
};
};}
