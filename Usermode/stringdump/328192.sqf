
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_traceBullets'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_traceBullets';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f_bootcamp\Misc\fn_traceBullets.sqf [BIS_fnc_traceBullets]"
#line 1 "A3\functions_f_bootcamp\Misc\fn_traceBullets.sqf"















params
[
["_shooter",objNull,[objNull]],
["_maxLines",20,[20]]
];

if (isNil "BIS_tracedShooter") then {BIS_tracedShooter = _shooter};

if (isNil {_shooter getVariable "BIS_bulletTrace_EHPool"}) then {
_shooter setVariable ["BIS_bulletTrace_EHPool", []];
};
if (_maxLines isEqualTo 0) then {
{_shooter removeEventHandler ["FiredMan", _x]} forEach (_shooter getVariable ["BIS_bulletTrace_EHPool",-1]);
_shooter setVariable ["BIS_bulletTrace_EHPool", []];
if (!isNil {_shooter getVariable "BIS_bulletTrace_EHDraw"}) then {removeMissionEventHandler ["Draw3D", _shooter getVariable "BIS_bulletTrace_EHDraw"]};
if (!isNil {_shooter getVariable "BIS_lines"}) then {
{for [{_i = 0}, {_i < count _x}, {_i = _i + 1}] do {_x set [_i, [[]]]}} forEach (_shooter getVariable "BIS_lines");
_shooter setVariable ["BIS_lines", []];
}
} else {
_shooter setVariable ["BIS_maxLines", _maxLines];
_shooter setVariable ["BIS_lines", []];
_shooter setVariable ["BIS_colors", []];
_shooter setVariable ["BIS_flying", 0];


bis_fnc_traceRound =
{
params
[
"_shooter",
"_startPos",
"_round"
];


private _cfg			= configFile >> "CfgAmmo" >> typeof _round;
private _submunition	= [_cfg,"submunitionAmmo",0] call BIS_fnc_returnConfigEntry;
if(_submunition isEqualTypeAny ["",[]] )then
{

if(typeName _submunition isEqualTo "STRING")then
{

if(_submunition == "")exitWith{_submunition = []};
_submunition = [_submunition];
};
if(_submunition isEqualTo [])exitWith{};


_submunition = _submunition select {typeName _x isEqualTo "STRING"};



private _pfh = format["BIS_pfh_trace_subammo_%1", _round];
[_pfh, "onEachFrame",
{
params["_round","_pos","_submunition","_shooter","_pfh"];
if(isNull _round)exitWith
{
private _newAmmo = [];
{{_newAmmo pushBackUnique _x}foreach (_pos nearObjects [_x,35])}foreach _submunition;

if(count _newAmmo > 0)then
{
{
[_shooter,_pos,_x] call bis_fnc_traceRound;
}foreach _newAmmo;
};
[_pfh, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
};
_this set [1,getPosVisual _round];

}, [_round,getPosVisual _round,_submunition,_shooter,_pfh]] call BIS_fnc_addStackedEventHandler;
};

_shooter setVariable ["BIS_flying", (_shooter getVariable "BIS_flying") + 1];
_shooter setVariable ["BIS_colors", (_shooter getVariable "BIS_colors") + [[]]];
_shooter setVariable ["BIS_lines", (_shooter getVariable "BIS_lines") + [[]]];

private _i = (count (_shooter getVariable "BIS_lines") - 1);

if (_i >= 0) then {
((_shooter getVariable "BIS_colors") select _i) set [0, [1,0,0,1]];
((_shooter getVariable "BIS_lines") select _i) set [0, _startPos];
};
if (count (_shooter getVariable "BIS_lines") > (_shooter getVariable "BIS_maxLines")) then {
(_shooter getVariable "BIS_colors") set [(count (_shooter getVariable "BIS_colors")) - (_shooter getVariable "BIS_maxLines") - 1, []];
(_shooter getVariable "BIS_lines") set [(count (_shooter getVariable "BIS_lines")) - (_shooter getVariable "BIS_maxLines") - 1, []];
};



private _pfh = format["BIS_pfh_trace_bullet_%1", _round];
[_pfh, "onEachFrame",
{
params["_time","_round","_shooter","_startSpeed","_i","_pfh"];


if(time < _time)exitWith{};

private _lines	= _shooter getVariable ["BIS_lines",[]];
private _colors	= _shooter getVariable ["BIS_colors",[]];
private _curSpd	= vectorMagnitude (velocity _round);

if (isNull _round || count _lines isEqualTo 0 || _curSpd <= 1)exitWith
{
if (count (_lines) > 0) then {
_shooter setVariable ["BIS_flying", (_shooter getVariable "BIS_flying") - 1];
if ((_shooter getVariable "BIS_flying") == 0) then {
_shooter setVariable ["BIS_colors", _colors - [[]]];
_shooter setVariable ["BIS_lines", _lines - [[]]];
};
};
[_pfh, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
};

if (count (_lines select _i) > 0) then
{
_curPos = getPosVisual _round;

_r = 2 - (_startSpeed / _curSpd);
_b = (_startSpeed / _curSpd) - 1;
((_shooter getVariable "BIS_colors") select _i) set [count (_colors select _i), [_r,0,_b,1]];
((_shooter getVariable "BIS_lines") select _i) set [count (_lines select _i), _curPos];


_this set [0,time + linearConversion [_startSpeed,40,_curSpd,0.01,0.15,true]];
};
}, [0,_round,_shooter,vectorMagnitude (velocity _round),_i,_pfh]] call BIS_fnc_addStackedEventHandler;

};


private _EHIndex = _shooter addEventHandler ["FiredMan", {[_this # 0, getPosVisual (_this # 6), _this # 6] spawn bis_fnc_traceRound}];

_shooter setVariable ["BIS_bulletTrace_EHPool", (_shooter getVariable "BIS_bulletTrace_EHPool") + [_EHIndex]];

private _event = addMissionEventHandler ["Draw3D", {
if (BIS_tracedShooter getVariable ["BIS_drawLines",true]) then {
{
for [{_i = 1}, {_i < count _x}, {_i = _i + 1}] do {
drawLine3D [_x select (_i - 1), _x select _i, ((BIS_tracedShooter getVariable "BIS_colors") select _forEachIndex) select (_i - 1)];
}
} forEach (BIS_tracedShooter getVariable "BIS_lines")
};
}];

_shooter setVariable ["BIS_bulletTrace_EHDraw", _event];
};
