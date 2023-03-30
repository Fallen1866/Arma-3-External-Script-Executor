
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_dynamicGroups'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_dynamicGroups';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f_mp_mark\DynamicGroups\fn_dynamicGroups.sqf [BIS_fnc_dynamicGroups]"
#line 1 "A3\functions_f_mp_mark\DynamicGroups\fn_dynamicGroups.sqf"

#line 1 "A3\Functions_F_MP_Mark\DynamicGroupsCommonDefines.inc"

#line 1 "A3\ui_f\hpp\defineResincl.inc"






















































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































#line 2 "A3\Functions_F_MP_Mark\DynamicGroupsCommonDefines.inc"

#line 1 "A3\ui_f\hpp\defineResinclDesign.inc"







































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































#line 3 "A3\Functions_F_MP_Mark\DynamicGroupsCommonDefines.inc"

#line 1 "A3\ui_f\hpp\defineCommonGrids.inc"















































































































































































































































































































































































































































































#line 4 "A3\Functions_F_MP_Mark\DynamicGroupsCommonDefines.inc"






































































#line 2 "A3\functions_f_mp_mark\DynamicGroups\fn_dynamicGroups.sqf"


private ["_mode", "_params"];
_mode   = _this param [0, "", [""]];
_params = _this param [1, [], [[]]];

switch (_mode) do
{






case "Initialize" :
{
	if (!isServer) exitWith {};

private _registerInitialPlayerGroups = _params param [0, false, [true]];
private _maxUnitsPerGroup = _params param [1, 99, [0]];
private _minimalInteraction = _params param [2, false, [true]];
private _forcedInsignia = _params param [3, "", [""]];


{ createCenter _x } forEach [WEST, EAST, RESISTANCE, CIVILIAN];


if (["IsInitialized"] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); }) exitWith
{
"Dynamic groups was already initialized, terminate in order to be able to re-initialize" call BIS_fnc_error;
};


				"BIS_dynamicGroups_clientMessage" addPublicVariableEventHandler [missionnamespace,
{
["OnClientMessage", _this] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
}];


missionNamespace setVariable [						"BIS_dg_ini", true, 							true];


if (_maxUnitsPerGroup < 99) then
{
missionNamespace setVariable [				"BIS_dg_mupg", _maxUnitsPerGroup, 							true];
};


if (_registerInitialPlayerGroups) then
{
["RegisterInitialPlayerGroups", []] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};



if (_minimalInteraction) then
{
missionNamespace setVariable [				"BIS_dg_mii", _minimalInteraction, 							true];
};


if (_forcedInsignia != "") then
{
missionNamespace setVariable [					"BIS_dg_fia", _forcedInsignia, 							true];
};


if (							false) then
{
"Initialized" call BIS_fnc_log;
};
};





case "Terminate" :
{
	if (!isServer) exitWith {};


				"BIS_dynamicGroups_clientMessage" addPublicVariableEventHandler [missionnamespace, {}];


missionNamespace setVariable [						"BIS_dg_ini", nil, 							true];


if (							false) then
{
"Terminated" call BIS_fnc_log;
};
};




case "IsInitialized" :
{
missionNamespace getVariable [						"BIS_dg_ini", false];
};




case "OnClientMessage" :
{
	if (!isServer) exitWith {};

private ["_variable", "_message"];
_variable 	= _params param [0, "", [""]];
_message	= _params param [1, [], [[]]];

private ["_inMode", "_inParams", "_player"];
_inMode 	= _message param [0, "", [""]];
_inParams 	= _message param [1, [], [[]]];
_player		= _message param [2, objNull, [objNull]];


[_inMode, _inParams] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };


if (							false) then
{
["OnClientMessage: Message (%1) received from client (%2 / %3) with data (%4) at time (%5)", _variable, _player, name _player, _message, time] call BIS_fnc_logFormat;
};
};

case "RegisterInitialPlayerGroups" :
{
{
if (isPlayer leader _x && {count units _x > 0}) then
{
["RegisterGroup", [_x, leader _x]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};
}
forEach (allGroups - (["GetAllGroups"] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); }));
};

case "RegisterGroup" :
{
	if (!isServer) exitWith {};

private ["_group", "_leader"];
_group	= _params param [0, grpNull, [grpNull]];
_leader	= _params param [1, objNull, [objNull]];
_data	= _params param [2, [], [[]]];

if (!isNull _group && {!isNull _leader} && {_leader == leader _group}) then
{
private ["_insignia", "_name", "_private"];
_insignia	= _data param [0, ["LoadRandomInsignia"] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); }, [""]];
_name		= _data param [1, groupId _group, [""]];
_private	= _data param [2, false, [true]];


_group setVariable [				"BIS_dg_reg", true, 							true];


_group setVariable [					"BIS_dg_cre", _leader, 							true];


_group setVariable [					"BIS_dg_ins", _insignia, 							true];


_group setVariable [					"BIS_dg_pri", _private, 							true];


_group setVariable [						"BIS_dg_var", format ["%1_%2_%3", _name, getPlayerUID _leader, time], 							true];


_group setGroupIdGlobal [_name];


{
["OnPlayerGroupChanged", [_x, _group]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
} forEach units _group;

if (							false) then
{
["RegisterGroup: Group (%1) registered with leader (%2)", _group, _leader] call BIS_fnc_logFormat;
};
};
};

case "UnregisterGroup" :
{
private ["_group", "_keep"];
_group 	= _params param [0, grpNull, [grpNull]];
_keep	= _params param [1, false, [false]];

if (!isNull _group && {["IsGroupRegistered", [_group]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); }}) then
{
if (_keep || {count units _group > 0}) then
{
_group setVariable [				"BIS_dg_reg", nil, 							true];
_group setVariable [					"BIS_dg_cre", nil, 							true];
_group setVariable [					"BIS_dg_ins", nil, 							true];
_group setVariable [					"BIS_dg_pri", nil, 							true];
_group setVariable [						"BIS_dg_var", nil, 							true];
}
else
{
["DeleteGroup", [_group]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};

if (							false) then
{
["UnregisterGroup: Group (%1) unregistered and deleted (%2)", _group, _keep] call BIS_fnc_logFormat;
};
};
};

case "IsGroupRegistered" :
{
private ["_group"];
_group = _params param [0, grpNull, [grpNull]];

_group getVariable [				"BIS_dg_reg", false];
};

case "DeleteGroup" :
{
private ["_group"];
_group = _params param [0, grpNull, [grpNull]];

if (local _group) then
{
["DeleteGroupLocal", [_group]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
}
else
{

[["DeleteGroupLocal", [_group]], "BIS_fnc_dynamicGroups", groupOwner _group] call BIS_fnc_mp;
};
};

case "DeleteGroupLocal" :
{
private ["_group"];
_group = _params param [0, grpNull, [grpNull]];

if (!isNull _group && {local _group}) then
{
deleteGroup _group;
};
};

case "SetName" :
{
	if (!isServer) exitWith {};

private ["_group", "_name"];
_group  = _params param [0, grpNull, [grpNull]];
_name 	= _params param [1, "", [""]];

if (!isNull _group && {_name != ""}) then
{
_group setGroupIdGlobal [_name];
};
};

case "SetPrivateState" :
{
	if (!isServer) exitWith {};

private ["_group", "_state"];
_group  = _params param [0, grpNull, [grpNull]];
_state 	= _params param [1, true, [true]];

if (!isNull _group) then
{
_group setVariable [					"BIS_dg_pri", _state, 							true];
};
};

case "CreateGroupAndRegister" :
{
	if (!isServer) exitWith {};

private ["_player"];
_player = _params param [0, objNull, [objNull]];

if (!isNull _player) then
{

private "_newGroup";
_newGroup = createGroup (side group _player);


[_player] joinSilent _newGroup;


["RegisterGroup", [_newGroup, _player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };


if (							false) then
{
["CreateNewGroupFor: %1 / %2 / %3 / %4 / %5", _newGroup, _player, units _newGroup, leader _newGroup, _group] call BIS_fnc_logFormat;
};
};
};

case "SwitchLeader" :
{
	if (!isServer) exitWith {};

private ["_group", "_player"];
_group  = _params param [0, grpNull, [grpNull]];
_player = _params param [1, objNull, [objNull]];

if (!isNull _group && {!isNull _player} && {_group == group _player}) then
{

[_group, _player] remoteExec ["selectLeader", groupOwner _group];


if (							false) then
{
["SwitchLeader: %1 / %2", _group, _player] call BIS_fnc_logFormat;
};
};
};

case "AddGroupMember" :
{
	if (!isServer) exitWith {};

private ["_group", "_player"];
_group  = _params param [0, grpNull, [grpNull]];
_player = _params param [1, objNull, [objNull]];

if (!isNull _player && {!isNull _group} && {group _player != _group}) then
{
private ["_oldGroup", "_units"];
_oldGroup 	= group _player;
_units		= units _oldGroup - [_player];


[_player] joinSilent _group;


["OnPlayerGroupChanged", [_player, _group]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };


if (count _units < 1) then
{
["DeleteGroup", [_oldGroup]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};
};
};

case "RemoveGroupMember" :
{
	if (!isServer) exitWith {};

private ["_group", "_player"];
_group  = _params param [0, grpNull, [grpNull]];
_player = _params param [1, objNull, [objNull]];

if (!isNull _player && {!isNull _group} && {group _player == _group}) then
{
private ["_units"];
_units = units _group - [_player];


[_player] joinSilent grpNull;


["OnPlayerGroupChanged", [_player, group _player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };


if (count _units < 1) then
{
["DeleteGroup", [_group]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};
};
};




case "SwitchGroup" :
{
	if (!isServer) exitWith {};

private ["_group", "_player"];
_group  = _params param [0, grpNull, [grpNull]];
_player = _params param [1, objNull, [objNull]];

if (!isNull _player && {!isNull _group} && {group _player != _group}) then
{
private ["_oldGroup", "_units"];
_oldGroup 	= group _player;
_units		= units _oldGroup - [_player];


[_player] joinSilent _group;


["OnPlayerGroupChanged", [_player, _group]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };

if (count _units < 1) then
{
["DeleteGroup", [_oldGroup]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};
};
};




case "KickPlayer" :
{
	if (!isServer) exitWith {};

private ["_group", "_leader", "_player"];
_group    = _params param [0, grpNull, [grpNull]];
_leader   = _params param [1, objNull, [objNull]];
_player   = _params param [2, objNull, [objNull]];

if (!isNull _group && {!isNull _leader} && {!isNull _player} && {leader group _leader == _leader} && {group _player == _group}) then
{

["RemoveGroupMember", [_group, _player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };


private "_kicks";
_kicks = _player getVariable [						"BIS_dg_kic", []];


_kicks pushBack _group;


_player setVariable [						"BIS_dg_kic", _kicks, 							true];
};
};




case "UnKickPlayer" :
{
	if (!isServer) exitWith {};

private ["_groupId", "_player"];
_group  = _params param [0, grpNull, [grpNull]];
_player = _params param [1, objNull, [objNull]];

if (!isNull _group && {!isNull _player} && {["WasPlayerKickedFrom", [_group, _player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); }}) then
{

private "_kicksOld";
_kicksOld = _player getVariable [						"BIS_dg_kic", []];


private "_kicks";
_kicks = _kicksOld - [_group];


if !(_kicksOld isEqualTo _kicks) then
{
_player setVariable [						"BIS_dg_kic", _kicks, 							true];
};
};
};

case "WasPlayerKickedFrom" :
{
private ["_group", "_player"];
_group  = _params param [0, grpNull, [grpNull]];
_player = _params param [1, objNull, [objNull]];

_group in (_player getVariable [						"BIS_dg_kic", []]);
};




case "GetAllGroups" :
{
private "_groups";
_groups = [];

{
if (isPlayer leader _x && {count units _x > 0} && {["IsGroupRegistered", [_x]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); }}) then
{
_groups pushBack _x;
};
} forEach allGroups;

_groups;
};




case "GetAllGroupsOfSide" :
{
private ["_side"];
_side = _params param [0, sideUnknown, [sideUnknown]];

private "_groups";
_groups = [];

{
if (side _x == _side) then
{
_groups pushBack _x;
};
} forEach (["GetAllGroups"] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); });

_groups;
};




case "GetGroupByName" :
{
private ["_name", "_side"];
_name = _params param [0, "", [""]];
_side = _params param [1, sideUnknown, [sideUnknown]];

private ["_groups", "_group"];
_groups = ["GetAllGroups"] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
_group  = grpNull;

{
if (_name == groupId _x && {side _x == _side}) then
{
_group = _x;
};
} forEach allGroups;

_group;
};




case "GetGroupByUniqueId" :
{
private ["_id", "_side"];
_id = _params param [0, "", [""]];
_side = _params param [1, sideUnknown, [sideUnknown]];

private ["_groups", "_group"];
_groups = ["GetAllGroups"] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
_group  = grpNull;

{
if (_id == _x getVariable [						"BIS_dg_var", ""] && {side _x == _side}) then
{
_group = _x;
};
} forEach allGroups;

_group;
};




case "GetFriendlyPlayers" :
{
private ["_side"];
_side = _params param [0, SIDEUNKNOWN, [SIDEUNKNOWN]];


if !(_side in [WEST, EAST, RESISTANCE, CIVILIAN]) exitWith
{
["GetFriendlyPlayers: Invalid side (%1), please use on of the supported (WEST, EAST, RESISTANCE, CIVILIAN)"] call BIS_fnc_error;
[];
};

private "_friendlies";
_friendlies = [];

{
if (isPlayer _x && {side group _x == _side}) then
{
_friendlies pushBack _x;
};
} forEach allUnits + allDead;

_friendlies;
};




case "PlayerHasGroup" :
{
private ["_player"];
_player = _params param [0, objNull, [objNull]];

["IsGroupRegistered", [group _player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};




case "PlayerIsLeader" :
{
private ["_player"];
_player = _params param [0, objNull, [objNull]];

_player == leader group _player && ["PlayerHasGroup", [_player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};





case "InitializePlayer" :
{
	if (!hasInterface) exitWith {};

private ["_player", "_registerInitialGroup"];
_player 				= _params param [0, player, [objNull]];
_registerInitialGroup 	= _params param [1, false, [true]];

if (isNull _player) exitWith
{
["InitializePlayer: Player provided is NULL", _player] call BIS_fnc_error;
};

if (!local _player) exitWith
{
["InitializePlayer: Player (%1) is not local", _player] call BIS_fnc_error;
};

if (!isNil { _player getVariable 						"BIS_dg_ini" }) exitWith
{
["InitializePlayer: Player (%1) already initialized, terminate to be able to re-initialize", _player] call BIS_fnc_error;
};


_player setVariable [						"BIS_dg_ini", true, 							true];


["AddKeyEvents"] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };


missionNamespace setVariable [			"BIS_dynamicGroups_respawnKeyDown",
[
missionnamespace,
"RscDisplayRespawnKeyDown",
{
private "_key";
_key = _this param [1, -1, [0]];

if (_key in actionKeys 							"TeamSwitch" && {missionNamespace getVariable [					"BIS_dynamicGroups_allowInterface", true]}) then
{
(_this select 0) createDisplay "RscDisplayDynamicGroups";
};
}
] call bis_fnc_addscriptedeventhandler, 							false];


missionNamespace setVariable [					"BIS_dynamicGroups_draw3D", addMissionEventHandler ["EachFrame",
{
private _timeLastUpdate         = missionNamespace getVariable [				"BIS_dynamicGroups_lastUpdateTime", 0];
private _timeNow                = time;
private _timeSinceLastUpdate    = _timeNow - _timeLastUpdate;

if (_timeSinceLastUpdate >= 				0.4) then
{

private _display = uiNamespace getVariable [						"BIS_dynamicGroups_display", displayNull];


if (!isNull _display) then
{
["Update", [false]] call 								{ _this call (uiNamespace getVariable ["RscDisplayDynamicGroups_script", {}]); };
};


missionNamespace setVariable [				"BIS_dynamicGroups_lastUpdateTime", _timeNow, 							false];
};
}], 							false];


if (_registerInitialGroup && {leader group _player == _player} && {!(["IsGroupRegistered", [group _player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); })}) then
{
["SendClientMessage", ["RegisterGroup", [group _player, _player]]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};
};





case "TerminatePlayer" :
{
	if (!hasInterface) exitWith {};

private _player = _params param [0, player, [objNull]];

if (!local _player) exitWith
{
["TerminatePlayer: Player (%1) is not local", _player] call BIS_fnc_error;
};

if (isNil { _player getVariable 						"BIS_dg_ini" }) exitWith
{
["TerminatePlayer: Player (%1) is not initialized yet", _player] call BIS_fnc_error;
};


["RemoveKeyEvents"] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };


[missionnamespace, "RscDisplayRespawnKeyDown", missionNamespace getVariable [			"BIS_dynamicGroups_respawnKeyDown", []]] call bis_fnc_removescriptedeventhandler;


removeMissionEventHandler ["EachFrame", missionnamespace getVariable [					"BIS_dynamicGroups_draw3D", -1]];
};




case "SendClientMessage" :
{
	if (!hasInterface) exitWith {};

private ["_inMode", "_inParams"];
_inMode         = _params param [0, "", [""]];
_inParams       = _params param [1, [], [[]]];


if (isServer) then
{
[_inMode, _inParams] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
}
else
{
missionNamespace setVariable [				"BIS_dynamicGroups_clientMessage", [_inMode, _inParams, player], 							true];
};
};




case "AddKeyEvents" :
{
disableSerialization;
	if (!hasInterface) exitWith {};

private ["_display"];
_display = _params param [0, displayNull, [displayNull]];

[_display] spawn
{
scriptName "DynamicGroups: AddKeyEvents";
disableSerialization;

private ["_display", "_varName"];
_display = _this select 0;
_varName = "BIS_dynamicGroups_keyMain";


if (isNull _display) then
{
waitUntil{ !isNull (findDisplay 46) };

_display = (findDisplay 46);
_varName = "BIS_dynamicGroups_key";
};


if (!isNil { missionNamespace getVariable _varName }) then
{
private ["_index", "_down", "_up"];
_index = missionNamespace getVariable _varName;
_down = _index select 0;
_up = _index select 1;


_display displayRemoveEventHandler ["KeyDown", _down];
_display displayRemoveEventHandler ["KeyUp", _up];
missionNamespace setVariable [_varName, nil];
};


private ["_down", "_up"];
_down   = _display displayAddEventHandler ["KeyDown", "['OnKeyDown', _this] call BIS_fnc_dynamicGroups;"];
_up     = _display displayAddEventHandler ["KeyUp", "['OnKeyUp', _this] call BIS_fnc_dynamicGroups;"];


missionNamespace setVariable [_varName, [_down, _up]];


if (							false) then
{
["AddKeyEvents: Key down event added for (%1)", _varName] call BIS_fnc_logFormat;
};
};
};




case "RemoveKeyEvents" :
{
disableSerialization;
	if (!hasInterface) exitWith {};

private ["_display"];
_display = _params param [0, displayNull, [displayNull]];

[_display] spawn
{
scriptName "DynamicGroups: RemoveKeyEvents";
disableSerialization;

private ["_display", "_varName"];
_display = _this select 0;
_varName = "BIS_dynamicGroups_keyMain";


if (isNull _display) then
{
waitUntil{ !isNull (findDisplay 46) };

_display = (findDisplay 46);
_varName = "BIS_dynamicGroups_key";
};


if (!isNil { missionNamespace getVariable _varName }) then
{
private ["_index", "_down", "_up"];
_index = missionNamespace getVariable _varName;
_down = _index select 0;
_up = _index select 1;


_display displayRemoveEventHandler ["KeyDown", _down];
_display displayRemoveEventHandler ["KeyUp", _up];
missionNamespace setVariable [_varName, nil];
};


if (							false) then
{
["RemoveKeyEvents: Key down event removed for (%1)", _varName] call BIS_fnc_logFormat;
};
};
};




case "OnKeyDown" :
{
disableSerialization;
	if (!hasInterface) exitWith {};

private ["_key", "_ctrl"];
_key  = _params param [1, -1, [0]];
_ctrl = _params param [3, false, [false]];

if (_key in actionKeys 							"TeamSwitch" && !_ctrl) then
{
if (isNil { uiNamespace getVariable "BIS_dynamicGroups_keyDownTime" }) then
{
uiNamespace setVariable ["BIS_dynamicGroups_keyDownTime", time];
uiNamespace setVariable ["BIS_dynamicGroups_ignoreInterfaceOpening", nil];
};

["UpdateKeyDown"] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
true;
}
else
{
false;
};
};




case "OnKeyUp" :
{
disableSerialization;
	if (!hasInterface) exitWith {};

private ["_key", "_ctrl"];
_key  = _params param [1, -1, [0]];
_ctrl = _params param [3, false, [false]];

uiNamespace setVariable ["BIS_dynamicGroups_keyDownTime", nil];

if (!_ctrl && {_key in actionKeys 							"TeamSwitch"} && {isNil { uiNamespace getVariable "BIS_dynamicGroups_ignoreInterfaceOpening" }}) then
{
if (isNull (findDisplay 60490) && {missionNamespace getVariable ["BIS_dynamicGroups_allowInterface", true]}) then
{
([] call BIS_fnc_displayMission) createDisplay "RscDisplayDynamicGroups";
}
else
{
if (isNil { uiNamespace getVariable "BIS_dynamicGroups_hasFocus" }) then
{
(["GetDisplay"] call 								{ _this call (uiNamespace getVariable ["RscDisplayDynamicGroups_script", {}]); }) closeDisplay 2;
};
};

true;
}
else
{
false;
};
};




case "UpdateKeyDown" :
{
	if (!hasInterface) exitWith {};

if (!isNil { uiNamespace getVariable "BIS_dynamicGroups_keyDownTime" } && {count (["GetPlayerInvites", [player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); }) > 0}) then
{
private ["_timestamp", "_timeHolding"];
_timestamp      = uiNamespace getVariable "BIS_dynamicGroups_keyDownTime";
_timeHolding    = time - _timestamp;

if (_timeHolding >= 	0.7) then
{
private "_invites";
_invites = ["GetPlayerInvites", [player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };

if (count _invites > 0) then
{
private ["_invite", "_group"];
_invite = _invites select (count _invites - 1);
_group = _invite select 0;


uiNamespace setVariable ["BIS_dynamicGroups_ignoreInterfaceOpening", true];


["RemoveInvite", [_group, player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };


if (count units _group < missionNamespace getVariable [				"BIS_dg_mupg", 99]) then
{
if !(["PlayerHasGroup", [player]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); }) then
{
["SendClientMessage", ["AddGroupMember", [_group, player]]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
}
else
{
["SendClientMessage", ["SwitchGroup", [_group, player]]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};


["LocalShowNotification", ["DynamicGroups_Joined", [groupId _group]]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };


if (							false) then
{
["UpdateKeyDown: Invite accepted from %1", _group] call BIS_fnc_logFormat;
};
}
else
{

["LocalShowNotification", ["DynamicGroups_PlayerJoinFailed", [_group]]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };


if (							false) then
{
["UpdateKeyDown: Invite cannot be accepted, %1 is full", _group] call BIS_fnc_logFormat;
};
};
};
};


};
};





case "AddInvite" :
{
private ["_group", "_from", "_to"];
_group	= _params param [0, grpNull, [grpNull]];
_from	= _params param [1, objNull, [objNull]];
_to	= _params param [2, objNull, [objNull]];


if (isNull _group) exitWith { "AddInvite: Group is null" call BIS_fnc_error; };
if (isNull _from) exitWith { "AddInvite: Invite sender is null" call BIS_fnc_error; };
if (isNull _to) exitWith { "AddInvite: Invite receiver is null" call BIS_fnc_error; };


private "_invitations";
_invitations = _to getVariable [							"BIS_dg_inv", []];


private "_index";
_index = -1;

{
if (_x select 0 == _group) exitWith
{
_index = _forEachIndex;
};
} forEach _invitations;


if (_index != -1) then
{
_invitations set [_index, [_group, _from, _to, time]];
}
else
{
_invitations pushBack [_group, _from, _to, time];
};


_to setVariable [							"BIS_dg_inv", _invitations, 							true];



[["OnInvitationReceived", [_group, _to, _from]], "BIS_fnc_dynamicGroups", _to] call BIS_fnc_mp;



[["UnKickPlayer", [_group, _to]], "BIS_fnc_dynamicGroups", false] call BIS_fnc_mp;


if (							false) then
{
["AddInvite: %1 / %2 / %3", _group, _from, _to] call BIS_fnc_logFormat;
};
};




case "RemoveInvite" : {
private ["_group", "_player"];
_group	= _params param [0, grpNull, [grpNull]];
_player	= _params param [1, objNull, [objNull]];

if (isNull _group) exitWith { "RemoveInvite: Group is null" call BIS_fnc_error; };
if (isNull _player) exitWith { "RemoveInvite: Invite holder is null" call BIS_fnc_error; };


private ["_invitations", "_container"];
_invitations    = _player getVariable [							"BIS_dg_inv", []];
_container      = [] + _invitations;


private "_index";
_index = -1;

{
if (_group == _x select 0 && {_player == _x select 2}) exitWith
{
_index = _forEachIndex;
};
} forEach _container;

if (_index < 0) exitWith
{
["RemoveInvite: Not found for group (%1)", _group] call BIS_fnc_error;
};

_container deleteAt _index;
_player setVariable [							"BIS_dg_inv", _container, 							true];


if (							false) then
{
["RemoveInvite: %1", _this] call BIS_fnc_logFormat;
};
};




case "HasInvite" :
{
private ["_group", "_player"];
_group	= _params param [0, grpNull, [grpNull]];
_player	= _params param [1, objNull, [objNull]];

private ["_invitations", "_hasInvitation"];
_invitations = _player getVariable [							"BIS_dg_inv", []];
_hasInvitation = false;

{
private ["_inviteGroup", "_inviteFrom", "_inviteTo", "_inviteTime"];
_inviteGroup 	= _x select 0;
_inviteFrom 	= _x select 1;
_inviteTo 		= _x select 2;
_inviteTime 	= _x select 3;

if (_group == _inviteGroup && {_player == _inviteTo} && {time <= _inviteTime + 						60}) exitWith
{
_hasInvitation = true;
};
} forEach _invitations;

_hasInvitation;
};




case "GetPlayerInvites" :
{
private ["_player", "_maxLifeTime"];
_player         = _params param [0, objNull, [objNull]];
_maxLifeTime    = _params param [1, 99999999, [0]];

private ["_invites", "_validInvites"];
_invites        = _player getVariable [							"BIS_dg_inv", []];
_validInvites   = [];

{
if (!isNull (_x select 0) && {time - (_x select 3) < _maxLifeTime}) then
{
_validInvites pushBack _x;
};
} forEach _invites;

_validInvites;
};




case "OnGroupJoin" :
{
private ["_group", "_leader", "_who"];
_group  = _params param [0, grpNull, [grpNull]];
_leader = _params param [1, objNull, [objNull]];
_who    = _params param [2, objNull, [objNull]];

if (!isNull _leader && {!isNull _who} && {_leader != _who}) then
{
[["LocalShowNotification", ["DynamicGroups_PlayerJoined", [name _who], _leader]], "BIS_fnc_dynamicGroups", _leader] call BIS_fnc_mp;
};
};




case "OnGroupJoinFailed" :
{
private ["_group", "_who"];
_group  = _params param [0, grpNull, [grpNull]];
_who    = _params param [1, objNull, [objNull]];

if (!isNull _who) then
{
[["LocalShowNotification", ["DynamicGroups_PlayerJoinFailed", [], _who]], "BIS_fnc_dynamicGroups", _who] call BIS_fnc_mp;
};
};




case "OnGroupLeave" :
{
private ["_group", "_leader", "_who"];
_group  = _params param [0, grpNull, [grpNull]];
_leader = _params param [1, objNull, [objNull]];
_who    = _params param [2, objNull, [objNull]];

if (!isNull _leader && {!isNull _who} && {_leader != _who}) then
{
[["LocalShowNotification", ["DynamicGroups_PlayerLeft", [name _who], _leader]], "BIS_fnc_dynamicGroups", _leader] call BIS_fnc_mp;
};
};




case "OnInvitationReceived" :
{
	if (!hasInterface) exitWith {};

private ["_group", "_to", "_from"];
_group  = _params param [0, grpNull, [grpNull]];
_to     = _params param [1, objNull, [objNull]];
_from   = _params param [2, objNull, [objNull]];

	if (player != _to) exitWith {};

if (!isNull _to && {!isNull _from} && {_to != _from}) then
{
["LocalShowNotification", ["DynamicGroups_InviteReceived", [name _from], _to]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
};


if (							false) then
{
["OnInvitationReceived: %1 / %2 / %3", _group, _to, _from] call bis_fnc_logFormat;
};
};




case "OnPromotedToLeader" :
{
private ["_group", "_newLeader", "_oldLeader"];
_group          = _params param [0, grpNull, [grpNull]];
_newLeader      = _params param [1, objNull, [objNull]];
_oldLeader      = _params param [2, objNull, [objNull]];

if (!isNull _oldLeader && {!isNull _newLeader} && {_oldLeader != _newLeader}) then
{
[["LocalShowNotification", ["DynamicGroups_PromotedToLeader", [name _oldLeader], _newLeader]], "BIS_fnc_dynamicGroups", _newLeader] call BIS_fnc_mp;
};


if (							false) then
{
["OnPromotedToLeader: %1 / %2 / %3", _group, _newLeader, _oldLeader] call BIS_fnc_logFormat;
};
};




case "OnGroupDisbanded" :
{
private ["_group", "_who", "_oldLeader"];
_group          = _params param [0, grpNull, [grpNull]];
_who            = _params param [1, objNull, [objNull]];
_oldLeader      = _params param [2, objNull, [objNull]];

if (!isNull _oldLeader && {!isNull _who} && {_oldLeader != _who}) then
{
[["LocalShowNotification", ["DynamicGroups_GroupDisbanded", [name _oldLeader], _who]], "BIS_fnc_dynamicGroups", _who] call BIS_fnc_mp;
};


if (							false) then
{
["OnGroupDisbanded: %1 / %2 / %3", _group, _who, _oldLeader] call bis_fnc_logFormat;
};
};




case "OnKicked" :
{
private ["_group", "_who", "_oldLeader"];
_group  = _params param [0, grpNull, [grpNull]];
_who    = _params param [1, objNull, [objNull]];
_leader = _params param [2, objNull, [objNull]];

if (!isNull _leader && {!isNull _who} && {_who != _leader}) then
{
[["LocalShowNotification", ["DynamicGroups_Kicked", [name _leader], _who]], "BIS_fnc_dynamicGroups", _who] call BIS_fnc_mp;
};


if (							false) then
{
["OnKicked: %1 / %2 / %3", _group, _who, _leader] call bis_fnc_logFormat;
};
};

case "LoadInsignias" :
{
(configfile >> "CfgUnitInsignia") call BIS_fnc_getCfgSubClasses;
};

case "LoadInsignia" :
{
private ["_class"];
_class = _params param [0, "", [""]];

private ["_cfg", "_displayName", "_texture", "_author"];
_cfg            = configfile >> "CfgUnitInsignia" >> _class;
_displayName    = getText (_cfg >> "displayName");
_texture        = getText (_cfg >> "texture");
_author         = getText (_cfg >> "author");

[_displayName, _texture, _author];
};

case "LoadRandomInsignia" :
{
private "_insignias";
_insignias = ["LoadInsignias"] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };
_insignias = _insignias - [					"BI"];
_insignias call bis_fnc_selectRandom;
};

case "GetInsigniaDisplayName" :
{
private ["_class"];
_class = _params param [0, "", [""]];

private "_insignia";
_insignia = ["LoadInsignia", [_class]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };

_insignia select 0;
};

case "GetInsigniaTexture" :
{
private ["_class"];
_class = _params param [0, "", [""]];

private "_insignia";
_insignia = ["LoadInsignia", [_class]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };

_insignia select 1;
};

case "GetInsigniaAuthor" :
{
private ["_class"];
_class = _params param [0, "", [""]];

private "_insignia";
_insignia = ["LoadInsignia", [_class]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); };

_insignia select 2;
};

case "LocalShowNotification" :
{
private ["_class", "_notificationParams", "_target"];
_class                  = _params param [0, "", [""]];
_notificationParams     = _params param [1, [], [[]]];
_target                 = _params param [2, objNull, [objNull]];

private ["_actionKeysNames", "_keyText", "_string"];
_actionKeysNames        = actionkeysnamesarray ["TeamSwitch", 1];
_keyText                = if (count _actionKeysNames > 0) then { _actionKeysNames select 0 } else { "N/A" };
_string                 = format ["<t color = '%2'>[%1]</t>", _keyText, (["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet) call BIS_fnc_colorRGBtoHTML];

_notificationParams pushBack _string;

if (player == _target || {isNull _target}) then
{
[_class, _notificationParams] call BIS_fnc_showNotification;
};
};

case "OnPlayerGroupChanged" :
{
private ["_player", "_newGroup", "_oldGroup"];
_player 	= _params param [0, objNull, [objNull]];
_newGroup 	= _params param [1, grpNull, [grpNull]];
_oldGroup 	= _params param [2, grpNull, [grpNull]];

if (["IsGroupRegistered", [_newGroup]] call 								{ _this call (missionNamespace getVariable ["BIS_fnc_dynamicGroups", {}]); }) then
{
[_player, _newGroup getVariable [					"BIS_dg_ins", ""]] call BIS_fnc_setUnitInsignia;
}
else
{
[_player, ""] call BIS_fnc_setUnitInsignia;
};
};

case "GetGroupTexture" :
{
private _group = _params param [0, grpNull, [grpNull]];
private _availableInsignias = [];

if (!isNil { uiNamespace getVariable "RscEGSpectator_availableInsignias" }) then
{
_availableInsignias = uiNamespace getVariable "RscEGSpectator_availableInsignias";
}
else
{
_availableInsignias = (configfile >> "CfgUnitInsignia") call BIS_fnc_getCfgSubClasses;
uiNamespace setVariable ["RscEGSpectator_availableInsignias", _availableInsignias];
};

private _lastInsigniaTexture = _group getVariable ["BIS_dynamicGroups_lastinsignia", ""];
private _insigniaTexture = "";

if (_lastInsigniaTexture == "") then
{
private _insignia = if (count _availableInsignias > 0) then { selectRandom _availableInsignias } else { "" };
private _groupPicture 	= leader _group getVariable ["BIS_dg_ins", _insignia];
_insigniaTexture = ["GetInsigniaTexture", [_groupPicture]] call BIS_fnc_dynamicGroups;
_group setVariable ["BIS_dynamicGroups_lastinsignia", _insigniaTexture];
}
else
{
_insigniaTexture = _lastInsigniaTexture;
};

if (_insigniaTexture != "") then
{
_insigniaTexture;
}
else
{
private _squadParams = squadParams leader _group;
private _squadPicture = if (count _squadParams > 0) then { ((_squadParams select 0) select 4) } else { "" };
_squadPicture;
};
};

case "SetAvailableInsignias" :
{
uiNamespace setVariable ["RscEGSpectator_availableInsignias", _params param [0, [], [[]]]];
};

case "GetAvailableInsignias" :
{
uiNamespace getVariable ["RscEGSpectator_availableInsignias", []];
};




case default
{
["Unknown mode: %1", _mode] call BIS_fnc_error;
};
};
