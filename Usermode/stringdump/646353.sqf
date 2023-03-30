#line 0 "/temp/bin/A3/Functions_F/Map/fn_keypointsExportFromKML.sqf"













startloadingscreen ["Loading KML","RscDisplayLoadCustom"];

_file =		_this param [0,"hsim\Doc_H\GoogleEarth\Missions\" + missionname + ".kml",[""]];
_tabCount =	_this param [1,0,[0]];
_exportMode =	_this param [2,0,[0]];



_tabText = tostring [9];
_brText = tostring [13,10];
_add = {
	call _tab;
	_textExport = _textExport + _this;
	call _br;
};
_br = {
	_textExport = _textExport + _brText;
};
_tab = {
	private ["_tabAdd"];
	_tabAdd = "";
	for "_i" from 1 to _tabCount do {_tabAdd = _tabAdd + _tabText;};
	_textExport = _textExport + _tabAdd;
};
_tabAdd = {
	_tabCount = _tabCount + _this;
};
_textExport = "";
call _tab;

_cfgWorld = configfile >> "cfgWorlds" >> worldname;
_parent = configname inheritsfrom _cfgWorld;
_textParent = if (_parent != "") then {": " + _parent} else {""};




_kml = _file call bis_fnc_KMLimport;

if (_exportMode != 2) then {
	if (_exportMode == 0) then {
		"class CfgWorlds" call _add;
		"{" call _add;
		+1 call _tabAdd;
		if (_textParent != "") then {format ["class %1;",_parent] call _add;};
	};
	format ["class %1%2",worldname,_textParent] call _add;
	"{" call _add;
	+1 call _tabAdd;
	"class Names" call _add;
	"{" call _add;
	+1 call _tabAdd;
};


_listCategory = [];
{
	_type = _x select 0;
	_position = _x select 1;
	_classCategory = _x select 2;
	_class = _x select 3;
	_description = _x select 4;

	if (_type == 0) then {

		if !(_classCategory in _listCategory) then {_listCategory = _listCategory + [_classCategory]};

		_direction = 0;
		_positionZ = 0;
		
		_textPosition = "{";
		{
			_textPosition = _textPosition + str _x;
			if (_forEachIndex < count _position - 1) then {_textPosition = _textPosition + ","};
		} foreach _position;
		_textPosition = _textPosition + "};";

		if (_class == "") then {
			_subLogicCounter = [_fnc_scriptName + _folder,1] call bis_fnc_counter;
			_class = format ["%1",_subLogicCounter];
		};

		if (_exportMode != 2) then {
			format ["class %1_%2",_classCategory,_class] call _add;
			"{" call _add;
			+1 call _tabAdd;
			format ["type = ""%1"";",_classCategory] call _add;
			format ["position[] = %1",_textPosition] call _add;
			format ["angle = %1;",_direction] call _add;
			format ["radiusA = %1;",_positionZ] call _add;
			"radiusB = 0;" call _add;
			if (_description != "") then {format ["%1",_description] call _add};
			-1 call _tabAdd;
			"};" call _add;
		};
	};
} foreach _kml;

if (_exportMode != 2) then {
	-1 call _tabAdd;
	"};" call _add;
	-1 call _tabAdd;
	"};" call _add;
	if (_exportMode == 0) then {
		-1 call _tabAdd;
		"};" call _add;
	};
};

if (_exportMode in [0,2]) then {

	"class CfgLocationTypes" call _add;
	"{" call _add;
	+1 call _tabAdd;
	"class Name;" call _add;
	{
		format ["class %1: Name {};",_x] call _add;
	} foreach _listCategory;
	-1 call _tabAdd;
	"};" call _add;
};

copytoclipboard _textExport;
_textExport call bis_fnc_log;

endloadingscreen;

_textExport
