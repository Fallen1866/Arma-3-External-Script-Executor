#line 0 "/temp/bin/A3/Functions_F/GUI/fn_liveFeedSetSource.sqf"














if (isDedicated) exitWith {"Not dedicated server compatible" call BIS_fnc_error; false};


if (isNil "BIS_liveFeed") exitWith {"No live feed exists" call BIS_fnc_error; false};

private ["_source"];
_source = _this param [0, objNull, [objNull, []]];


if (typeName _source == typeName objNull) then {
	_source = [_source];
	{if (isNull _x) then {_source = _source - [_x]}} forEach _source;
};

if (count _source == 0 || count _source > 3) exitWith {"Invalid source defined" call BIS_fnc_error; false};


switch (count _source) do {
	
	case 1: {
		_source = _source select 0;
		BIS_liveFeed attachTo [_source, [0, 0, -2]];
	};
	
	
	case 2: {
		BIS_liveFeed attachTo _source;
	};
	
	
	case 3: {
		BIS_liveFeed camPreparePos _source;
		BIS_liveFeed camCommitPrepared 0;
	};
};

true
