#line 0 "/temp/bin/A3/Functions_F/Configs/fn_uniqueClasses.sqf"

















private ["_cfg","_code","_allClasses","_allChildren","_allValues","_result"];
_cfg = _this param [0,configfile,[configfile]];
_code = _this param [1,{},[{}]];


_allClasses = [];
_allChildren = [];
_allValues = [];
{
	_allClasses set [count _allClasses,_x];
	_allChildren set [count _allChildren,[]];
	_allValues set [count _allValues,_x call _code];
} foreach (_cfg call bis_fnc_subClasses);


{
	_class = _x;
	_parents = [_class] call bis_fnc_returnparents;
	_parents = _parents - [_class];
	{
		_parentID = _allClasses find _x;
		_parentChildren = _allChildren select _parentID;
		_parentChildren set [count _parentChildren,_class];
	} foreach _parents;
} foreach _allClasses;


_result = [];
{
	_class = _x;
	_classChildren = _allChildren select _foreachindex;
	_classValue = _allValues select _foreachindex;

	if (typename _classValue != typename configfile) then {
		{
			_child = _x;
			_childID = _allClasses find _child;
			_childValue = _allValues select _childID;
			if (typename _childValue != typename configfile) then {
				if (_childValue == _classValue) then {
					_allValues set [_childID,_class];
				};
			};
		} foreach _classChildren;

		_result set [count _result,[_class,_classValue]];
	};
} foreach _allClasses;



_result
