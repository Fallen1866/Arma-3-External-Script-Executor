
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_reviveOnState'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_reviveOnState';
	scriptName _fnc_scriptName;

#line 1 "a3\functions_f_mp_mark\revive\fn_reviveOnState.sqf [BIS_fnc_reviveOnState]"
#line 1 "a3\functions_f_mp_mark\revive\fn_reviveOnState.sqf"
#line 1 "a3\functions_f_mp_mark\revive\defines.inc"



















































































































































































































































































#line 1 "a3\functions_f_mp_mark\revive\fn_reviveOnState.sqf"

























private ["_unitVar","_statePrev","_playerVar","_source","_reason"];

private _state 	= param [1, 								0, [123,[]]];
private _unit  	= param [2, objNull, [objNull]];

if (isNull _unit) exitWith {};

if (_state isEqualType []) then
{
_source	= _state param [1, objNull, [objNull]];
_reason	= _state param [2, 				-1, [123]];
_state 	= _state param [0, 								0, [123]];
}
else
{
_source	= objNull;
_reason = 				-1;
};

_unitVar = ([_unit] call bis_fnc_objectVar);
_playerVar = ([player] call bis_fnc_objectVar);


_statePrev = (_unit getVariable [						"#rev_state", 								0]);


if (_statePrev == _state) exitWith {};


_unit setVariable [						"#rev_state", _state];

switch (_state) do
{
case 							2:
{
private _sidePlayer = side group player;
private _sideUnit = side group _unit;


_unit setVariable ["BIS_revive_incapacitated", true];


if (bis_revive_killfeedShow) then
{
if (isNull _source) then
{
systemChat format [					(localize "STR_A3_Revive_MSG_INCAPACITATED")				,name _unit];
}
else
{
private _name = if (isPlayer _source) then
{
name _source;
}
else
{
format [				(localize "STR_A3_Revive_MSG_NAME_TEMPLATE_AI")				, name _source];
};

if (side group _source getFriend side group _unit >= 0.6) then
{
systemChat format [				(localize "STR_A3_Revive_MSG_INCAPACITATED_BY_FF")			,name _unit,_name];
}
else
{
systemChat format [				(localize "STR_A3_Revive_MSG_INCAPACITATED_BY")				,name _unit,_name];
};
};
};

if (local _unit) then
{

_unit setUnconscious true;


if (!captive _unit) then {_unit setCaptive true;_unit setVariable ["#rev_captiveForced",true];} else {_unit setVariable ["#rev_captiveForced",false];};


player setVariable [					"#rev_camera",cameraView];


[_unitVar] call bis_fnc_reviveBleedOut;


{inGameUISetEventHandler [_x, "true"]} forEach ["PrevAction", "NextAction"];
}
else
{

[						-1, _unitVar] call bis_fnc_reviveIconControl;
};


if (_playerVar != _unitVar && {_sidePlayer getFriend _sideUnit > 0 && {_sideUnit getFriend _sidePlayer > 0}}) then
{
bis_revive_incapacitatedUnits pushBackUnique _unitVar;
};


if ((vehicle _unit != _unit)) then
{
_unit playAction "Unconscious";
};

if (local _unit) then
{
if (bis_revive_3rdPersonViewAllowed) then
{
[] spawn
{
if (cameraView != "external") then
{
titleCut ["","BLACK OUT",0.5];
sleep 0.5;
player switchCamera "external";
titleCut ["","BLACK IN",0.5];
};


#line 1 "a3\functions_f_mp_mark\revive\_addAction_respawn.inc"
private _title = localize "STR_A3_ForceRespawn";
private _iconIdle = bis_fnc_reviveGetActionIcon;
private _iconProgress = 				"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_forceRespawn_ca.paa";
private _condShow = "lifeState player == 'INCAPACITATED'";
private _condProgress = _condShow;
private _codeStart = {["", true,player] call bis_fnc_reviveOnForcingRespawn;player setVariable [	"#revF",  true, true];};
private _codeProgress = {};
private _codeCompleted =
{
bis_revive_deathReason = 			12;

player setDamage 1;
};
private _codeInterrupted = {["", false,player] call bis_fnc_reviveOnForcingRespawn;player setVariable [	"#revF",  false, true];};
private _arguments = [];
private _duration = bis_revive_forceRespawnDuration;
private _priority = 1000;

private _actionID = [player,_title,_iconIdle,_iconProgress,_condShow,_condProgress,_codeStart,_codeProgress,_codeCompleted,_codeInterrupted,_arguments,_duration,_priority,true,true] call bis_fnc_holdActionAdd;
player setVariable [			"#rev_actionID_respawn",_actionID];#line 126 "a3\functions_f_mp_mark\revive\fn_reviveOnState.sqf"



while {!((player getVariable [						"#rev_state", 								0]) < 							2)} do
{
if (cameraView != "external") then {player switchCamera "external";};
sleep 0.001;
};
};
}
else
{

#line 1 "a3\functions_f_mp_mark\revive\_addAction_respawn.inc"
private _title = localize "STR_A3_ForceRespawn";
private _iconIdle = bis_fnc_reviveGetActionIcon;
private _iconProgress = 				"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_forceRespawn_ca.paa";
private _condShow = "lifeState player == 'INCAPACITATED'";
private _condProgress = _condShow;
private _codeStart = {["", true,player] call bis_fnc_reviveOnForcingRespawn;player setVariable [	"#revF",  true, true];};
private _codeProgress = {};
private _codeCompleted =
{
bis_revive_deathReason = 			12;

player setDamage 1;
};
private _codeInterrupted = {["", false,player] call bis_fnc_reviveOnForcingRespawn;player setVariable [	"#revF",  false, true];};
private _arguments = [];
private _duration = bis_revive_forceRespawnDuration;
private _priority = 1000;

private _actionID = [player,_title,_iconIdle,_iconProgress,_condShow,_condProgress,_codeStart,_codeProgress,_codeCompleted,_codeInterrupted,_arguments,_duration,_priority,true,true] call bis_fnc_holdActionAdd;
player setVariable [			"#rev_actionID_respawn",_actionID];#line 139 "a3\functions_f_mp_mark\revive\fn_reviveOnState.sqf"

};
}
else
{

[										2, _unitVar] call bis_fnc_reviveIconControl;


if (side group player getFriend side group _unit >= 0.6) then
{
#line 1 "a3\functions_f_mp_mark\revive\_addAction_revive.inc"
private _title = localize "STR_A3_Revive";
private _iconIdle = bis_fnc_reviveGetActionIcon;
private _iconProgress = 				"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa";
private _condShow = "[_target] call bis_fnc_reviveIsValid";
private _condProgress = _condShow;
private _codeStart =
{
["",true,_a0] call bis_fnc_reviveOnBeingRevived;_a0 setVariable [		"#revB", true, true];


player playAction "medicStart";
};
private _codeProgress = {};
private _codeCompleted =
{
["",false,_target] call bis_fnc_reviveOnBeingRevived;_target setVariable [		"#revB", false, true];

if (bis_revive_killfeedShow) then
{
["",[								1,player],_target] call bis_fnc_reviveOnState;_target setVariable [				"#rev", [								1,player], true];
}
else
{
["",								1,_target] call bis_fnc_reviveOnState;_target setVariable [				"#rev", 								1, true];
};


if (bis_revive_requiredItems == 2 && {!(player getUnitTrait "Medic" && {('Medikit' in items player || {(!isNull _target && {'Medikit' in items _target})})})}) then
{
if (('FirstAidKit' in items _target)) then
{
_target removeItem "FirstAidKit";
}
else
{
player removeItem "FirstAidKit";
};
};


player playAction "medicStop";


player addRating 													200;


private _reviveCount = (profileNamespace getVariable ["bis_reviveCount", 0]) + 1;
profileNamespace setVariable ["bis_reviveCount", _reviveCount];
if (_reviveCount == 5) then
{
setStatValue ["ExpGuardianAngel", 1];
};
};
private _codeInterrupted =
{
["",false,_a0] call bis_fnc_reviveOnBeingRevived;_a0 setVariable [		"#revB", false, true];


player playAction "medicStop";
};
private _arguments = [_unit];
private _duration = bis_revive_duration;
private _priority = 1000;

if (player getUnitTrait "Medic") then
{
_duration = bis_revive_durationMedic;
};

private _actionID = [_unit,_title,_iconIdle,_iconProgress,_condShow,_condProgress,_codeStart,_codeProgress,_codeCompleted,_codeInterrupted,_arguments,_duration,_priority] call bis_fnc_holdActionAdd;
_unit setVariable [			"#rev_actionID_revive",_actionID];#line 150 "a3\functions_f_mp_mark\revive\fn_reviveOnState.sqf"

}
else
{
#line 1 "a3\functions_f_mp_mark\revive\_addAction_secure.inc"

private _title = "Secure";								
private _iconIdle = 				"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_secure_ca.paa";
private _iconProgress = 				"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_secure_ca.paa";
private _condShow = "[_target] call bis_fnc_reviveIsValidSecure";
private _condProgress = _condShow;
private _codeStart = {};
private _codeProgress = {};
private _codeCompleted =
{

[_target,player] remoteExec ["bis_fnc_reviveSecureUnit",0,false];


player addRating 													200;
};
private _codeInterrupted = {};
private _arguments = [];
private _duration = 1;
private _priority = 1000;

private _actionID = [_unit,_title,_iconIdle,_iconProgress,_condShow,_condProgress,_codeStart,_codeProgress,_codeCompleted,_codeInterrupted,_arguments,_duration,_priority] call bis_fnc_holdActionAdd;
_unit setVariable [			"#rev_actionID_secure",_actionID];#line 154 "a3\functions_f_mp_mark\revive\fn_reviveOnState.sqf"

};
};
};
case 									3:
{
bis_revive_incapacitatedUnits = bis_revive_incapacitatedUnits - [_unitVar];


_unit setVariable ["BIS_revive_incapacitated", false];


if (bis_revive_killfeedShow && !bis_revive_hudLocked) then
{

if (_reason > 10 && {side group _unit getFriend side group player < 0.6}) exitWith {};

private _name = if (!isNull _source) then
{
if (isPlayer _source) then
{
name _source;
}
else
{
format [				(localize "STR_A3_Revive_MSG_NAME_TEMPLATE_AI")				, name _source];
};
};

switch (_reason) do
{
case 					0:
{
systemChat format [							(localize "STR_A3_Revive_MSG_DIED")							,name _unit];
};
case 				3:
{
if (isNull _source) then
{
systemChat format [							"%1 was secured",name _unit];
}
else
{
systemChat format [						"%1 was secured by %2",name _unit,_name];
};
};
case 			12:
{
systemChat format [					(localize "STR_A3_Revive_MSG_FORCED_RESPAWN")				,name _unit];
};
case 				11:
{
systemChat format [							(localize "STR_A3_Revive_MSG_BLEDOUT")						,name _unit];
};
case 				1:
{
if (isNull _source) then
{
systemChat format [						(localize "STR_A3_Revive_MSG_EXECUTED")						,name _unit];
}
else
{
if (side group _source getFriend side group _unit >= 0.6) then
{
systemChat format [					(localize "STR_A3_Revive_MSG_EXECUTED_BY_FF")				,name _unit,_name];
}
else
{
systemChat format [						(localize "STR_A3_Revive_MSG_EXECUTED_BY")					,name _unit,_name];
};
};
};
case 				2:
{
systemChat format [						(localize "STR_A3_Revive_MSG_SUICIDED")						,name _unit];
};
case 				13:
{
systemChat format [							(localize "STR_A3_Revive_MSG_DROWNED")						,name _unit];
};
default
{
if (isNull _source) then
{
systemChat format [							(localize "STR_A3_Revive_MSG_KILLED")						,name _unit];
}
else
{
if (side group _source getFriend side group _unit >= 0.6) then
{
systemChat format [					(localize "STR_A3_Revive_MSG_KILLED_BY_FF")					,name _unit,_name];
}
else
{
systemChat format [						(localize "STR_A3_Revive_MSG_KILLED_BY")					,name _unit,_name];
};
};
};
};
};


if (!local _unit) then
{

if (lifeState _unit != 'INCAPACITATED') then
{
[						-1, _unitVar] call bis_fnc_reviveIconControl;
};


["", false,_unit] call bis_fnc_reviveOnBeingRevived;_unit setVariable [		"#revB",  false];
["", false,_unit] call bis_fnc_reviveOnForcingRespawn;_unit setVariable [	"#revF",  false];


{if (_x != -1) then {[_unit,_x] call bis_fnc_holdActionRemove}} forEach [_unit getVariable [			"#rev_actionID_revive",-1],_unit getVariable [			"#rev_actionID_secure",-1]];

[															3, _unitVar] call bis_fnc_reviveIconControl;
}
else
{

bis_revive_bleeding = false;


private _actionID = _unit getVariable [			"#rev_actionID_respawn",-1];
if (_actionID != -1) then {[_unit,_actionID] call bis_fnc_holdActionRemove;};


if ((_unit getVariable [				"#rev_being_revived", false])) then {["", false,_unit] call bis_fnc_reviveOnBeingRevived;_unit setVariable [		"#revB",  false, true];};
if ((_unit getVariable [				"#rev_forcing_respawn", false])) then {["", false,_unit] call bis_fnc_reviveOnForcingRespawn;_unit setVariable [	"#revF",  false, true];};
};
};
case 								1:
{
if (_statePrev != 							2) exitWith {};

bis_revive_incapacitatedUnits = bis_revive_incapacitatedUnits - [_unitVar];


_unit setVariable ["BIS_revive_incapacitated", false];


if (bis_revive_killfeedShow && {side group player getFriend side group _unit >= 0.6}) then
{
if (isNull _source) then
{
systemChat format [							(localize "STR_A3_Revive_MSG_REVIVED")						,name _unit];
}
else
{
systemChat format [						(localize "STR_A3_Revive_MSG_REVIVED_BY")					,name _unit,name _source];
};
};

if (local _unit) then
{

bis_revive_deathReason = 				-1;


bis_revive_bleeding = false;


_unit setUnconscious false;


if (_unit getVariable ["#rev_captiveForced",false]) then {_unit setVariable ["#rev_captiveForced",false];_unit setCaptive false;};


_unit playAction "Stop";


if ({currentWeapon player == _x} count ["",binocular player] > 0) then
{
[] spawn
{
sleep 0.1;
if (({currentWeapon player == _x} count ["",binocular player] > 0) && {((player getVariable [						"#rev_state", 								0]) < 							2)}) then {player playAction "Civil";};
};
};


_unit setVariable [				"#rev_bleed", 0];
_unit setVariable [						"#rev_damage", 0];


if ((_unit getVariable [				"#rev_being_revived", false])) then {["", false,_unit] call bis_fnc_reviveOnBeingRevived;_unit setVariable [		"#revB",  false, true];};
if ((_unit getVariable [				"#rev_forcing_respawn", false])) then {["", false,_unit] call bis_fnc_reviveOnForcingRespawn;_unit setVariable [	"#revF",  false, true];};


{inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "NextAction"];


if (cameraView != (player getVariable [					"#rev_camera", "internal"])) then
{
[] spawn
{
titleCut ["","BLACK OUT",0.5];
sleep 0.5;
player switchCamera (player getVariable [					"#rev_camera", "internal"]);
titleCut ["","BLACK IN",0.5];
};
};


private _actionID = _unit getVariable [			"#rev_actionID_respawn",-1];
if (_actionID != -1) then {[_unit,_actionID] call bis_fnc_holdActionRemove;};


[] call bis_fnc_reviveDamageReset;
}
else
{

["", false,_unit] call bis_fnc_reviveOnBeingRevived;_unit setVariable [		"#revB",  false];
["", false,_unit] call bis_fnc_reviveOnForcingRespawn;_unit setVariable [	"#revF",  false];


{if (_x != -1) then {[_unit,_x] call bis_fnc_holdActionRemove}} forEach [_unit getVariable [			"#rev_actionID_revive",-1],_unit getVariable [			"#rev_actionID_secure",-1]];


[					-2,_unitVar] call bis_fnc_reviveIconControl;
};
};
case 								0:
{
bis_revive_incapacitatedUnits = bis_revive_incapacitatedUnits - [_unitVar];


_unit setVariable ["BIS_revive_incapacitated", false];

if (local _unit) then
{

if (_unit getVariable ["#rev_captiveForced",false]) then {_unit setVariable ["#rev_captiveForced",false];_unit setCaptive false;};


bis_revive_deathReason = 				-1;


bis_revive_bleeding = false;


_unit setVariable [				"#rev_bleed", 0];
_unit setVariable [						"#rev_damage", 0];


if ((_unit getVariable [				"#rev_being_revived", false])) then {["", false,_unit] call bis_fnc_reviveOnBeingRevived;_unit setVariable [		"#revB",  false, true];};
if ((_unit getVariable [				"#rev_forcing_respawn", false])) then {["", false,_unit] call bis_fnc_reviveOnForcingRespawn;_unit setVariable [	"#revF",  false, true];};


{inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "NextAction"];


_unit switchCamera (_unit getVariable [					"#rev_camera", "internal"]);


private _actionID = _unit getVariable [			"#rev_actionID_respawn",-1];
if (_actionID != -1) then {[_unit,_actionID] call bis_fnc_holdActionRemove;};


[] call bis_fnc_reviveDamageReset;
}
else
{

["", false,_unit] call bis_fnc_reviveOnBeingRevived;_unit setVariable [		"#revB",  false];
["", false,_unit] call bis_fnc_reviveOnForcingRespawn;_unit setVariable [	"#revF",  false];


{if (_x != -1) then {[_unit,_x] call bis_fnc_holdActionRemove}} forEach [_unit getVariable [			"#rev_actionID_revive",-1],_unit getVariable [			"#rev_actionID_secure",-1]];


[					-2,_unitVar] call bis_fnc_reviveIconControl;
};
};
default
{
};
};
