#line 0 "/temp/bin/A3/Functions_F/Debug/fn_errorParamsType.sqf"














































private _fnc_getTypeName = 
{
	if (isNil {_this select 0}) then {"ANY"} else {typeName (_this select 0)};
};

try 
{
	if !(params [["_actual",nil],["_method","",[""]],["_expected",nil]]) then 
	{
		throw ["%1: Invalid Input", "BIS_fnc_errorParamsType"];
	};

	if (_method == "isEqualType") then 
	{
		if !(_actual isEqualType _expected) then 
		{
			throw ["Error: type %1, expected %2, in %3", [_actual] call _fnc_getTypeName, [_expected] call _fnc_getTypeName, str _actual];
		};
	};

	if (_method == "isEqualTypeArray") then 
	{
		private _actualCount = count _actual;
		private _expectedCount = count _expected;
		
		if (_actualCount != _expectedCount) then 
		{
			throw ["Error: size %1, expected %2, in %3", _actualCount, _expectedCount, str _actual];
		};
		
		{
			private _par = _actual select _forEachIndex;
			
			if !(isNil "_x" && isNil "_par") then 
			{
				if !(!isNil "_x" && !isNil "_par" && {_par isEqualType _x}) then 
				{
					throw ["Error: type %1, expected %2, on index %3, in %4", [_par] call _fnc_getTypeName, [_x] call _fnc_getTypeName, _forEachIndex, str _actual];
				};
			};
		} 
		forEach _expected;
	};
	
	if (_method == "isEqualTypeAll") then 
	{
		if (_actual isEqualTo []) then 
		{
			throw ["Error: size %1, expected %2, in %3", 0, 1, str _actual];
		};
		
		{
			if !(!isNil "_x" && {_x isEqualType _expected}) then 
			{
				throw ["Error: type %1, expected %2, on index %3, in %4", [_x] call _fnc_getTypeName, [_expected] call _fnc_getTypeName, _forEachIndex, str _actual];
			};
		} 
		forEach _actual;
	};
	
	if (_method == "isEqualTypeAny") then 
	{	
		_expected = _expected arrayIntersect _expected;
		
		{
			_expected set [_forEachIndex, [_x] call _fnc_getTypeName];
		} 
		forEach _expected;
		
		private _actualTypeName = [_actual] call _fnc_getTypeName;
		
		if !(_expected isEqualTo [] || _actualTypeName in _expected) then 
		{
			throw ["Error: type %1, expected %2, in %3", _actualTypeName, _expected joinString ", ", str _actual];
		};
	};
	
	if (_method == "isEqualTypeParams") then 
	{
		if !(_actual isEqualType []) then 
		{
			throw ["Error: type %1, expected %2, in %3", [_actual] call _fnc_getTypeName, typeName [], str _actual];
		};
		
		private _actualCount = count _actual;
		private _expectedCount = count _expected;
		
		if (_actualCount < _expectedCount) then 
		{
			throw ["Error: size %1, expected %2, in %3", _actualCount, _expectedCount, str _actual];
		};
		
		{
			private _par = _actual select _forEachIndex;
			
			if (!isNil "_x") then 
			{
				if !(!isNil "_par" && {_par isEqualType _x}) then 
				{
					throw ["Error: type %1, expected %2, on index %3, in %4", [if (isNil "_par") then { nil } else { _par }] call _fnc_getTypeName, [_x] call _fnc_getTypeName, _forEachIndex, str _actual];
				};
			};
		} 
		forEach _expected;
	};
	
	throw ["%1: Unknown Validation Method", "BIS_fnc_errorParamsType"];
} 
catch 
{
	_exception call BIS_fnc_error;
	
	nil
};
