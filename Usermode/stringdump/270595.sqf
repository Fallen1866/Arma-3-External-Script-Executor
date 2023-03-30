#line 0 "/temp/bin/A3/Functions_F/Animation/Curve/RichCurve/fn_richCurve_computeCurveArcLength.sqf"
















private _curve	= _this param [0, objNull, [objNull]];
private _forced	= _this param [1, false, [false]];


if (isNull _curve) exitWith
{
	[0.0, [], []];
};


if (!_forced && {time < (_curve getVariable ["_l", -1]) + 1.0}) exitWith
{
	[_curve getVariable ["ArcTotalLength", 0.0], _curve getVariable ["ArcLengths", []], _curve getVariable ["ArcPoints", []]];
};

_curve setVariable ["_l", time];


private _keys = [_curve] call BIS_fnc_richCurve_getKeys;


if (count _keys < 2) exitWith
{
	[0.0, [], []];
};


private _length 	= 0.0;
private _lengths 	= [];
private _points		= [];


for "_i" from 0 to (count _keys - 2) do
{
	private _curKey 	= _keys select _i;
	private _nextKey 	= _keys select (_i + 1);

	if ([_curKey] call BIS_fnc_key_getInterpMode != 1) then
	{
		_length = _length + (_curKey distance _nextKey);
		_lengths pushBack _length;
	}
	else
	{
		private _p0 = [_curKey] call BIS_fnc_key_getValue;
		private _p1	= [_nextKey] call BIS_fnc_key_getValue;
		private _c0	= _p0 vectorAdd ([_curKey] call BIS_fnc_key_getLeaveTangent);
		private _c1	= _p1 vectorAdd ([_nextKey] call BIS_fnc_key_getArriveTangent);

		private _len = [_p0, _c0, _c1, _p1] call BIS_fnc_bezierLength;

		_length = _length + (_len select 0);
		_lengths = _lengths + (_len select 1);
		_points = _points + (_len select 2);
	};
};


[_length, _lengths, _points];
