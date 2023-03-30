{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_encodeFlags8'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_encodeFlags8';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f\Misc\fn_encodeFlags8.sqf [BIS_fnc_encodeFlags8]"
#line 0 "/temp/bin/A3/Functions_F/Misc/fn_encodeFlags8.sqf"


















if (!(_this isEqualType []) || {count _this > 12}) exitWith {_encoded = 0;["[x] Input parameter must be an array of zeroes or ones of max size of 12!"] call bis_fnc_error;_encoded};

private _encoded = 0;
private _mult = 1;

{
	if !(_x in [0,1,2,3,4,5,6,7]) exitWith {_encoded = 0;["[x] Input parameter must be an array of zeroes or ones of max size of 12!"] call bis_fnc_error;_encoded};

	if (_x != 0) then
	{
		_encoded = _encoded + _x * _mult;
	};

	_mult = _mult * 8;
}
forEach _this;

_encoded}
