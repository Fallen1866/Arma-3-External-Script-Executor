#line 0 "/temp/bin/A3/Functions_F/Diagnostic/fn_diagWiki.sqf"




































_mode = _this param [0,"",[""]];
startloadingscreen [""];
_result = "";
_br = "
";

_stats = [
	"SentCovering_0",12388,
	"SentCoverMe_0",10671,
	"SelectCmdMoveSentence_1",5977,
	"SentCommandFailed_1",3761,
	"SelectVehicleMoveSentence_1",3062,
	"SelectEnemyDetectedSentence_5",2011,
	"SentCommandFailed_2",1847,
	"SelectEnemyDetectedSentence_1",1777,
	"SentConfirmOther_1",1617,
	"SelectEnemyDetectedSentence_4",1530,
	"SelectEnemyDetectedSentence_3",1476,
	"SentEngage_1",1345,
	"SentTarget_1",1224,
	"SelectEnemyDetectedSentence_2",1202,
	"SentARTYRoundsComplete_0",1077,
	"SentNotifyAttack_2",830,
	"SentCmdGetOut_2",727,
	"SentThrowingGrenade_1",643,
	"SentNotifyAttackSubgroup_1",627,
	"SentCommandFailed_3",609,
	"SentClear_1",555,
	"SentCommandCompleted_1",553,
	"SentUnitKilled_6",513,
	"SentCmdGetOut_1",500,
	"SentContact_1",465,
	"SentFireReady_1",432,
	"SentCommandCompleted_4",415,
	"SentUnitKilled_1",412,
	"SentUnderFire_1",394,
	"SentUnderFire_2",392,
	"SentUnderFire_7",368,
	"SentCovering_2",367,
	"SentUnitKilled_4",366,
	"SentCoverMe_2",364,
	"SentCoverMe_4",361,
	"SelectCmdMoveSentence_2",357,
	"SentCovering_1",354,
	"SelectCmdMoveSentence_0",352,
	"SentThrowingGrenade_2",341,
	"SentARTYFireAtWithAmmo_0",322,
	"SentClear_3",313,
	"SentFireReady_4",301,
	"SentLooseFormation_1",282,
	"VehicleTarget_1",278,
	"SentUnderFire_8",277,
	"SentObjectDestroyed_1",271,
	"SentObjectDestroyed_7",268,
	"SentReloading_1",268,
	"SentUnderFire_4",267,
	"SentNotifyAttackSubgroup_2",266,
	"SentObjectDestroyed_3",257,
	"SentObjectDestroyed_6",257,
	"SentCommandCompleted_5",256,
	"SentNotifyAttack_4",254,
	"SentContact_3",254,
	"SentCommandCompleted_2",253,
	"SentObjectDestroyed_4",252,
	"SentObjectDestroyed_5",250,
	"SentObjectDestroyed_2",250,
	"SentThrowingGrenade_3",248,
	"SentReportPosition_1",246,
	"SentObjectDestroyed_8",243,
	"SelectVehicleMoveSentence_2",236,
	"SentCovering_7",235,
	"SentClear_2",233,
	"SentFireReady_6",231,
	"SentHoldFire_1",230,
	"SentCoverMe_3",218,
	"SentReloading_2",214,
	"SentCmdGetInCargo_1",213,
	"SentFireReady_5",212,
	"SentUnitKilled_7",211,
	"SentFireReady_3",206,
	"SentUnitKilled_2",204,
	"SentUnitKilled_3",188,
	"SentCommandCompleted_6",182,
	"SentIsLeader_3",181,
	"SentLooseFormation_2",179,
	"SentAmmoLow_1",164,
	"SentReloading_4",151,
	"SentCovering_6",146,
	"SentCovering_5",145,
	"VehicleLoad_1",144,
	"SentCovering_4",142,
	"SentNotifyAttack_3",141,
	"SentBehaviourCombat_4",141,
	"SentFire_1",140,
	"SentReturnToFormation_2",132,
	"SentCeaseFireInsideGroup_1",130,
	"SentNotifyAttack_1",124,
	"SentFormWedge_1",120,
	"VehicleNoTarget_1",117,
	"SentCoverMe_5",116,
	"SentCoverMe_1",114,
	"SentUnitKilled_5",114,
	"SentIsLeader_1",101,
	"SentCommandCompleted_3",97,
	"SentIsLeader_2",96,
	"SentReturnToFormation_5",94,
	"SentUnderFire_6",91,
	"SentContact_2",88,
	"SentUnderFire_3",88,
	"SentOpenFireInCombat_1",88,
	"SentIsLeader_4",85,
	"SentConfirmAttack_4",84,
	"SentConfirmAttack_2",82,
	"SentReturnToFormation_6",81,
	"SentConfirmAttack_1",81,
	"SentConfirmAttack_3",76,
	"SentCovering_3",74,
	"SentHealthNormal_1",73,
	"SentWhereAreYou_3",66,
	"SentHealthCritical_6",64,
	"SentFireReady_2",64,
	"SentJoinCompleted_1",62,
	"SentOpenFireInCombat_6",62,
	"SentHealthCritical_1",58,
	"SentReturnToFormation_3",56,
	"SentCmdGetInDriver_1",56,
	"SentConfirmMove_2",54,
	"SentCmdHealSomeone_1",53,
	"SentConfirmMove_4",53,
	"SentHealthNormal_4",52,
	"SentReturnToFormation_1",51,
	"SentHealthCritical_4",50,
	"SentConfirmMove_1",50,
	"SentWhereAreYou_2",50,
	"SentBehaviourAware_2",49,
	"SentCmdGetIn_1",49,
	"SentCmdDismiss_1",49,
	"SentOpenFireInCombat_2",48,
	"SentHealthCritical_8",47,
	"SentConfirmMove_6",46,
	"SentHealthUnconscious_4",45,
	"SentKeepFormation_1",44,
	"SentCmdHealSomeone_2",44,
	"SentReportStatus_3",43,
	"SentReturnToFormation_4",43,
	"SentReportStatus_4",43,
	"SentHealthCritical_5",41,
	"SentReloading_3",39,
	"SentFire_2",39,
	"SentHealthUnconscious_3",38,
	"SentFormLine_1",38,
	"SentDetectedBomb_1",38,
	"SentHealthUnconscious_2",37,
	"VehicleFaster_1",36,
	"SentHoldFireInCombat_3",36,
	"SentHealthNormal_2",36,
	"SentHoldFireInCombat_1",35,
	"SentBehaviourCombat_1",35,
	"SentHealthUnconscious_5",34,
	"SentReportStatus_1",33,
	"SentAmmoCritical_2",31,
	"SentHealthNormal_5",31,
	"SentHealthUnconscious_1",31,
	"SentHealthNormal_6",30,
	"SentReportStatus_2",30,
	"SentHealthCritical_3",29,
	"SentWhereAreYou_1",28,
	"SentCmdRearmAt_1",27,
	"SentOpenFireInCombat_3",27,
	"SentAmmoCritical_1",26,
	"SentOpenFireInCombat_4",25,
	"SentCmdGetInGunner_1",25,
	"SentCmdAttack_1",24,
	"SentConfirmMove_5",23,
	"SentAmmoCritical_3",23,
	"SentFireNegative_1",23,
	"SentDetectedMine_2",23,
	"SentHoldFireInCombat_2",22,
	"VehicleJoin_1",22,
	"SentCmdFollow_1",21,
	"SentBehaviourAware_1",21,
	"VehicleRight_1",21,
	"SentBehaviourCombat_2",21,
	"SentBehaviourCombat_3",20,
	"VehicleLeft_1",19,
	"SentConfirmMove_3",19,
	"SentDetectedMine_1",19,
	"SentFireNegative_2",19,
	"SentHealthCritical_7",18,
	"SentCeaseFire_1",18,
	"SentOpenFire_1",18,
	"SentCeaseFire_4",17,
	"SentFireNegative_3",16,
	"SentCeaseFire_2",16,
	"SentOpenFire_2",16,
	"SentDetectedMine_3",15,
	"SentHealthCritical_2",15,
	"SentOpenFireInCombat_5",13,
	"VehicleForward_1",12,
	"VehicleDirectFire_1",12,
	"VehicleManualFire_1",11,
	"SentFuelLow_1",11,
	"SentOpenFire_3",10,
	"VehicleStop_1",10,
	"SentOpenFireInCombat_7",10,
	"VehicleJoin_2",9,
	"SentCmdHealSomeone_3",8,
	"VehicleBackward_1",8,
	"SentWatchPos_1",8,
	"SentHealthNormal_3",7,
	"SentCmdSupportAt_1",6,
	"SentFuelCritical_1",6,
	"SentCmdHealSelf_1",6,
	"SentCmdGetInCommander_1",5,
	"SentCmdStop_3",5,
	"SentCmdStop_1",5,
	"SentCeaseFire_3",5,
	"SentARTYCannotExecuteAdjustCoordinates_0",4,
	"SentBehaviourSafe_1",4,
	"SentDammageCritical_4",4,
	"SentDammageCritical_1",4,
	"SentUnitPosAuto_1",3,
	"SentCmdFollowMe_2",3,
	"SentCmdHealSelf_2",3,
	"SentBehaviourStealth_3",3,
	"VehicleCeaseFire_1",3,
	"SentCmdRearm_1",3,
	"SentFormColumn_1",2,
	"SentCmdRearmFar_1",2,
	"SentDetectedBomb_0",2,
	"SentEngageNoTarget_1",2,
	"SentFormDiamond_1",2,
	"SentThrowingSmoke_1",1,
	"SentWatchAround_2",1,
	"SentFormPosFlankRight_1",1,
	"SentNotifySupport_1",1,
	"SentObjectUnconscious_4",1,
	"SentDammageCritical_3",1,
	"SentRepairThat_0",1,
	"SentRepeatCommand_2",1,
	"SentCmdGetInPilot_1",1,
	"SentCmdFollowMe_6",1,
	"SentWatchAround_1",1,
	"SentUnitPosDown_1",1,
	"SentBehaviourSafe_2",1,
	"SentBehaviourStealth_1",1,
	"SentBehaviourStealth_2",1,
	"SentCmdFollowMe_5",1
];

switch _mode do {

	
	case "RscMapControl_icons": {
		_cfg = configfile >> "RscMapControl";
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_className = configname _class;
				if !(_className in ["Command","Task","CustomMark","Waypoint","WaypointCompleted"]) then {
					_icon = gettext (_class >> "icon");
					if (_icon != "") then {
						_color = getarray (_class >> "color");
						_size = getnumber (_class >> "size");

						_result = _result + format [
							"|-" + _br +
							"|<div style=""background:grey; color:white; padding:3px; height:64px;"">https://altar.bistudio.com/svn/futura/CA/Ui_f/data/Map/MapControl/%2_CA.png</div>" + _br +
							"|style=""border: 1px dotted gray; border-left:none; border-top:none;"" |<div style=""background:%3; width:%4px; height:%4px;""></div>" + _br +
							"{{Table-border-right|'''%1'''}}" + _br +
							"{{Table-border-right|}}" + _br + _br,

							_className,
							tolower _className,
							_color call bis_fnc_colorRGBtoHTML,
							_size * 1.25
						];
					};
				};
			};
		};
		_result = "{|" + _br + _result + _br + "|}";
	};


	
	case "RscMapControl_colors": {
		_cfg = configfile >> "RscMapControl";
		for "_c" from 0 to (count _cfg - 1) do {
			_param = _cfg select _c;
			if (isarray _param) then {
				_color = getarray (_param);
				if (count _color == 4) then {
					_colorAvg = 1 - ((_color select 0) + (_color select 1) + (_color select 2)) / 3;
					_result = _result + format [
						"|-" + _br +
						"|width=""64px"" style=""background:%2; color:#666;""|%3" + _br +
						"{{Table-border-right|'''%1'''}}" + _br +
						"{{Table-border-right|}}" + _br + _br,
						configname _param,
						_color call bis_fnc_colorRGBtoHTML,
						_color,
						[_colorAvg,_colorAvg,_colorAvg] call bis_fnc_colorRGBtoHTML
					];
				};
			};
		};
		_result = "{|" + _br + _result + _br + "|}";
	};


	
	case "RscMapControl_fonts": {
		_cfg = configfile >> "RscMapControl";
		_cfgCore = configfile >> "CfgIngameUi" >> "IslandMap";
		{
			_font = gettext (_cfg >> (_x select 0));
			_textsize = getnumber (_cfg >> (_x select 1));
			_result = _result + format [
				"|-" + _br +
				"{{Table-border-right|'''%1'''}}" + _br +
				"| style=""color:%3; font-family:%2; font-size:%3px;"" | Example Text" + _br +
				"{{Table-border-right|}}" + _br + _br,

				_x select 0,
				_font,
				_textsize * 400
			];
		} foreach [
			["fontLabel",	"sizeExLabel"],
			["fontGrid",	"sizeExGrid"],
			["fontUnits",	"sizeExUnits"],
			["fontNames",	"sizeExNames"],
			["fontInfo",	"sizeExInfo"],
			["fontLevel",	"sizeExLevel"]
		];
		_result =
		"{| class=""wikitable"" width=""100%""" + _br + 
		"! style=""border-bottom: 2px solid black;"" width=""256px"" | Example Text" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""128px"" | Name" + _br +
		"! style=""border-bottom: 2px solid black;"" | Description" + _br + _br +
		_result + _br +
		"|}";
	};


	
	case "IslandMap_icons": {
		_cfg = configfile >> "CfgIngameUI" >> "IslandMap";
		for "_p" from 0 to (count _cfg - 1) do {
			_param = _cfg select _p;
			if (istext _param) then {
				_icon = gettext _param;
				if (_icon != "") then {
					_paramName = configname _param;
					_result = _result + format [
						"|-" + _br +
						"|<div style=""background:grey; color:white; padding:3px;"">https://altar.bistudio.com/svn/futura/CA/Ui_f/data/IGUI/Cfg/IslandMap/%1_ca.png</div>" + _br +
						"{{Table-border-right|'''%1'''}}" + _br +
						"{{Table-border-right|}}" + _br + _br,

						_paramName
					];

				};
			};
		};
		_result =
		"{| class=""wikitable sortable"" width=""100%""" + _br + 
		"! style=""border-bottom: 2px solid black;"" width=""64px"" class=""unsortable"" | Texture" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""256px"" | Name" + _br +
		"! style=""border-bottom: 2px solid black;"" class=""unsortable"" | Description" + _br +
		_result + _br +
		"|}";
	};


	
	case "IslandMap_colors": {
		_cfg = configfile >> "CfgIngameUI" >> "IslandMap";
		for "_c" from 0 to (count _cfg - 1) do {
			_param = _cfg select _c;
			if (isarray _param) then {
				_color = getarray (_param);
				if (count _color == 4) then {
					_colorAvg = 1 - ((_color select 0) + (_color select 1) + (_color select 2)) / 3;
					_result = _result + format [
						"|-" + _br +
						"|width=""64px"" style=""background:%2; color:#666;""|%3" + _br +
						"{{Table-border-right|'''%1'''}}" + _br +
						"{{Table-border-right|}}" + _br + _br,
						configname _param,
						_color call bis_fnc_colorRGBtoHTML,
						_color,
						[_colorAvg,_colorAvg,_colorAvg] call bis_fnc_colorRGBtoHTML
					];
				};
			};
		};
		_result = "{|" + _br + _result + _br + "|}";
	};


	
	case "CfgLocationTypes": {
		_cfg = configfile >> "CfgLocationTypes";
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_className = configname _class;
				_classNameArray = toarray _className;
				_classNameArray set [0,toarray (tolower tostring [_classNameArray select 0]) select 0];
				_className = tostring _classNameArray;
				_color = getarray (_class >> "color");
				_size = getnumber (_class >> "size");
				_drawStyle = gettext (_class >> "drawStyle");
				_textSize = getnumber (_class >> "textSize");
				_texture = gettext (_class >> "texture");
				_textureClass = loadfile format ["\A3\ui_f\data\map\locationtypes\%1_ca.paa",_className];

				_textureoutput = if (_texture == "" || _textureClass == "") then {
					"N/A"
				} else {
					format ["https://altar.bistudio.com/svn/futura/CA/Ui_f/data/Map/LocationTypes/%1_CA.png",_className]
				};
				_result = _result + format [
					"|-" + _br +
					"|<div style=""background:grey; color:white; padding:3px;"">%2</div>" + _br +
					"|style=""border: 1px dotted gray; border-left:none; border-top:none;"" |<div style=""background:%3; width:%4px; height:%4px;""></div>" + _br +
					"{{Table-border-right|<small>%5</small>}}" + _br +
					"{{Table-border-right|'''%1'''}}" + _br +
					"| style=""color:%3; font-family:Purista; font-size:%6px;"" | Example Text" + _br +
					"{{Table-border-right|}}" + _br + _br,

					_className,
					_textureoutput,
					_color call bis_fnc_colorRGBtoHTML,
					_size * 1.25,
					_drawStyle,
					_textSize * 400
				];
			};
		};
		_result = "{|" + _br + _result + _br + "|}";
	};


	
	case "CfgMarkers": {
		_category = _this param [1,"System",[""]];
		_cfg = configfile >> "CfgMarkers";
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_className = tolower configname _class;
				_color = getarray (_class >> "color");
				_icon = gettext (_class >> "icon");
				_markerClass = gettext (_class >> "markerClass");
				_name = gettext (_class >> "name");
				_scope = getnumber (_class >> "scope");
				_shadow = getnumber (_class >> "shadow");
				_side = getnumber (_class >> "side");
				_size = getnumber (_class >> "size");

				if (_markerClass == _category) then {
					_result = _result + format [
						"|-" + _br +
						
						"|<div style=""background:grey; color:white; padding:3px; height:64px;"">https://altar.bistudio.com/svn/futura/CA/Ui_f/data/Map/Markers/Military/%2_CA.png</div>" + _br +
						"|style=""border: 1px dotted gray; border-left:none; border-top:none;"" |<div style=""background:%3; width:%4px; height:%4px;""></div>" + _br +
						"{{Table-border-right|'''%1'''}}" + _br + _br,

						_className,
						tolower _className,
						_color call bis_fnc_colorRGBtoHTML,
						_size * 1.25
					];
				};
			};
		};
		_result =
		"{|" + _br + 
		"! style=""border-bottom: 2px solid black;"" width=""64px"" class=""unsortable"" | Texture" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""64px"" class=""unsortable"" | Color / Size" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""256px"" | Name" + _br +
		_result + _br +
		"|}";
	};


	
	case "CfgMarkerBrushes": {
		_cfg = configfile >> "CfgMarkerBrushes";
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_className = tolower configname _class;
				_texture = gettext (_class >> "texture");

				_result = _result + format [
					"|-" + _br +
					"|<div style=""background:grey; color:white; padding:3px; height:64px;"">https://altar.bistudio.com/svn/futura/CA/Ui_f/data/Map/MarkerBrushes/%2_ca.png</div>" + _br +
					"{{Table-border-right|'''%1'''}}" + _br + _br,

					_className,
					tolower _className
				];
			};
		};
		_result =
		"{|" + _br + 
		"! style=""border-bottom: 2px solid black;"" width=""64px"" class=""unsortable"" | Texture" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""256px"" | Name" + _br +
		_result + _br +
		"|}";
	};



	
	case "CfgMarkerColors": {
		_cfg = configfile >> "CfgMarkerColors";
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;

			if (isclass _class) then {
				_color = getarray (_class >> "color");
				if (count _color == 4) then {
					_colorAvg = 1 - ((_color select 0) + (_color select 1) + (_color select 2)) / 3;
					_result = _result + format [
						"|-" + _br +
						"|width=""64px"" style=""background:%2; color:#666;""|%3" + _br +
						"{{Table-border-right|'''%1'''}}" + _br + _br,
						configname _class,
						_color call bis_fnc_colorRGBtoHTML,
						_color,
						[_colorAvg,_colorAvg,_colorAvg] call bis_fnc_colorRGBtoHTML
					];
				};
			};

		};
		_result =
		"{|" + _br + 
		"! style=""border-bottom: 2px solid black;"" width=""64px"" class=""unsortable"" | Color" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""256px"" | Name" + _br +
		_result + _br +
		"|}";
	};


	
	case "CfgVehicleIcons": {
		_cfg = configfile >> "CfgVehicleIcons";
		for "_p" from 0 to (count _cfg - 1) do {
			_param = _cfg select _p;
			if (istext _param) then {
				_icon = gettext _param;
				if (_icon != "") then {
					_paramName = configname _param;
					_result = _result + format [
						"|-" + _br +
						"|<div style=""background:grey; color:white; padding:3px;"">https://altar.bistudio.com/svn/futura/CA/Ui_f/data/Map/VehicleIcons/%1_ca.png</div>" + _br +
						"{{Table-border-right|'''%1'''}}" + _br + _br,

						_paramName
					];

				};
			};
		};
		_result =
		"{|" + _br + 
		"! style=""border-bottom: 2px solid black;"" width=""64px"" class=""unsortable"" | Texture" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""256px"" | Name" + _br +
		_result + _br +
		"|}";
	};


	
	case "CfgDiary_Icons": {
		_cfg = configfile >> "CfgDiary" >> "Icons";
		for "_p" from 0 to (count _cfg - 1) do {
			_param = _cfg select _p;
			if (istext _param) then {
				_icon = gettext _param;
				if (_icon != "") then {
					_paramName = configname _param;
					_result = _result + format [
						"|-" + _br +
						"|<div style=""background:grey; color:white; padding:3px;"">https://altar.bistudio.com/svn/futura/CA/Ui_f/data/Map/Diary/Icons/%1_ca.png</div>" + _br +
						"{{Table-border-right|'''%1'''}}" + _br + _br,

						_paramName
					];

				};
			};
		};
		_result =
		"{|" + _br + 
		"! style=""border-bottom: 2px solid black;"" width=""32px"" class=""unsortable"" | Texture" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""256px"" | Name" + _br +
		_result + _br +
		"|}";
	};


	
	case "CfgWrapperUI_Cursors": {
		_cfg = configfile >> "CfgWrapperUI" >> "Cursors";
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_className = configname _class;
				_texture = gettext (_class >> "texture");
				_width = getnumber (_class >> "width");
				_height = getnumber (_class >> "height");
				_color = getarray (_class >> "color");

				_result = _result + format [
					"|-" + _br +
					"|<div style=""background:grey; color:white; padding:3px; height:32px;"">https://altar.bistudio.com/svn/futura/CA/Ui_f/data/GUI/Cfg/Cursors/%2_gs.png</div>" + _br +
					"|style=""border: 1px dotted gray; border-left:none; border-top:none;"" |<div style=""background:%3; width:%4px; height:%5px;""></div>" + _br +
					"{{Table-border-right|'''%1'''}}" + _br +
					"{{Table-border-right|}}" + _br +
					"{{Table-border-task|}}" + _br +
					"{{Table-border-task|}}" + _br + _br,

					_className,
					tolower _className,
					_color call bis_fnc_colorRGBtoHTML,
					_width,
					_height
				];
			};
		};
		_result =
		"{|" + _br + 
		"! style=""border-bottom: 2px solid black;"" width=""32px"" class=""unsortable"" | Texture" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""32px"" class=""unsortable"" | Color / Size" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""128px"" | Name" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""100%"" class=""unsortable"" | Description" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""64px"" | Map" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""64px"" | Revised" + _br +
		_result +
		"|}";
	};


	
	case "Anims_aimPrecision": {
		_cfg = configfile >> "CfgMovesMaleSdr" >> "States";
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_aimPrecision = getnumber (_class >> "aimPrecision");
				_disableWeapons = getnumber (_class >> "disableWeapons");
				if (true) then {
					
					_disableWeaponsText = if (_disableWeapons > 0) then {"style=""background-color:salmon;""|"} else {"style=""background-color:palegreen;""|"};

					_type = (configname _class) call BIS_fnc_animType;
					if (count _type > 3) then {
						{
							_type set [_foreachindex,_x select 1];
						} foreach _type;
						_result = _result + format (
							[
								"|-" + _br +
								"|'''%1'''" + _br +
								"|%2" + _br +
								"|%3" + _br +
								"|%4" + _br +
								"|%5" + _br +
								"|%6" + _br +
								"|%7" + _br +
								"|%8" + _br +
								"|%9" + _br,
								configname _class,_aimPrecision,_disableWeaponsText + str _disableWeapons
							] + _type
						);
					};
				};
			};
		};
		
		_result =
		"{| class=""wikitable sortable"" border=""1"" width=""100%"" style=""border-collapse:collapse""" + _br +
		"! Class" + _br +
		"! aim<br />Precision" + _br +
		"! disable<br />Weapon" + _br +
		"! Action" + _br +
		"! Pose" + _br +
		"! Movement" + _br +
		"! Stance" + _br +
		"! Hand Item" + _br +
		"! Direction" + _br +
		_result + _br +
		"|}";

	};


	
	case "RadioProtocol_Select": {
		_protocol = _this param [1,"RadioProtocolBase",[""]];
		_cfg = configfile >> _protocol;
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			_className = configname _class;
			if (isclass _class) then {
				_cfgSentences = _class >> "sentences";
				if (isarray _cfgSentences) then {
					_sentences = getarray (configfile >> "RadioProtocolEN" >> _className >> "sentences");
					_statValue = 0;
					for "_i" from 0 to (count _sentences - 1) step 2 do {
						_statID = _stats find (_classname + "_" + str (_i/2 + 1));
						if (_statID >= 0) then {
							_statValue = _statValue + (_stats select (_statID + 1));
						};
					};

					_priority = getnumber (_class >> "priority");
					_timeout = getnumber (_class >> "timeout");
					_parents = [_class,""] call bis_fnc_returnparents;
					_parent = if (count _parents > 1) then {_parents select 1} else {""};

					_result = _result + format [
						"|-"+ _br +
						"|'''" + configname _class + "'''" + _br +
						"|" + str _statValue + _br
					];
				};
			};
		};

		_result =
		"{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse"" cellpadding=""3px""" + _br +
		"! Class" + _br +
		"! [http://splendid.bistudio.com/protokol.php Statistics]" + _br +
		_result + _br +
		"|}";
	};


	
	case "RadioProtocol_Sent": {
		_protocol = _this param [1,"RadioProtocolBase",[""]];
		_cfg = configfile >> _protocol;
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			_className = configname _class;
			if (isclass _class) then {
				_cfgVersions = _class >> "versions";
				if (isarray _cfgVersions) then {
					_versions = getarray (configfile >> "RadioProtocolEN" >> _className >> "versions");
					_statValue = 0;
					for "_i" from 0 to 10 do {
						_statID = _stats find (_classname + "_" + str (_i));
						if (_statID >= 0) then {
							_statValue = _statValue + (_stats select (_statID + 1));
						};
					};

					_priority = getnumber (_class >> "priority");
					_timeout = getnumber (_class >> "timeout");
					_parents = [_class,""] call bis_fnc_returnparents;
					_parent = if (count _parents > 1) then {_parents select 1} else {""};

					_result = _result + format [
						"|-"+ _br +
						"|'''" + configname _class + "'''" + _br +
						"|" + _parent + _br +
						"|" + str _priority + _br +
						"|" + str _timeout + _br +
						"|" + str _statValue + _br
					];
				};
			};
		};

		_result =
		"{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse"" cellpadding=""3px""" + _br +
		"! Class" + _br +
		"! Parent Class" + _br +
		"! Priority" + _br +
		"! Timeout" + _br +
		"! [http://splendid.bistudio.com/protokol.php Statistics]" + _br +
		_result + _br +
		"|}";
	};


	
	case "RadioProtocol_Words": {
		_protocol = _this param [1,"RadioProtocolBase",[""]];
		_cfg = configfile >> _protocol >> "words";
		for "_c" from 0 to (count _cfg - 1) do {
			_param = (_cfg select _c);
			_paramArray = getarray _param;
			if (count _paramArray > 0) then {
				_result = _result +
					"|-"+ _br +
					"|'''" + (configname _param) + "'''" + _br +
					"|" + (_paramArray select 0) + _br;
			};
		};

		_result =
		"{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse"" cellpadding=""3px""" + _br +
		"! Class" + _br +
		"! Path" + _br +
		_result + _br +
		"|}";
	};


	
	case "RadioProtocol_Stats": {
		_protocol = _this param [1,"RadioProtocolBase",[""]];
		_parseSentences = _this param [2,false,[false]];
		if (_parseSentences) then {
			_cfg = configfile >> _protocol;
			for "_c" from 0 to (count _cfg - 1) do {
				_class = _cfg select _c;
				if (isclass _class) then {
					_className = configname _class;
					_classArray = toarray tolower _classname;
					if ((_classArray select 0) in [115,118]) then {
						_cfgSentences = _class >> "sentences";
						if (isarray _cfgSentences) then {
							_sentences = getarray _cfgSentences;
							for "_i" from 0 to (count _sentences - 1) step 2 do {
								_sentence = _cfg >> (_sentences select _i);
								_probability = str(_sentences select (_i + 1));
								_statID = _stats find (_classname + "_" + str (_i/2 + 1));
								_statValue = if (_statID >= 0) then {str (_stats select (_statID + 1))} else {""};

								_result = _result +
									"|-"+ _br +
									"|'''" + _classname + "'''" + _br + str(_i/2) + ": " + configname _sentence + _br +
									"|" + _probability + _br;
									
							};
						};
					};
				};
			};

			_result =
			"{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse"" cellpadding=""2px""" + _br +
			"! Sentence / Version" + _br +
			"! Probability" + _br +
			
			_result + _br +
			"|}";
		} else {
			_cfg = configfile >> _protocol;
			for "_c" from 0 to (count _cfg - 1) do {
				_class = _cfg select _c;
				if (isclass _class) then {
					_className = configname _class;
					_classArray = toarray tolower _classname;
					if ((_classArray select 0) in [115,118]) then {
						_cfgVersions = _class >> "versions";
						if (isarray _cfgVersions) then {
							_versions = getarray _cfgVersions;
							for "_i" from 0 to (count _versions - 1) step 2 do {
								_version = _class >> (_versions select _i);
								_probability = (_versions select (_i + 1));
								
								_statID = _stats find (_classname + "_" + str (_i/2 + 1));
								_statValue = if (_statID >= 0) then {str (_stats select (_statID + 1))} else {""};
								_text = str gettext (_version >> "text");
								_speech = getarray (_version >> "speech");

								_result = _result +
									"|-"+ _br +
									"|'''" + _classname + "'''" + _br + str(_i/2) + ": " + configname _version + _br +
									
									"|" + str _probability + _br +
									
									"|" + _text + _br +
									"|" + "<small>" + str(count _speech) + ": " + str _speech + "</small>" + _br;
							};
						};
					};
				};
			};

			_result =
			"{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse"" cellpadding=""2px""" + _br +
			"! Sentence<br />ID: Version" + _br +
			"! Probability" + _br +
			
			"! Text" + _br +
			"! Speech<br />(number of variants: variants)" + _br +
			_result + _br +
			"|}";
		};
	};


	
	case "RadioProtocol_Variables": {
		_cfg = configfile >> "RadioProtocol_EP1_EN";
		_logged = [];
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_cfgVersions = _class >> "versions";
				if (isarray _cfgVersions) then {
					_versions = getarray _cfgVersions;
					for "_v" from 0 to (count _versions - 1) step 2 do {
						_version = _versions select _v;
						_text = gettext (_class >> _version >> "text");
						if !(_text in _logged) then {
							_speech = getarray (_class >> _version >> "speech");
							_wordsClass = gettext (_class >> _version >> "wordsClass");
							if (_wordsClass != "StealthWords") then {
									{
									_xArray = toarray _x;
									if ((_xArray select 0) == 37) then {
										_result = _result + 
											"|-"+ _br +
											"|'''" + configname _class + "'''" + _br +
											"|" + _version + _br +
											"|" + _x + _br +
											"|" + _text + _br;
									};
								} foreach _speech;
							};
							_logged = _logged + [_text];
						};
					};
				};
			};
		};

		_result =
		"{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse"" cellpadding=""3px""" + _br +
		"! Class" + _br +
		"! Version" + _br +
		"! Variable" + _br +
		"! Text" + _br +
		_result + _br +
		"|}";
	};


	
	case "CfgVehicles_identityTypes": {
		_cfg = configfile >> "CfgVehicles";
		_loggedTypes = [];
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_identityTypes = getarray (_class >> "identityTypes");
				{
					_type = tolower _x;
					if !(_type in _loggedTypes) then {
						_loggedTypes = _loggedTypes + [_type];
					};
				} foreach _identityTypes;
			};
		};

		_cfg = configfile >> "CfgVoice";
		_loggedVoice = [];
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_identityTypes = getarray (_class >> "identityTypes");
				{
					_type = tolower _x;
					if !(_type in _loggedVoice) then {
						_loggedVoice = _loggedVoice + [_type];
					};
				} foreach _identityTypes;
			};
		};
		{
			if (_x in _loggedVoice) then {
				_result = _result + 
					"|-"+ _br +
					"|'''" + _x + "'''" + _br;
			};
		} foreach _loggedTypes;

		_result =
		"{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse"" cellpadding=""3px""" + _br +
		"! Class" + _br +
		_result + _br +
		"|}";
	};


	
	case "CfgVehicles_speechVariants": {
		_cfg = configfile >> "CfgVehicles";
		_logged = [];
		for "_g" from 0 to (count _cfg - 1) do {
			_class = _cfg select _g;
			if (isclass _class) then {

				for "_c" from 0 to (count _class - 1) do {
					_subclass = _class select _c;

					if (configname _subclass == "speechVariants") then {
						_speechVariants = _subClass;
						for "_s" from 0 to 0 do {
							_variant = _speechVariants select _s;
							if (isclass _variant) then {
								_speechSingular = getarray (_variant >> "speechSingular");	
								_speechPlural = getarray (_variant >> "speechPlural");

								_speechSingular = if (count _speechSingular > 0) then {_speechSingular select 0} else {""};
								_speechPlural = if (count _speechPlural > 0) then {_speechPlural select 0} else {""};

								_textSingular = gettext (_class >> "textSingular");
								_textPlural = gettext (_class >> "textPlural");

								_result = _result + 
									"|-"+ _br +
									"|'''" + (configname _class) + "'''" + _br +
									"|'''" + (configname _variant) + "'''" + _br +
									"|" + _speechSingular + _br +
									"|" + _speechPlural + _br +
									"|''" + _textSingular + "''" + _br +
									"|''" + _textPlural + "''" + _br;
							};
						};
					};
				};
			};
		};


		_result =
		"{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse"" cellpadding=""3px""" + _br +
		"! Class" + _br +
		"! speechVariant" + _br +
		"! speechSingular" + _br +
		"! speechPlural" + _br +
		"! textSingular" + _br +
		"! textPlural" + _br +
		_result + _br +
		"|}";
	};


	
	case "CfgVehicles_mapSize": {
		if (time == 0) exitwith {"'CfgVehicles_mapSize' can be executed only in a running mission" call bis_fnc_error;};
		_cfg = configfile >> "CfgVehicles";
		_cfgCount = count _cfg - 1;
		_pos = [100,100,100];

		_classes = [];
		_sizes = [];
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {

				_classname = configname _class;
				_parents = [_class,""] call bis_fnc_returnparents;
				{
					
						_parentID = _classes find _x;
						if (_parentID < 0) then {
							_classes = _classes + [_x,[_classname]];
						} else {
							_parentArray = _classes select (_parentID + 1);
							_parentArray set [count _parentArray,_classname];
						};
					
				} foreach _parents;

				_scope = getnumber (_class >> "scope");
				if (_scope > 0) then {
					_obj = createvehicle [configname _class,_pos,[],0,"none"];

					_bbox = boundingbox _obj;
					_bboxX = abs((_bbox select 0) select 0) + abs((_bbox select 1) select 0);
					_bboxY = abs((_bbox select 0) select 1) + abs((_bbox select 1) select 1);
					_size = _bboxX max _bboxY;
					_size = (round (_size * 100)) / 100;

					_sizes set [count _sizes,configname _class];
					_sizes set [count _sizes,_size];

					deletevehicle _obj;
				} else {
					_sizes set [count _sizes,configname _class];
					_sizes set [count _sizes,0];
				};
			};
			progressloadingscreen (_c / _cfgCount);
		};

		_inherits = [];
		_classCount = count _classes - 1;
		for "_c" from 0 to _classCount step 2 do {
			_parent = _classes select _c;
			_children = _classes select (_c + 1);

			_parentSize = -1;
			{
				_childID = _sizes find _x;
				if (_childID >= 0) then {
					_childSize = _sizes select (_childID + 1);
					if (_parentSize <= 0) then {_parentSize = _childSize;};
					if (_childSize == 0) then {_childSize = _parentSize;};
					if (_childSize != _parentSize) then {_parentSize = -1;};
				};
				if (_parentSize < 0) exitwith {};
			} foreach _children;

			_inheritID = _inherits find _parent;
			_sizeText = if (_inheritID >= 0) then {
				"''inherited from " + ((_inherits select (_inheritID + 1)) select 0) + "''"
			} else {
				if (_parentSize > 0) then {str _parentSize} else {"1 ''(Default)''"};
			};

			_scope = getnumber (configfile >> "cfgvehicles" >> _parent >> "scope");
			_formatText = switch _scope do {
				case 0: {"| style=""background-color:salmon;"" | %1"};
				case 1: {"| style=""background-color:lightsalmon;"" | %1"};
				case 2: {"| %1"};
			};

			_result = _result + "|-" + _br +
			format [_formatText,_parent] + _br +
			format [_formatText,_sizeText] + _br +
			format [_formatText,getnumber (configfile >> "cfgvehicles" >> _parent >> "mapsize")] + _br +
			format [_formatText,str _scope] + _br;

			if (_parentSize > 0) then {
				{
					_childID = _sizes find _x;
					if (_childID >= 0) then {
						_inherits = _inherits + [_x,[_parent]];
						
					};
				} foreach _children;
			};
		};

		_result =
		"{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse"" cellpadding=""3px""" + _br +
		"! Class" + _br +
		"! Desired mapSize" + _br +
		"! Current mapSize" + _br +
		"! scope" + _br +
		_result + _br +
		"|}";
	};


	
	case "CfgActions": {
		_icons = [
			"arrow_down",
			"arrow_up",
			"autohover",
			"bandage",
			"cancelhover",
			"clear_empty",
			"close",
			"eject",
			"engine_off",
			"engine_on",
			"gear",
			"getincargo",
			"getincommander",
			"getindriver",
			"getingunner",
			"getinpilot",
			"getout",
			"heal",
			"ico_cpt_batt_OFF",
			"ico_cpt_batt_ON",
			"ico_cpt_brk_ON",
			"ico_cpt_col_OFF",
			"ico_cpt_col_ON",
			"ico_cpt_land_OFF",
			"ico_cpt_land_ON",
			"ico_cpt_start_OFF",
			"ico_cpt_start_ON",
			"ico_cpt_thtl_IDL",
			"ico_cpt_thtl_OFF",
			"ico_OFF",
			"ico_ON",
			"ladderdown",
			"ladderoff",
			"ladderup",
			"reammo",
			"refuel",
			"reload",
			"repair",
			"returnflag",
			"settimer",
			"takeflag",
			"talk"
		];
		_cfg = configfile >> "CfgActions";
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_className = configname _class;
				_text = gettext (_class >> "text");
				_texture = if ({_x == _classname} count _icons > 0) then {
					format [
						"| style=""background:grey; color:white; padding:3px; height:64px; text-align:center;"" | https://altar.bistudio.com/svn/futura/CA/Ui_f/data/IGUI/Cfg/Actions/%1_ca.png",
						tolower _classname
					];
				} else {
					"| style=""background:grey; color:white;"" | N/A"
				};
				_priority = getnumber (_class >> "priority");
				_shortcut = gettext (_class >> "shortcut");






				_result = _result + format [
					"|-" + _br +
					_texture + _br +
					"| '''%1'''" + _br +
					"| %3" + _br +
					"| %4" + _br +
					"| %5" + _br + _br,

					_className,
					_texture,
					_text,
					_priority,
					_shortcut
				];
			};
		};
		_result =
		"{| class=""wikitable sortable"" width=""100%"" border=""1"" style=""border-collapse:collapse"" cellpadding=""3px""" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""64px"" | Texture" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""32px"" | Class" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""256px"" class=""unsortable"" | Text" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""32px"" | Priority" + _br +
		"! style=""border-bottom: 2px solid black;"" width=""64px"" | Shortcut" + _br +
		_result +
		"|}";
	};

	case "CfgActions_CfgVehicles": {
		_cfg = configfile >> "CfgVehicles";
		for "_c" from 0 to (count _cfg - 1) do {
			_class = _cfg select _c;
			if (isclass _class) then {
				_classname = configname _class;
				_useractions = _class >> "useractions";
				if (isclass _useractions) then {

					_islocal = false;
					for "_a" from 0 to (count _class - 1) do {
						if (configname (_class select _a) == "useractions") exitwith {_islocal = true;};
					};

					if (_islocal) then {
					_displaynames = [];
					_actions = [];
					for "_u" from 0 to (count _useractions - 1) do {
						_action = _useractions select _u;
						_displayname = gettext (_action >> "displayname");
						if (_displayname in _displaynames) then {
							_actionid = _displaynames find _displayname;
							_actions set [_actionid + 1,(_actions select (_actionid + 1)) + 1];
						} else {
							_displaynames = _displaynames + [_displayname,0];
							_actions = _actions + [_action,1];
						};
					};

					for "_a" from 0 to (count _actions - 1) step 2 do {
						_action = _actions select _a;
						_actioncount = _actions select (_a + 1);
						_displayname = gettext (_action >> "displayname");
						_position = gettext (_action >> "position");

						_classtext = if (_a == 0) then {
							format ["| rowspan=""%1"" | '''%2'''",count _actions / 2,_classname]
						} else {
							""
						};

						_actiontext = if (_actioncount > 1) then {
							configname _action + " <small>(" + str _actioncount + "x)</small>"
						} else {
							configname _action
						};

						_result = _result + format [
							"|-" + _br +
							_classText + _br +
							"| '''%1'''" + _br +
							"| %2" + _br +
							"| %3" + _br + _br,
							_actiontext,
							_displayname,
							_position
						];
					};
					};
				};

			};
		};
		_result =
		"{| class=""wikitable sortable"" width=""100%"" border=""1"" style=""border-collapse:collapse"" cellpadding=""3px""" + _br +
		"! style=""border-bottom: 2px solid black;"" | Object" + _br +
		"! style=""border-bottom: 2px solid black;"" | Class" + _br +
		"! style=""border-bottom: 2px solid black;"" | displayName" + _br +
		"! style=""border-bottom: 2px solid black;"" | position" + _br +
		_result +
		"|}";
	};


	
	default {["'%1' is not a valid entry.",_mode] call bis_fnc_error;};
};

[0,_mode == "CfgMarkerBrushes",_result] call bis_fnc_log;
copytoclipboard _result;
endloadingscreen;
