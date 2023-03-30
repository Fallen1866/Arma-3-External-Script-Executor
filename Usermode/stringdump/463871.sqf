{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_diagKnownTargets'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_diagKnownTargets';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f\Diagnostic\fn_diagKnownTargets.sqf [BIS_fnc_diagKnownTargets]"
#line 0 "/temp/bin/A3/Functions_F/Diagnostic/fn_diagKnownTargets.sqf"
















if (missionNamespace getVariable ["BIS_fnc_diagKnownTargets_running", false]) then 
{
	"Diagnostics terminated." call BIS_fnc_log;

	BIS_fnc_diagKnownTargets_terminate = true;
	
	(((uiNamespace getVariable "gui_displays") select 3) displayCtrl 51) ctrlRemoveAllEventHandlers "draw";
} 
else 
{
	"Diagnostics started." call BIS_fnc_log;

	missionNamespace setVariable ["BIS_fnc_diagKnownTargets_running", true];
	BIS_fnc_diagKnownTargets_terminate = false;
	
	BIS_fnc_diagKnownTargets_unit = _this param [0, player, [objNull]];
	BIS_fnc_diagKnownTargets_radius = _this param [1, 1000, [0]];
	
	("Visualizing targets known to: " + (str BIS_fnc_diagKnownTargets_unit)) call BIS_fnc_log;

	BIS_fnc_diagKnownTargets_colorWest = west call BIS_fnc_sideColor;
	BIS_fnc_diagKnownTargets_colorEast = east call BIS_fnc_sideColor;
	BIS_fnc_diagKnownTargets_colorResistance = resistance call BIS_fnc_sideColor;
	BIS_fnc_diagKnownTargets_colorUnknown = sideUnknown call BIS_fnc_sideColor;
	
	[] spawn 
	{
		(((uiNamespace getVariable "gui_displays") select 3) displayCtrl 51) ctrlRemoveAllEventHandlers "draw";
		private ["_draw"];
		_draw = 
		"
			{
				private ['_target', '_cost'];
				_target = _x select 4;

				_cost = _x select 3;
				if (_cost > 0) then 
				{
					private ['_side', '_color', '_alpha', '_size'];
					_side = _x select 2;
					_color = [1, 1, 1];
					switch _side do 
					{
						case west: {_color = BIS_fnc_diagKnownTargets_colorWest;};
						case east: {_color = BIS_fnc_diagKnownTargets_colorEast;};
						case resistance: {_color = BIS_fnc_diagKnownTargets_colorResistance;};
						case sideUnknown: {_color = BIS_fnc_diagKnownTargets_colorUnknown;};
					};
					_color resize 3;
					
					_alpha = (([[0, 5], _x select 5, [0.2, 0.9]] call BIS_fnc_linearConversion) min 0.9) max 0.2;
					
					_size = (([[0, 20], _cost, [0.1, 5]] call BIS_fnc_linearConversion) min 5) max 0.1;
					
					(_this select 0) drawRectangle [position _target, 1, 1, direction _target, _color + [0.9], '#(argb,8,8,3)color(1,1,1,1)'];
					(_this select 0) drawEllipse [_x select 0, _size, _size, direction _target, _color + [_alpha], ''];
					(_this select 0) drawArrow [position _target, _x select 0, _color + [0.9]];
				};
			} forEach (BIS_fnc_diagKnownTargets_unit nearTargets BIS_fnc_diagKnownTargets_radius);
		";
		(((uiNamespace getVariable "gui_displays") select 3) displayCtrl 51) ctrlSetEventHandler ["draw", _draw];
		
		setGroupIconsVisible [false, true]; 
		
		private ["_groups", "_logics", "_targets"];
		_groups = [];
		_logics = [];
		_targets = [];
		
		while {(alive BIS_fnc_diagKnownTargets_unit) && !BIS_fnc_diagKnownTargets_terminate} do 
		{
			private ["_currentTargets"];
			_currentTargets = [];

			{
				private ["_target", "_targetIndex", "_cost"];
				_target = _x select 4;
				_targetIndex = _targets find _target;

				_cost = _x select 3;
				if (_cost > 0) then 
				{
					_currentTargets set [count _currentTargets, _target];
				
					private ["_grp", "_logic"];
					if (_targetIndex == -1) then 
					{			
						_grp = createGroup civilian;
						_groups set [count _groups, _grp];
					
						_logic = _grp createUnit ["Logic", [10, 10, 10], [], 0, "NONE"];
						_logic enableSimulation false;
						_logic hideObject true;
						_logics set [count _logics, _logic];
						
						_grp addGroupIcon ["hc_selectedEnemy", [0, 0]];
						
						_targets set [count _targets, _target];
					} 
					else 
					{
						_grp = _groups select _targetIndex;
						_logic = _logics select _targetIndex;
					};
					
					_logic setPos (_x select 0);
					[_logic, -2.3] call BIS_fnc_setHeight;
					
					private ["_side", "_color", "_alpha", "_size"];
					_side = _x select 2;
					_color = [1, 1, 1];
					switch _side do 
					{
						case west: {_color = BIS_fnc_diagKnownTargets_colorWest;};
						case east: {_color = BIS_fnc_diagKnownTargets_colorEast;};
						case resistance: {_color = BIS_fnc_diagKnownTargets_colorResistance;};
						case sideUnknown: {_color = BIS_fnc_diagKnownTargets_colorUnknown;};
					};
					_color resize 3;
					
					_alpha = (([[0, 5], _x select 5, [0.2, 1]] call BIS_fnc_linearConversion) min 1) max 0.2;
					
					_size = (([[0, 20], _cost, [0.1, 2]] call BIS_fnc_linearConversion) min 2) max 0.1;
					
					_grp setGroupIconParams [_color + [_alpha], _x select 1, _size, true];
				} 
				else 
				{
					if (_targetIndex != -1) then 
					{
						_targets set [_targetIndex, objNull];
					};
				};
			} forEach (BIS_fnc_diagKnownTargets_unit nearTargets BIS_fnc_diagKnownTargets_radius);
			
			{
				if (!(_x in _currentTargets)) then 
				{
					_targets set [_forEachIndex, objNull];

					deleteVehicle (_logics select _forEachIndex);
					_logics set [_forEachIndex, -1];
					deleteGroup (_groups select _forEachIndex);
					_groups set [_forEachIndex, -1];
				};
			} forEach _targets;
			
			_targets = _targets - [objNull];
			_groups = _groups - [-1];
			_logics = _logics - [-1];
			
			sleep 0.001;
		};	
		
		{
			{
				deleteVehicle _x;
			} forEach (units _x);
			
			deleteGroup _x;
		} forEach _groups;
		
		BIS_fnc_diagKnownTargets_terminate = nil;
		missionNamespace setVariable ["BIS_fnc_diagKnownTargets_running", false];
	};
};

true}
