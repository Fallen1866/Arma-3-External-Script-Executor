#line 0 "/temp/bin/A3/Functions_F/GUI/fn_liveFeedEffects.sqf"













private ["_mode"];
_mode = _this param [0, 0, [0]];
if (_mode > 2) exitWith {"Invalid effects mode defined" call BIS_fnc_error; false};


"livefeedrendertarget0" setPiPEffect [0];

if (_mode >= 0) then {
	private ["_effectParams"];
	_effectParams = switch (_mode) do {
		
		case 0: {
			[3, 1, 1, 1, 0.1, [0, 0.4, 1, 0.1], [0, 0.2, 1, 1], [0, 0, 0, 0]]
		};
		
		
		case 1: {
			[1]
		};
		
		
		case 2: {
			[2]
		};
	};
	
	
	"livefeedrendertarget0" setPiPEffect _effectParams;
};

true
