#line 0 "/temp/bin/A3/Functions_F/Strategic/fn_ORBATSetGroupFade.sqf"














private ["_group","_fade","_commit","_remove","_groupID","_fadeStart","_timeStart","_timeEnd","_fadeValue"];
_group = _this param [0,configfile,[configfile]];
_fade = _this param [1,1,[0]];
_commit = _this param [2,0,[0]];

_remove = if (typename _this == typename []) then {count _this <= 1} else {true};
if (_remove) then {
	
	_groupID = BIS_fnc_ORBATSetGroupFade_groups find _group;
	if (_groupID >= 0) then {
		BIS_fnc_ORBATSetGroupFade_groups set [_groupID,-1];
		BIS_fnc_ORBATSetGroupFade_groups set [_groupID + 1,-1];
		BIS_fnc_ORBATSetGroupFade_groups = BIS_fnc_ORBATSetGroupFade_groups - [-1];
		true
	} else {
		false
	};
} else {
	
	if (isnil "BIS_fnc_ORBATSetGroupFade_groups") then {BIS_fnc_ORBATSetGroupFade_groups = [];};
	_groupID = BIS_fnc_ORBATSetGroupFade_groups find _group;
	_fadeStart = if (_groupID < 0) then {
		_groupID = count BIS_fnc_ORBATSetGroupFade_groups;
		BIS_fnc_ORBATSetGroupFade_groups set [_groupID,_group];
		BIS_fnc_ORBATSetGroupFade_groups set [_groupID + 1,1];
		1
	} else {
		BIS_fnc_ORBATSetGroupFade_groups select (_groupID + 1);
	};
	if (_fadeStart != _fade) then {
		if (_commit > 0) then {
			_timeStart = diag_ticktime;
			_timeEnd = _timeStart + _commit;
			while {diag_ticktime < _timeEnd} do {
				_groupID = BIS_fnc_ORBATSetGroupFade_groups find _group;
				if (_groupID >= 0) then {
					_fadeValue = linearconversion [_timeStart,_timeEnd,diag_ticktime,_fadeStart,_fade,true];
					BIS_fnc_ORBATSetGroupFade_groups set [_groupID,_group];
					BIS_fnc_ORBATSetGroupFade_groups set [_groupID + 1,_fadeValue];
					uisleep 0.05;
				} else {
					_time = 0; 
				};
			};
		};

		
		_groupID = BIS_fnc_ORBATSetGroupFade_groups find _group;
		if (_groupID >= 0) then {
			BIS_fnc_ORBATSetGroupFade_groups set [_groupID,_group];
			BIS_fnc_ORBATSetGroupFade_groups set [_groupID + 1,_fade];
		};
	};

	true
};
