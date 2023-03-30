#line 0 "/temp/bin/A3/Functions_F/Diagnostic/fn_exportCfgHints.sqf"
private ["_category","_class","_br"];
_category = _this param [0,"",[""]];
_class = _this param [1,"",[""]];
_br = tostring [13,10];


if (_class == "") exitwith {
	private ["_result"];
	_result = format ["== %1 ==",gettext (configfile >> "CfgHints" >> _category >> "displayName")] + _br;
	{
		_result = _result + ([_category,configname _x] call bis_fnc_exportCfgHints) + _br + _br;
	} foreach ((configfile >> "CfgHints" >> _category) call bis_fnc_returnchildren);
	_result = _result + "[[Category:Arma 3: Field Manual]]";
	copytoclipboard _result;
	_result
};

private ["_cfg"];
_cfg = configfile >> "CfgHints" >> _category >> _class;
if !(isclass _cfg) exitwith {["Hint '%1' in category %2' not found",_category,_class] call bis_fnc_error; ""};

private ["_arguments","_description","_displayName","_tip"];
_arguments = getarray (_cfg >> "arguments");
_description = gettext (_cfg >> "description");
_displayName = gettext (_cfg >> "displayName");
_tip = gettext (_cfg >> "tip");

{
	_x = switch (typename _x) do {
		case (typename []): {
			private ["_xItem"];
			_xItem = _x param [0,objnull];
			switch (typename _xItem) do {
				case (typename []): {
					private ["_xItemIn"];
					_xItemIn = _xItem param [0,objnull];
					switch (typename _xItemIn) do {
						case (typename ""): {
							format ["'''[%1]'''", actionKeysNamesArray _xItemIn param [0,""]];
						};
						case (typename 00): {
							format ["'''[%1]'''",call compile keyname _xItemIn];
						};
						default {_x};
					};
				};
				case (typename ""): {
					_arrayItem = toArray _xItem;
					if (((_arrayItem select 0 == 115) && (_arrayItem select 1 == 116) && (_arrayItem select 2 == 114) && (_arrayItem select 3 == 95)) || ((_arrayItem select 0 == 83) && (_arrayItem select 1 == 84) && (_arrayItem select 2 == 82) && (_arrayItem select 3 == 95))) then {
						_xItem call bis_fnc_localize
					} else {
						format ["'''%1'''",_xItem]
					};
				};
				default {_x};
			};
		};
		case (typename ""): {
			_x call bis_fnc_localize
		};
		default {_x};
	};
	_arguments set [_foreachindex,_x];
} foreach _arguments;

private ["_argumentsDefault"];
_argumentsDefault = [
	"<br />" + _br,
	"* ",
	"'''",
	"'''",
	"color = '#ff9900'",
	format ["color = '%1'",((configfile >> 'CfgInGameUI' >> 'IslandMap' >> 'colorCivilian') call bis_fnc_colorConfigToRGBA) call bis_fnc_colorRGBAtoHTML],
	format ["color = '%1'",((configfile >> 'CfgInGameUI' >> 'IslandMap' >> 'colorEnemy') call bis_fnc_colorConfigToRGBA) call bis_fnc_colorRGBAtoHTML],
	format ["color = '%1'",((configfile >> 'CfgInGameUI' >> 'IslandMap' >> 'colorFriendly') call bis_fnc_colorConfigToRGBA) call bis_fnc_colorRGBAtoHTML],
	format ["color = '%1'",((configfile >> 'CfgInGameUI' >> 'IslandMap' >> 'colorNeutral') call bis_fnc_colorConfigToRGBA) call bis_fnc_colorRGBAtoHTML],
	format ["color = '%1'",((configfile >> 'CfgInGameUI' >> 'IslandMap' >> 'colorUnknown') call bis_fnc_colorConfigToRGBA) call bis_fnc_colorRGBAtoHTML]
];
_arguments = _argumentsDefault + _arguments;

_description = format ([_description] + _arguments);
_displayName = format ([_displayName] + _arguments);
_tip = format ([_tip] + _arguments);

private ["_result"];
_result = "";
_result = _result + format ["=== %1 ===" + _br,_displayName];
_result = _result + format ["%1" + _br,_description];
if (_tip != "") then {_result = _result + format [ _br + "''%1''" + _br,_tip];};

copytoclipboard _result;
_result
