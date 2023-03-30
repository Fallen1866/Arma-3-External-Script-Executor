#line 0 "/temp/bin/A3/Functions_F/Diagnostic/fn_diagMacrosSimpleObject.sqf"












































private _pos	  		= param [0, getPos player vectorAdd [0,15,0], [[],objNull]]; if (_pos isEqualType objNull) then {_p = getPos _pos; deleteVehicle _pos; _pos = _p;}; _pos set [2,0];
private _autolog 		= param [1, false, [true,123]];				
private _filter 		= param [2, [], [[],{}]];
private _posSea	  		= param [3, getPos player vectorAdd [0,15,0], [[],objNull]]; if (_posSea isEqualType objNull) then {_p = getPos _posSea; deleteVehicle _posSea; _posSea = _p;}; _posSea set [2,0];
private _logCurrent		= param [4, false, [true]];
private _fileNameSuffix = param [5, "", [""]]; if (_fileNameSuffix != "") then {_fileNameSuffix = "_" + _fileNameSuffix};

private _verticalOffsetIssues = [];

if (_autolog isEqualType 123 && {!(_autolog in [0,1,2,3])}) exitWith {["[x] Parameter 'autolog' valid values are: %1",[0,1,2,3]] call bis_fnc_error};


_autolog = [0,1,2,3] select _autolog;

private _filename =	switch (_autolog) do
{
	case 1:
	{
		format["A3\macros_CfgVehicles_simpleObject_auto_A3%1.hpp",_fileNameSuffix];
	};
	case 2:
	{
		format["A3\macros_CfgVehicles_simpleObject_auto_A3_%1_%2%3.hpp",worldName,round random 1000,_fileNameSuffix];
	};
	case 3:
	{
		format["A3\macros_CfgVehicles_simpleObject_manual_A3%1.hpp",_fileNameSuffix];
	};
	default
	{
		""
	};
};

private _path = configFile >> "cfgVehicles";

private _pathText = toUpper configName _path;
private _br = if (_autolog > 0) then {toString [10]} else {toString [13,10]};
private _brMacro =  "\" + _br;


private _result = (_path call bis_fnc_returnChildren) apply {configName _x};
private _resultCount = 0;
private _resultText = "";


if (_filter isEqualType []) then
{
	if (count _filter > 0) then
	{
		{
			private _class = _x;
			if ({_class == _x} count _result == 0) then {_filter set [_forEachIndex,""]};
		}
		forEach (_filter arrayIntersect _filter); 

		_result = _filter - [""];
	};
}
else
{
	_result = _result select _filter;
};


_result = _result call BIS_fnc_sortAlphabetically;
_resultCount = count _result;


if (_autolog > 0) then
{
_resultText =
"/*
	Automatic export of simpleObject values

	Execute following code to pring the output:
	0 = [] spawn bis_fnc_diagMacrosSimpleObject;

	Function automatically copies result to clipboard. It is also stored in a global variable bis_fnc_diagMacrosSimpleObject_resultText and saved to A3 folder via Julien's extension.
	Simply select all defines (Ctrl + Shift + End from the first item) and paste the new result.

	macros_CfgVehicles_simpleObject_manual_A3.hpp document contains manual replacements of certain defines
*/
////END-OF-HEADER MARK, FOR AUTOMATIC GENERATOR////
";


"bi_Logger" callExtension format["%1<<trunc<<%2",_filename,_resultText];
};

{
	private ["_animateText","_hideText"];

	hintSilent format ["Progress: %1%2",floor(_forEachIndex / (_resultCount max 1) * 1000)/10,"%"];

	private _class = _x;

	
	private _objects = ((allMissionObjects "all") + (allSimpleObjects []) - [player]);
	if (count _objects > 0) then {{deleteVehicle _x} forEach _objects;waitUntil{sleep 0.1;{!isNull _x} count _objects == 0};_objects = [];};

	





	private _animate = [];	
	private _hide = [];		
	private _verticalOffsetAsl = 0;
	private _verticalOffsetWorld = 0;
	private _scope = getNumber(configfile >> "CfgVehicles" >> _class >> "scope");

	if (_scope > 0) then
	{
		private _model = toLower getText(configfile >> "CfgVehicles" >> _class >> "model");

		if (_model in ["","\a3\weapons_f\empty.p3d","\a3\weapons_f\dummyweapon.p3d","\a3\weapons_f\dummyweapon_single.p3d","\a3\weapons_f\dummylauncher_single.p3d","\a3\weapons_f\dummypistol_single.p3d"] || {{_class isKindOf _x} count ["man","moduleempty_f","thingeffect","logic","reammobox","lasertarget","nvtarget","artillerytarget","firesectortarget","rope","windanomaly","object","placed_chemlight_green","nvg_targetbase","placed_b_ir_grenade","sound","parachutebase"] > 0}) exitWith {};

		if (_logCurrent) then {["[ ] Processing class: %1",_class] call bis_fnc_logFormat;};

		private _position = [_pos,_posSea] select (_class isKindOf "ship");

		private _object = createVehicle [_class, _position, [], 0, "NONE"];

		
		if ({_class isKindOf _x} count ["air","ship","tank","car","staticweapon"] == 0) then
        {
            _object enableSimulation false;
        };

		private _heightWorldDisabled = getPosWorld _object select 2;
		private _heightATLDisabled = getPosATL _object select 2;

		private _data 			= [_object,true] call BIS_fnc_simpleObjectData;
		_animate 				= _data select 4;	
		_hide 					= _data select 5;	

		if ({_class isKindOf _x} count ["air","ship","tank","car","staticweapon"] > 0) then
		{
			private _verticalOffsetAsl_start = _data select 3;
			private _verticalOffsetWorld_start = round((1/ 0.001)*((getPosWorld _object select 2) - _heightWorldDisabled))* 0.001;

			private _heightASL_collection = [];
			private _heightATL_collection = [];
			private _heightWorld_collection = [];

			for "_i" from 1 to 25 do
			{
				_heightASL_collection pushBack (getPosASL _object select 2);
				_heightATL_collection pushBack (getPosATL _object select 2);
				_heightWorld_collection pushBack (getPosWorld _object select 2);

				sleep 0.05;
			};

			
			private _heightASL_avg = 0; {_heightASL_avg = _heightASL_avg + _x} forEach _heightASL_collection; _heightASL_avg = _heightASL_avg / 25;
			private _heightATL_avg = 0; {_heightATL_avg = _heightATL_avg + _x} forEach _heightATL_collection; _heightATL_avg = _heightATL_avg / 25;
			private _heightWorld_avg = 0; {_heightWorld_avg = _heightWorld_avg + _x} forEach _heightWorld_collection; _heightWorld_avg = _heightWorld_avg / 25;

			
			private _verticalOffsetAsl_min = +_heightASL_collection;
			_verticalOffsetAsl_min sort true;
			_verticalOffsetAsl_min = round((1/ 0.001)*((_verticalOffsetAsl_min param [0,0]) - _heightASL_avg))* 0.001;
			private _verticalOffsetAsl_max = +_heightASL_collection;
			_verticalOffsetAsl_max sort false;
			_verticalOffsetAsl_max = round((1/ 0.001)*((_verticalOffsetAsl_max param [0,0]) - _heightASL_avg))* 0.001;
			private _verticalOffsetWorld_min = +_heightWorld_collection;
			_verticalOffsetWorld_min sort true;
			_verticalOffsetWorld_min = round((1/ 0.001)*((_verticalOffsetWorld_min param [0,0]) - _heightWorld_avg))* 0.001;
			private _verticalOffsetWorld_max = +_heightWorld_collection;
			_verticalOffsetWorld_max sort false;
			_verticalOffsetWorld_max = round((1/ 0.001)*((_verticalOffsetWorld_max param [0,0]) - _heightWorld_avg))* 0.001;

			
			if (_object isKindOf "ship") then
			{
				_verticalOffsetAsl = round((1/ 0.001)*(_heightWorld_avg - _heightASL_avg))* 0.001;
				_verticalOffsetWorld = round((1/ 0.001)*(_heightWorld_avg - _heightWorldDisabled))* 0.001;
			}
			else
			{
				_verticalOffsetAsl = round((1/ 0.001)*(_heightWorld_avg - _heightASL_avg + _heightATL_avg))* 0.001;
				_verticalOffsetWorld = round((1/ 0.001)*(_heightWorld_avg - _heightWorldDisabled + _heightATLDisabled))* 0.001;
			};

			private _verticalOffsetAsl_delta = [abs(_verticalOffsetAsl_start - _verticalOffsetAsl),abs _verticalOffsetAsl_min,abs _verticalOffsetAsl_max];
			_verticalOffsetAsl_delta sort false;
			_verticalOffsetAsl_delta = _verticalOffsetAsl_delta param [0,0];

			private _verticalOffsetWorld_delta = [abs(_verticalOffsetWorld_start - _verticalOffsetWorld),abs _verticalOffsetWorld_min,abs _verticalOffsetWorld_max];
			_verticalOffsetWorld_delta sort false;
			_verticalOffsetWorld_delta = _verticalOffsetWorld_delta param [0,0];

			if (_verticalOffsetAsl_delta > 0.02) then {_verticalOffsetIssues pushBack format ["[!][Asl][%1] error: %6| min-max: [%4,%5] | avg: %2 | start: %3",_class,_verticalOffsetAsl,_verticalOffsetAsl_start,_verticalOffsetAsl_min,_verticalOffsetAsl_max,abs(_verticalOffsetAsl-_verticalOffsetAsl_start)]};
			if (_verticalOffsetWorld_delta > 0.02) then {_verticalOffsetIssues pushBack format ["[!][Wrd][%1] error: %6| min-max: [%4,%5] | avg: %2 | start: %3",_class,_verticalOffsetWorld,_verticalOffsetWorld_start,_verticalOffsetWorld_min,_verticalOffsetWorld_max,abs(_verticalOffsetWorld-_verticalOffsetWorld_start)]};
		}
		else
		{
			_verticalOffsetAsl = _data select 3;
			_verticalOffsetWorld = round((1/ 0.001)*((getPosWorld _object select 2) - _heightWorldDisabled))* 0.001;
		};

		private _initAnims 		= _data select 8;
		private _initTexs 		= _data select 9;

		
		if (abs _verticalOffsetAsl < 0.002) then {_verticalOffsetAsl = 0};

		private _timeMax = time + 10;

		
		_object setPos [100,100,0];

		waitUntil
		{
			deleteVehicle _object;
			sleep 0.05;

			isNull _object || {time > _timeMax}
		};

		if (!isNull _object) then {["[x] Object %1 classname %2 wasn't deleted!",_object,_class] call bis_fnc_logFormat;};

		private _simulation = toLower getText(configfile >> "CfgVehicles" >> _class >> "simulation");
		private _eden = if (_scope == 2 && {_simulation in ["airplanex","car","carx","helicopterrtd","shipx","submarinex","tankx","thing","thingx"]}) then {1} else {0};

		




		
		private _animateCount = count _animate;

		
		if (_animateCount > 0) then
		{
			
			_animateText = "		animate[] =" + _brMacro + "		{" + _brMacro;

			
			{
				if (count _x == 2) then
				{
					
					_animateText = _animateText + format ["			{""%1"", %2}", (_x select 0), (_x select 1)];

					
					if (_forEachIndex < (_animateCount - 1)) then
					{
						_animateText = _animateText + ",";
					};

					
					_animateText = _animateText + _brMacro;
				}
				
				else
				{
					["[x] Animate array for class %1 contains a non-pair element. Element excluded from output.", _class] call bis_fnc_error;
				};
			}
			forEach _animate;

			
			_animateText = _animateText + "		};" + _brMacro;
		}
		
		else
		{
			_animateText = "		animate[] = {};" + _brMacro;
		};

		




		
		private _hideCount = count _hide;

		
		if (_hideCount > 0) then
		{
			
			_hideText = "		hide[] =" + _brMacro + "		{" + _brMacro;

			
			{
				
				_hideText = _hideText + format ["			""%1""", _x];

				
				if (_forEachIndex < (_hideCount - 1)) then
				{
					_hideText = _hideText + ",";
				};

				
				_hideText = _hideText + _brMacro;
			}
			forEach _hide;

			
			_hideText = _hideText + "		};" + _brMacro;
		}
		
		else
		{
			_hideText = "		hide[] = {};" + _brMacro;
		};

		
		if (_eden == 0 && {_verticalOffsetAsl == 0 && {_verticalOffsetWorld == 0 && {_animateCount == 0 &&  {_hideCount == 0}}}}) exitWith {};


		





		
		_verticalOffsetAsl 		= format ["		verticalOffset = %1;\", _verticalOffsetAsl] + _br;
		_verticalOffsetWorld 	= format ["		verticalOffsetWorld = %1;\", _verticalOffsetWorld] + _br;
		_eden 					= format ["		eden = %1;\", _eden] + _br;

		private _init = if ((_initAnims || _initTexs) && (_class isKindOf "AllVehicles")) then
		{
			"		postinit = [this, '', []] call bis_fnc_initVehicle;\" + _br;
		}
		else
		{
			"		init = '';\" + _br;
		};

		private _singleEntry =
			"#define " + _pathText + "_SIMPLEOBJECT_" + _x + _brMacro +
			"	class SimpleObject" + _brMacro +
			"	{" + _brMacro +
					_eden +
					_animateText +
					_hideText +
					_verticalOffsetAsl +
					_verticalOffsetWorld +
					_init +
			"	};" + _br +
			_br;

		
		if (_autolog > 0) then
		{
			"bi_Logger" callExtension format["%1<<app<<%2",_filename,_singleEntry];
		};

		




		
		_resultText = _resultText + _singleEntry;
	};
}
forEach _result;


bis_fnc_diagMacrosSimpleObject_resultText = _resultText;
bis_fnc_diagMacrosSimpleObject_verticalOffsetIssues = _verticalOffsetIssues;

copyToClipboard _resultText;
hint "Finished diagMacrosSimpleObject";

["[!] Script 'diagMacrosSimpleObject' completed!"] call bis_fnc_logFormat;

if (count _verticalOffsetIssues > 0) then
{
	["[!] Following issues in vertical offsets (World or ASL) detected:"] call bis_fnc_logFormat;
	["[!] -------------------------------------------------------------"] call bis_fnc_logFormat;

	{["%1",_x] call bis_fnc_logFormat} forEach _verticalOffsetIssues;
};

_resultText
