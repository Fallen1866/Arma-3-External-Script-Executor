{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_getArea'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_getArea';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f\Misc\fn_getArea.sqf [BIS_fnc_getArea]"
#line 0 "/temp/bin/A3/Functions_F/Misc/fn_getArea.sqf"




















if (_this isEqualType objNull && {_this isKindOf "EmptyDetector"}) exitWith {[ASLToAGL getPosASL _this] + triggerArea _this};


if (_this isEqualType "" && {markerShape _this in ["ELLIPSE", "RECTANGLE"]}) exitWith {[markerPos _this] + markerSize _this + [markerDir _this, markerShape _this isEqualto "RECTANGLE", -1]};


if (_this isEqualType locationNull) exitWith {[locationPosition _this] + size _this + [direction _this, rectangular _this, -1]};


if (_this isEqualTypeArray [[], 0, 0, 0, false]) exitWith {_this + [-1]};
if (_this isEqualTypeArray [[], 0, 0, 0, false, -1]) exitWith {_this};


private _center = [param [0] call BIS_fnc_position] param [0, [0, 0, 0]];
private _area = param [1, [0, 0, 0, false, -1]];


if (_area isEqualType 0) exitWith {[_center, _area, _area, 0, false, -1]};


if !(_area isEqualType []) exitWith {[[0, 0, 0], 0, 0, 0, false, -1]};
if (_area isEqualTypeArray [0, 0, 0, false, -1]) exitWith {[_center] + _area};
if (_area isEqualTypeArray [0, 0, 0, false]) exitWith {[_center] + _area + [-1]};


[[0, 0, 0], 0, 0, 0, false, -1]}
