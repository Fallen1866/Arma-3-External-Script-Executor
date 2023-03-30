#line 0 "/temp/bin/A3/Functions_F/Scenes/fn_sceneCheckWeapons.sqf"















private["_neededWeapons", "_mode", "_missingWeaponsBeforeScene", "_LogicMissingWeaponsBeforeScene"];
_mode = "restore";
_neededWeapons = [];
if(!isNil "BIS_Miles") then {		_neededWeapons = _neededWeapons + [[BIS_Miles, "primary"]]};
if(!isNil "BIS_Sykes") then {		_neededWeapons = _neededWeapons + [[BIS_Sykes, "primary"]]};
if(!isNil "BIS_Rodriguez") then {	_neededWeapons = _neededWeapons + [[BIS_Rodriguez, "primary"]]};
if(!isNil "BIS_Ohara") then {		_neededWeapons = _neededWeapons + [[BIS_Ohara, "primary"]]};
if(!isNil "BIS_Cooper") then {		_neededWeapons = _neededWeapons + [[BIS_Cooper, "primary"]]};

if(BIS_debugModules) then {textLogFormat ["sceneCheckWeapons: Running"]};
if(isNil "BIS_sceneCheckWeaponsLogic") then
{
	BIS_sceneCheckWeaponsGroup = createGroup sideLogic;
	
	"Logic" createUnit [[1000,10,0], BIS_sceneCheckWeaponsGroup, "BIS_sceneCheckWeaponsLogic = this"];
	
	PublicVariable "BIS_sceneCheckWeaponsLogic";
	_mode = "setup";
	
};

if((count _this) > 0) then
{
	_neededWeapons = _this select 0;	
};


private["_defaultPistol", "_defaultPistolAmmo", "_defaultPrimaryWeapon", "_defaultPrimaryWeaponAmmo", "_checkIfHasPistol"];

_defaultPistol = "M9SD";
_defaultPistolAmmo = "15Rnd_9x19_M9SD";
_defaultPrimaryWeapon = "M4A1_HWS_GL_camo";
_defaultPrimaryWeaponAmmo = "30Rnd_65x39_mag";

_checkIfHasPistol = 
{
	private["_who", "_knownPistols", "_hasPistol"];
	_who = _this select 0;
	_knownPistols = ["M9", "M9SD", "Makarov", "MakarovSD", "Colt1911"];
	_hasPistol = "";
	{
		if(_x in (weapons _who)) then
		{
			_hasPistol = _x;
			if(BIS_debugModules) then {textLogFormat["%1 has pistol %2", _who, _x]};
		};
	}forEach _knownPistols;
	_hasPistol
};

switch(_mode) do
{
	case "setup":
	{
		private["_tmpMissingWeaponsBeforeScene", "_who", "_whatPistol"];
		if(BIS_debugModules) then {textLogFormat ["sceneCheckWeapons: Running in mode SETUP"]};
		_missingWeaponsBeforeScene = [];
		_participant = (count _neededWeapons) - 1; 
		while{_participant >= 0} do
		{
			_who = (_neededWeapons select _participant) select 0;			
			_neededWeapon = (_neededWeapons select _participant) select 1;		
			
	
			
			textLogFormat["_who: %1", _who];
			textLogFormat["_neededWeapon: %1", _neededWeapon];
			textLogFormat["he has : %1", primaryWeapon _who];
			
			switch(_neededWeapon) do
			{
				case "primary":							
				{
					if(primaryWeapon _who == "") then			
					{
						_tmpMissingWeaponsBeforeScene = [];
						_tmpMissingWeaponsBeforeScene = _tmpMissingWeaponsBeforeScene + [_who];
						_tmpMissingWeaponsBeforeScene = _tmpMissingWeaponsBeforeScene + ["primary"];
						_missingWeaponsBeforeScene = _missingWeaponsBeforeScene + [_tmpMissingWeaponsBeforeScene];	
						_who addMagazine _defaultPrimaryWeaponAmmo;	
						_who addWeapon _defaultPrimaryWeapon;
					};
					
					_who selectWeapon primaryWeapon _who;			
				};
				case "pistol":							
				{
					
					_whatPistol = [_who] call _checkIfHasPistol;
					if(_whatPistol == "") then				
					{
						_tmpMissingWeaponsBeforeScene = [];
						_tmpMissingWeaponsBeforeScene = _tmpMissingWeaponsBeforeScene + [_who];
						_tmpMissingWeaponsBeforeScene = _tmpMissingWeaponsBeforeScene + ["pistol"];
						_missingWeaponsBeforeScene = _missingWeaponsBeforeScene + [_tmpMissingWeaponsBeforeScene];	
						_who addMagazine _defaultPistolAmmo;		
						_who addWeapon _defaultPistol;
					};

					_who selectWeapon _defaultPistol;
				};
			};
			_participant = _participant - 1;		
		};
		BIS_sceneCheckWeaponsLogic setVariable ["_LogicMissingWeaponsBeforeScene", _missingWeaponsBeforeScene];
	};
	case "restore":								
	{
		private["_currentCharacter", "_whatWeaponWasMissing"];
		if(BIS_debugModules) then {textLogFormat ["sceneCheckWeapons: Running in mode RESTORE"]};
		_missingWeaponsBeforeScene = BIS_sceneCheckWeaponsLogic getVariable "_LogicMissingWeaponsBeforeScene";
		{
			_currentCharacter = _x select 0;
			_whatWeaponWasMissing = _x select 1;
			 switch(_whatWeaponWasMissing) do
			 {
			 	case "primary":
			 	{
				 	_currentCharacter removeWeapon _defaultPrimaryWeapon;
					_currentCharacter removeWeapon _defaultPrimaryWeaponAmmo;	
				};
				case "pistol":
				{
					_currentCharacter removeWeapon _defaultPistol;
					_currentCharacter removeWeapon _defaultPistolAmmo;
				};	
			 };
			
		}forEach _missingWeaponsBeforeScene;
		
		deleteVehicle BIS_sceneCheckWeaponsLogic;
		BIS_sceneCheckWeaponsLogic = nil;
		deleteGroup BIS_sceneCheckWeaponsGroup;

	};
};
