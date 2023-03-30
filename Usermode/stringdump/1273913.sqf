#line 0 "/temp/bin/A3/Functions_F/Debug/fn_animViewer.sqf"








































disableserialization;


if (count _this <= 1) exitwith {
	with uinamespace do {
		if (
			if (isnil {BIS_fnc_animViewer_cam}) then {false} else {!isnull BIS_fnc_animViewer_cam}
		) exitwith {"Animation Viewer is already running" call bis_fnc_logFormat;};
		BIS_fnc_animViewer_this = _this;
		_displayMission = [] call (uinamespace getvariable "bis_fnc_displayMission");
		if (is3DEN) then {_displayMission = finddisplay 313;};
		_displayMission createdisplay "RscDisplayAnimViewer";
	};
};

_mode = _this param [0,"Init",[displaynull,""]];
_this = _this param [1,[]];

_fnc_loadCombo = {
	_prefixCurrent = _this select 0;
	_prefixNext = _this select 1;
	_anims = _this select 2;
	_idc = _this select 3;
	_idcNext = _this select 4;
	_id = _this select 5;

	_cursel = lbcursel (_display displayctrl _idc);
	_selected = (_display displayctrl _idc) lbtext _cursel;

	
	_selectedAnims = [];
	{
		_anim = _x select 0;
		_animType = _x select 1;
		if (count _animType >= 5) then {
			{
				_prefix = _x select 0;
				_type = _x select 1;
				if (_prefix == _prefixCurrent) then {
					if (_type == _selected) then {
						_selectedAnims set [count _selectedAnims,[_anim,_animType]];
					};
				};
			} foreach _animType;
		} else {
			if (_selected == "<Unknown>") then {
				_selectedAnims set [count _selectedAnims,[_anim,_animType]];
			};
		};
	} foreach _anims;

	
	_nextTypes = [];
	{
		_anim = _x select 0;
		_animType = _x select 1;
		if (_prefixNext == "") then {
			_nextTypes set [count _nextTypes,_anim];
		} else {
			{
				_prefix = _x select 0;
				_type = _x select 1;
				if (_prefix == _prefixNext) then {
					if !(_type in _nextTypes) then {
						_nextTypes set [count _nextTypes,_type];
					};
				};
			} foreach _animType;
		};
	} foreach _selectedAnims;
	if (count _nextTypes == 0) then {_nextTypes = ["<Unknown>"];};


	_idc = _idcNext;
	lbclear (_display displayctrl _idc);
	{
		(_display displayctrl _idc) lbadd _x;	
	} foreach _nextTypes;
	lbsort (_display displayctrl _idc);
	(_display displayctrl _idc) ctrlenable (count _nextTypes > 1);

	
	_cursel = 0;
	_curselClass = BIS_fnc_animViewer_path select _id;
	for "_c" from 0 to (lbsize (_display displayctrl _idc) - 1) do {
		_class = (_display displayctrl _idc) lbtext _c;
		if (_class == _curselClass) then {_cursel = _c;};
	};
	(_display displayctrl _idc) lbsetcursel _cursel;
	BIS_fnc_animViewer_path set [_id - 1,_selected];

	_selectedAnims
};



switch _mode do {

	
	case "Init": {
		startloadingscreen [""];
		_display = _this select 0;

		_display displayaddeventhandler ["mousebuttondown","with uinamespace do {['MouseButtonDown',_this] call bis_fnc_animViewer;};"];
		_display displayaddeventhandler ["mousebuttonup","with uinamespace do {['MouseButtonUp',_this] call bis_fnc_animViewer;};"];
		_display displayaddeventhandler ["mousezchanged","with uinamespace do {['MouseZChanged',_this] call bis_fnc_animViewer;};"];
		_display displayaddeventhandler ["keydown","with (uinamespace) do {['KeyDown',_this] call bis_fnc_animViewer;};"];
		_display displayaddeventhandler ["mousemoving","with (uinamespace) do {['Loop',_this] call bis_fnc_animViewer;};"];
		_display displayaddeventhandler ["mouseholding","with (uinamespace) do {['Loop',_this] call bis_fnc_animViewer;};"];

		_ctrlMouseArea = _display displayctrl 999;
		_ctrlMouseArea ctrladdeventhandler ["mousemoving","with uinamespace do {['Mouse',_this] call bis_fnc_animViewer;};"];
		_ctrlMouseArea ctrladdeventhandler ["mouseholding","with uinamespace do {['Mouse',_this] call bis_fnc_animViewer;};"];
		ctrlsetfocus _ctrlMouseArea;

		_idc = 2106;
		(_display displayctrl _idc) ctrladdeventhandler ["lbselchanged","with uinamespace do {['Soldier',_this] spawn bis_fnc_animviewer};"];
		_idc = 2100;
		(_display displayctrl _idc) ctrladdeventhandler ["lbselchanged","with uinamespace do {['Action',_this] spawn bis_fnc_animviewer};"];
		_idc = 2101;
		(_display displayctrl _idc) ctrladdeventhandler ["lbselchanged","with uinamespace do {['Pose',_this] spawn bis_fnc_animviewer};"];
		_idc = 2102;
		(_display displayctrl _idc) ctrladdeventhandler ["lbselchanged","with uinamespace do {['Movement',_this] spawn bis_fnc_animviewer};"];
		_idc = 2103;
		(_display displayctrl _idc) ctrladdeventhandler ["lbselchanged","with uinamespace do {['Stance',_this] spawn bis_fnc_animviewer};"];
		_idc = 2104;
		(_display displayctrl _idc) ctrladdeventhandler ["lbselchanged","with uinamespace do {['Item',_this] spawn bis_fnc_animviewer};"];
		_idc = 1500;
		(_display displayctrl _idc) ctrladdeventhandler ["lbselchanged","with uinamespace do {['Misc',_this] spawn bis_fnc_animviewer};"];
		(_display displayctrl _idc) ctrladdeventhandler ["mousebuttondblclick","with uinamespace do {['MouseButtonDblClick',_this] spawn bis_fnc_animviewer};"];

		
		_logicPos = [1000,1000,10000];

		_logic = createagent ["Logic",_logicPos,[],0,"none"];
		_logic setpos _logicPos;
		_logic setdir 180;
		BIS_fnc_animViewer_logic = _logic;

		_target = createagent ["Logic",_logicPos,[],0,"none"];
		_target setpos _logicPos;
		BIS_fnc_animViewer_target = _target;

		
		setviewdistance 1;
		_cam = "camera" camcreate position _logic;
		_cam cameraeffect ["internal","back"];
		_cam campreparefocus [-1,-1];
		_cam camcommitprepared 0;
		cameraEffectEnableHUD true;
		showcinemaborder false;
		BIS_fnc_animViewer_cam = _cam;
		BIS_fnc_animViewer_campos = [5,-45,30];

		
		if (isnil "BIS_fnc_animViewer_moves") then {BIS_fnc_animViewer_moves = "";};
		if (isnil "BIS_fnc_animViewer_anims") then {BIS_fnc_animViewer_anims = [];};
		BIS_fnc_animViewer_anims_action = [];
		BIS_fnc_animViewer_anims_pose = [];
		BIS_fnc_animViewer_anims_movement = [];
		BIS_fnc_animViewer_anims_stance = [];
		BIS_fnc_animViewer_anims_item = [];
		BIS_fnc_animViewer_buttons = [[],[]];
		BIS_fnc_animViewer_unit = objnull;
		BIS_fnc_animViewer_animData = [];


		
		_vehicles = [configfile >> "cfgvehicles"] call bis_fnc_subClasses;
		_soldiers = [];
		{
			_displayName = _x call bis_fnc_displayName;
			_simulation = gettext (_x >> "simulation");
			_scope = getnumber (_x >> "scope");
			_side = getnumber (_x >> "side");
			if (_simulation == "animal") then {_side = 8; if (_scope != 0) then {_scope = 2;};};
			if ({_simulation == _x} count ["soldier","animal"] > 0 && _scope == 2 && _side >= 0) then {
				_soldiers set [count _soldiers,[_x,_side,_displayName]];
			};
		} foreach _vehicles;

		_idc = 2106;
		{
			_class = _x select 0;
			_side = _x select 1;
			_displayName = _x select 2;
			_classname = configname _class;
			_lbAdd = (_display displayctrl _idc) lbadd format ["%1 (%2)",_displayName,_classname];
			(_display displayctrl _idc) lbsetvalue [_lbAdd,_side];
			(_display displayctrl _idc) lbsetdata [_lbAdd,_classname];
			(_display displayctrl _idc) lbsetpicture [_lbAdd,(_side call bis_fnc_sidecolor) call bis_fnc_colorRGBAtoTexture];
		} foreach _soldiers;
		lbsortbyvalue (_display displayctrl _idc);

		
		_pathThis = BIS_fnc_animViewer_this param [0,[],[[]]];
		_thisName = _pathThis param [0,typeof player,[""]];
		_thisAnim = _pathThis param [1,animationstate player,[""]];
		_thisAnimType = [_thisAnim,true,false] call bis_fnc_animType;

		_path = [_thisName] + _thisAnimType;
		_path resize 6;
		_path = _path + [_thisAnim];
		BIS_fnc_animViewer_path = _path;

		_cursel = 0;
		_curselClass = BIS_fnc_animViewer_path select 0;
		if !(isclass (configfile >> "cfgvehicles" >> _curselClass)) then {
			_curselClass = typeof player;
			BIS_fnc_animViewer_path set [1,_curselClass];
		};
		for "_c" from 0 to (lbsize (_display displayctrl _idc) - 1) do {
			_class = (_display displayctrl _idc) lbdata _c;
			if (_class == _curselClass) then {_cursel = _c;};
		};
		(_display displayctrl _idc) lbsetcursel _cursel;

		
		BIS_fnc_animViewer_buttons = [[0,0],[0,0]];
		["Mouse",[controlnull,0,0]] call bis_fnc_animViewer;
		BIS_fnc_animViewer_buttons = [[],[]];

		
			BIS_fnc_animViewer_draw3D = addMissionEventHandler ["draw3D",{with (uinamespace) do {['draw3D',_this] call bis_fnc_animViewer;};}];
		

		if (is3DEN) then {
			["ShowInterface",false] spawn bis_fnc_3DENInterface;
			if (get3denactionstate "togglemap" > 0) then {do3DENAction "togglemap";};
		};

		
	};

	
	case "Exit": {
		
			removemissioneventhandler ["draw3D",BIS_fnc_animViewer_draw3D];
		

		deletevehicle (uinamespace getvariable ["BIS_fnc_animViewer_unit",objnull]);
		deletevehicle (uinamespace getvariable ["BIS_fnc_animViewer_logic",objnull]);
		deletevehicle (uinamespace getvariable ["BIS_fnc_animViewer_target",objnull]);

		setviewdistance -1;
		_cam = uinamespace getvariable ["BIS_fnc_animViewer_cam",objnull];
		_cam cameraeffect ["terminate","back"];
		camdestroy _cam;

		BIS_fnc_animViewer_this = nil;
		BIS_fnc_animViewer_logic = nil;
		BIS_fnc_animViewer_target = nil;
		BIS_fnc_animViewer_cam = nil;
		BIS_fnc_animViewer_campos = nil;
		BIS_fnc_animViewer_anims_action = nil;
		BIS_fnc_animViewer_anims_pose = nil;
		BIS_fnc_animViewer_anims_movement = nil;
		BIS_fnc_animViewer_anims_stance = nil;
		BIS_fnc_animViewer_anims_item = nil;
		BIS_fnc_animViewer_buttons = nil;
		BIS_fnc_animViewer_unit = nil;
		BIS_fnc_animViewer_path = nil;
		BIS_fnc_animViewer_animData = nil;

		if (is3DEN) then {
			get3DENCamera cameraeffect ["internal","back"];
			["ShowInterface",true] call bis_fnc_3DENInterface;
		};
	};

	
	case "Soldier": {
		_display = ctrlparent (_this select 0);

		_idc = 2106;
		_cursel = lbcursel (_display displayctrl _idc);
		_soldier = (_display displayctrl _idc) lbdata _cursel;

		
		_moves = gettext (configfile >> "cfgvehicles" >> _soldier >> "moves");

		startloadingscreen [format ["Loading %1",_moves]];
		if (_moves != BIS_fnc_animViewer_moves) then {

			_states = [configfile >> _moves >> "states"] call bis_fnc_subclasses;
			_statesCount = count _states;
			_anims = [];
			{
				_anim = configname _x;
				_animCheck = _anim;

				_actions = gettext (_x >> "actions");
				switch (tolower _actions) do {
					case "cargoactions":		{_animCheck = "P001_" + _animCheck;};
					case "deadactions":		{_animCheck = "P002_" + _animCheck;};
					case "parachutefreefall":	{_animCheck = "P003_" + _animCheck;};
					case "parachutefreefall":	{_animCheck = "P004_" + _animCheck;};
				};

				_animType = [_animCheck,true,true] call bis_fnc_animType;
				_anims set [count _anims,[_anim,_animType]];

				progressloadingscreen (_foreachindex / _statesCount);
			} foreach _states;

			BIS_fnc_animViewer_moves = _moves;
			BIS_fnc_animViewer_anims = _anims;
		};

		
		_actions = [];
		{
			_anim = _x select 0;
			_animType = _x select 1;
			{
				_prefix = _x select 0;
				_type = _x select 1;
				if (_prefix == "Action") then {
					if !(_type in _actions) then {
						_actions set [count _actions,_type];
					};
				};
				
			} foreach _animType;
		} foreach BIS_fnc_animViewer_anims;
		if (count _actions == 0) then {_actions = ["<Unknown>"];};

		_idc = 2100;
		lbclear (_display displayctrl _idc);
		{
			_lbAdd = (_display displayctrl _idc) lbadd _x;
		} foreach _actions;
		lbsort (_display displayctrl _idc);
		(_display displayctrl _idc) ctrlenable (count _actions > 1);

		
		_cursel = 0;
		_curselClass = BIS_fnc_animViewer_path select 1;
		for "_c" from 0 to (lbsize (_display displayctrl _idc) - 1) do {
			_class = (_display displayctrl _idc) lbtext _c;
			if (_class == _curselClass) then {_cursel = _c;};
		};
		(_display displayctrl _idc) lbsetcursel _cursel;

		
		deletevehicle (uinamespace getvariable ["BIS_fnc_animViewer_unit",objnull]);
		_logic = (uinamespace getvariable ["BIS_fnc_animViewer_logic",objnull]);
		


			_unit = createvehicle [_soldier,position _logic,[],0,"none"];
		
		_unit attachto [_logic,[0,0,0]];
		_unit disableai "target";
		_unit disableai "autotarget";
		_unit disableai "anim";
		_unit addeventhandler [
			"animdone",
			{
				(_this select 0) switchmove (_this select 1);
				with uinamespace do {BIS_fnc_animViewer_animData set [3,time];};
			}
		];
		BIS_fnc_animViewer_unit = _unit;

		
	};

	
	case "Action": {
		startloadingscreen [""];
		_display = ctrlparent (_this select 0);

		BIS_fnc_animViewer_anims_action = [
			"Action",
			"Pose",
			BIS_fnc_animViewer_anims,
			2100,
			2101,
			2
		] call _fnc_loadCombo;
	};

	
	case "Pose": {
		startloadingscreen [""];
		_display = ctrlparent (_this select 0);

		BIS_fnc_animViewer_anims_pose = [
			"Pose",
			"Movement",
			BIS_fnc_animViewer_anims_action,
			2101,
			2102,
			3
		] call _fnc_loadCombo;
	};

	
	case "Movement": {
		startloadingscreen [""];
		_display = ctrlparent (_this select 0);

		BIS_fnc_animViewer_anims_movement = [
			"Movement",
			"Stance",
			BIS_fnc_animViewer_anims_pose,
			2102,
			2103,
			4
		] call _fnc_loadCombo;
	};

	
	case "Stance": {
		startloadingscreen [""];
		_display = ctrlparent (_this select 0);

		BIS_fnc_animViewer_anims_stance = [
			"Stance",
			"Hand item",
			BIS_fnc_animViewer_anims_movement,
			2103,
			2104,
			5
		] call _fnc_loadCombo;
	};

	
	case "Item": {
		startloadingscreen [""];
		_display = ctrlparent (_this select 0);
		BIS_fnc_animViewer_anims_item = [
			"Hand item",
			"",
			BIS_fnc_animViewer_anims_stance,
			2104,
			-1,
			6
		] call _fnc_loadCombo;

		_idc = 1500;
		lbclear (_display displayctrl _idc);
		{
			_anim = _x select 0;
			_animType = _x select 1;

			_lbAdd = (_display displayctrl _idc) lbadd _anim;
		} foreach BIS_fnc_animViewer_anims_item;
		lbsort (_display displayctrl _idc);

		
		_cursel = 0;
		_curselClass = BIS_fnc_animViewer_path select 6;
		for "_c" from 0 to (lbsize (_display displayctrl _idc) - 1) do {
			_class = (_display displayctrl _idc) lbtext _c;
			if (_class == _curselClass) then {_cursel = _c;};
		};
		(_display displayctrl _idc) lbsetcursel _cursel;


		endloadingscreen;
	};

	
	case "Misc": {
		_display = ctrlparent (_this select 0);
		_idc = 1500;
		_cursel = lbcursel (_display displayctrl _idc);
		_anim = (_display displayctrl _idc) lbtext _cursel;

		_unit = BIS_fnc_animViewer_unit;
		_unit switchmove _anim;
		

		_cfgAnim = configfile >> BIS_fnc_animViewer_moves >> "States" >> _anim;
		_file = gettext (_cfgAnim >> "file");
		_speed = getnumber (_cfgAnim >> "speed");
		_duration = if (_speed != 0) then {abs (1 / _speed)} else {0};
		BIS_fnc_animViewer_animData = [_anim,_file,_duration,time];
		BIS_fnc_animViewer_path set [6,_anim];
	};

	
	case "Loop": {
		_display = _this select 0;

		
		if (count BIS_fnc_animViewer_animData > 0) then {
			_idc = 1100;
			_anim = BIS_fnc_animViewer_animData select 0;
			_file = BIS_fnc_animViewer_animData select 1;
			_duration = BIS_fnc_animViewer_animData select 2;
			_initTime = BIS_fnc_animViewer_animData select 3;

			







			_durationText = [_duration,"SS.MS"] call bis_fnc_secondsToString;
			_progressText = [(time - _initTime) min _duration,"SS.MS"] call bis_fnc_secondsToString;

			(_display displayctrl _idc) ctrlsetstructuredtext parsetext format [
				"<t align='left' shadow='0'><t size='2'>%1</t><br />File: %2<br />Duration: %3 s<br />Progress: %4 s<br />Time acceleration: %5x</t>",
				_anim,
				_file,
				_durationText,
				_progressText,
				acctime
			];
		};
	};

	
	case "Mouse": {
		_mX = _this select 1;
		_mY = _this select 2;

		_cam = (uinamespace getvariable ["BIS_fnc_animViewer_cam",objnull]);
		_logic = (uinamespace getvariable ["BIS_fnc_animViewer_logic",objnull]);
		_target = (uinamespace getvariable ["BIS_fnc_animViewer_target",objnull]);

		_dis = BIS_fnc_animViewer_campos select 0;
		_dirH = BIS_fnc_animViewer_campos select 1;
		_dirV = BIS_fnc_animViewer_campos select 2;
		_disLocal = _dis;

		_LMB = BIS_fnc_animViewer_buttons select 0;
		_RMB = BIS_fnc_animViewer_buttons select 1;

		if (count _LMB > 0) then {
			_cX = _LMB select 0;
			_cY = _LMB select 1;
			_dX = (_cX - _mX) * 10;
			_dY = (_cY - _mY) * 10;
			BIS_fnc_animViewer_buttons set [0,[_mX,_mY]];

			_targetPos = position _target;
			_logicPos = position _logic;
			_targetPos = [
				 (_logicPos select 0) - (_targetPos select 0),
				 (_logicPos select 1) - (_targetPos select 1),
				0
			];
			_targetPos = [_targetPos,_dY,_dirH + 00] call bis_fnc_relpos;
			_targetPos = [_targetPos,_dX,_dirH - 90] call bis_fnc_relpos;
			_targetPos set [0,(_targetPos select 0) max (-5) min (+5)];
			_targetPos set [1,(_targetPos select 1) max (-5) min (+5)];
			_target attachto [_logic,_targetPos,""];
			
		};

		if (count _RMB > 0) then {
			_cX = _RMB select 0;
			_cY = _RMB select 1;
			_dX = (_cX - _mX);
			_dY = (_cY - _mY);

			_dirH = (_dirH - _dX * 180) % 360;
			_dirV = (_dirV - _dY * 100) max -89 min 89;

			BIS_fnc_animViewer_campos set [1,_dirH];
			BIS_fnc_animViewer_campos set [2,_dirV];
			BIS_fnc_animViewer_buttons set [1,[_mX,_mY]];
		};

		_x = cos _dirV * _dis;
		_z = sin _dirV * _dis;
		_campos = [[0,0,_z],_x,_dirH] call bis_fnc_relpos;
		_cam attachto [_target,_campos,""];
		_cam campreparetarget _target;
		_cam camcommitprepared 0;
	};

	
	case "MouseButtonDown": {
		BIS_fnc_animViewer_buttons set [_this select 1,[_this select 2,_this select 3]];
	};

	
	case "MouseButtonUp": {
		BIS_fnc_animViewer_buttons set [_this select 1,[]];
	};

	
	case "MouseZChanged": {
		_z = _this select 1;
		_dis = BIS_fnc_animViewer_campos select 0;
		_dis = _dis - (_z / 4);
		_dis = _dis max 1 min 10;
		BIS_fnc_animViewer_campos set [0,_dis];
	};

	
	case "MouseButtonDblClick": {
		_display = ctrlparent (_this select 0);

		_idc = 1500;
		_cursel = lbcursel (_display displayctrl _idc);
		_anim = (_display displayctrl _idc) lbtext _cursel;

		_display closedisplay 2;
		waituntil {isnull _display};

		profilenamespace setvariable ["BIS_fnc_configviewer_path",["configfile",BIS_fnc_animViewer_moves,"States"]];
		profilenamespace setvariable ["BIS_fnc_configviewer_selected",_anim];

		[] call bis_fnc_configviewer;
	};

	
	case "KeyDown": {
		_display = _this select 0;
		_key = _this select 1;
		_shift = _this select 2;
		_ctrl = _this select 3;
		_alt = _this select 4;
		_return = false;

		switch (_key) do {
			case (0x2E): {
				copytoclipboard (BIS_fnc_animViewer_animData select 0);

				(_display displayctrl _idc) ctrlsetfade 0.5;
				(_display displayctrl _idc) ctrlcommit 0;
				(_display displayctrl _idc) ctrlsetfade 0;
				(_display displayctrl _idc) ctrlcommit 0.2;
			};
			case (0x2D): {
				
				copytoclipboard format [
					"[[%1,%2]] call BIS_fnc_animViewer;",
					str (BIS_fnc_animViewer_path select 0),
					str (BIS_fnc_animViewer_animData select 0)
				];

				_idc = 1500;
				(_display displayctrl _idc) ctrlsetfade 0.5;
				(_display displayctrl _idc) ctrlcommit 0;
				(_display displayctrl _idc) ctrlsetfade 0;
				(_display displayctrl _idc) ctrlcommit 0.2;
			};

			case (0x01): {
				_return = true;
				_this spawn {
					disableserialization;
					_display = _this select 0;
					_message = [
						"Do you really want to quit?",
						"Splendid Animation Viewer",
						nil,
						true,
						_display
					] call bis_fnc_guimessage;
					if (_message) then {
						_display closedisplay 2;
					};
				};
			};

			case (0x0C): {setacctime ((acctime / 2) max (1 / 128))};
			case (0x0D): {setacctime ((acctime * 2) min 4)};
		};
		_return
	};

	
	
	case "draw3D": {
		_logic = (uinamespace getvariable ["BIS_fnc_animViewer_logic",objnull]);

		
		for "_x" from -5 to 5 step 1 do {
			drawLine3D [
				_logic modeltoworld [_x,-5],
				_logic modeltoworld [_x,+5],
				[0,0,0,1]
			];
		};
		for "_y" from -5 to 5 step 1 do {
			drawLine3D [
				_logic modeltoworld [-5,_y],
				_logic modeltoworld [+5,_y],
				[0,0,0,1]
			];
		};

		
		drawLine3D [
			_logic modeltoworld [0,0,-5],
			_logic modeltoworld [0,0,+5],
			[0.2,0,0,1]
		];
		drawLine3D [
			_logic modeltoworld [0,-5,0],
			_logic modeltoworld [0,+5,0],
			[0.2,0,0,1]
		];
		drawLine3D [
			_logic modeltoworld [-5,0,0],
			_logic modeltoworld [+5,0,0],
			[0.2,0,0,1]
		];
	};
	
};
