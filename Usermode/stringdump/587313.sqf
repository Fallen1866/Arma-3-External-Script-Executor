
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'bis_fnc_moduleSpawnAI'} else {_fnc_scriptName};
	private _fnc_scriptName = 'bis_fnc_moduleSpawnAI';
	scriptName _fnc_scriptName;

#line 1 "a3\modules_f_heli\misc\functions\fn_moduleSpawnAI.sqf [bis_fnc_moduleSpawnAI]"
#line 1 "a3\modules_f_heli\misc\functions\fn_moduleSpawnAI.sqf"
private["_emitter","_activated","_initialized"];

_emitter 	= _this param [0,objNull,[objNull]];
_activated 	= _this param [2,true,[true]];

_initialized 	= _emitter getVariable ["initialized",false];


if (_initialized) exitWith {_emitter setVariable ["activated",_activated];};

_emitter setVariable ["initialized",true];
_emitter setVariable ["activated",_activated];






BIS_fnc_moduleSpawnAI_debug = false;






private["_engine","_side","_var"];

_side 	= _emitter getVariable ["side","West"];
_var	= format["bis_fnc_moduleSpawnAI_%1",_side];
_engine = missionNamespace getVariable [_var,objNull];


if (!isNull _engine) exitWith {}; missionNamespace setVariable [_var,_emitter];








private["_storage"];

_storage = missionNamespace getVariable ["bis_fnc_moduleSpawnAI_costs",objNull];


if (isNull _storage) then
{
missionNamespace setVariable ["bis_fnc_moduleSpawnAI_costs",_emitter];


};







if (isNil "bis_fnc_moduleSpawnAI_initialized") then
{
bis_fnc_moduleSpawnAI_initialized = true;

_path = "\A3\Modules_F_Heli\Misc\Functions\ModuleSpawnAI\";
[
_path,
"bis_fnc_moduleSpawnAI_",
[
"init",
"initEmitters",
"initSpawnpoints",
"initGroups",
"getManpower",
"getRandomGroup",
"getRandomPoint",
"getGroupUnitCount",
"getGroupCost",
"getGroupWeight",
"getGroupComposition",
"getUnitCost",
"getGroupType",
"spawnGroup",
"spawnVehicle",
"cleanGroups",
"cleanGroup",
"startGarbageCollector",
"deleteGroup",
"getCargoSlots",
"countCargoSlots",
"logFormat",
"log",
"mergeGroup",
"generateGroupId",
"main"
]
]
call bis_fnc_loadFunctions;

_path = "\A3\Modules_F_Heli\Misc\Functions\ModuleSpawnAI\";
[
_path,
"b",
[
"is_fnc_param"
]
]
call bis_fnc_loadFunctions;

[] call bis_fnc_moduleSpawnAI_init;
};






private["_emitters"];

_emitters = [_side] call bis_fnc_moduleSpawnAI_initEmitters;






private["_points"];

{
_points = [_x] call bis_fnc_moduleSpawnAI_initSpawnpoints;

if (count _points == 0) then
{
_emitters set [_forEachIndex,objNull];

["[x] Emitter |%1| was deleted as it has now spawnpoints.",_x] call bis_fnc_moduleSpawnAI_logFormat;
};
}
forEach _emitters; _emitters = _emitters - [objNull];


if (count _emitters == 0) exitWith {};


missionNamespace setVariable [format["bis_fnc_moduleSpawnAI_%1_emitters",_side],_emitters];






{
[_x] call bis_fnc_moduleSpawnAI_initGroups;
}
forEach _emitters;






[_emitters] spawn bis_fnc_moduleSpawnAI_main;
