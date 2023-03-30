
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_finishCuratorChallenge'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_finishCuratorChallenge';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f_curator\CuratorChallenges\fn_finishCuratorChallenge.sqf [BIS_fnc_finishCuratorChallenge]"
#line 1 "A3\functions_f_curator\CuratorChallenges\fn_finishCuratorChallenge.sqf"















private ["_curator","_challenge","_state","_challengeClass","_params"];
_curator = _this param [0,objnull,[objnull]];
_challenge = _this param [1,[],[[],""]];
_state = _this param [2,"SUCCEEDED",[""]];

_challengeClass = _challenge param [0,"",[""]];
_params = _curator getvariable _challengeClass;
if !(isnil "_params") then {
private ["_challengeArray","_challengeType","_challengeTask"];
_challengeArray = _challenge param [1,[],[[]]];
_challengeType = _challengeArray param [0,"",[""]];
_challengeTask = _challengeArray param [1,"",[""]];
{
private ["_task"];
_task = _x select 1;
if (_task == _challengeTask || _challengeTask == "") then {
[_task,nil,nil,nil,_state,nil,nil,false] call bis_fnc_settask;
_params set [_foreachindex,0];
};
} foreach _params;
_params = _params - [0];
_curator setvariable [_challengeClass,_params,true];
};
true
