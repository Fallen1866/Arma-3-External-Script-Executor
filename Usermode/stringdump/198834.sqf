#line 0 "/temp/bin/A3/Functions_F/Strategic/fn_ORBATAnimate.sqf"
















private ["_target","_zoom","_commit","_display","_map","_scaleMin","_scaleMax","_scale","_targetID","_position"];
disableserialization;
_target = _this param [0,[],[[],configfile]];
_zoom = _this param [1,-1,[0]];
_commit = _this param [2,1,[0]];


_display = finddisplay 505;
if (isnull _display) exitwith {"ORBAT is not open. Do it first by calling 'BIS_fnc_ORBATOpen' function." call (uinamespace getvariable "bis_fnc_error"); false};
_map = _display displayctrl 51;


if (_zoom >= 0) then {
	_scaleMin = getnumber (configfile >> "RscDisplayORBAT" >> "ControlsBackground" >> "Map" >> "scaleMin");
	_scaleMax = getnumber (configfile >> "RscDisplayORBAT" >> "ControlsBackground" >> "Map" >> "scaleMax");
	_scale = linearConversion [0,1,_zoom,_scaleMin,_scaleMax,true];
} else {
	_scale = ctrlmapscale _map;
};


if (typename _target == typename configfile) then {

	
	 _targetID = BIS_fnc_ORBAT_posArray find _target;
	_position = if (_targetID >= 0) then {
		BIS_fnc_ORBAT_posArray select (_targetID + 1);
	} else {
		["Group '%1' not found in ORBAT.",_target] call bis_fnc_error;
		[]
	};
} else {
	_position = if (count _target >= 2) then {
		[
			(BIS_fnc_ORBAT_posStart select 0) + ((_target select 0) call BIS_fnc_parseNumberSafe),
			(BIS_fnc_ORBAT_posStart select 1) + ((_target select 1) call BIS_fnc_parseNumberSafe)
		]
	} else {
		
		_parentParams = BIS_fnc_ORBAT_structure select 1;
		_subclassesCount = _parentParams select 1;
		_scale = ((0.0007 * _subclassesCount)) / BIS_fnc_ORBAT_sizeCoef;
		BIS_fnc_ORBAT_posStart;
	};
};


if (count _position > 0) then {
	_map ctrlmapanimadd [_commit,_scale,_position];
	ctrlmapanimcommit _map;
	waituntil {ctrlmapanimdone _map};
	true
} else {
	false
};
