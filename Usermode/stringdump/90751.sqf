#line 0 "/temp/bin/A3/Functions_F/Configs/fn_subClasses.sqf"
#line 1 "//temp/bin/A3/Functions_F/Configs/fn_returnChildren.sqf"
#line 0 "//temp/bin/A3/Functions_F/Configs/fn_returnChildren.sqf"















private ["_class","_depth","_lastOnly","_first","_classnames","_subClass","_subClassName"];
_class = _this param [0,configfile >> "",[configfile]];
_depth = _this param [1,0,[0]];
_lastOnly = _this param [2,true,[true]];
_first = _this param [3,true,[true]];

_private = if (_first) then {["_classes"]} else {[]};
private _private;
if (_first) then {_classes = [];};

if (_depth >= 0) then {
	_classnames = [];
	{
		for "_c" from 0 to (count _x - 1) do {
			_subClass = _x select _c;
			if (isclass _subClass) then {
				_subClassName = tolower configname _subClass;
				if !(_subClassName in _classnames) then {
					if (_depth == 0 || _lastOnly) then {
						_classes set [count _classes,_subClass];
						_classnames set [count _classnames,_subClassName];
					};

					
					[_subClass,_depth - 1,_lastOnly,false] call bis_fnc_returnChildren;
				};
			};
		};
	} foreach (_class call bis_fnc_returnparents);
};
_classes
#line 0 "/temp/bin/A3/Functions_F/Configs/fn_subClasses.sqf"

