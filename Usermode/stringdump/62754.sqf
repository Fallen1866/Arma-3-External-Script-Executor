{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_decodeFlags2'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_decodeFlags2';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f\Misc\fn_decodeFlags2.sqf [BIS_fnc_decodeFlags2]"
#line 0 "/temp/bin/A3/Functions_F/Misc/fn_decodeFlags2.sqf"














params
[
	["_value",0,[123]],
	["_size",-1,[123]]
];

if (_value < 0 || _value > 16777215 || {_value % 1 > 0}) exitWith
{
	["[x] Input parameter must be a single non-decimal number between 0 and 16777215!"] call bis_fnc_error;
	[]
};

private _flags = [];
private _found = false;

{
	if (_value >= _x) then
	{
		_found = true;

		_flags pushBack 1;
		_value = _value - _x;
	}
	else
	{
		if (_found) then
		{
			_flags pushBack 0;
		};
	};
}
forEach ([8388608,4194304,2097152,1048576,524288,262144,131072,65536,32768,16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1] select {_x <= _value});

reverse _flags;

if (_size != -1) then
{
	private _flagCount = count _flags;
	_flags resize _size;

	if (_size > _flagCount) then {_flags = _flags apply {if (isNil{_x}) then {0} else {_x}};};
};

_flags}
