#line 0 "/temp/bin/A3/Functions_F/GUI/fn_overviewMission.sqf"




disableserialization;

private ["_display","_idcHTML","_config","_ctrlHTML","_ctrlBackground","_ctrlPicture","_ctrlStructuredText","_ctrlStatistics","_overview","_picture"];
_display = _this param [0,displaynull,[displaynull]];
_config = _this param [1,configfile,[configfile]];
_idcHTML = _this param [2,0,[0]];


_ctrlHTML = _display displayCtrl _idcHTML;
if (isnull _ctrlHTML) exitwith {["Control %1 not found",_idcHTML] call bis_fnc_error};

_ctrlBackground = _display displayCtrl 1002;
_ctrlPicture = _display displayCtrl 1200;
_ctrlStructuredText = _display displayCtrl 1100;
_ctrlStatistics = _display displayCtrl 1101;

if (isnil "_config") then {_config = configfile};

if (istext (_config >> "overviewText") || istext (_config >> "overviewPicture")) then {

	
	_picture = getText (_config >> "overviewPicture");
	if (_picture != "") then {
		_ctrlPicture ctrlSetText _picture;
	};

	
	_overview = getText (_config >> "overviewText");
	if (_overview != "") then {	
		_ctrlStructuredText ctrlSetStructuredText parsetext _overview;
	};

	
	if (!isnull _ctrlStatistics) then {
		_statistics = getText (_config >> "statistics");
		if (_statistics != "") then {
			_statistics = _class call compile _statistics;
			if (typename _statistics == typename "") then {_statistics = parsetext _statistics;};
			if (typename _statistics != typename (parsetext "")) then {_statistics = parsetext str _statistics;};
			_ctrlStatistics ctrlSetStructuredText _statistics;
		} else {
			_ctrlStatistics ctrlSetStructuredText (parseText "");
		};
	};

	
	_ctrlStructuredText ctrlshow true; 	_ctrlStructuredText ctrlsetfade 0; 	_ctrlStructuredText ctrlcommit 0;
	_ctrlStatistics ctrlshow true; 	_ctrlStatistics ctrlsetfade 0; 	_ctrlStatistics ctrlcommit 0;
	_ctrlPicture ctrlshow true; 	_ctrlPicture ctrlsetfade 0; 	_ctrlPicture ctrlcommit 0;
	_ctrlBackground ctrlshow true; 	_ctrlBackground ctrlsetfade 0; 	_ctrlBackground ctrlcommit 0;

	
	
	
	_ctrlHTML ctrlshow false; 	_ctrlHTML ctrlsetfade 1; 	_ctrlHTML ctrlcommit 0;
} else {

	
	
	_ctrlHTML ctrlshow true; 	_ctrlHTML ctrlsetfade 0; 	_ctrlHTML ctrlcommit 0;

	
	_ctrlStructuredText ctrlshow false; 	_ctrlStructuredText ctrlsetfade 1; 	_ctrlStructuredText ctrlcommit 0;
	_ctrlStatistics ctrlshow false; 	_ctrlStatistics ctrlsetfade 1; 	_ctrlStatistics ctrlcommit 0;
	_ctrlPicture ctrlshow false; 	_ctrlPicture ctrlsetfade 1; 	_ctrlPicture ctrlcommit 0;
	_ctrlBackground ctrlshow false; 	_ctrlBackground ctrlsetfade 1; 	_ctrlBackground ctrlcommit 0;
};

