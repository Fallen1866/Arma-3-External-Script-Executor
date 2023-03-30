
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleZoneProtection'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleZoneProtection';
	scriptName _fnc_scriptName;

#line 1 "a3\modules_f_curator\multiplayer\functions\fn_moduleZoneProtection.sqf [BIS_fnc_moduleZoneProtection]"
#line 1 "a3\modules_f_curator\multiplayer\functions\fn_moduleZoneProtection.sqf"
if !(hasinterface) exitwith {};

_logic = _this select 0;
_units = _this select 1;
_activated = _this select 2;

if (_activated) then
{
_show = _logic getvariable ["show",true];


_areas = missionnamespace getvariable ["bis_fnc_modulezoneprotection_areas",[]];
_maxAreaSize = 0;
{
if (_x  iskindof "LocationArea_F") then
{
{
_areas set [count _areas,_x];
_maxAreaSize = _maxAreaSize max (triggerarea _x select 0) max (triggerarea _x select 1);
}
foreach (_x call bis_fnc_moduleTriggers);
};
}
foreach (synchronizedobjects _logic);

missionnamespace setvariable ["bis_fnc_modulezoneprotection_areas",_areas];


_maxAreaSize = _maxAreaSize * 0.1;
if (_show) then {[_areas,_maxAreaSize] call bis_fnc_drawAO};

if (isnil "bis_fnc_modulezoneprotection_spawn") then
{
bis_fnc_modulezoneprotection_spawn = [_maxAreaSize,_show,_logic] spawn
{
_fnc_scriptName = "BIS_fnc_moduleZoneProtection: Loop";
scriptname _fnc_scriptName;

params ["_maxAreaSize","_show","_logic"];

private _loading = [] spawn {waituntil{!({!isnull _x} count ((uinamespace getvariable "loading_displays") - [finddisplay 18]) > 0)};};
waitUntil{scriptDone _loading};

sleep 1; 
sleep 1;

_warningTimeLimit = 30;
_warningTime = time;

_neutralizeTimeLimit = 5;
_neutralizeTime = time;

_playersideOld = player call bis_fnc_objectside;
_lastAliveState = alive player;

private _warningExpression = compile (_logic getVariable ["WarningExpression",""]);
private _executionExpression = compile (_logic getVariable ["ExecutionExpression",""]);
private _warningAreaWidth = _logic getVariable ["WarningWidth",0.9];
private ["_warningValue","_executionValue"];

private _hq = _playersideOld call bis_fnc_moduleHQ;

while {true} do
{
_areas = missionnamespace getvariable ["bis_fnc_modulezoneprotection_areas",[]];

if (alive player && {simulationenabled player && {count _areas > 0 && {!(player call bis_fnc_isUnitVirtual)}}}) then
{
if !(_lastAliveState) then {sleep 5;}; 
_inPresent = 0;
_inNotPresent = 1e10;
_delay = 3 / count _areas;
_playerside = sideunknown;

{

if !(isnull _x) then {
_activation = triggeractivation _x;
_activationBy = _activation select 0;
_activationType = (_activation select 1) == "PRESENT";

_playerside = player call bis_fnc_objectside;
if (_activationBy == (str _playerside) || _activationBy == "ANY" || _activationBy == "ANYPLAYER") then
{
_inTrigger = [_x,player,true] call bis_fnc_inTrigger;

if (_activationType) then
{
_inPresent = _inPresent min _inTrigger;
}
else
{
_inNotPresent = _inNotPresent min _inTrigger;
};
};
};
sleep _delay;
}
foreach _areas;

if (_inNotPresent == 1e10) then {_inNotPresent = 0;};
_in = _inPresent min -_inNotPresent;


if (_playerside != _playersideOld) then
{
_hq = _playerside call bis_fnc_moduleHQ;

if (_show) then {[_areas,_maxAreaSize] call bis_fnc_drawAO;};
_playersideOld = _playerside;
};


if (_in < 0) then
{
if (time > _warningTime) then
{
_warningValue = call _warningExpression;

if !(!isNil{_warningValue} && {_warningValue isEqualTo true}) then
{
if (!isNull _hq) then
{
_hq sideradio "SentGenLeavingAO";
}
else
{
player groupChat localize "STR_A3_mdl_supp_zonerest_leaving";
};
};

_warningTime = time + _warningTimeLimit;
};

_maxSpeed = (vehicle player) getVariable "#maxspeed";

if (isNil{_maxSpeed}) then
{
_maxSpeed = getnumber (configfile >> "cfgvehicles" >> typeof (vehicle player) >> "maxspeed") ^ _warningAreaWidth;
(vehicle player) setVariable ["#maxspeed",_maxSpeed];
};

if (_in < -_maxSpeed && time > _neutralizeTime) then
{
_executionValue = call _executionExpression;

if !(!isNil{_executionValue} && {_executionValue isEqualTo true}) then
{
player call bis_fnc_neutralizeUnit;
};

_neutralizeTime = time + _neutralizeTimeLimit;
};
};
};
_lastAliveState = alive player;

sleep 0.1;
};
};
};
};
