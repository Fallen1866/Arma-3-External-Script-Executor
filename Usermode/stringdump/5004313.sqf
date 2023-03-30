#line 0 "/temp/bin/A3/Functions_F/Hints/fn_advHint.sqf"

































_ignoreTutHintsEnabled = _this param [5,false];

if (isTutHintsEnabled || _ignoreTutHintsEnabled) then {
	if (isNil {BIS_fnc_advHint_shownList}) then {BIS_fnc_advHint_shownList = []};
	_onlyOnceCheck = true;
	_onlyOnce = _this param [7,false];				

	_class = _this select 0;
	_cfg = configFile;
	if ((count _class) > 2) then {
		_cfg = [["CfgHints",_class select 0,_class select 1,_class select 2],configfile >> "CfgHints" >> "Empty"] call bis_fnc_loadClass;
	} else {
		_cfg = [["CfgHints",_class select 0,_class select 1],configfile >> "CfgHints" >> "Empty"] call bis_fnc_loadClass;
	};
	if (isclass _cfg) then {
		if (_cfg in BIS_fnc_advHint_shownList) then {
			_onlyOnceCheck = false;
		} else {
			BIS_fnc_advHint_shownList set [count BIS_fnc_advHint_shownList,_cfg];
		};
	};

	if (!_onlyOnce || _onlyOnceCheck) then {
		_this spawn {
			scriptName "fn_advHint_mainLoop";
			
			_class = _this select 0;
			_titleClass = _class select 1;									
			_showT = _this param [1,15,[0]];				
			_cond = _this param [2,"false",[""]];			
			_showTF = _this param [3,35,[0]];				
			_condF = _this param [4,"false",[""]];			
			_show = _this param [5,false];					
			_onlyFull = _this param [6,false];				
			_sound = _this param [8,true];					

			if (_showT == 0) then {_showT = 15};
			if (_cond == "") then {_cond = "false"};
			if (_showTF == 0) then {_showTF = 35};
			if (_condF == "") then {_condF = "false"};

			
			_hintData = _class call bis_fnc_advHintFormat;
			_titleCfg = _hintData select 0;
			_titleName = _hintData select 1;
			_titleNameShort = _hintData select 2;
			_info = _hintData select 3;
			_tipString = _hintData select 4;
			_image = _hintData select 5;
			_dlc = _hintData select 6;
			_isDlc = _hintData select 7;
			_keyColor = _hintData select 8;
			_imageVar = _image != "";

			if (_isDlc) then {
				_showT = 15;
				_cond = "false";
				_showTF = 35;
				_condF = "false";
				_show = false;
				_onlyFull = true;
			};

			
			if (isNil {BIS_fnc_advHint_FMMark}) then {BIS_fnc_advHint_FMMark = []};
			_FMClassList = ["GlobalTopic_"+(_class select 0),(_class select 0) + "_" + (_class select 1)];
			{
				if !(_x in BIS_fnc_advHint_FMMark) then {BIS_fnc_advHint_FMMark = BIS_fnc_advHint_FMMark + [_x]};
			} forEach _FMClassList;

			if (isNil {player getVariable "BIS_fnc_advHint_HActiveF"}) then {
				player setVariable ["BIS_fnc_advHint_HActiveF",""]
			};
			if (isNil {player getVariable "BIS_fnc_advHint_HActiveS"}) then {
				player setVariable ["BIS_fnc_advHint_HActiveS",""]
			};

			
			
			if (_dlc >= 0) then {	
				
				if (!(player diarysubjectexists "log")) then
				{
					player creatediarysubject ["log", localize "STR_UI_DIARY_TITLE"];
				};

				player createDiaryRecord ["log", [localize "STR_A3_RSCDIARY_RECORD_HINTS", format["<img image='%1' width=18 height=18/> <execute expression=""
				uinamespace setvariable ['RscDisplayFieldManual_Topic', '%2'];
				uinamespace setvariable ['RscDisplayFieldManual_Hint', '%3'];
				_display = if (!isnull (finddisplay 129)) then {finddisplay 129} else {finddisplay 12};
				_display createDisplay 'RscDisplayFieldManual';"">%4</execute>",
					getText (_titleCfg >> "image"),
					"GlobalTopic_" + (_class select 0),
					(_class select 0) + "_" + (_class select 1),
					_titleName]]];
			};
			

			disableSerialization;
			waitUntil {!(isNull call BIS_fnc_displayMission)};
			BIS_fnc_advHint_HPressed = nil;

			
			
			if !(isNil {uiNamespace getVariable "BIS_fnc_advHint_hintHandlers"}) then {
				if !(uiNamespace getVariable ["BIS_fnc_advHint_hintHandlers",true]) then {
					_display = [] call BIS_fnc_displayMission;

					uiNamespace setVariable ["BIS_fnc_advHint_hintHandlers",true];
					_display displayAddEventHandler [
						"KeyDown",
						"
							_key = _this select 1;

							if (_key in actionkeys 'help') then {
								BIS_fnc_advHint_HPressed = true;
								BIS_fnc_advHint_RefreshCtrl = true;
								[true] call BIS_fnc_AdvHintCall;
								true;
							};
						"
					];
				};
			} else {
				_display = [] call BIS_fnc_displayMission;

				uiNamespace setVariable ["BIS_fnc_advHint_hintHandlers",true];
				_display displayAddEventHandler [
					"KeyDown",
					"
						_key = _this select 1;

						if (_key in actionkeys 'help') then {
							BIS_fnc_advHint_HPressed = true;
							BIS_fnc_advHint_RefreshCtrl = true;
							[true] call BIS_fnc_AdvHintCall;
							true;
						};
					"
				];
			};

			








































			
			_textSizeSmall = 1;			
			_textSizeNormal = 1.25;		
			_invChar05 = "<img image='#(argb,8,8,3)color(0,0,0,0)' size='0.5' />";		
			_invChar02 = "<img image='#(argb,8,8,3)color(0,0,0,0)' size='0.2' />";		
			_shadowColor = "#999999";

			_helpArray = actionKeysNamesArray "help";

			private _keyString = if (count _helpArray != 0) then
			{
				format ["[<t color = '%1'>%2</t>]", _keyColor, _helpArray select 0];
			}
			else
			{
				
				format ["[<t color = '#FF0000'>%1</t>]", toUpper localize "STR_A3_Hints_unmapped"];
			};

			_partString = format [localize "STR_A3_Hints_recall", _keyString];
			_partShortString = format [localize "STR_A3_Hints_moreinfo", _keyString];

			_startPartString = "";
			if (_titleNameShort == "") then {
				_titleNameShort = _titleName;
				_startPartString = "";	
			} else {
				_startPartString = format ["<t size = '%3' align='center' color = '%5'>""%2""</t><br/>", _titleName, _titleNameShort, _textSizeNormal, _keyColor, _shadowColor];	
			};
			_middlePartString = format ["<t align='left' size='%2'>%1</t><br/>", _info, _textSizeSmall];	
			_endPartString = format ["%4<br/><t size = '%2' color = '%3'>%1</t>", _partString, _textSizeSmall, _shadowColor, _invChar02];	
			_tipPartString = "";
			if (_tipString != "") then
			{
				_tipPartString = format ["<t align='left' size='%2' color='%3'>%1</t><br/>", _tipString, _textSizeSmall, _shadowColor];
			};

			_shortHint = format ["<t size = '%5' color = '%6'>%2</t>", _titleName, _partShortString, _textSizeNormal, _keyColor, _textSizeSmall, _shadowColor];

			if (_imageVar) then {		
				if (_tipString != "") then {			
					_hint = format ["%1<img image = '%5' size = '5' shadow = '0' align='center' /><br/>%2<br/>%3%4", _startPartString, _middlePartString, _tipPartString, _endPartString, _image];
					BIS_fnc_advHint_hint = [_titleClass, [_titleName,_hint], [_titleNameShort,_shortHint], _showT, _cond, _showTF, _condF, _onlyFull, _sound];
				} else {						
					_hint = format ["%1<img image = '%4' size = '5' shadow = '0' align='center' /><br/>%2%3", _startPartString, _middlePartString, _endPartString, _image];
					BIS_fnc_advHint_hint = [_titleClass, [_titleName,_hint], [_titleNameShort,_shortHint], _showT, _cond, _showTF, _condF, _onlyFull, _sound];
				}
			} else {					
				if (_tipString != "") then {			
					_hint = format ["%1<br/>%5<br/>%2<br/>%3%4", _startPartString, _middlePartString, _tipPartString, _endPartString, _invChar02];
					BIS_fnc_advHint_hint = [_titleClass, [_titleName,_hint], [_titleNameShort,_shortHint], _showT, _cond, _showTF, _condF, _onlyFull, _sound];
				} else {						
					_hint = format ["%1<t size='0.05'><br/>a<br/>a<br/></t>%2%3", _startPartString, _middlePartString, _endPartString];
					BIS_fnc_advHint_hint = [_titleClass, [_titleName,_hint], [_titleNameShort,_shortHint], _showT, _cond, _showTF, _condF, _onlyFull, _sound];
				}
			};

			[false] call BIS_fnc_AdvHintCall;
		};
	};
};
