#line 0 "/temp/bin/A3/Functions_F/GUI/fn_credits_movie.sqf"















private ["_display","_displayMain"];
_displayMain = _this param [0,finddisplay 46,[displaynull]];
_mode = _this param [1,1,[0]];


BIS_fnc_credits_movie_script = [_displayMain,_mode] spawn {
	disableSerialization;
	uiNameSpace setVariable ["BIS_fnc_credits_movie_script",BIS_fnc_credits_movie_script];
	_displayMain = _this select 0;
	_mode = _this select 1;

	if (_mode > 0) then {

		
		102 cuttext ["","black out",0];
		(["BIS_fnc_credits_movie"] call bis_fnc_rscLayer) cutrsc ["RscCredits","plain"];
		waituntil {!isNull (uiNamespace getVariable ["A3_RscCredits", displayNull])};

		with uinamespace do {
			disableSerialization;
			
			
			_backColor = [0,0,0,1];		
			_delay = 10;						
			
			_supporterArray = [] call BIS_fnc_credits_movieSupport;		
			_display = uiNamespace getVariable "A3_RscCredits";
			
			BIS_fnc_credits_A3_display = _display;
			
			
			_ctrlBack = _display displayctrl 1000;
			_ctrlBack ctrlsetbackgroundcolor _backColor;
			_ctrlBack ctrlsetposition [safezoneXAbs,safezoneY,safezoneWAbs,safezoneH];
			_ctrlBack ctrlcommit 0;

			_ctrlBlackLeft = _display displayctrl 9098;
			_ctrlBlackLeft ctrlsetbackgroundcolor [0,0,0,1];
			_ctrlBlackLeft ctrlsetposition [safezoneX - 10,safezoneY,10,safezoneH];
			_ctrlBlackLeft ctrlcommit 0;

			_ctrlBlackRight = _display displayctrl 9099;
			_ctrlBlackRight ctrlsetbackgroundcolor [0,0,0,1];
			_ctrlBlackRight ctrlsetposition [safezoneX + safezoneW,safezoneY,10,safezoneH];
			_ctrlBlackRight ctrlcommit 0;
			











			
			102 cuttext ["","black in",0.25];
			
			
			
			BIS_fnc_credits_A3_keydown = {
				_key = _this select 1;
				_display = BIS_fnc_credits_A3_display;

				
				if ((_key == 156) || (_key == 28) || (_key == 57) || (_key == 1)) exitwith {		
					terminate BIS_fnc_credits_movie_script;
					BIS_fnc_credits_A3_display closeDisplay 0;
					(["BIS_fnc_credits_movie"] call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
				};
			};
			uinamespace setvariable ["BIS_fnc_credits_A3_keydown",BIS_fnc_credits_A3_keydown];
			_display displayaddeventhandler ["keydown","with uinamespace do {_this call BIS_fnc_credits_A3_keydown;};"];
			
			
			_ctrlLogoA = _display displayctrl 1310;
			if (false) then {
				_ctrlLogoA ctrlsettext "\a3\Ui_f\data\Logos\arma3apex_shadow_ca.paa";
			} else {
				_ctrlLogoA ctrlsettext "\a3\Ui_f\data\Logos\arma3_shadow_ca.paa";
			};
			_ctrlLogoA ctrlsettextcolor [1,1,1,1];
			_ctrlLogoA_W = 0.25 * safezoneW;
			_ctrlLogoA_H = 0.25 * safezoneH;
			_ctrlLogoA_X = 0.5 - _ctrlLogoA_W / 2;
			_ctrlLogoA_Y = safezoneY + safezoneH;
			_ctrlLogoA ctrlsetposition [_ctrlLogoA_X,_ctrlLogoA_Y,_ctrlLogoA_W,_ctrlLogoA_H];
			_ctrlLogoA ctrlcommit 0;

			_ctrlLogoA_Y = safezoneY - _ctrlLogoA_H;
			_ctrlLogoA ctrlsetposition [_ctrlLogoA_X,_ctrlLogoA_Y,_ctrlLogoA_W,_ctrlLogoA_H];
			_delayCoef = _delay * (1 + (_ctrlLogoA_H/safezoneH));
			_ctrlLogoA ctrlcommit _delayCoef;

			uiSleep 5;
			
			
			_oldId = 0;
			_id = 1;
			_c = 0;
			_cMod = 10;
			while {_id != _oldId} do {
				_oldId = _id;
				_nameArray = [_id] call BIS_fnc_credits_movieConfig;
				_ctrlText = _display displayctrl 9011;
				_ctrlTextOld = _display displayctrl 9012;
				
				if !((_nameArray select 2) < 0) then {
					_id = _id + 1;
					_text = (_nameArray select 0) + "<br/>" + (_nameArray select 1) + "<br/>";
					
					
					_ctrlText = _display displayctrl (9000 + (_c % _cMod));
					_ctrlText ctrlsetstructuredtext parsetext _text;
					_ctrlText_W = 0.8 * safezoneW;
					_ctrlText_H = ctrlTextHeight _ctrlText;
					_ctrlText_X = safezoneX + (safezoneW - _ctrlText_W)/2;
					_ctrlText_Y = safezoneY + safezoneH;
					_ctrlText ctrlsetposition [_ctrlText_X,_ctrlText_Y,_ctrlText_W,_ctrlText_H];
					_ctrlText ctrlcommit 0;

					
					_ctrlText_Y = safezoneY - _ctrlText_H;
					_ctrlText ctrlsetposition [_ctrlText_X,_ctrlText_Y,_ctrlText_W,_ctrlText_H];
					_delayCoef = _delay * (1 + (_ctrlText_H/safezoneH));
					_ctrlText ctrlcommit _delayCoef;
					
					_c = _c + 1;
					waitUntil {(((ctrlPosition _ctrlText) select 1) + ctrlTextHeight _ctrlText) < (safezoneY + safezoneH)};
				} else {		
					
					_text = (_supporterArray select 0) + "<br/>";
					
					_ctrlText = _display displayctrl (9000 + (_c % _cMod));
					_ctrlText ctrlsetstructuredtext parsetext _text;
					_ctrlText_W = 0.8 * safezoneW;
					_ctrlText_H = ctrlTextHeight _ctrlText;
					_ctrlText_X = safezoneX + (safezoneW - _ctrlText_W)/2;
					_ctrlText_Y = safezoneY + safezoneH;
					_ctrlText ctrlsetposition [_ctrlText_X,_ctrlText_Y,_ctrlText_W,_ctrlText_H];
					_ctrlText ctrlcommit 0;

					
					_ctrlText_Y = safezoneY - _ctrlText_H;
					_ctrlText ctrlsetposition [_ctrlText_X,_ctrlText_Y,_ctrlText_W,_ctrlText_H];
					_delayCoef = _delay * (1 + (_ctrlText_H/safezoneH));
					_ctrlText ctrlcommit _delayCoef;
					
					_c = _c + 1;
					waitUntil {(((ctrlPosition _ctrlText) select 1) + ctrlTextHeight _ctrlText) < (safezoneY + safezoneH)};
					
					
					_intPos = 0.1 * safeZoneW;
					_i = 0;
					_cMod = 9;
					_height = 0;
					{
						if ((typeName _x) == "STRING") then {
							_heightOld = _height;
							_text = _x;
							
							_ctrlText = _display displayctrl (9000 + (_c % _cMod));
							_ctrlText ctrlsetstructuredtext parsetext _text;
							_ctrlText_W = 0.8 * safezoneW / 3;
							_ctrlText_H = ctrlTextHeight _ctrlText;
							_ctrlText_X = safezoneX + _intPos;
							_ctrlText_Y = safezoneY + safezoneH;
							_ctrlText ctrlsetposition [_ctrlText_X,_ctrlText_Y,_ctrlText_W,_ctrlText_H];
							_ctrlText ctrlcommit 0;

							
							_ctrlText_Y = safezoneY - _ctrlText_H;
							_ctrlText ctrlsetposition [_ctrlText_X,_ctrlText_Y,_ctrlText_W,_ctrlText_H];
							_delayCoef = _delay * (1 + (_ctrlText_H/safezoneH));
							_ctrlText ctrlcommit _delayCoef;
							
							_c = _c + 1;
							_i = _i + 1;
							_intPos = _intPos + safezoneW * (0.8/3);
							_height = ctrlTextHeight _ctrlText;
							
							if (_height > _heightOld) then {
								_ctrlTextOld = _ctrlText
							}; 
							if (_i == 3) then {
								_height = 0;
								_i = 0;
								_intPos = 0.1 * safeZoneW;
								waitUntil {(((ctrlPosition _ctrlTextOld) select 1) + ctrlTextHeight _ctrlTextOld) < (safezoneY + safezoneH)};
							};
						};
					} forEach (_supporterArray select 1);
					waitUntil {(((ctrlPosition _ctrlTextOld) select 1) + ctrlTextHeight _ctrlTextOld) < (safezoneY + safezoneH)};
					_cMod = 10;
				};
				
			};
			
			uiSleep (_delay / 4);

			
			_ctrlLogo = _display displayctrl (1302 + (_c % _cMod));
			_ctrlLogo ctrlsettext "A3\Ui_f\data\Logos\bi_white_ca.paa";
			_ctrlLogo ctrlsettextcolor [1,1,1,1];
			_ctrlLogo_W = 0.5 * safezoneW;
			_ctrlLogo_H = 0.5 * safezoneH;
			_ctrlLogo_X = 0.5 - _ctrlLogo_W / 2;
			_ctrlLogo_Y = safezoneY + safezoneH;
			_ctrlLogo ctrlsetposition [_ctrlLogo_X,_ctrlLogo_Y,_ctrlLogo_W,_ctrlLogo_H];
			_ctrlLogo ctrlcommit 0;

			_ctrlLogo ctrlsetposition [_ctrlLogo_X,0.5 - (_ctrlLogo_H / 2),_ctrlLogo_W,_ctrlLogo_H];
			_delayCoef = _delay * (1 + (_ctrlLogo_H/safezoneH));
			_ctrlLogo ctrlcommit (_delayCoef / 2);

			waituntil {ctrlcommitted _ctrlLogo};
			
			uiSleep 10;

			BIS_fnc_credits_A3_display closeDisplay 0;
			(["BIS_fnc_credits_movie"] call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
			
		};
		
		waitUntil {isNull (uiNamespace getVariable ["A3_RscCredits", displayNull])};
		
	} else {
		
		
		uiSleep 3;
		102 cuttext ["","plain"];
		103 cuttext ["","plain"];

		BIS_fnc_credits_A3_display = nil;
		BIS_fnc_credits_A3_keydown = nil;
	};
};
