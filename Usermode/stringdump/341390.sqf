#line 0 "/temp/bin/A3/Functions_F/Strategic/fn_ORBATSetGroupParams.sqf"

























private ["_group","_groupArray","_groupID","_types","_type","_value"];
_group = _this param [0,configfile,[configfile]];
_groupArray = [];
_groupArray resize 9;

_remove = if (typename _this == typename []) then {count _this <= 1} else {true};
if (_remove) then {
	
	_groupID = BIS_fnc_ORBATsetGroupParams_groups find _group;
	if (_groupID >= 0) then {
		BIS_fnc_ORBATsetGroupParams_groups set [_groupID,-1];
		BIS_fnc_ORBATsetGroupParams_groups set [_groupID + 1,-1];
		BIS_fnc_ORBATsetGroupParams_groups = BIS_fnc_ORBATsetGroupParams_groups - [-1];
		true
	} else {
		false
	};
} else {
	
	_typesArray = [
		["",00], 
		[""], 
		[""], 
		[""], 
		[""], 
		[""], 
		[""], 
		[00], 
		[""], 
		[[]], 
		[""], 
		[""], 
		[""], 
		[[]] 
	];


	for "_t" from 0 to (count _typesArray - 1) do {
		_types = _typesArray select _t;
		_value = _this param [_t + 1,objnull,_types + [objnull]];
		if ({typename _value == typename _x} count _types > 0) then {
			_groupArray set [_t,_value];
		};
	};

	if (isnil "BIS_fnc_ORBATsetGroupParams_groups") then {BIS_fnc_ORBATsetGroupParams_groups = [];};
	_groupID = BIS_fnc_ORBATsetGroupParams_groups find _group;
	if (_groupID < 0) then {_groupID = count BIS_fnc_ORBATsetGroupParams_groups};

	
	BIS_fnc_ORBATsetGroupParams_groups set [_groupID,_group];
	BIS_fnc_ORBATsetGroupParams_groups set [_groupID + 1,_groupArray];
	true
};
