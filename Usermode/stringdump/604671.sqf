
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleCuratorAddPoints'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleCuratorAddPoints';
	scriptName _fnc_scriptName;

#line 1 "a3\modules_f_curator\curator\functions\fn_moduleCuratorAddPoints.sqf [BIS_fnc_moduleCuratorAddPoints]"
#line 1 "a3\modules_f_curator\curator\functions\fn_moduleCuratorAddPoints.sqf"
_logic = _this select 0;
_units = _this select 1;
_activated = _this select 2;

if (_activated) then {

_curatorVar = _logic getvariable ["curator",""];
_curator = missionnamespace getvariable [_curatorVar,objnull];
_curators = if (isnull _curator) then {[]} else {[_curator]};

{
if (_x call bis_fnc_isCurator && !(_x in _curators)) then {_curators set [count _curators,_x];};
} foreach (synchronizedobjects _logic);

if (count _curators == 0) exitwith {["No curator synchronized to %1",_logic] call bis_fnc_error;};

_value = _logic getvariable ["value",0];
_repeat = _logic getvariable ["repeat",0];

if (_repeat > 0) then {

_handle = [_logic,_curators,_value,_repeat] spawn {
_logic = _this select 0;
_curators = _this select 1;
_value = _this select 2;
_repeat = _this select 3;
while {!isnull _logic} do {
_time = time + _repeat;
waituntil {time > _time};
_points = (_value + _value * (time - _time));
{_x addcuratorpoints _points;} foreach _curators;
};
};
_logic setvariable ["handle",_handle];
} else {

{_x addcuratorpoints _value;} foreach _curators;
};
} else {
_handle = _logic getvariable "handle";
if !(isnil "_handle") then {terminate _handle;};
};
