#line 0 "/temp/bin/A3/Functions_F/Diagnostic/fn_diagObjectPerformance.sqf"


















private _count 	 	= floor param [0, 1024, [123]]; _count = _count max 1;
private _section 	= param [1, [0,-1], [[]]];
private _autolog 	= param [2, true, [true]];
private _path 	 	= param [3, configFile >> "cfgVehicles", [configfile]];
private _diagMemory	= param [4, false, [true]];


player setDir 0;
player allowDamage false;
player enableSimulation false;

private _posPlayer = getPos player;
_posPlayer params ["_posPlayerX","_posPlayerY"];


private _objects = ((allMissionObjects "all") + (allSimpleObjects []) - [player]);
if (count _objects > 0) then {{deleteVehicle _x} forEach _objects;waitUntil{sleep 0.1;{!isNull _x} count _objects == 0};_objects = [];};


private _pathText = toUpper configName _path;


private _classes = [];
{
	_classes pushBack configName _x;
}
forEach (_path call bis_fnc_returnChildren);


_classes = _classes call BIS_fnc_sortAlphabetically;


private _csv = "classname;simulation;cleanscene;simulated;disabled;simple with class;simple without class;";

if (_autolog) then
{
	"bi_Logger" callExtension format["_diagSimpleObjectPerformance.csv<<trunc<<%1",_csv];
};


{
	private _class = _x;
	private _scope = getNumber(configfile >> "CfgVehicles" >> _class >> "scope");

	if (true) then
	{
		if (_scope == 0) exitWith {_classes set [_forEachIndex,""]};

		private _model = getText(configfile >> "CfgVehicles" >> _class >> "model");

		if (_model == "" || {_model == "\a3\weapons_f\empty.p3d"}) exitWith {_classes set [_forEachIndex,""]};

		if ({_class isKindOf _x} count ["man","moduleempty_f","thingeffect","logic","reammobox","lasertarget","nvtarget","artillerytarget","firesectortarget","rope","windanomaly","object","placed_chemlight_green","nvg_targetbase","placed_b_ir_grenade","sound"] > 0) exitWith {_classes set [_forEachIndex,""]};
	};
}
forEach _classes;


_classes = _classes - [""];
private _classesCount = count(_classes) max 1;


private _sectionStart = _section param [0, 0, [123]];
private _sectionLength = _section param [1, _classesCount - _sectionStart, [123]];

if (_sectionStart < 0) then
{
	_sectionStart = 0;
};

if (_sectionLength == -1 || {_sectionLength > _classesCount - _sectionStart}) then
{
	_sectionLength = _classesCount - _sectionStart;
};


_classes = _classes select [_sectionStart, _sectionLength];
_classesCount = _sectionLength;


private _aMax = floor(_count ^ 0.5);
private _bMax = floor (_count / _aMax);
private _aPlayer = ceil (_aMax / 2);
private _bPlayer = ceil (_bMax / 2);








private _fnc_showHint =
{
	params ["_data","_progressTotal",["_progress",0,[123]]];
	private _localData = +_data;


	if (_progress != 0) then
	{
		_localData set [count _localData, format["<t color='#ff9600'>%1%2</t>",_progress,"%"]];
	};

	_localData params [
		"_class",
		"_simulation",
		["_clean","",[123,""]],
		["_simulated","",[123,""]],
		["_disabled","",[123,""]],
		["_simpleWithClass","",[123,""]],
		["_simpleNoClass","",[123,""]]
	];

	
	private _template = "<t font='EtelkaMonospacePro' size='0.7'><t size='0.9'>%1</t><br/><br/><t align='left' color='#919191'>Simulation:</t><t align='right' color='#919191'>%8</t><br/><t color='#919191' align='left'>Progress:</t><t color='#919191' align='right'>%2%12</t><br/><t align='left' color='#919191'>Time spent:</t><t align='right' color='#919191'>%9 hr %10 min %11 secs</t><br/><br/><t align='left' color='#919191'>Clean Scene:</t><t align='right' color='#919191'>%7</t><br/><t align='left'>Simulation ON:</t><t align='right'>%3</t><br/><t align='left'>Simulation OFF:</t><t align='right'>%4</t><br/><t align='left'>Simple with Class:</t><t align='right'>%5</t><br/><t align='left'>Simple without Class:</t><t align='right'>%6</t></t>";

	if (_clean isEqualType 123) then {_clean = format["%1 fps",_clean]};
	if (_simulated isEqualType 123) then {_simulated = format["%1 fps",_simulated]};
	if (_disabled isEqualType 123) then {_disabled = format["%1 fps",_disabled]};
	if (_simpleWithClass isEqualType 123) then {_simpleWithClass = format["%1 fps",_simpleWithClass]};
	if (_simpleNoClass isEqualType 123) then {_simpleNoClass = format["%1 fps",_simpleNoClass]};

	([] call _fnc_getElapsedTime) params ["_hours","_mins","_secs"];
	hintSilent parseText format [_template,_class,_progressTotal,_simulated,_disabled,_simpleWithClass,_simpleNoClass,_clean,_simulation,_hours,_mins,_secs,"%"];
};

private _fnc_getElapsedTime =
{
	private _timeElapsed = round(time - _timeStart);
	private _timeHours = floor(_timeElapsed / 3600);
	_timeElapsed = _timeElapsed % 3600;
	private _timeMins = floor(_timeElapsed / 60);
	_timeElapsed = _timeElapsed % 60;

	[_timeHours,_timeMins,_timeElapsed]
};



private _fnc_logFps =
{
	
	sleep 1;

	private _mod = ceil(diag_fps/50);
	private _fps = 0;
	private _rounds = (5 * _mod) min 10;
	private _f = 0;

	for "_i" from 1 to _rounds do
	{
		sleep 1 / _mod;
		_f = diag_fps;
		_fps = _fps + _f;
	};

	_fps = round(_fps/_rounds);

	
	_this pushBack _fps;
};

private _timeStart = time;


private _fnc_benchmark =
{
	private _mode = _this;
	private _data = if (_mode == 3) then {[_class] call BIS_fnc_simpleObjectData} else {[]};
	private _posX = 0;
	private _posY = 0;
	private _progress = 0;
	private _progressPrev = 0;

	
	private _objects = ((allMissionObjects "all") + (allSimpleObjects []) - [player]);

	if (_mode != 1) then
	{
		if (count _objects > 0) then
		{
			["[x] REDUNDANT class: %4 | mode: %1 | object count: %2 | objects: %3",_mode,count _objects,_objects,_class] call bis_fnc_logFormat;

			if (_autolog) then {"bi_Logger" callExtension format["_diagSimpleObjectPerformance.csv<<app<<%1",format["[x] REDUNDANT class: %4 | mode: %1 | object count: %2 | objects: %3",_mode,count _objects,_objects,_class]]};

			{deleteVehicle _x} forEach _objects;waitUntil{sleep 0.1;{!isNull _x} count _objects == 0};_objects = [];;
		};

		
		for "_a" from 1 to _aMax do
		{
			_posX = _posStartX + _a * _gridSize;

			for "_b" from 1 to _bMax do
			{
				_progress = round (100 * (((_a-1)*_bMax) + _b)/(_aMax*_bMax));

				if (_progress != _progressPrev) then
				{
					[_entry,_progressTotal,_progress] call _fnc_showHint;
					_progressPrev = _progress;
				};

				if !(_a == _aPlayer && {_b == _bPlayer}) then
				{
					_posY = _posStartY + _b * _gridSize;

					private _object = switch (_mode) do
					{
						case 0:
						{
							createVehicle [_class, [_posX, _posY, 0], [], 0, "CAN_COLLIDE"]
						};
						case 2:
						{
							createSimpleObject [_class, [_posX, _posY, 5]]
						};
						default
						{
							[_data, [_posX, _posY, 5], 0] call bis_fnc_createSimpleObject
						};
					};

					_objects pushBack _object;
				};
			};
		};
	}
	
	else
	{
		_objects = allMissionObjects _class;

		
		{_x enableSimulation false} forEach _objects;
	};

	

	
	_entry call _fnc_logFps;

	
	if (_mode != 0) then
	{
		
		{deleteVehicle _x} forEach _objects;waitUntil{sleep 0.1;{!isNull _x} count _objects == 0};_objects = [];;
	};
};


private _output = [];

{
	private _class = _x;
	
	private _progressTotal = floor(_forEachIndex / _classesCount * 1000)/10;

	
	private _testObj = createVehicle [_class, [100,100,0], [], 0, "CAN_COLLIDE"];
	private _testBBox = boundingBoxReal _testObj;
	_testBBox params ["_p1","_p2"];
	private _testWidth = abs ((_p2 select 0) - (_p1 select 0));
	private _testLength = abs ((_p2 select 1) - (_p1 select 1));
	deleteVehicle _testObj;	waitUntil{sleep 0.1;isNull _testObj};

	
	private _gridSize = (_testWidth max _testLength) + 0.5;

	
	private _posStartX = _posPlayerX - (_aPlayer * _gridSize);
	private _posStartY = _posPlayerY - (_bPlayer * _gridSize);

	
	private _entry = [_class, getText(_path >> _class >> "simulation")];

	
	[_entry,_progressTotal] call _fnc_showHint;
	sleep 3;
	_entry call _fnc_logFps;
	[_entry,_progressTotal] call _fnc_showHint;

	private _memory = if (_diagMemory) then {[diag_memory]} else {[]};

	
	0 call _fnc_benchmark;
	[_entry,_progressTotal] call _fnc_showHint;

	
	1 call _fnc_benchmark;
	[_entry,_progressTotal] call _fnc_showHint;

	if (_diagMemory) then {_memory pushBack diag_memory};

	
	2 call _fnc_benchmark;
	[_entry,_progressTotal] call _fnc_showHint;

	if (_diagMemory) then {_memory pushBack diag_memory};

	
	3 call _fnc_benchmark;
	[_entry,_progressTotal] call _fnc_showHint;
	sleep 1;

	private _csvLine = if (_diagMemory) then
	{
		(_entry joinString ";") + ";" + (_memory joinString ";");
	}
	else
	{
		_entry joinString ";";
	};

	
	if (_autolog) then {"bi_Logger" callExtension format["_diagSimpleObjectPerformance.csv<<app<<%1",_csvLine]};

	
	_output pushBack _entry;
	_csv = _csv + _csvLine;

	["[!][%2] %1",_entry,_forEachIndex] call bis_fnc_logFormat;
}
forEach _classes;

([] call _fnc_getElapsedTime) params ["_hours","_mins","_secs"];
["[!] Benchmark of %4 object(s) completed after: %1 hours, %2 mins, %3 secs",_hours,_mins,_secs,_classesCount] call bis_fnc_logFormat;

bis_fnc_diagObjectPerformance_output = _output;
bis_fnc_diagObjectPerformance_csv = _csv;

private _template = "<t font='EtelkaMonospacePro' size='0.7'><t size='0.9'>BENCHMARK COMPLETE!</t><br/><br/><t align='left'>Object(s) tested:</t><t align='right'>%1</t><br/><t align='left'>Time spent:</t><t align='right'>%2 hr %3 min %4 secs</t></t>";

while {true} do
{
	hintSilent parseText format [_template,_classesCount,_hours,_mins,_secs];
	sleep 1;
};
