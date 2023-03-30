
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_modulePoster'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_modulePoster';
	scriptName _fnc_scriptName;

#line 1 "A3\Modules_F_EPB\Misc\functions\fn_modulePoster.sqf [BIS_fnc_modulePoster]"
#line 1 "A3\Modules_F_EPB\Misc\functions\fn_modulePoster.sqf"
private ["_logic","_radius","_rotationLimit","_objList","_posterObjList","_posterList","_class","_pathPoster","_countPoster","_pathWindow","_countWindow","_getMemoryPointPos","_obj","_memoryList",
"_i","_memoryPos","_memoryDir","_memoryPosPos","_memoryDirPos","_posterClass","_poster","_dir","_rotation","_classPath","_classCount","_j","_item","_size","_smallPosters","_bigPosters","_allPosters",
"_size","_hitpoint","_posterArray","_allPosterArray","_smallPosterArray","_itemPos","_limitDist","_stored","_posterCreator","_prob","_noSizeValueArray","_itemConfig"];

_logic = _this param [0, objNull, [objNull]];
_radius = _logic getVariable ["Radius",5];
_rotationLimit = _logic getVariable ["Rotation",10];
_prob = _logic getVariable ["Probability",0.5];
_objList = (getPos _logic) nearObjects ["House_F",_radius];
_posterObjList = [];
_posterList = [];
_limitDist = 1;


_classPath = configFile >> "CfgVehicles";
_classCount = count _classPath;

for "_j" from 0 to (_classCount - 1) do {
_item = _classPath select _j;
if (isClass _item) then {
_itemConfig = configName _item;
if ((_itemConfig isKindOf "Leaflet_base_F") && (_itemConfig != "Leaflet_base_F" && _itemConfig != "Poster_base_F")) then {
_posterList = _posterList + [_item]
} else {
if ((_itemConfig isKindOf "Graffiti_base_F") && (_itemConfig != "Graffiti_base_F")) then {
_posterList = _posterList + [_item]
};
};
};
};


_smallPosters = [];
_bigPosters = [];
_noSizeValueArray = [];

{
_size = getNumber (_x >> "posterSize");
switch (_size) do {
case 1: {_smallPosters = _smallPosters + [configName _x]};
case 2: {_bigPosters = _bigPosters + [configName _x]};
default {_noSizeValueArray = _noSizeValueArray + [configName _x]};
};
} forEach _posterList;

_allPosters = _smallPosters + _bigPosters;


{
_class = typeOf _x;
_pathPoster = configFile >> "CfgVehicles" >> _class >> "numberOfPosters";
_countPoster = getNumber _pathPoster;
_pathWindow = configFile >> "CfgVehicles" >> _class >> "numberOfWindows";
_countWindow = getNumber _pathWindow;


if (_countPoster > 0) then {_posterObjList = _posterObjList + [[_x,_countPoster,_countWindow]]};
} forEach _objList;


if ((count _posterObjList) == 0) exitWith {("POSTER MODULE WARNING: No suitable objects found in given area! Module position: " +  str (getPos _logic)) call BIS_fnc_log};

if ((count _allPosters) == 0) exitWith {"POSTER MODULE WARNING: No posters found in config!" call BIS_fnc_log};


_posterCreator = {
_posters = _this select 0;
_array = _this select 1;
_obj = _this select 2;
_createdPosters = [];

{
_memoryPosPos = _x select 2;
_memoryDirPos = _x select 3;
_rotation = _x select 4;

_posterClass = _posters call BIS_fnc_selectRandom;
_poster = _posterClass createVehicle [0,0,0];
_poster setPos _memoryPosPos;

_dir = [_poster, _memoryDirPos] call BIS_fnc_relativeDirTo;
_poster setDir (_dir + 180);
[_poster,0,_rotation] call BIS_fnc_setPitchBank;

_createdPosters = _createdPosters + [_poster];
} forEach _array;
_obj setVariable ["postersArray",_createdPosters];
};


{
_obj = _x select 0;
_countPoster = _x select 1;
_countWindow = _x select 2;

if (_countPoster != 0) then {
_memoryList = [];
_i = 0;


while {_i < _countWindow} do {
_i = _i + 1;
_hitpoint = "Glass_" + (str _i) + "_hitpoint";
_obj setHitPointDamage [_hitpoint,1];
};
_obj allowDamage false;
_i = 0;


_posterArray = [];		
while {_i < _countPoster} do {
_i = _i + 1;
if ((random 1) < _prob) then {
_memoryPos = "Poster_" + (str _i) + "_pos";
_memoryDir = "Poster_" + (str _i) + "_dir";
_memoryPosPos = _obj modelToWorld (_obj selectionPosition _memoryPos);
_memoryDirPos = _obj modelToWorld (_obj selectionPosition _memoryDir);
_rotation = (0 - _rotationLimit) + (random (2 * _rotationLimit));

_posterArray = _posterArray + [[_memoryPos,_memoryDir,_memoryPosPos,_memoryDirPos,_rotation]];
};
};


_allPosterArray = [];
_smallPosterArray = [];
{
_item = _x;
_itemPos = _x select 2;
_stored = false;
_testArray = _posterArray - [_x];
{
if ((!_stored) && ((_itemPos distance (_x select 2)) < _limitDist)) then {
_smallPosterArray = _smallPosterArray + [_item];
_stored = true;
};
} forEach _testArray;
if (!_stored) then {
_allPosterArray = _allPosterArray + [_item];
};
} forEach _posterArray;


if ((count _smallPosterArray) != 0) then {[_smallPosters,_smallPosterArray,_obj] call _posterCreator};
if ((count _allPosterArray) != 0) then {[_bigPosters,_allPosterArray,_obj] call _posterCreator};
};
} forEach _posterObjList;
