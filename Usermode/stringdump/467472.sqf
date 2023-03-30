
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_addCuratorChallenge'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_addCuratorChallenge';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f_curator\CuratorChallenges\fn_addCuratorChallenge.sqf [BIS_fnc_addCuratorChallenge]"
#line 1 "A3\functions_f_curator\CuratorChallenges\fn_addCuratorChallenge.sqf"























private ["_curator","_pool","_count","_condition","_reward","_parentTaskID","_rewardCode","_rewardText"];
_curator = _this param [0,objnull,[objnull]];
_pool = _this param [1,[],[[]]];
_count = _this param [2,3,[0]];
_count = _count min 10 max 1;
_condition = _this param [3,{true},[{}]];
_reward = _this param [4,{},[{},[]]];
_parentTaskID = _this param [5,"",[""]];
_init = _this param [6,true,[true]];
if (_parentTaskID == "") then {_parentTaskID = _fnc_scriptname + str ([_fnc_scriptname + "_counter",1] call bis_fnc_counter)};

if (_init && !isserver) exitwith {["%1 can be executed only on server",_fnc_scriptName] call bis_fnc_error; ""};

_rewardCode = _reward param [0,{},[{}]];
_rewardText = _reward param [1,"",[""]];


if (_init) exitwith {
[[_curator,_pool,_count,_condition,[nil,_rewardText],_parentTaskID,false],_fnc_scriptname,_curator,false] call bis_fnc_mp;


_curatorOwner = owner _curator;
waituntil {
!isnil {_curator getvariable _parentTaskID} 
||
_curatorOwner != owner _curator 
};


_challengeID = [["bis_fnc_addCuratorChallenge_completed",_curator],1] call bis_fnc_counter;
[_curator,_challengeID - 1,_parentTaskID] call _rewardCode;
true
};




if (count _pool == 0) then {
_cfgCuratorChallenges = configfile >> "CfgCuratorChallenges";
for "_i" from 0 to (count _cfgCuratorChallenges - 1) do {
_class = _cfgCuratorChallenges select _i;
if (isclass _class) then {_pool set [count _pool,configname _class];};
};
};


private ["_challenges","_curatorUnit","_objects","_objectsCount"];
_challenges = [];
_curatorUnit = getassignedcuratorunit _curator;
_objects = curatorRegisteredObjects _curator;
_objectsCount = count _objects - 1;
{
private ["_challenge","_functionVar","_function"];
_challenge = _x;
_functionVar = gettext (configfile >> "CfgCuratorChallenges" >> _challenge >> "function");
_function = missionnamespace getvariable _functionVar;
if !(isnil "_function") then {
private ["_enabled"];
_enabled = false;
{
private ["_object","_show"];
_object = _x select 0;
_show = _x select 1;
if (_show) then {
private ["_curator","_pool","_count","_condition","_reward","_parentTaskID","_rewardCode","_rewardText","_challenges","_curatorUnit","_objects","_objectsCount","_challenge","_functionVar","_show"];
_enabled = [] call {
["condition",_object] call _function;
};
};
if (_enabled) exitwith {_challenges set [count _challenges,_challenge];};
} foreach _objects;
} else {
["Cannot initialize '%1' challenge, function '%2' doesn't exist.",_challenge,_functionVar] call bis_fnc_error;
};
} foreach _pool;


_challenges = _challenges call bis_fnc_arrayShuffle;
_challenges resize (_count min count _challenges);

if (count _challenges == 0) exitwith {""};


private ["_functions","_allTypes","_allTypeObjects","_playerTypes"];
_functions = [];
_allTypes = [];
_allTypeObjects = [];
_playerTypes = [];
{
private ["_cfg","_functionVar","_function"];
_cfg = configfile >> "CfgCuratorChallenges" >> _x;
_functionVar = gettext (_cfg >> "function");
_function = missionnamespace getvariable _functionVar;
_functions set [_foreachindex,_function];
_allTypes set [_foreachindex,[]];
_allTypeObjects set [_foreachindex,[]];
_playerTypes set [_foreachindex,[]];
} foreach _challenges;


private ["_editableobjects"];
_editableobjects = curatoreditableobjects _curator;
{
private ["_player"];
_player = _x;
if (_player in _editableobjects) then {
{
private ["_types","_challengePlayerTypes"];
_types = [] call {
["object",typeof _player] call _x;
};
_challengePlayerTypes = _playerTypes select _foreachindex;
{
if !(_x in _challengePlayerTypes) then {_challengePlayerTypes set [count _challengePlayerTypes,_x];};
} foreach _types;
} foreach _functions;
};
} foreach (playableunits + switchableunits);


{
private ["_show"];
_show = _x select 1;
if (_show) then {
private ["_object"];
_object = _x select 0;
{
private ["_types","_types","_challengeTypes","_challengeTypeObjects"];
_types = [] call {
private ["_show","_challengeTypes","_challengeTypeObjects","_functionVar","_cfg","_types","_objects","_functions"];
["object",_object] call _x;
};
_challengePlayerTypes = _playerTypes select _foreachindex;
_types = _types - _challengePlayerTypes;

_challengeTypes = _allTypes select _foreachindex;
_challengeTypeObjects = _allTypeObjects select _foreachindex;
{
private ["_typeID","_typeObjects"];
_typeID = _challengeTypes find _x;
if (_typeID < 0) then {
_typeID = count _challengeTypeObjects;
_challengeTypes set [_typeID,_x];
_challengeTypeObjects set [_typeID,[]];
};
_typeObjects = _challengeTypeObjects select _typeID;
if !(_object in _typeObjects) then {
_typeObjects set [count _typeObjects,_object];
};
} foreach _types;
} foreach _functions;
};
progressloadingscreen (_foreachindex / _objectsCount);
} foreach _objects;


[
_parentTaskID,
_curatorUnit,
[
localize "STR_A3_BIS_fnc_addCuratorChellange_taskDescription" + "<br /><br />" + _rewardText,
localize "STR_A3_BIS_fnc_addCuratorChellange_taskTitle",
""
],
nil,
nil,
nil,
false, 
false 
] call bis_fnc_settask;


private ["_challengeTasks"];
_challengeTasks = [];
{
private ["_challengeTypes","_challengeTypeObjects","_index","_selectedType","_selectedObjects","_cfg","_title","_description","_textObjects","_titleParams","_taskID"];
_challengeTypes = _allTypes select _foreachindex;
_challengeTypeObjects = _allTypeObjects select _foreachindex;


_index = _challengeTypes call bis_fnc_randomindex;
_selectedType = _challengeTypes select _index;
_selectedObjects = _challengeTypeObjects select _index;


_cfg = configfile >> "CfgCuratorChallenges" >> _x;
_title = gettext (_cfg >> "title");
if (_title == "") then {_title = "%1";};
_description = gettext (_cfg >> "description");
_textObjects = _selectedObjects call bis_fnc_formatcuratorchallengeobjects;
_titleParams = [] call {
private ["_show","_challengeTypes","_challengeTypeObjects","_functionVar","_cfg","_types","_objects"];
["title",_selectedType] call (_functions select _foreachindex);
};
if (isnil "_titleParams") then {_titleParams = [];};
if (typename _titleParams != typename []) then {_titleParams = [_titleParams];};


_taskID = _parentTaskID + _x;
[
[_taskID,_parentTaskID],
_curatorUnit,
[
[_description + _textObjects] + _titleParams,
[_title] + _titleParams,
""
],
nil,
nil,
nil,
nil,
false
] call bis_fnc_settask;


private ["_isPersistent","_params","_isGlobal","_functionVar"];
_isPersistent = isnil {_curator getvariable _x};
_params = _curator getvariable [_x,[]];
_params set [count _params,[_selectedType,_taskID]];
_curator setvariable [_x,_params,true];
_challengeTasks set [count _challengeTasks,[_x,[_selectedType,_taskID]]];


_isGlobal = getnumber (_cfg >> "isGlobal") > 0;
_functionVar = gettext (_cfg >> "function");
["exec",_curator] spawn (missionnamespace getvariable _functionVar);
if (_isGlobal) then {
[["execLocal",_curator],_functionVar,true,_isPersistent] call bis_fnc_mp;
};
} foreach _challenges;


_completed = false;
while _condition do {


if !(_parentTaskID call bis_fnc_taskExists) exitwith {};


_taskChildren = _parentTaskID call bis_fnc_taskChildren;
if ({!(_x call bis_fnc_taskCompleted)} count _taskChildren == 0 && count _taskChildren > 0) exitwith {_completed = true;};

sleep 1;
};
_state = if (_completed) then {"succeeded"} else {"canceled"};
{
[_curator,_x,_state] call bis_fnc_finishcuratorchallenge;
} foreach _challengeTasks;
[_parentTaskID,nil,nil,nil,_state,nil,nil,false] call bis_fnc_settask;

_curator setvariable [_parentTaskID,_completed,true];
if (_completed) then {
_challengeID = [["bis_fnc_addCuratorChallenge_completed",_curator],1] call bis_fnc_counter;
};
true
