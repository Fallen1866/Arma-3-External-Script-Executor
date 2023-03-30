#line 0 "/temp/bin/A3/Ui_f/scripts/GUI/RscDisplayGameOptions.sqf"
_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do {

	
	case "onLoad": {

		
		private ["_display"];

		
		_display = _params select 0;

		
		(_display displayctrl 601) ctrlSetText profileName;
		[_display, 601] call (uinamespace getvariable 'BIS_fnc_setIDCStreamFriendly');

		
		["RscDisplayGameOptions",["RscText","RscTitle","CA_TextLanguage"],["PlayersName"]] call bis_fnc_toUpperDisplayTexts;
		
		
		_difficultyFlags = configFile >> "RscDisplayGameOptions" >> "controls" >> "DifficultyGroup" >> "controls" >> "DiffOptionsGroup" >> "controls";
		
		for "_i" from 0 to (count _difficultyFlags - 1) do
		{
			_current = _difficultyFlags select _i;
			
			if( configName(inheritsFrom(_current)) == "RscText" ) then
			{
				_idc = getnumber (_current >> "idc");
				_control = _display displayctrl _idc;
				_control ctrlSetText (toUpper (ctrlText _control));
			};
		};
		

		
		_ButtonGeneral = _display displayctrl 2402;
		_ButtonGeneral ctrladdeventhandler ["buttonclick","with uinamespace do {['general',_this,'RscDisplayGameOptions'] call RscDisplayGameOptions_script};"];		

		
		_control = _display displayctrl 304;
		_control ctrladdeventhandler ["buttonclick","with uinamespace do {['difficulty',_this,'RscDisplayGameOptions'] call RscDisplayGameOptions_script};"];

		
		_control = _display displayctrl 2404;
		_control ctrladdeventhandler ["buttonclick","with uinamespace do {['colors',_this,'RscDisplayGameOptions'] call RscDisplayGameOptions_script};"];

		
		_ColorsGroup = _display displayctrl 2301;
		_ColorsGroup ctrlenable false;
		_ColorsGroup ctrlshow false;

		
		_DifficultyGroup = _display displayctrl 2302;
		_DifficultyGroup ctrlenable false;
		_DifficultyGroup ctrlshow false;

		_listTags = _display displayctrl 1504;
		_listVariables = _display displayctrl 1505;
		_listPresets = _display displayctrl 1506;
		_sliderColorR =	_display displayctrl 1903;
		_sliderColorG =	_display displayctrl 1904;
		_sliderColorB =	_display displayctrl 1905;
		_sliderColorA =	_display displayctrl 1906;
		
		_buttonOK = _display displayctrl 999;
		
		RscDisplayGameOptions_buttonOK_activated = false;

		{
			_x ctrladdeventhandler [
				"SliderPosChanged",
				format ["with uinamespace do {['sliderPosChanged', [_this, %1, true], 'RscDisplayGameOptions'] call RscDisplayGameOptions_script};", _forEachIndex]
			];
		} foreach [
			_sliderColorR,
			_sliderColorG,
			_sliderColorB,
			_sliderColorA
		];

		_listTags ctrladdeventhandler [
			"LBSelChanged",
			"with uinamespace do {['listTags_LBSelChanged', _this, 'RscDisplayGameOptions'] call RscDisplayGameOptions_script};"
		];

		_listVariables ctrladdeventhandler [
			"LBSelChanged",
			"with uinamespace do {['listVariables_LBSelChanged', _this, 'RscDisplayGameOptions'] call RscDisplayGameOptions_script};"
		];
		_listPresets ctrladdeventhandler [
			"LBSelChanged",
			"with uinamespace do {['listPresets_LBSelChanged', _this, 'RscDisplayGameOptions'] call RscDisplayGameOptions_script};"
		];

		_buttonOK ctrladdeventhandler [
			"buttonclick",
			"with uinamespace do {['buttonOK_action', _this, 'RscDisplayGameOptions'] call RscDisplayGameOptions_script};"
		];


		
		RscDisplayGameOptions_currentNames = [];
		RscDisplayGameOptions_currentValues = [];
		_CfgUIColors = configfile >> "CfgUIColors";
		for "_i" from 0 to (count _CfgUIColors - 1) do {
			_current = _CfgUIColors select _i;
			if (isclass _current && {getnumber (_current >> "scope") == 2 || !isnumber (_current >> "scope")}) then {
				_currentName = configname _current;

				
				_displayName = _current call bis_fnc_displayName;
				_lbAdd = _listTags lbadd _displayName;
				_listTags lbsetdata [_lbAdd,_currentName];

				
				_cfgVariables = _current >> "variables";
				for "_v" from 0 to (count _cfgVariables - 1) do {
					_varName = _cfgVariables select _v;
					if (isclass _varName) then {
						_var = _currentName + "_" + configname _varName;
						_varR = _var + "_R";
						_varG = _var + "_G";
						_varB = _var + "_B";
						_varA = _var + "_A";
						_varPreset = _var + "_preset";

						RscDisplayGameOptions_currentNames set [count RscDisplayGameOptions_currentNames,_varR];
						RscDisplayGameOptions_currentNames set [count RscDisplayGameOptions_currentNames,_varG];
						RscDisplayGameOptions_currentNames set [count RscDisplayGameOptions_currentNames,_varB];
						RscDisplayGameOptions_currentNames set [count RscDisplayGameOptions_currentNames,_varA];
						RscDisplayGameOptions_currentNames set [count RscDisplayGameOptions_currentNames,_varPreset];

						RscDisplayGameOptions_currentValues set [count RscDisplayGameOptions_currentValues,profilenamespace getvariable [_varR,0]];
						RscDisplayGameOptions_currentValues set [count RscDisplayGameOptions_currentValues,profilenamespace getvariable [_varG,0]];
						RscDisplayGameOptions_currentValues set [count RscDisplayGameOptions_currentValues,profilenamespace getvariable [_varB,0]];
						RscDisplayGameOptions_currentValues set [count RscDisplayGameOptions_currentValues,profilenamespace getvariable [_varA,1]];
						RscDisplayGameOptions_currentValues set [count RscDisplayGameOptions_currentValues,profilenamespace getvariable [_varPreset,""]];
					};
				};
			};
		};

		if (lbcursel _listTags < 0) then
		{
			_listTags lbsetcursel (profilenamespace getvariable ["RscDisplayGameOptions_listTagsCurSel",0]);
		};
		
		
		_ButtonGeneral ctrlSetBackgroundColor [1,1,1,1];
		_ButtonGeneral ctrlSetTextColor [0,0,0,1];
		uiNameSpace setvariable ["RscDisplayGameOptions_SelectedTab", "GENERAL"];

	}; 


	
	case "buttonOK_action":
	{
			disableserialization;
			_ctrl = _params select 0;
			_display = ctrlparent _ctrl;

			
			
			_warning = [true];

			if (_warning select 0) then {
				RscDisplayGameOptions_buttonOK_activated = true;
				

				{
					[configfile >> (_x getvariable ["BIS_fnc_initDisplay_configClass",confignull]),_x] call bis_fnc_displayColorSet;
				} foreach GUI_displays;

				saveProfileNamespace;
			};

			
			ctrlactivate (_display displayctrl 1);
	};


	
	case "listPresets_LBSelChanged":
	{
		private ["_display","_lbId","_lbData","_cfgPreset","_colorBackground","_colorR","_colorG","_colorB","_colorA","_sliderList","_valueList"];
		_listPresets = _params select 0;
		_lbId = _params select 1;
		_display = ctrlParent _listPresets;
		_lbData = _listPresets lbdata _lbId;

		_sliderColorR =	_display displayctrl 1903;
		_sliderColorG =	_display displayctrl 1904;
		_sliderColorB =	_display displayctrl 1905;
		_sliderColorA =	_display displayctrl 1906;
		_listTags = _display displayctrl 1504;
		_listVariables = _display displayctrl 1505;

		_tag = _listTags lbdata (lbcursel _listTags);
		_varName = _listVariables lbdata (lbcursel _listVariables);
		_var = _tag + "_" + _varName + "_";

		_cfgPresetVariables = configfile >> "CfgUIColors" >> _tag >> "Presets" >> _lbData >> "Variables";
		_colorBackground = getarray (_cfgPresetVariables >> _varName);
		if (count _colorBackground == 4) then {

			_colorR = _colorBackground select 0;
			_colorG = _colorBackground select 1;
			_colorB = _colorBackground select 2;
			_colorA = _colorBackground select 3;
		} else {
			_colorR = profilenamespace getvariable (_var + "R");
			_colorG = profilenamespace getvariable (_var + "G");
			_colorB = profilenamespace getvariable (_var + "B");
			_colorA = profilenamespace getvariable (_var + "A");
		};

		if (typename _colorR == typename "") then {_colorR = parsenumber _colorR};
		if (typename _colorG == typename "") then {_colorG = parsenumber _colorG};
		if (typename _colorB == typename "") then {_colorB = parsenumber _colorB};
		if (typename _colorA == typename "") then {_colorA = parsenumber _colorA};

		_sliderColorR slidersetposition (_colorR)*10;
		_sliderColorG slidersetposition (_colorG)*10;
		_sliderColorB slidersetposition (_colorB)*10;
		_sliderColorA slidersetposition (_colorA)*10;

		
		_sliderList = [_sliderColorR, _sliderColorG, _sliderColorB, _sliderColorA];
		_valueList = [_colorR, _colorG, _colorB, _colorA];

		{
			["sliderPosChanged", [[_sliderList select _forEachIndex, _x * 10], _forEachIndex, false], "RscDisplayGameOptions"] call RscDisplayGameOptions_script;

		} foreach _valueList;

		
		_cfgVariables = configfile >> "CfgUIColors" >> _tag >> "Variables";
		_n = 0;
		for "_v" from 0 to (count _cfgVariables - 1) do {
			_relatedVarClass = _cfgVariables select _v;
			if (isclass _relatedVarClass) then {
				_relatedVarName = configname _relatedVarClass;
				_relatedVar = _tag + "_" + _relatedVarName + "_";
				_relatedVarColor = getarray (_cfgPresetVariables >> _relatedVarName);
				if (count _relatedVarColor == 4) then {
					_colorR = _relatedVarColor select 0;
					_colorG = _relatedVarColor select 1;
					_colorB = _relatedVarColor select 2;
					_colorA = _relatedVarColor select 3;
					if (typename _colorR == typename "") then {_colorR = parsenumber _colorR};
					if (typename _colorG == typename "") then {_colorG = parsenumber _colorG};
					if (typename _colorB == typename "") then {_colorB = parsenumber _colorB};
					if (typename _colorA == typename "") then {_colorA = parsenumber _colorA};
					profileNameSpace setvariable [_relatedVar + "R",_colorR];
					profileNameSpace setvariable [_relatedVar + "G",_colorG];
					profileNameSpace setvariable [_relatedVar + "B",_colorB];
					profileNameSpace setvariable [_relatedVar + "A",_colorA];

					
					_listVariables lbsetpicture [
						_n,
						format ["#(argb,8,8,3)color(%1,%2,%3,%4)",_colorR,_colorG,_colorB,_colorA]
					];
				};
				profileNameSpace setvariable [_relatedVar + "preset",_lbData];
				_n = _n + 1;
			};
		};

		
		[configfile >> "RscDisplayGameOptions", _display] call bis_fnc_displayColorSet;
		
		
		_ColorsButton = _display displayctrl 2404;
		if(uiNameSpace getVariable ["RscDisplayGameOptions_SelectedTab", "GENERAL"] == "COLORS") then
		{
			_ColorsButton ctrlSetBackgroundColor [1,1,1,1];
			_ColorsButton ctrlSetTextColor [0,0,0,1];
		}
		else
		{
			_ColorsButton ctrlSetBackgroundColor [0,0,0,1];
			_ColorsButton ctrlSetTextColor [1,1,1,1];
		};

		
		profileNameSpace setvariable [_var + "preset",_lbData];
		
	};


	
	case "listVariables_LBSelChanged":
	{
		_listVariables = _params select 0;
		_display = ctrlParent _listVariables;
		_listTags = _display displayctrl 1504;
		_listPresets = _display displayctrl 1506;
		_previewCtrl = _display displayctrl 1201;
		_previewBackgroundCtrl = _display displayctrl 1200;
		lbclear _listPresets;
		_tag = _listTags lbdata (lbcursel _listTags);
		_varName = _listVariables lbdata (lbcursel _listVariables);
		_var = _tag + "_" + _varName + "_";
		_presetName = profileNameSpace getvariable [_var + "preset","#"];
		_cfgVariable = configfile >> "CfgUIColors" >> _tag >> "Variables" >> _varName;

		
		_previewBackground = [_cfgVariable,"previewBackground"] call BIS_fnc_returnConfigEntry;
		_previewBackgroundCtrl ctrlsettext "";
		switch (typename _previewBackground) do {
			case (typename 1): {

			};
			case (typename ""): {
				_previewBackgroundCtrl ctrlsettext _previewBackground;
			};
		};

		
		_preview = [_cfgVariable,"preview"] call BIS_fnc_returnConfigEntry;
		_previewCtrl ctrlsettext "";

		_previewPath = switch (typename _preview) do {
			case (typename 1): {
				if (_preview == 1) then {"bcg"} else {""};
			};
			case (typename ""): {

				_w = (_cfgVariable >> "previewW") call BIS_fnc_parseNumberSafe;
				_h = (_cfgVariable >> "previewH") call BIS_fnc_parseNumberSafe;
				if (_w > 0 && _h > 0) then {
					_posBcg = ctrlposition _previewBackgroundCtrl;
					_x = (_posBcg select 0) + (_posBcg select 2) / 2;
					_y = (_posBcg select 1) + (_posBcg select 3) / 2;
					_previewCtrl ctrlsetposition [
						_x - (_w / 2),
						_y - (_h / 2),
						_w,
						_h
					];
				};

				_previewCtrl ctrlsettext _preview;
				_preview
			};
			default {""};
		};

		uiNamespace setVariable ["RscDisplayGameOptions_previewPath", _previewPath];

		
		_lbAdd = _listPresets lbadd (localize "str_a3_rscdisplayoptionslayout_custom");
		_listPresets lbsetdata [_lbAdd,""];
		_listPresets lbsetcursel 0;
		_CfgUIColors = configfile >> "CfgUIColors" >> _tag >> "Presets";

		for "_i" from 0 to (count _CfgUIColors - 1) do {
			_current = _CfgUIColors select _i;
			if (isclass _current) then {
				_currentVar = _current >> "Variables" >> _varName;
				if (isarray _currentVar) then {

					_currentName = configname _current;
					_default = getnumber (_current >> "default");

					
					_displayName = _current call bis_fnc_displayName;
					if (_default > 0) then {
						_displayName = format ["%1 (%2)",_displayName,localize "str_disp_default"];
						if (_presetName == "#") then {_presetName = _currentName;}; 
					};
					_lbAdd = _listPresets lbadd _displayName;
					_listPresets lbsetdata [_lbAdd,_currentName];
				};
			};
		};
		
		lbsort _listPresets;
		for "_i" from 0 to (lbsize _listPresets - 1) do {
			if ((_listPresets lbdata _i) == _presetName) then {_listPresets lbsetcursel _i;};
		};
	};


	
	case "listTags_LBSelChanged":
	{
		_listTags = _params select 0;
		_display = ctrlParent _listTags;
		_listVariables = _display displayctrl 1505;
		lbclear _listVariables;
		_cursel = _params select 1;
		profilenamespace setvariable ["RscDisplayGameOptions_listTagsCurSel",_cursel];
		_tag = _listTags lbdata _cursel;
		_cfgVariables = configfile >> "CfgUIColors" >> _tag >> "Variables";

		for "_i" from 0 to (count _cfgVariables - 1) do {
			_current = _cfgVariables select _i;

			if (isclass _current) then {
				_currentName = configname _current;

				
				_displayName = _current call bis_fnc_displayName;
				_lbAdd = _listVariables lbadd _displayName;
				_listVariables lbsetdata [_lbAdd,_currentName];

				
				_colorVar = _tag + "_" + _currentName + "_";
				_color = format [
					"#(argb,8,8,3)color(%1,%2,%3,%4)",
					profilenamespace getvariable [_colorVar + "R",1],
					profilenamespace getvariable [_colorVar + "G",0],
					profilenamespace getvariable [_colorVar + "B",1],
					profilenamespace getvariable [_colorVar + "A",1]
				];
				_listVariables lbsetpicture [_lbAdd,_color];
			};
		};
		_listVariables lbsetcursel 0;
	};


	
	case "sliderPosChanged":
	{
		_params = _this select 1;
		_display = ctrlParent ((_params select 0) select 0);
		_sliderPos = (_params select 0) select 1;
		_sliderPos = _sliderPos / 10;
		_sliderId = _params select 1;
		_manual = _params select 2;

		_listTags = _display displayctrl 1504;
		_listVariables = _display displayctrl 1505;
		_listPresets = _display displayctrl 1506;
		_sliderColorR =	_display displayctrl 1903;
		_sliderColorG =	_display displayctrl 1904;
		_sliderColorB =	_display displayctrl 1905;
		_sliderColorA =	_display displayctrl 1906;
		_valueColorR = _display displayctrl 1013;
		_valueColorG = _display displayctrl 1014;
		_valueColorB = _display displayctrl 1015;
		_valueColorA = _display displayctrl 1016;
		_previewCtrl = _display displayctrl 1201;

		_tag = _listTags lbdata (lbcursel _listTags);
		_varName = _listVariables lbdata (lbcursel _listVariables);
		_var = _tag + "_" + _varName + "_";

		_varList = [
			(_var + "R"),
			(_var + "G"),
			(_var + "B"),
			(_var + "A")
		];

		_valueList = [
			_valueColorR,
			_valueColorG,
			_valueColorB,
			_valueColorA
		];

		
		if (_manual && lbcursel _listPresets > 0) then {

			
			_slider = [
				_sliderColorR,
				_sliderColorG,
				_sliderColorB,
				_sliderColorA
			] select _sliderID;

			[_slider,_sliderPos * 10] spawn {
				disableserialization;
				_this call bis_fnc_log;
				(_this select 0) slidersetposition (_this select 1);
			};
			_listPresets lbsetcursel 0;
		};

		
		_valueText = (round (_sliderPos * 100));
		_value = _valueList select _sliderId;
		_value ctrlsettext (str _valueText + "%");

		
		profilenamespace setvariable [_varList select _sliderId,_sliderPos];

		
		_preview = uiNamespace getvariable "RscDisplayGameOptions_previewPath";
		if (_preview != "") then {
			if (_preview == "bcg") then
			{
				[configfile >> "RscDisplayGameOptions", _display] call bis_fnc_displayColorSet;
				
				
				_ColorsButton = _display displayctrl 2404;
				if(uiNameSpace getVariable ["RscDisplayGameOptions_SelectedTab", "GENERAL"] == "COLORS") then
				{
					_ColorsButton ctrlSetBackgroundColor [1,1,1,1];
					_ColorsButton ctrlSetTextColor [0,0,0,1];
				}
				else
				{
					_ColorsButton ctrlSetBackgroundColor [0,0,0,1];
					_ColorsButton ctrlSetTextColor [1,1,1,1];
				};				
			}
			else
			{
				
				[_previewCtrl, _varList] spawn {
					disableserialization;
					_previewCtrl = _this select 0;
					_varList = _this select 1;
					with uinamespace do {
						_previewCtrl ctrlsettextcolor [
							profilenamespace getvariable [_varList select 0,1],
							profilenamespace getvariable [_varList select 1,0],
							profilenamespace getvariable [_varList select 2,1],
							profilenamespace getvariable [_varList select 3,1]
						];
						_previewCtrl ctrlcommit 0;
					};
				};
			};
		};

		
		_listVariables lbsetpicture [
			lbcursel _listVariables,
			format [
				"#(argb,8,8,3)color(%1,%2,%3,%4)",
				profilenamespace getvariable [_varList select 0,1],
				profilenamespace getvariable [_varList select 1,0],
				profilenamespace getvariable [_varList select 2,1],
				profilenamespace getvariable [_varList select 3,1]
			]
		];
	};


	
	case "general":
	{
		uiNameSpace setvariable ["RscDisplayGameOptions_SelectedTab", "GENERAL"];

		_GeneralButton = _params select 0;
		_display = ctrlparent _GeneralButton;

		_GeneralGroup = _display displayctrl 2300;
		_ColorsGroup = _display displayctrl 2301;
		_DifficultyGroup = _display displayctrl 2302;

		
		_GeneralGroup ctrlenable true;
		_GeneralGroup ctrlshow true;

		
		_DifficultyGroup ctrlenable false;
		_DifficultyGroup ctrlshow false;

		
		_ColorsGroup ctrlenable false;
		_ColorsGroup ctrlshow false;

		
		_DifficultyButton = _display displayctrl 304;
		_ColorsButton = _display displayctrl 2404;
		_LayoutButton = _display displayctrl 2405;
		
		_GeneralButton ctrlSetBackgroundColor [1,1,1,1];
		_GeneralButton ctrlSetTextColor [0,0,0,1];
		
		ctrlSetFocus _GeneralButton;
		
		_DifficultyButton ctrlSetBackgroundColor [0,0,0,1];
		_DifficultyButton ctrlSetTextColor [1,1,1,1];
		
		_ColorsButton ctrlSetBackgroundColor [0,0,0,1];
		_ColorsButton ctrlSetTextColor [1,1,1,1];
		
		_LayoutButton ctrlSetBackgroundColor [0,0,0,1];
		_LayoutButton ctrlSetTextColor [1,1,1,1];
	};

	
	case "difficulty":
	{
		uiNameSpace setvariable ["RscDisplayGameOptions_SelectedTab", "DIFFICULTY"];

		_DifficultyButton = _params select 0;
		_display = ctrlparent _DifficultyButton;

		_GeneralGroup = _display displayctrl 2300;
		_ColorsGroup = _display displayctrl 2301;
		_DifficultyGroup = _display displayctrl 2302;

		
		_DifficultyGroup ctrlenable true;
		_DifficultyGroup ctrlshow true;

		
		_GeneralGroup ctrlenable false;
		_GeneralGroup ctrlshow false;

		
		_ColorsGroup ctrlenable false;
		_ColorsGroup ctrlshow false;

		
		_GeneralButton = _display displayctrl 2402;
		_ColorsButton = _display displayctrl 2404;
		_LayoutButton = _display displayctrl 2405;
		
		_DifficultyButton ctrlSetBackgroundColor [1,1,1,1];
		_DifficultyButton ctrlSetTextColor [0,0,0,1];
		
		
		
		_DiffOptionsGroup = _display displayctrl 1520;
		ctrlSetFocus _DiffOptionsGroup;
		
		_GeneralButton ctrlSetBackgroundColor [0,0,0,1];
		_GeneralButton ctrlSetTextColor [1,1,1,1];
		
		_ColorsButton ctrlSetBackgroundColor [0,0,0,1];
		_ColorsButton ctrlSetTextColor [1,1,1,1];
		
		_LayoutButton ctrlSetBackgroundColor [0,0,0,1];
		_LayoutButton ctrlSetTextColor [1,1,1,1];
	};

	
	case "colors":
	{	
		uiNameSpace setvariable ["RscDisplayGameOptions_SelectedTab", "COLORS"];

		_ColorsButton = _params select 0;
		_display = ctrlparent _ColorsButton;

		_GeneralGroup = _display displayctrl 2300;
		_ColorsGroup = _display displayctrl 2301;
		_DifficultyGroup = _display displayctrl 2302;

		
		_ColorsGroup ctrlenable true;
		_ColorsGroup ctrlshow true;

		
		_GeneralGroup ctrlenable false;
		_GeneralGroup ctrlshow false;

		
		_DifficultyGroup ctrlenable false;
		_DifficultyGroup ctrlshow false;

		
		_GeneralButton = _display displayctrl 2402;
		_DifficultyButton = _display displayctrl 304;
		_LayoutButton = _display displayctrl 2405;
		
		_ColorsButton ctrlSetBackgroundColor [1,1,1,1];
		_ColorsButton ctrlSetTextColor [0,0,0,1];
		
		ctrlSetFocus _ColorsButton;
		
		_GeneralButton ctrlSetBackgroundColor [0,0,0,1];
		_GeneralButton ctrlSetTextColor [1,1,1,1];
		
		_DifficultyButton ctrlSetBackgroundColor [0,0,0,1];
		_DifficultyButton ctrlSetTextColor [1,1,1,1];
		
		_LayoutButton ctrlSetBackgroundColor [0,0,0,1];
		_LayoutButton ctrlSetTextColor [1,1,1,1];
	};


	case "onUnload": {

		if(isStreamFriendlyUIEnabled) then
		{
			{
				_displayIDD = ctrlIDD _x;

				
				if( (_displayIDD == 0) || (_displayIDD == 49) ) then
				{
					(_x displayctrl 109) ctrlSetFade 1; 
					(_x displayctrl 109) ctrlCommit 0;
				};

				
				if( (_displayIDD == 2) || (_displayIDD == 43) ) then
				{
					(_x displayctrl 8434) ctrlSetFade 1;
					(_x displayctrl 8434) ctrlCommit 0;
				};

				
				if( (_displayIDD == 12) || (_displayIDD == 37) || (_displayIDD == 52) || (_displayIDD == 53) ) then
				{
					(_x displayctrl 111) ctrlSetFade 1;
					(_x displayctrl 111) ctrlCommit 0;
				};
			}
			foreach (uinamespace getvariable "gui_displays");
		}
		else
		{
			
			{
				_displayIDD = ctrlIDD _x;

				
				if( (_displayIDD == 0) || (_displayIDD == 49) ) then
				{
					(_x displayctrl 109) ctrlSetText profileName;
					(_x displayctrl 109) ctrlSetFade 0;
					(_x displayctrl 109) ctrlCommit 0;
				};

				
				if( (_displayIDD == 2) || (_displayIDD == 43) ) then
				{
					(_x displayctrl 8434) ctrlSetText profileName;
					(_x displayctrl 8434) ctrlSetFade 0;
					(_x displayctrl 8434) ctrlCommit 0;
				};

				
				if( (_displayIDD == 12) || (_displayIDD == 37) || (_displayIDD == 52) || (_displayIDD == 53) ) then
				{
					(_x displayctrl 111) ctrlSetText profileName;
					(_x displayctrl 111) ctrlSetFade 0;
					(_x displayctrl 111) ctrlCommit 0;
				};
			}
			foreach (uinamespace getvariable "gui_displays");
		};

		
		if !(uiNamespace getvariable "RscDisplayGameOptions_buttonOK_activated") then
		{
			_currentValues = uiNamespace getvariable "RscDisplayGameOptions_currentValues";
			_currentNames = uiNamespace getvariable "RscDisplayGameOptions_currentNames";

			{
				profilenamespace setvariable [_x, _currentValues select _foreachindex];
			} foreach _currentNames;
		};
		
		private _okButtonPressed = uiNamespace getvariable ["RscDisplayGameOptions_buttonOK_activated", false];

		
		RscDisplayGameOptions_buttonOK_activated = nil;
		RscDisplayGameOptions_currentNames = nil;
		RscDisplayGameOptions_currentValues = nil;
		RscDisplayGameOptions_SelectedTab = nil;
		
		[missionNamespace, "OnGameOptionsExited", [_okButtonPressed]] call BIS_fnc_callScriptedEventHandler;
	};

	
	default {};
};

