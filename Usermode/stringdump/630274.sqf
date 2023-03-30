#line 0 "/temp/bin/A3/Functions_F/Debug/fn_configviewer.sqf"

































































































































disableserialization;
private ["_mode"];
_mode = _this param [0,displaynull,[displaynull,""]];


if (typename _mode == typename displaynull) exitwith {
	private ["_root","_isOK","_code","_title","_displayMission","_parent","_display","_classes","_returnedClass"];

	
	_root = _this param [1,false,[false,configfile]];
	_isOK = _this param [2,false,[false]];
	_code = _this param [3,{},[{}]];
	_codeList = _this param [4,{configname (_this select 0)},[{}]];
	_title = _this param [5,"%1",[""]];
	uinamespace setvariable ["BIS_fnc_configviewer_root",_root];
	uinamespace setvariable ["BIS_fnc_configviewer_isOK",_isOK];
	uinamespace setvariable ["BIS_fnc_configviewer_previewCode",_code];
	uinamespace setvariable ["BIS_fnc_configviewer_codeList",_codeList];
	uinamespace setvariable ["BIS_fnc_configviewer_title",_title];

	
	_parent = if (isnull _mode) then {
		_displayMission = [] call (uinamespace getvariable "bis_fnc_displayMission");
		if !(isnull (finddisplay 312)) then {_displayMission = finddisplay 312;}; 
		if (isnull _displayMission) then {
			_displays = alldisplays;
			{if (ctrlidd _x in [12,2928]) then {_displays set [_foreachindex,-1];};} foreach _displays;
			_displays = _displays - [-1];
			if (count _displays > 0) then {
				if (ctrlidd (_displays select (count _displays - 1)) == 56) then {
					
					_displays select (count _displays - 2)
				} else {
					
					_displays select (count _displays - 1)
				};
			} else {
				
				displaynull
			};
		} else {
			
			_displayMission
		};
	} else {
		_mode
	};
	_parent createdisplay "RscDisplayConfigViewer";

	
	if (_isOK) then {
		waituntil {!isnil {uinamespace getvariable "BIS_fnc_configviewer_display"}};
		_display = uinamespace getvariable "BIS_fnc_configviewer_display";

		waituntil {isnull _display};
		_returnedClass = uinamespace getvariable "BIS_fnc_configviewer_returnedClass";
		if !(isnil "_returnedClass") then {
			BIS_fnc_configviewer_returnedClass = nil;
			_returnedClass
		} else {
			[]
		};
	} else {
		[]
	};
};

_this = _this param [1,[]];
switch _mode do {

	
	case "Init": {
		private ["_display","_path","_selected"];
		_display = _this select 0;

		BIS_fnc_configviewer_display = _display;

		(_display displayctrl 1500) ctrladdeventhandler ["lbselchanged","with uinamespace do {terminate bis_fnc_configviewer_lbselchanged; bis_fnc_configviewer_lbselchanged = ['lbSelChanged',_this] spawn bis_fnc_configviewer};"];
		(_display displayctrl 1500) ctrladdeventhandler ["lbdblclick","with uinamespace do {['buttonClick',_this] spawn bis_fnc_configviewer};"];
		(_display displayctrl 1500) ctrladdeventhandler ["keydown","with uinamespace do {['keyDown',_this] call bis_fnc_configviewer};"];
		(_display displayctrl 1502) ctrladdeventhandler ["lbdblclick","with uinamespace do {['bookmarkButtonClick',_this] spawn bis_fnc_configviewer};"];
		(_display displayctrl 1502) ctrladdeventhandler ["keydown","with uinamespace do {['bookmarkKeyDown',_this] call bis_fnc_configviewer};"];
		(_display displayctrl 1501) ctrladdeventhandler ["keydown","with uinamespace do {['keyDown',_this] spawn bis_fnc_configviewer};"];
		(_display displayctrl 1501) ctrladdeventhandler ["lbselchanged","with uinamespace do {['paramLbSelChanged',_this] spawn bis_fnc_configviewer};"];
		(_display displayctrl 2) ctrladdeventhandler ["buttonclick","(ctrlparent (_this select 0)) closedisplay 2;"];

		
		_titleText = ctrltext (_display displayctrl 1000);
		(_display displayctrl 1000) ctrlsettext format [BIS_fnc_configviewer_title,_titleText];

		
		if (BIS_fnc_configviewer_isOK) then {
			(_display displayctrl 2600) ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonOK',_this] spawn bis_fnc_configviewer};"];
		} else {
			(_display displayctrl 2600) ctrlenable false;
			(_display displayctrl 2600) ctrlsetfade 1;
			(_display displayctrl 2600) ctrlcommit 0;
		};

		
		if (str BIS_fnc_configviewer_previewCode != str {}) then {
			(_display displayctrl 2400) ctrlenable false;
			(_display displayctrl 2400) ctrlsetfade 1;
			(_display displayctrl 2400) ctrlcommit 0;

			(_display displayctrl 2401) ctrlenable false;
			(_display displayctrl 2401) ctrlsetfade 1;
			(_display displayctrl 2401) ctrlcommit 0;

			(_display displayctrl 2300) ctrlenable false;
			(_display displayctrl 2300) ctrlsetfade 1;
			(_display displayctrl 2300) ctrlcommit 0;

			(_display displayctrl 1005) ctrlsetposition [
				ctrlposition (_display displayctrl 2301) select 0,
				ctrlposition (_display displayctrl 1500) select 1,
				ctrlposition (_display displayctrl 2301) select 2,
				ctrlposition (_display displayctrl 1500) select 3
			];
			(_display displayctrl 1005) ctrlcommit 0;
		} else {
			(_display displayctrl 2400) ctrladdeventhandler ["buttonclick","with uinamespace do {['previewClass',_this] spawn bis_fnc_configviewer};"];
			(_display displayctrl 2401) ctrladdeventhandler ["buttonclick","with uinamespace do {['previewParam',_this] spawn bis_fnc_configviewer};"];
			(_display displayctrl 2400) ctrlsettooltip localize "str_a3_rscdisplayconfigviewer_buttonpreviewclass_tooltip";
			(_display displayctrl 2401) ctrlsettooltip localize "str_a3_rscdisplayconfigviewer_buttonpreviewparam_tooltip";

			(_display displayctrl 2301) ctrlenable false;
			(_display displayctrl 2301) ctrlsetfade 1;
			(_display displayctrl 2301) ctrlcommit 0;
		};

		
		if (typename BIS_fnc_configviewer_root == typename false) then {
			_path = missionnamespace getvariable ["BIS_fnc_configviewer_path",profilenamespace getvariable "BIS_fnc_configviewer_path"];
			_selected = missionnamespace getvariable ["BIS_fnc_configviewer_selected",profilenamespace getvariable "BIS_fnc_configviewer_selected"];
			if (isnil "_path") then {_path = [];};
			if (isnil "_selected") then {_selected = "";};
			BIS_fnc_configviewer_path = if (typename _path == typename []) then {+_path} else {[]};
			BIS_fnc_configviewer_selected = if (typename _selected == typename "") then {_selected} else {""};
			profilenamespace setvariable ["BIS_fnc_configviewer_path",BIS_fnc_configviewer_path];
			profilenamespace setvariable ["BIS_fnc_configviewer_selected",BIS_fnc_configviewer_selected];
			missionnamespace setvariable ["BIS_fnc_configviewer_path",nil];
			missionnamespace setvariable ["BIS_fnc_configviewer_selected",nil];
			saveprofilenamespace;
		} else {
			BIS_fnc_configviewer_path = [];
			BIS_fnc_configviewer_selected = "";
		};

		BIS_fnc_configviewer_rootNames = [str configfile,str campaignconfigfile,str missionconfigfile];
		

		if (typename BIS_fnc_configviewer_root == typename false) then {

			
			_bookmarksDefault = [
				[["configfile","CfgVehicles"],["typeof vehicle cameraon"]],
				[["configfile","CfgWeapons"],["currentweapon vehicle cameraon"]],
				[["configfile","CfgMagazines"],["currentmagazine vehicle cameraon"]],
				[["configfile","CfgAmmo"],["gettext (configfile >> 'CfgMagazines' >> currentmagazine vehicle cameraon >> 'ammo')"]]
			];
			if (isnil {profilenamespace getvariable "BIS_fnc_configviewer_bookmarks"}) then {
				profilenamespace setvariable ["BIS_fnc_configviewer_bookmarks",_bookmarksDefault];
			};
			_bookmarks = +(profilenamespace getvariable "BIS_fnc_configviewer_bookmarks");
			_lbAdd = (_display displayctrl 1502) lbadd format ["<%1>",localize "STR_A3_RscDisplayConfigViewer_bookmark"];
			(_display displayctrl 1502) lbsetpicture [_lbadd,"\A3\ui_f\data\gui\rsc\rscdisplayconfigviewer\bookmark_gs.paa"];
			{
				_path = _x select 0;
				_selected = _x select 1;
				if (typename _selected == typename []) then {_selected = call compile (_selected select 0);}; 
				_text = "";
				{
					if (_x == "configfile") then {_x = ""};
					if (_x == "missionconfigfile") then {_x = "mission"};
					if (_x == "campaignconfigfile") then {_x = "campaign"};
					_add = if (_foreachindex == 0) then {_x} else {"/" + _x};
					_text = _text + _add;
				} foreach _path;
				if ((_path select (count _path - 1)) != _selected) then {
					_text = _text + "/" + _selected;
				};
				_lbAdd = (_display displayctrl 1502) lbadd _text;
				(_display displayctrl 1502) lbsetvalue [_lbAdd,_foreachindex];
				if (_lbAdd <= count _bookmarksDefault) then {
					(_display displayctrl 1502) lbsetcolor [_lbAdd,[1,1,1,0.6]];
				};
			} foreach _bookmarks;

			
			_posClasses = ctrlposition (_display displayctrl 1500);
			_posBookmarks = ctrlposition (_display displayctrl 1502);
			_posH = ((_posBookmarks select 1) - (_posClasses select 1)) - 0.01;

			_posClasses set [3,_posH];
			(_display displayctrl 1500) ctrlsetposition _posClasses;
			(_display displayctrl 1500) ctrlcommit 0;

		} else {
			
			(_display displayctrl 1502) ctrlenable false;
			(_display displayctrl 1502) ctrlsetfade 1;
			(_display displayctrl 1502) ctrlcommit 0;
		};

		["treeRefresh",[]] call bis_fnc_configViewer;
	};

	
	case "Exit": {
		if (typename BIS_fnc_configviewer_root == typename false) then {
			profilenamespace setvariable ["BIS_fnc_configviewer_path",BIS_fnc_configviewer_path];
			profilenamespace setvariable ["BIS_fnc_configviewer_selected",BIS_fnc_configviewer_selected];
			saveprofilenamespace;
		};

		BIS_fnc_configviewer_path = nil;
		BIS_fnc_configviewer_selected = nil;
		BIS_fnc_configviewer_listMeta = nil;
		BIS_fnc_configviewer_root = nil;
		BIS_fnc_configviewer_rootNames = nil;
		BIS_fnc_configviewer_isOK = nil;
		BIS_fnc_configviewer_previewCode = nil;
		BIS_fnc_configviewer_title = nil;
		BIS_fnc_configviewer_display = nil;
	};

	
	
	case "treeRefresh": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		startloadingscreen [""];

		private ["_progress"];
		if (isnil "_progress") then {_progress = 0};

		lbclear (_display displayctrl 1500);
		BIS_fnc_configviewer_listMeta = [];
		_lbCursel = 0;
		if (BIS_fnc_configviewer_selected == "" && count BIS_fnc_configviewer_path > 0) then {BIS_fnc_configviewer_selected = BIS_fnc_configviewer_path select (count BIS_fnc_configviewer_path - 1);};
		_selected = BIS_fnc_configviewer_selected;
		_root = if (typename BIS_fnc_configviewer_root == typename false) then {
			[
				[

					[configfile,"configfile"],
					[campaignconfigfile,"campaignconfigfile"],
					[missionconfigfile,"missionconfigfile"]
				],
				0
			]
		} else {
			[BIS_fnc_configviewer_root,1]
		};
		["treeSub",_root] call bis_fnc_configviewer;

		
		(_display displayctrl 1500) lbsetcursel _lbCursel;
		BIS_fnc_configviewer_selected = nil;

		endloadingscreen;
	};

	
	
	case "treeSub": {
		private ["_path","_pathSorted","_pathSortedCount","_subPath","_subPathName","_n","_r","_parents"];
		_path = _this select 0;
		_n = _this select 1;

		_parents = if (_n == 0) then {
			[_path]
		} else {
			[_path] call bis_fnc_returnparents;
		};
		
		_pathSorted = [];
		_pathList = [];

		lbclear (_display displayctrl 1501);
		{
			for "_p" from 0 to (count _x - 1) do {
				_subPath = _x select _p;

				
				if (_n == 0) then {
					_subPath = _subPath select 0;
					_subPathName = configname _subPath;
					_lbAdd = (_display displayctrl 1501) lbadd _subPathName;
				} else {
					if (isclass _subPath) then {
						_subPathName = configname _subPath;
						if !(_subPathName in _pathList) then {
							_lbAdd = (_display displayctrl 1501) lbadd _subPathName;
							_pathList set [count _pathList,_subPathName];
						};
					};
				};
			};
		} foreach _parents;
		lbsort (_display displayctrl 1501);

		_r = 0;
		for "_p" from 0 to (lbsize (_display displayctrl 1501) - 1) do {
			_subPath = (_display displayctrl 1501) lbtext _p;

			if (_subPath in BIS_fnc_configviewer_rootNames) then {
				_pathSorted = _pathSorted + [_path select _r];
				_r = _r + 1;
			} else {
				_pathSorted set [count _pathSorted,_path >> _subPath];
			};
		};
		lbclear (_display displayctrl 1501);

		
		_pathSortedCount = count _pathSorted - 1;
		for "_p" from 0 to _pathSortedCount do {
			private ["_subPathConfigName"];
			_subPath = _pathSorted select _p;
			_subPathName = if (typename _subPath == typename []) then {
				_subPathName = _subPath select 1;
				_subPath = _subPath select 0;
				_subPathConfigName = _subPathName;
				_subPathName
			} else {
				_subPathConfigName = configname _subPath;
				[_subPath] call BIS_fnc_configviewer_codeList;
			};

			if (_subPathName != "") then {

				
				_hasSubclasses = false;
				_parents = [_subPath] call bis_fnc_returnparents;
				{
					for "_s" from 0 to (count _x - 1) do {
						if (isclass (_x select _s)) exitwith {_hasSubclasses = true;_s = count _x;};
					};
					if (_hasSubclasses) exitwith {};
				} foreach _parents;

				
				_prefix = "";
				for "_i" from 1 to _n do {_prefix = _prefix + "  "};
				_prefix = if (_hasSubclasses) then {_prefix + "+"} else {_prefix + " "};
				_prefix = _prefix + " ";

				_lbAdd = (_display displayctrl 1500) lbadd (_prefix + _subPathName);
				(_display displayctrl 1500) lbsetvalue [_lbAdd,_n];
				(_display displayctrl 1500) lbsetdata [_lbAdd,_subPathConfigName];
				_color = if (_n == count BIS_fnc_configviewer_path || typename (uinamespace getvariable "BIS_fnc_configviewer_root") == typename configfile) then {[1,1,1,1]} else {[1,1,1,0.6]};
				(_display displayctrl 1500) lbsetcolor [_lbAdd,_color];

				BIS_fnc_configviewer_listMeta set [count BIS_fnc_configviewer_listMeta,[_hasSubclasses,toarray tolower _subPathConfigName]];

				if (count BIS_fnc_configviewer_path > 0) then {

					
					if (_subPathConfigName == BIS_fnc_configviewer_selected) then {
						_lbCursel = (lbsize (_display displayctrl 1500) - 1);
					};

					
					if ((BIS_fnc_configviewer_path select _n) == _subPathConfigName) then {
						["treeSub",[_subPath,_n + 1]] call bis_fnc_configviewer;
					};
				};
			};

			
			_progress = _progress + ((1 / (_pathSortedCount + 1)) / (_n + 3.1));
			progressloadingscreen _progress;
		};
	};

	
	
	case "buttonClick": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		_lbId = lbcursel (_display displayctrl 1500);
		_lbValue = (_display displayctrl 1500) lbvalue _lbId;
		_lbData = (_display displayctrl 1500) lbData _lbId;

		
		_listMeta = BIS_fnc_configviewer_listMeta select _lbId;
		_hasSubclasses = _listMeta select 0;

		
		if !(_hasSubclasses) exitwith {};

		
		if (_lbId != lbcursel (_display displayctrl 1500)) exitwith {};

		_path = [""] + BIS_fnc_configviewer_path; 

		
		

		BIS_fnc_configviewer_path resize _lbValue;
		if ((_path select (count _path - 1)) == _lbData) then {
			
			if (count BIS_fnc_configviewer_path == 1) then {
				if (isnil {BIS_fnc_configviewer_path select 0}) then {BIS_fnc_configviewer_path = [];};
			};
		} else {
			
			BIS_fnc_configviewer_path = BIS_fnc_configviewer_path + [_lbData];
		};
		BIS_fnc_configviewer_selected = _lbData;
		["treeRefresh",[]] call bis_fnc_configViewer;

	};

	
	
	case "lbSelChanged": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		_lbId = lbcursel (_display displayctrl 1500);
		_lbValue = (_display displayctrl 1500) lbvalue _lbId;
		_lbData = (_display displayctrl 1500) lbData _lbId;

		
		if (_lbData == missionnamespace getvariable ["BIS_fnc_configviewer_selected",""]) exitwith {};
		BIS_fnc_configviewer_selected = _lbData;

		
		_configPath = ["composePath",_this] call bis_fnc_configviewer;

		
		if (str BIS_fnc_configviewer_previewCode != str {}) exitwith {
			_text = [_configPath] call BIS_fnc_configviewer_previewCode;
			_text = _text param [0,"",[""]];
			(_display displayctrl 1100) ctrlsetstructuredtext parsetext _text;

			_pos = ctrlposition (_display displayctrl 1100);
			_pos set [3,ctrltextheight (_display displayctrl 1100)];
			(_display displayctrl 1100) ctrlsetposition _pos;
			(_display displayctrl 1100) ctrlcommit 0;
		};

		
		_text = ["textPath",_this] call bis_fnc_configviewer;
		(_display displayctrl 1400) ctrlsettext _text;

		_parents = [_configPath,true] call bis_fnc_returnparents;
		_parents set [0,-1];
		_parents = _parents - [-1];
		(_display displayctrl 1401) ctrlsettext str (_parents);

		
		_path = (["arrayPath",_this] call bis_fnc_configviewer) select 0;
		_pathCount = count _path;
		_class = "";

		_cfgVehiclesId = _path find "CfgVehicles";
		_scopeVehicle = if (_cfgVehiclesId >= 0 && _pathCount > (_cfgVehiclesId + 1)) then {
			_class = _path select (_cfgVehiclesId + 1);
			getnumber (_configPath >> "scope");
		} else {
			-1
		};

		_cfgWeaponsId = _path find "CfgWeapons";
		_scopeWeapon = if (_cfgWeaponsId >= 0 && _pathCount > (_cfgWeaponsId + 1)) then {
			_class = _path select (_cfgWeaponsId + 1);
			getnumber (_configPath >> "scope");
		} else {
			-1
		};
		(_display displayctrl 2400) ctrlsettext format [localize "STR_A3_RscDisplayConfigViewer_ButtonPreviewClass",_class];
		(_display displayctrl 2400) ctrlenable (_scopeVehicle > 0 || _scopeWeapon > 0);


		
		lbclear (_display displayctrl 1501);
		_parents = [_configPath] call bis_fnc_returnparents;
		_params = [];
		{
			_pathScope = _x;
			for "_p" from 0 to (count _pathScope - 1) do {
				_param = _pathScope select _p;
				_paramName = configName _param;
				_param = _configPath >> _paramName;

				if !(isclass _param) then {
					if !(_param in _params) then {
						_paramColor = [1,1,1,1];
						_paramValue = switch true do {
							case (istext _param): {
								_paramColor = [1,0.8,0.8,1];
								str gettext _param;
							};
							case (isnumber _param): {
								_paramColor = [0.8,1,0.8,1];
								str getnumber _param;
							};
							case (isarray _param): {
								_paramColor = [0.6,0.6,1,1];
								_paramName = _paramName + "[]";
								_paramValue = "{";
								_paramArray = getarray _param;
								{
									if (_foreachindex > 0) then {_paramValue = _paramValue + ",";};
									_paramValue = _paramValue + str _x;
								} foreach _paramArray;
								_paramValue = _paramValue + "}";
								_paramValue
							};
						};
						_lbAdd = (_display displayctrl 1501) lbadd (_paramName + " = " + _paramValue + ";");
						(_display displayctrl 1501) lbsetdata [_lbAdd,configName _param];
						(_display displayctrl 1501) lbsetcolor [_lbAdd,_paramColor];
						if (_foreachindex > 0) then {(_display displayctrl 1501) lbsetpicture [_lbAdd,"#(argb,8,8,3)color(0,0,0,0)"];};
						_params set [count _params,_param];
					};
				};
			};
		} foreach _parents;

		lbsort (_display displayctrl 1501);
		_lbAdd = (_display displayctrl 1501) lbadd ""; 
		(_display displayctrl 1501) lbsetcursel -1;
		(_display displayctrl 2401) ctrlenable false;
	};

	
	case "keyDown": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		_key = _this select 1;
		_shift = _this select 2;
		_ctrl = _this select 3;
		_alt = _this select 4;

		_isClasses = ((_this select 0) == (_display displayctrl 1500));

		if (_ctrl) then {
			switch _key do {

				
				case 0x2D: {
					if (_isClasses) then {
						_lbId = lbcursel (_display displayctrl 1500);
						_lbData = (_display displayctrl 1500) lbData _lbId;
						if (_shift) then {

							
							copytoclipboard (["textPath",_this] call bis_fnc_configviewer);
						} else {
							
							copytoclipboard str (["arrayPath",_this] call bis_fnc_configviewer);
						};
						(_display displayctrl 1500) ctrlsetfade 0.5;
						(_display displayctrl 1500) ctrlcommit 0;
						(_display displayctrl 1500) ctrlsetfade 0;
						(_display displayctrl 1500) ctrlcommit 0.2;
					};
				};

				
				case 0x2E: {
					if (_isClasses) then {
						if (_shift) then {
							_text = "";
							_br = tostring [13,10];
							_value = (count BIS_fnc_configviewer_path);
							for "_i" from 0 to (lbsize (_display displayctrl 1500) - 1) do {
								if (((_display displayctrl 1500) lbvalue _i) == _value) then {
									_text = _text + ((_display displayctrl 1500) lbdata _i) + _br;
								};
							};
							copytoclipboard _text;
						} else {
							_lbId = lbcursel (_display displayctrl 1500);
							_lbData = (_display displayctrl 1500) lbData _lbId;
							copytoclipboard _lbData;
						};
						(_display displayctrl 1500) ctrlsetfade 0.5;
						(_display displayctrl 1500) ctrlcommit 0;
						(_display displayctrl 1500) ctrlsetfade 0;
						(_display displayctrl 1500) ctrlcommit 0.2;
					} else {
						if (_shift) then {
							_text = "";
							_br = tostring [13,10];
							for "_i" from 0 to (lbsize (_display displayctrl 1501) - 1) do {
								_text = _text + ((_display displayctrl 1501) lbtext _i) + _br;
							};
							copytoclipboard _text;
						} else {
							_lbId = lbcursel (_display displayctrl 1501);
							_lbText = (_display displayctrl 1501) lbText _lbId;
							copytoclipboard _lbText;
						};
						(_display displayctrl 1501) ctrlsetfade 0.5;
						(_display displayctrl 1501) ctrlcommit 0;
						(_display displayctrl 1501) ctrlsetfade 0;
						(_display displayctrl 1501) ctrlcommit 0.2;
					};
				};

				
				case 0x2F: {
					if (_isClasses) then {
						_copy = call compile copyfromclipboard;
						if (typename _copy == typename []) then {
							if (count _copy == 2) then {
								_path = _copy select 0;
								_selected = _copy select 1;
								if ({typename _x != typename ""} count _path == 0 && typename _selected == typename "") then {
									BIS_fnc_configviewer_path = _path;
									BIS_fnc_configviewer_selected = _selected;
									["treeRefresh",[]] call bis_fnc_configViewer;
									(_display displayctrl 1500) ctrlsetfade 0.5;
									(_display displayctrl 1500) ctrlcommit 0;
									(_display displayctrl 1500) ctrlsetfade 0;
									(_display displayctrl 1500) ctrlcommit 0.2;
								};
							};
						};
					};
				};
			};

			false
		} else {

			
			if (isnil "BIS_fnc_configviewer_keyList") then {BIS_fnc_configviewer_keyList = []};

			
			if (_key in [0x1C,0x9C,0x0E]  && (count BIS_fnc_configviewer_keyList isEqualTo 0) ) then {
				if (_key == 0x0E) then {

					
					if (count BIS_fnc_configviewer_path > 0) then {
						BIS_fnc_configviewer_selected = BIS_fnc_configviewer_path select (count BIS_fnc_configviewer_path - 1);
						BIS_fnc_configviewer_path resize ((count BIS_fnc_configviewer_path - 1) max 0);
					};
					["treeRefresh",[]] spawn bis_fnc_configViewer;
				} else {

					
					['buttonClick',_this] spawn bis_fnc_configviewer;
				};

				true
			} else {


				
				_alphabet = ["_","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","_","1","2","3","4","5","6","7","8","9","0"];
				_alphabetUni = [95,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,95, 49,50,51,52,53,54,55,56,57,48];
				_alphabetDik = [0x39,0x1E,0x30,0x2E,0x20,0x12,0x21,0x22,0x23,0x17,0x24,0x25,0x26,0x32,0x31,0x18,0x19,0x10,0x13,0x1F,0x14,0x16,0x2F,0x11,0x2D,0x15,0x2C,0x0C,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B];
				_keyId = _alphabetDik find _key;
				if (_keyId >= 0) then  {
					_keyUni = _alphabetUni select _keyId;
					_keyText = _alphabet select _keyId;

					_textSearch = if (_isClasses) then {(_display displayctrl 1001)} else {(_display displayctrl 1002)};
					_textSearch ctrlsettext ((ctrltext _textSearch) + _keyText);

					BIS_fnc_configviewer_keyList set [count BIS_fnc_configviewer_keyList,_keyUni];

					
					[(_display displayctrl 1500),_isClasses] spawn {
						disableserialization;
						with uinamespace do {
							_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
							_isClasses = _this select 1;
							_listbox = if (_isClasses) then {(_display displayctrl 1500)} else {(_display displayctrl 1501)};
							_keyCount = count BIS_fnc_configviewer_keyList;

							uisleep 0.5; 
							if (count BIS_fnc_configviewer_keyList != _keyCount) exitwith {};

							startloadingscreen [""];
							_matchMax = 0;
							for "_i" from 0 to (lbsize _listbox - 1) do {
								_lbValue = _listbox lbvalue _i;
								if (_lbValue == count BIS_fnc_configviewer_path) then {
									_meta = (uinamespace getvariable "BIS_fnc_configviewer_listMeta") select _i;
									_metaArray = _meta select 1;
									_metaArrayCount = count _metaArray;

									_match = 0;
									_stop = false;
									{
										if (_metaArrayCount > _foreachindex) then {
											if (_x == (_metaArray select _foreachindex)) then {
												_match = _match + 1
											} else {
												_stop = true;
											};
										};
										if (_stop) exitwith {};
									} foreach BIS_fnc_configviewer_keyList;

									
									if (_match > _matchMax) then {
										_matchMax = _match;
										_listbox lbsetcursel _i;
										
									};
								};
							};

							endloadingscreen;
							
							uisleep 5; 
							if (count BIS_fnc_configviewer_keyList != _keyCount) exitwith {};
							BIS_fnc_configviewer_keyList = [];
							(_display displayctrl 1001) ctrlsettext "";
							(_display displayctrl 1002) ctrlsettext "";
						};
					};
					true 
				} else {
					if(_key in [0x0E,0xD3])then
					{
						_textSearch = if (_isClasses) then {(_display displayctrl 1001)} else {(_display displayctrl 1002)};
						_textSearch ctrlsettext ( (ctrltext _textSearch) select [0,(count (ctrltext _textSearch)) - 1] );
						BIS_fnc_configviewer_keyList deleteAt (count BIS_fnc_configviewer_keyList - 1);
					};
					false
				};
			};
		};
	};


	
	
	case "paramLbSelChanged": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		_lbId = lbcursel (_display displayctrl 1501);
		_lbData = (_display displayctrl 1501) lbData _lbId;

		
		_text = ["textPath",_this] call bis_fnc_configviewer;
		(_display displayctrl 1400) ctrlsettext _text;

		_configPath = ["composePath",_this] call bis_fnc_configviewer;
		_configValue = [_configPath,_lbData,""] call bis_fnc_returnconfigentry;

		_enable = switch (typename _configValue) do {
			case (typename ""): {
				_configValueArray = toarray tolower _configValue;
				_configValueCount = count _configValueArray;

				
				if (count _configValueArray > 3) then {
					(
						_configValueArray select (_configValueCount - 3) == 112
						&&
						_configValueArray select (_configValueCount - 2) == 97
						&&
						_configValueArray select (_configValueCount - 1) == 97
					)
				} else {
					false
				};
			};
			case (typename []): {
				{typename _x == typename 0} count _configValue == 4
			};
			default {false};
		};

		(_display displayctrl 2401) ctrlenable _enable;
		(_display displayctrl 2401) ctrlsettext format [localize "STR_A3_RscDisplayConfigViewer_ButtonPreviewParam",_lbData];
	};

	
	
	case "previewClass": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		_lbId = lbcursel (_display displayctrl 1501);
		_lbValue = (_display displayctrl 1501) lbvalue _lbId;
		_lbData = (_display displayctrl 1501) lbData _lbId;

		_path = (["arrayPath",_this] call bis_fnc_configviewer) select 0;
		_pathCount = count _path;
		_class = "";
		_pos = screentoworld [0.5,0.5];
		_obj = objnull;

		_cfgVehiclesId = _path find "CfgVehicles";
		if (_cfgVehiclesId >= 0 && _pathCount > (_cfgVehiclesId + 1)) then {
			_class = _path select (_cfgVehiclesId + 1);
			_obj = createvehicle [_class,_pos,[],0,"none"];
		};

		_cfgWeaponsId = _path find "CfgWeapons";
		if (_cfgWeaponsId >= 0 && _pathCount > (_cfgWeaponsId + 1)) then {
			_class = _path select (_cfgWeaponsId + 1);
			_obj = createvehicle ["weaponholder",_pos,[],0,"none"];
			_obj addweaponcargo [_class,1];
			{
				_obj addmagazinecargo [_x,1];
			} foreach getarray (configfile >> "CfgWeapons" >> _class >> "magazines");
		};


		_obj setdir (direction player - 90);
		_obj setpos _pos;
		player reveal _obj;
		with missionnamespace do {
			if (!isnil "BIS_fnc_configviewer_preview") then {deletevehicle BIS_fnc_configviewer_preview;};
			BIS_fnc_configviewer_preview = _obj;
		};
	};

	
	
	case "previewParam": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		_lbId = lbcursel (_display displayctrl 1501);
		_lbValue = (_display displayctrl 1501) lbvalue _lbId;
		_lbData = (_display displayctrl 1501) lbData _lbId;

		_configPath = ["composePath",_this] call bis_fnc_configviewer;
		_configValue = [_configPath,_lbData] call bis_fnc_returnconfigentry;

		switch (typename _configValue) do {

			case (typename 0): {

			};

			case (typename ""): {
				_configValueArray = toarray tolower _configValue;
				_configValueCount = count _configValueArray;

				
				if (
					_configValueArray select (_configValueCount - 3) == 112
					&&
					_configValueArray select (_configValueCount - 2) == 97
					&&
					_configValueArray select (_configValueCount - 1) == 97
				) then {
					[
						parsetext format ["<img align='center' shadow='0' image='%1' size='%2' /> ",_configValue,safezoneH * 12],
						str _configValue,
						nil,
						nil,
						_display
					] spawn bis_fnc_guimessage;
				};
			};

			case (typename []): {
				if ({typename _x == typename 0} count _configValue == 4) then {
					[
						parsetext format (["<img align='center' shadow='0' size='%1' image='#(argb,8,8,3)color(%2,%3,%4,%5)' size='10' /> ",safezoneH * 20] + _configValue),
						str _configValue,
						nil,
						nil,
						_display
					] spawn bis_fnc_guimessage;
				};
			};

		};
	};

	
	
	case "composePath": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		private ["_lbData","_path","_configPath"];
		_lbId = lbcursel (_display displayctrl 1500);
		_lbValue = (_display displayctrl 1500) lbvalue _lbId;
		_lbData = (_display displayctrl 1500) lbData _lbId;

		_path = +BIS_fnc_configviewer_path;
		_path resize _lbValue;
		_configPath = configfile;
		_configPath = if (count _path > 0) then {
			{
				if (_foreachindex == 0) then {
					if (isnil "_x") then {
						_configPath = BIS_fnc_configviewer_root;
					} else {
						_configPath = call compile _x;
					};
				} else {
					_configPath = _configPath >> _x;
				};
			} foreach _path;
			_configPath >> _lbData
		} else {
			call compile _lbData;
		};
		_configPath
	};

	
	
	case "textPath": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		private ["_lbData","_path","_text","_textType"];
		_textType = _this param [2,false];
		_lbId = lbcursel (_display displayctrl 1500);
		_lbValue = (_display displayctrl 1500) lbvalue _lbId;
		_lbData = (_display displayctrl 1500) lbData _lbId;

		_path = +BIS_fnc_configviewer_path;
		_path resize _lbValue;
		_path = _path - [nil];
		if (typename BIS_fnc_configviewer_root != typename false) then {
			_path = (BIS_fnc_configviewer_root call bis_fnc_configPath) + _path;
		};

		_text = "";
		_text = if (count _path > 0) then {
			{
				if (_foreachindex == 0) then {
					if (_textType) then {
						if (_x == "configfile") then {_text = ""};
						if (_x == "missionconfigfile") then {_text = "mission"};
						if (_x == "campaignconfigfile") then {_text = "campaign"};
					} else {
						_text = _x;
					};
				} else {
					if !(isnil "_x") then {
						if (_textType) then {_text = _text + "/" + _x} else {_text = _text + " >> " + str _x};
					};
				};
			} foreach _path;
			if (_textType) then {_text + "/" + _lbData} else {_text + " >> " + str _lbData};
		} else {
			_lbData;
		};

		
		_lbIdParam = lbcursel (_display displayctrl 1501);
		_lbDataParam = (_display displayctrl 1501) lbData _lbIdParam;
		if (!_textType && _lbDataParam != "") then {
			_text = _text + " >> " + str _lbDataParam;
		};

		_text
	};

	
	
	case "arrayPath": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		private ["_lbData","_path","_array"];
		_lbId = lbcursel (_display displayctrl 1500);
		_lbValue = (_display displayctrl 1500) lbvalue _lbId;
		_lbData = (_display displayctrl 1500) lbData _lbId;

		_path = +BIS_fnc_configviewer_path;
		_path resize _lbValue;
		_array = [];
		_array = if (count _path > 0) then {
			{
				if (_foreachindex == 0) then {
					if (isnil "_x") then {
						_array = [];
					} else {
						_array = [_x];
					};
				} else {
					_array = _array + [_x];
				};
			} foreach _path;
			_array + [_lbData]
		} else {
			[_lbData];
		};
		[_array,_lbData]
	};

	
	
	case "bookmarkButtonClick": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		_lbId = lbcursel (_display displayctrl 1502);
		_bookmarks = +(profilenamespace getvariable ["BIS_fnc_configviewer_bookmarks",[]]);
		if (_lbId == 0) then {

			
			_text = ["textPath",_this + [true]] call bis_fnc_configviewer;
			(_display displayctrl 1502) lbadd _text;

			_array = ["arrayPath",_this] call bis_fnc_configviewer;
			profilenamespace setvariable ["BIS_fnc_configviewer_bookmarks",_bookmarks + [_array]];
		} else {

			
			_lbId = _lbId - 1;
			if (_lbId < count _bookmarks) then {
				_path = _bookmarks select _lbId;
				BIS_fnc_configviewer_path = _path select 0;
				BIS_fnc_configviewer_selected = _path select 1;
				if (typename BIS_fnc_configviewer_selected == typename []) then {BIS_fnc_configviewer_selected = call compile (BIS_fnc_configviewer_selected select 0);};
				["treeRefresh",[]] call bis_fnc_configViewer;
				ctrlsetfocus (_display displayctrl 1500);
				(_display displayctrl 1502) lbsetcursel -1;
			};
		};
	};

	
	
	case "bookmarkKeyDown": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];
		_key = _this select 1;

		switch _key do {

			
			case 0x9C;
			case 0x1C: {
				["bookmarkButtonClick",_this] spawn bis_fnc_configviewer;
			};

			
			case 0xD3: {
				_lbId = (lbcursel (_display displayctrl 1502));
				if (_lbId > 2) then { 
					(_display displayctrl 1502) lbdelete _lbId;
					_bookmarks = +(profilenamespace getvariable ["BIS_fnc_configviewer_bookmarks",[]]);
					if (_lbId <= count _bookmarks) then {
						_bookmarks set [_lbId-1,-1];
						_bookmarks = _bookmarks - [-1];
						profilenamespace setvariable ["BIS_fnc_configviewer_bookmarks",_bookmarks];
					};
				};
			};
		};
		false
	};

	
	
	case "buttonOK": {
		_display = uinamespace getvariable ["BIS_fnc_configviewer_display",displaynull];

		_lbId = lbcursel (_display displayctrl 1501);
		_lbValue = (_display displayctrl 1501) lbvalue _lbId;
		_lbData = (_display displayctrl 1501) lbData _lbId;

		BIS_fnc_configviewer_returnedClass = [
			["composePath",_this] call bis_fnc_configviewer,
			_lbData
		];
		_display closedisplay 2;
	};
};
