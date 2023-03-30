
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_VRDrawBorder'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_VRDrawBorder';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f_bootcamp\VR\fn_VRDrawBorder.sqf [BIS_fnc_VRDrawBorder]"
#line 1 "A3\functions_f_bootcamp\VR\fn_VRDrawBorder.sqf"














private ["_pos1", "_rds", "_steps", "_radStep", "_pos2", "_wall", "_ret"];
_pos1 = _this param [0,position player,[[]]];
_rds = _this param [1,800,[0]];
_ret = [];

_steps = floor ((2 * pi * _rds) / 40);
_radStep = 360 / _steps;

for [{_i = 0}, {_i < 360}, {_i = _i + _radStep}] do {

for [{_x = 0}, {_x <= 0}, {_x = _x + 100}] do {
_pos2 = [_pos1, _rds, _i] call BIS_fnc_relPos;
_pos2 set [2, _x];
_wall = "VR_Billboard_01_F" createVehicle _pos2;
_wall setPos _pos2;
_wall setDir _i;
_ret = _ret + [_wall];
};
};



_ret
