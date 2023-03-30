{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_exportMapToBiTXT'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_exportMapToBiTXT';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f\Map\fn_exportMapToBiTXT.sqf [BIS_fnc_exportMapToBiTXT]"
#line 0 "/temp/bin/A3/Functions_F/Map/fn_exportMapToBiTXT.sqf"
















startloadingscreen [""];

_resolution = _this param [0,64,[0]];
_resolution1 = _resolution - 1;
_resolutionN = _resolution ^ 2;

_modelSize = _this param [1,10,[0]];
_modelSize = _modelSize * 1000; 

_vCoef = _this param [2,2,[0]];

_fnc_addLine = {_text = _text + _this + _br;};
_fnc_addDecimal = {if (parsenumber str _this % 1 == 0) then {format ["%1.0",_this]} else {_this}};

_mapSize = [] call bis_fnc_mapSize;
if (_mapSize < 0) exitwith {endloadingscreen; ["mapSize attribute is missing for %1",worldname] call bis_fnc_error; ""};
_step = _mapSize / _resolution1;
_hCoef = _modelSize / _mapSize;
_hOffset = _modelSize * 0.5;
_posXY = _hOffset call _fnc_addDecimal;
_posZmax = 0;
_texture = gettext (configfile >> "CfgWorlds" >> worldname >> "pictureMap");
_textureArray = toarray _texture;
if (count _textureArray > 0) then {
	
	_textureSymbol = _textureArray select 0;
	if (_textureSymbol in toarray "\") then {
		reverse _textureArray;
		_textureArray resize (count _textureArray - 1);
		reverse _textureArray;
		_texture = tostring _textureArray;
	};
} else {
	_texture = "#(argb,8,8,3)color(0.5,0.5,0.5,1)";
};

_br = tostring [13,10];
_text = "";



":header" call _fnc_addLine;
"version 1.0" call _fnc_addLine;
"sharp sg" call _fnc_addLine;
"" call _fnc_addLine;



":lod 0.0" call _fnc_addLine;
":object" call _fnc_addLine;
":points" call _fnc_addLine;


for "_y" from _resolution1 to 0 step -1 do {
	for "_x" from 0 to _resolution1 do {
		_posX = _x * _step;
		_posY = _y * _step;
		_posZ = getterrainheightasl [_posX,_posY];

		_posX = (_posX * _hCoef) - _hOffset;
		_posY = (_posY * _hCoef) - _hOffset;
		_posZ = (_posZ * _hCoef * _vCoef) max 0;
		_posZmax = _posZmax max _posZ;

		_posX = _posX call _fnc_addDecimal;
		_posY = _posY call _fnc_addDecimal;
		_posZ = _posZ call _fnc_addDecimal;

		format ["%1 %2 %3",_posX,_posY,_posZ] call _fnc_addLine;
	};
	progressloadingscreen (0.5 * (1 - (_y / _resolution)));
};
format ["-%1 -%1 1.0",_posXY] call _fnc_addLine;
format ["%1 -%1 1.0",_posXY] call _fnc_addLine;
format ["-%1 %1 1.0",_posXY] call _fnc_addLine;
format ["%1 %1 1.0",_posXY] call _fnc_addLine;



"" call _fnc_addLine;
for "_y" from 0 to (_resolution - 2) do {
	for "_x" from 0 to (_resolution - 2) do {
		_pointBR = (_y * _resolution) + _x + 1;
		_pointBL = _pointBR + 1;
		_pointTL = _pointBR + _resolution;
		_pointTR = _pointBL + _resolution;

		_uv1 = _x * (1 / _resolution1);
		_uv2 = 1 - (_y + 1) * (1 / _resolution1);
		_uv3 = (_x + 1) * (1 / _resolution1);
		_uv4 = _uv2;
		_uv5 = _uv3;
		_uv6 = 1 - _y * (1 / _resolution1);
		_uv7 = _uv1;
		_uv8 = _uv6;

		_uv1 = _uv1 call _fnc_addDecimal;
		_uv2 = _uv2 call _fnc_addDecimal;
		_uv3 = _uv3 call _fnc_addDecimal;
		_uv4 = _uv4 call _fnc_addDecimal;
		_uv5 = _uv5 call _fnc_addDecimal;
		_uv6 = _uv6 call _fnc_addDecimal;
		_uv7 = _uv7 call _fnc_addDecimal;
		_uv8 = _uv8 call _fnc_addDecimal;

		":face" call _fnc_addLine;
		format ["index %1 %2 %3 %4",_pointTL,_pointTR,_pointBL,_pointBR] call _fnc_addLine;
		format ["uv %1 %2 %3 %4 %5 %6 %7 %8",_uv1,_uv2,_uv3,_uv4,_uv5,_uv6,_uv7,_uv8] call _fnc_addLine;
		format ["texture ""%1""",_texture] call _fnc_addLine;
		"sg 1" call _fnc_addLine;
	};
	progressloadingscreen (0.5 + 0.5 * (_y / _resolution));
};

":face" call _fnc_addLine;
format ["index %1 %2 %3 %4",_resolutionN + 1,_resolutionN + 2,_resolutionN + 4,_resolutionN + 3] call _fnc_addLine;
"uv 0.0 1.0 1.0 1.0 1.0 0.0 0.0 0.0" call _fnc_addLine;
"texture ""a3\Ui_f\data\Map\grid_ca.paa""" call _fnc_addLine;
"sg 1" call _fnc_addLine;


"" call _fnc_addLine;
":selection ""Map""" call _fnc_addLine;
for "_i" from 1 to _resolutionN do {format ["%1 1.0",_i] call _fnc_addLine;};
":selection ""Grid""" call _fnc_addLine;
for "_i" from (_resolutionN + 1) to (_resolutionN + 4) do {format ["%1 1.0",_i] call _fnc_addLine;};



"" call _fnc_addLine;
"" call _fnc_addLine;
":lod 1e+013" call _fnc_addLine;
":object" call _fnc_addLine;
":points" call _fnc_addLine;


for "_y" from 1 to 0 step -1 do {
	_posZ = (_posZmax * _y) call _fnc_addDecimal;
	format ["-%1 -%1 %2",_posXY,_posZ] call _fnc_addLine;
	format ["%1 -%1 %2",_posXY,_posZ] call _fnc_addLine;
	format ["-%1 %1 %2",_posXY,_posZ] call _fnc_addLine;
	format ["%1 %1 %2",_posXY,_posZ] call _fnc_addLine;
};


"" call _fnc_addLine;
{
	":face" call _fnc_addLine;
	format ["index %1",_x select 0] call _fnc_addLine;
	format ["uv %1",_x select 1] call _fnc_addLine;
	"sg 1" call _fnc_addLine;
} foreach [
	["1 2 4 3","0.0 1.0 1.0 1.0 1.0 0.0 0.0 0.0"],
	["7 8 6 5","0.0 0.0 1.0 0.0 1.0 1.0 0.0 1.0"],
	["5 6 2 1","0.0 -1.0 1.0 -1.0 1.0 0.0 0.0 0.0"],
	["6 8 4 2","0.0 -1.0 1.0 -1.0 1.0 0.0 0.0 0.0"],
	["8 7 3 4","0.0 -1.0 1.0 -1.0 1.0 0.0 0.0 0.0"],
	["7 5 1 3","0.0 -1.0 1.0 -1.0 1.0 0.0 0.0 0.0"]
];


"" call _fnc_addLine;
":selection ""Component01""" call _fnc_addLine;
for "_i" from 1 to 8 do {format ["%1 1.0",_i] call _fnc_addLine;};



"" call _fnc_addLine;
":lod 1e+015" call _fnc_addLine;
":object" call _fnc_addLine;
":points" call _fnc_addLine;


_cfgNames = "isclass _x" configclasses (configfile >> "cfgworlds" >> worldname >> "names");
{
	_pos = getarray (_x >> "position");
	_posX = _pos select 0;
	_posY = _pos select 1;
	_posZ = getterrainheightasl [_posX,_posY];

	_posX = (_posX * _hCoef) - _hOffset;
	_posY = (_posY * _hCoef) - _hOffset;
	_posZ = (_posZ * _hCoef * _vCoef) max 0;
	_posZmax = _posZmax max _posZ;

	_posX = _posX call _fnc_addDecimal;
	_posY = _posY call _fnc_addDecimal;
	_posZ = _posZ call _fnc_addDecimal;

	format ["%1 %2 %3",_posX,_posY,_posZ] call _fnc_addLine;
} foreach _cfgNames;


"" call _fnc_addLine;
{
	format [":selection ""%1""",configname _x] call _fnc_addLine;
	format ["%1 1.0",_foreachindex + 1] call _fnc_addLine;
} foreach _cfgNames;



"" call _fnc_addLine;
"" call _fnc_addLine;
"" call _fnc_addLine;
":end" call _fnc_addLine;
endloadingscreen;

copytoclipboard _text;
_text}
