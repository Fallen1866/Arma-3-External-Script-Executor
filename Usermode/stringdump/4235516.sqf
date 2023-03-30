#line 0 "/temp/bin/A3/Functions_F/Systems/fn_RespawnManager.sqf"

























DEBUGLOG "Started";

private["_functionCalled", "_returnValue", "_paramForFunction1", "_paramForFunction2"];

private["_Init", "_Destroy", "_AddCheckpoint", "_RemoveCheckpoint"];

private["_CheckNearestCheckpoint",
	"_CheckRespawnPointInLoop", 
	"_ShowCheckpoints", 
	"_ScanForAllCheckpoints", 
	"_SetNearestCheckpoint", 
	"_GetNearestCheckpoint"];







_Init = 
{
	private	[	"_respawners", "_tempActualCheckpoints", "_respawnMarker", "_checkPointPosition", "_marker", "_RESPAWN_DELAY", "_RESPAWN_COUNT",
			"_CheckpointMarkerType", "_CHECKPOINTMARKERTYPEDEFAULT", "_amountOfCheckpoints", "_returnValue", "_safePositions"
		];
		
	_respawners = (_this select 0) select 0;
	_safePositions = (_this select 0) select 1;
	
	
	_CheckpointMarkerType = _this select 1;
	if(isNil "BIS_RespawnManager") then
	{
		BIS_RespawnManagerGroup = createGroup sideLogic;
		"Logic" createUnit [[0,0,0], BIS_RespawnManagerGroup, "BIS_RespawnManager = this"];
		PublicVariable "BIS_RespawnManager";
		_RESPAWN_DELAY = 5;
		_RESPAWN_COUNT = 100;
		_CHECKPOINTMARKERTYPEDEFAULT = "EMPTY";				
		switch(_CheckpointMarkerType) do							
		{
			case "":
			{_CheckpointMarkerType = _CHECKPOINTMARKERTYPEDEFAULT};			
			case "true":
			{_CheckpointMarkerType = _CHECKPOINTMARKERTYPEDEFAULT};
			case "false":
			{_CheckpointMarkerType = "EMPTY"};
			default
			{_CheckpointMarkerType = "EMPTY"};
		};
		BIS_RespawnManager setVariable ["Respawners", _respawners, TRUE];
		BIS_RespawnManager setVariable ["CheckpointMarkerType", _CheckpointMarkerType, TRUE];		
		BIS_RespawnManager setVariable ["CheckpointPrefix", "BIS_checkpointnr", TRUE];			
		BIS_RespawnManager setVariable ["Checkpoints", [], TRUE];					
		BIS_RespawnManager setVariable ["NextCheckpointNr", 1, TRUE];					
		BIS_RespawnManager setVariable ["ScanEnabled", true, TRUE];					
		BIS_RespawnManager setVariable ["serNr", 0, TRUE];							
		BIS_RespawnManager setVariable ["Positions", ["gunner", "driver", "commander", "cargo"], TRUE];
		
		
		
		_tempActualCheckpoints = [];
		RespawnersCrew = [] ;
		{
			_tempActualCheckpoints = _tempActualCheckpoints + [[_x, ""]];			
		}forEach _respawners;
		BIS_RespawnManager setVariable ["ActualCheckpoints", _tempActualCheckpoints, TRUE];	
		
		private["_safePositionsCount", "_xxLoop"];
		_safePositionsCount = (count _safePositions);
		_defaultSafePos = [8179.12, 1881.57, 0];

		_xxLoop = 0;
		{											
			if(_safePositionsCount > 0) then
			{
				_x setVariable ["savepos", _safePositions select _xxLoop, true];	
				_xxLoop = _xxLoop + 1;
			}
			else
			{
				_x setVariable ["savepos", _defaultSafePos, true];			
			};
		} forEach _respawners;
	
		
		
		if((([] call _ScanForAllCheckpoints) - 2) != 0) then
		{
			_tempActualCheckpoints = (BIS_RespawnManager getVariable "Checkpoints");	
			DEBUGLOG format ["=================RespawnManager================="];
			DEBUGLOG format ["RespawnManager: Manager successfully initialized:"];
			DEBUGLOG format ["================================================"];
			{
				DEBUGLOG format ["RespawnManager: %1", _x];
			}forEach _tempActualCheckpoints;
			DEBUGLOG format ["Respawners:"];
			{
				DEBUGLOG format ["RespawnManager: %1", _x];
			}forEach (BIS_RespawnManager getVariable "Respawners");
			
			DEBUGLOG format ["================================================"];
		}
		else											
		{
			DEBUGLOG format ["=================RespawnManager================="];		
			DEBUGLOG format ["RespawnManager: ERROR: At least one checkpoint must be in the mission"];
			DEBUGLOG format ["RespawnManager: Manager initialization FAILED:"];
			DEBUGLOG format ["================================================"];			
			_returnValue = false;
			[] call _Destroy;								
		};
		
		{
			
			
			
			private["_code1", "_code2"];
					
			_code1 = "
					_whoDied = (_this select 0);						
					[""SetNearestCheckpoint"", _whoDied] call BIS_fnc_RespawnManager;
					DEBUGLOG format [""RespawnManager: Player %1 died"", _whoDied];				 	
				";
			_code2 = "
					DEBUGLOG format [""RespawnManager: this = %1"", _this];
					private[""_oldUnit"", ""_newUnit"", ""_tempActualCheckpoints"", ""_actualCheckpointAndUnit"", ""_nearestCheckpoint""];
					private[""_oldUnitMagazines"", ""_oldUnitWeapons"", ""_oldUnitTasks"", ""_tmpRespawners""];
					_newUnit = (_this select 0);
					_oldUnit = (_this select 1);
					_oldUnitMagazines = magazines _oldUnit;
					_oldUnitWeapons = weapons _oldUnit;
										
					
					_tmpRespawners = BIS_RespawnManager getVariable ""Respawners"";
					_tmpRespawners = _tmpRespawners - [_oldUnit] + [_newUnit];
					BIS_RespawnManager setVariable [""Respawners"", _tmpRespawners, true];
					
																				
					DEBUGLOG format[""RespawnManager:_oldUnit magazines = %1"", _oldUnitMagazines];
					DEBUGLOG format[""RespawnManager:_oldUnit weapons = %1"", _oldUnitWeapons];
					DEBUGLOG format[""RespawnManager:_oldUnit tasks = %1"", _oldUnitTasks];
					removeAllWeapons _newUnit;
					{
						_newUnit addMagazine _x	
					}forEach _oldUnitMagazines;
					{
						_newUnit addWeapon _x	
					}forEach _oldUnitWeapons;
					_newUnit selectWeapon (currentWeapon _oldUnit);
										
					
					_nearestCheckpoint = (BIS_RespawnManager getVariable ""Checkpoints"") select 0;	
															
					_tempActualCheckpoints = BIS_RespawnManager getVariable ""ActualCheckpoints"";
					{
						_actualCheckpointAndUnit = _x;
						if(_oldUnit in _actualCheckpointAndUnit) then				
						{
							_nearestCheckpoint = _actualCheckpointAndUnit select 1;		
							_actualCheckpointAndUnit set [0, _newUnit];			
						};
					}forEach _tempActualCheckpoints;
					DEBUGLOG format[""_oldUnit:%1|vehicle _oldUnit:%2"", vehicle _oldUnit, _oldUnit];	
					DEBUGLOG format[""crew: %1"", _oldUnit getVariable ""vehicleCrew""];
					DEBUGLOG format[""crew: %1"", _newUnit getVariable ""vehicleCrew""];
					if(isNil(compile format[""%1_Vehicle"", _oldUnit])) then
					{
						DEBUGLOG format[""RespawnManager:Moving NOT to the %1_Vehicle"", _newUnit];
						markerpos _nearestCheckpoint;
							
					}					
					else
					{
						DEBUGLOG format[""Moving to the %1_Vehicle"", _newUnit];
						if(!alive (call compile format[""%1_Vehicle"", _newUnit])) then
						{
							DEBUGLOG format[""RespawnManager:BUT DOESNT ALIVE"", _newUnit];
						};
						if(!canmove (call compile format[""%1_Vehicle"", _newUnit])) then
						{
							(call compile format[""%1_Vehicle"", _newUnit]) setpos [10,10,0];	
							(call compile format[""%1_Vehicle"", _newUnit]) setdamage 1;
						};
						[_newUnit, _nearestCheckpoint, _oldUnit]spawn
						{
							_newUnit = _this select 0;
							_nearestCheckpoint = _this select 1;
							_oldUnit = _this select 2;
							_t = time + 6;
							DEBUGLOG format[""RespawnManager:Waiting for vehicle %1_Vehicle respawn"", _newUnit];
							WaitUntil{alive (call compile format[""%1_Vehicle"", _newUnit])};
							DEBUGLOG ""RespawnManager:Vehicle respawned!"";
							
							
							_newpos1 = [markerpos _nearestCheckpoint, 0, 80, 15, 0, 60 * (pi / 180), 0, [], [(_newUnit getvariable ""savepos""), []]] call BIS_fnc_findSafePos;
							call compile format[""%1_Vehicle setpos _newpos1"", _newUnit];
							DEBUGLOG format[""RespMan: crew: %1"", _newUnit getVariable ""vehicleCrew""];
							_xCrew = _newUnit getVariable ""vehicleCrew"";
							[""ReplaceNullObjectInArray"", [_newUnit]] call BIS_fnc_RespawnManager;
						
							_newUnit setVariable [""vehicleCrew"", _xCrew, true];
							
							[""RespawnCrew"", [(call compile format[""%1_Vehicle"", _newUnit]), _xCrew, _newUnit]] call BIS_fnc_RespawnManager;
							true
						};
						
					};
				 															 	
				";
			x = [objNull, _x, "per", rSPAWN, [str _x, _code1], {(call compile (_this select 0)) addEventHandler ["killed", _this select 1];}] call RE;		
			x = [objNull, _x, "per", rSPAWN, [str _x, _code2], {(call compile (_this select 0)) addEventHandler ["respawn", _this select 1];}] call RE;
			
			
			
			if(isNil(compile format["%1_Vehicle", _x])) then
			{
				DEBUGLOG format["RespMan: %1 is without a vehicle", _x];
			}
			else	
			{
				DEBUGLOG format["RespMan: %1 has vehicle", _x];
				_crew = [(call compile format["%1_Vehicle", _x]), _x] call _CheckTheVehicleCrew;
				(call compile format["%1", _x]) setVariable ["vehicleCrew", _crew, true];
				private["_myCode2"];
				_myCode2 = 
				{
					private ["_what"];
					_what = _this select 0;
					_what respawnVehicle[-1, 0];		
				};
				[objNull, _x, rSPAWN, [(call compile format["%1_Vehicle", _x])], _myCode2] call RE;
				
			};
			

			DEBUGLOG format ["RespawnManager: unit:%1|vehicle Unit:%2", _x, vehicle _x];
			
		}foreach _respawners;
		
		
		_returnValue = true;
	}
	else
	{
		DEBUGLOG "RespawnManager: Already initialized";
		_returnValue = false;
	};
	_returnValue
};


_Destroy = 
{
	
	BIS_RespawnManager setVariable ["ScanEnabled", false, TRUE];				
	deleteVehicle BIS_RespawnManager;
	BIS_RespawnManager = nil;
	deleteGroup BIS_RespawnManagerGroup;
	DEBUGLOG "RespawnManager: Deinitialized";
	true;
};








_ScanForAllCheckpoints = 
{
	private["_scanEnabled", "_checkPointNumber", "_checkPointPrefix", "_checkPointPosition", "_checkPointsArray"];
	_checkPointNumber = BIS_RespawnManager getVariable "NextCheckpointNr";
	_checkPointPrefix = BIS_RespawnManager getVariable "CheckpointPrefix";
	_checkPointsArray = BIS_RespawnManager getVariable "Checkpoints";
	
	_scanEnabled = true;
	while{_scanEnabled} do								
	{
		_checkPointName = _checkPointPrefix + str(_checkPointNumber);
		_checkPointPosition = getMarkerpos _checkPointName;
		if((_checkPointPosition select 0 != 0) && (_checkPointPosition select 1 != 0)) then 
		{
			call compile format["_checkPointsArray = _checkPointsArray + [%1]", str(_checkPointName)];
		}
		else
		{
			_scanEnabled = false;
		};
		_checkPointNumber = _checkPointNumber + 1;
		
	};
	BIS_RespawnManager setVariable ["Checkpoints", _checkPointsArray, TRUE];
	BIS_RespawnManager setVariable ["NextCheckpointNr", (_checkPointNumber-1), TRUE];	
	_checkPointNumber	
};









_CheckRespawnPointInLoop =
{
	[]spawn
	{
		private["_respawner", "_tempActualCheckpoints", "_actualCheckpointAndUnit", "_nearestCheckpoint"];
		_tempActualCheckpoints = BIS_RespawnManager getVariable "ActualCheckpoints";
		while{(BIS_RespawnManager getVariable "ScanEnabled")} do
		{

			_tempActualCheckpoints = BIS_RespawnManager getVariable "ActualCheckpoints";
			{
				_actualCheckpointAndUnit = _x;
				
				_respawner = _actualCheckpointAndUnit select 0;
				
				_nearestCheckpoint = ["CheckNearestCheckpoint", _respawner] call BIS_fnc_RespawnManager;
				_actualCheckpointAndUnit set [1, _nearestCheckpoint];					
				
				BIS_RespawnManager setVariable ["ActualCheckpoints", BIS_RespawnManager getVariable "ActualCheckpoints", true];
				
				if(isplayer _respawner) then
				{
					
					call compile format ["_nic = [nil, _respawner, ""loc"", rSETMARKERPOSLOCAL, ""%1"", (markerPos _nearestCheckpoint)] call RE", (BIS_RespawnManager getVariable "RespawnMarker")];
					
					
				};
				Sleep 1;
			}forEach _tempActualCheckpoints;
			Sleep 1;
		};
		
	}; 
	true
};







_CheckNearestCheckpoint = 
{
	private["_respawner", "_tempCheckpoints", "_nearestCheckpoint", "_distance", "_checkPoint"];
	_respawner = _this select 0;	
	_tempCheckpoints = BIS_RespawnManager getVariable "Checkpoints";
	_distance = 99999999;
	{
		call compile format["_checkPoint = ""%1""", _x];
		_tempDistance = (_respawner distance (markerpos _checkPoint));
		
		if(_tempDistance <= _distance) then
		{
			call compile format["_nearestCheckpoint = ""%1""", _checkPoint];
			_distance = _tempDistance;
		}; 	
	}forEach _tempCheckpoints;
	
	_nearestCheckpoint
};








_SetNearestCheckpoint =
{
	private["_respawner", "_tempActualCheckpoints", "_actualCheckpointAndUnit", "_nearestCheckpoint"];
	_respawner = _this select 0;
	_tempActualCheckpoints = BIS_RespawnManager getVariable "ActualCheckpoints";
	{
		_actualCheckpointAndUnit = _x;
		if(_respawner in _actualCheckpointAndUnit) then
		{
			_nearestCheckpoint = ["CheckNearestCheckpoint", _respawner] call BIS_fnc_RespawnManager;	
			_actualCheckpointAndUnit set [1, _nearestCheckpoint];
			
		};
	}forEach _tempActualCheckpoints;	
	true	
};







private["_GetNearestCheckpoint"];
_GetNearestCheckpoint = 
{
	private["_respawner", "_tempActualCheckpoints", "_actualCheckpointAndUnit", "_nearestCheckpoint"];
	_respawner2 = _this select 0;
	_nearestCheckpoint = BIS_RespawnManager getVariable "Checkpoints" select 0;					
	_tempActualCheckpoints = BIS_RespawnManager getVariable "ActualCheckpoints";
	{
		_actualCheckpointAndUnit = _x;
		DEBUGLOG format["_respawner match: %1 ", (_respawner2 == _x select 0)];	
		if(_respawner2 in _actualCheckpointAndUnit) then
		{
			_nearestCheckpoint = _actualCheckpointAndUnit select 1;
		};
	}forEach _tempActualCheckpoints;
	_nearestCheckpoint	
};







_RemoveCheckpoint = 
{
	private["_tempCheckpoints", "_checkPointToDelete", "_returnValue"];	
	_checkPointToDelete = _this select 0;
	_tempCheckpoints = BIS_RespawnManager getVariable "Checkpoints";
	if((count _tempCheckpoints) != 1) then
	{
		if(_checkPointToDelete in _tempCheckpoints) then
		{
			call compile format ["_tempCheckpoints = _tempCheckpoints - [""%1""]", _checkPointToDelete];
			BIS_RespawnManager setVariable ["Checkpoints", _tempCheckpoints, TRUE];
			call compile format ["deleteMarker ""%1"" ", _checkPointToDelete];
			[] call _ShowCheckpoints;
			_returnValue = true;
		}
		else
		{
			DEBUGLOG format ["=================RespawnManager================="];		 
			DEBUGLOG format ["RespawnManager: ERROR: Marker with given name NOT FOUND"];
			DEBUGLOG format ["RespawnManager: Checkpoint remove FAILED:"];
			DEBUGLOG format ["================================================"];
			_returnValue = false;
		}
	}
	else
	{
		DEBUGLOG format ["=================RespawnManager================="];		 
		DEBUGLOG format ["RespawnManager: ERROR: At least one checkpoint must be in the mission"];
		DEBUGLOG format ["RespawnManager: Checkpoint remove FAILED:"];
		DEBUGLOG format ["================================================"];	
		_returnValue = false;		
	};
	_returnValue
};













_AddCheckpoint = 
{
	private	[	"_tempCheckpoints", "_checkPointToAdd", "_checkpointNumber", 
			"_checkPointName", "_checkPointPrefix", "_marker",
			"_checkpointPos", "_checkPointNameText"
		];

	_checkpointPos = _this select 0;		
	_tempCheckpoints = BIS_RespawnManager getVariable "Checkpoints";
	if((_this select 1) != "") then
	{
		_checkPointName = _this select 1;
		_checkPointNameText = _checkPointName;
	}
	else
	{
		_checkpointNumber = BIS_RespawnManager getVariable "NextCheckpointNr";
		BIS_RespawnManager setVariable ["NextCheckpointNr", (_checkpointNumber + 1), TRUE];
		_checkPointPrefix = BIS_RespawnManager getVariable "CheckpointPrefix";
		_checkPointName = _checkPointPrefix + str(_checkPointNumber);
		_checkPointNameText = "CheckPoint_" + str(_checkPointNumber);	
	};

	call compile format ["_marker = createMarker [""%1"", _checkpointPos];", _checkPointName];
	_marker setMarkerShape "ICON";
	call compile format ["""%1"" setMarkerType ""%2"";", _checkPointName, BIS_RespawnManager getVariable "CheckpointMarkerType"];
	
	
	call compile format ["""%1"" setMarkerText ""%2"";", _checkPointName, _checkPointNameText];
	call compile format ["_tempCheckpoints = _tempCheckpoints + [""%1""]", _checkPointName];
	
	BIS_RespawnManager setVariable ["Checkpoints", _tempCheckpoints, TRUE];
	[] call _ShowCheckpoints;
	true
};







_ShowCheckpoints = 
{
	private["_tempActualCheckpoints"];
	_tempActualCheckpoints = (BIS_RespawnManager getVariable "Checkpoints");
	DEBUGLOG format ["RespawnManager: Checkpoints:"];
	{
		DEBUGLOG format ["RespawnManager: %1", _x];
	}forEach _tempActualCheckpoints;
	true
};










_CheckTheVehicleCrew = 
{
	private["_vehicle", "_crew", "_crewParams", "_name", "_class", "_gunner", "_driver", "_commander", "_functionInVehicle", "_playerMP", "_newName"];
	_vehicle =  _this select 0;
	_playerMP = _this select 1;
	
	
	_gunner = assignedGunner _vehicle;
	_driver = assignedDriver _vehicle;
	_commander = assignedCommander _vehicle;
	_cargo = assignedCargo _vehicle;
	_crew = crew _vehicle - [_playerMP] - playableUnits;
	_newName = "";
	
	
		
	_crewParams = [];
	{
		_functionInVehicle = "none";
		_name = _x;
		
		if(vehicleVarName _name == "") then
		{
			_serNr = (BIS_RespawnManager getVariable "serNr") + 1;		
			_newName = (str _vehicle) + (str _serNr);
			
			call compile format ["%1 = _x; PublicVariable ""%1""; ", _newName];
			_nic = [objNull, _x, rSPAWN, [_x, _newName], {(_this select 0) setVehicleVarName (_this select 1)}] call RE;
			PublicVariable _newName;
			private["_myCode"];
			_myCode = 
			{
				private["_who", "_newName2"];
				_who = _this select 0;
				_newName2 = _this select 1;
				DEBUGLOG format ["_newName: %1", _newName2];
				PublicVariable _newName2;
				_who setVehicleVarName _newName2;
				call compile format["%1 = _who", _newName2];
				
			};
			[objNull, _playerMP, "locper", rSPAWN, [_x, _newName], _myCode] call RE;

			BIS_RespawnManager setVariable ["serNr", _serNr, true];		
			
		}
		else
		{
			_newName = _name; 
		};
		
		
	
		_class = typeof _x;
		switch(_name) do
		{
			case _gunner:
			{
				_functionInVehicle = "gunner";	
			};
			case _driver:
			{
				_functionInVehicle = "driver";	
			};
			case _commander:
			{
				_functionInVehicle = "commander	";	
			};
			case _cargo:
			{
				_functionInVehicle = "cargo";	
			};	
			default
			{
				
			};
		}; 
		
















		
		call compile format["_crewParams = _crewParams + [[%1, _class, _functionInVehicle]]", _newName];
	}forEach _crew;
	_crewParams
};
_RespawnCrew = 
{ 
	private["_vehicle", "_crew", "_actualUnit", "_name", "_class", "_function"];
	_vehicle = (_this select 0) select 0;
	_crew = (_this select 0) select 1;
	_who = (_this select 0) select 2;
	{
		_actualUnit = _x;
		
		_name = _actualUnit select 0;
		_class = _actualUnit select 1;
		_function = _actualUnit select 2;
	
		DEBUGLOG format ["_actualUnit: %1|%2|%3|%4", _actualUnit,_name,_class,_function];
	
		


	
			if(_function != "none") then
			{
				
				if(!alive _name) then
				{
					DEBUGLOG format ["_this = group player createUnit [""%1"", Position player, [], 0, ""CAN_COLLIDE""];", _class];
					call compile format ["_this = group player createUnit [""%1"", Position player, [], 0, ""CAN_COLLIDE""];", _class];
					call compile format ["%1 = _this;", _name];
					call compile format ["_this setVehicleVarName ""%1""", _name];
				};
				call compile format ["_name assignAs%1 _vehicle", _function];
				call compile format ["%1 moveIn%2 %3", _name, _function, _vehicle];	
				
					
				DEBUGLOG format ["%1 will be %2]", _name, _function];
				DEBUGLOG format ["%1 moveIn%2 %3", _name, _function, _vehicle];
			};
		


				
	}forEach _crew;
	private["_positions", "_playerInVehicle", "_who"];
	_positions = BIS_RespawnManager getVariable "Positions";			
	_playerInVehicle = false;
	{
		
		if(((_vehicle emptyPositions _x) > 0) && !(_playerInVehicle)) then
		{
			call compile format ["%1 moveIn%2 %3", _who, _x, _vehicle];	
			_playerInVehicle = true;
		};
	}forEach _positions;
	
		
	true
};

_ReplaceNullObjectInArray = 
{
	call compile format 
	["
		private[""_who"", ""_crew"", ""_actualUnit"", ""_name"", ""_i"", ""_j"", ""_class"", ""_func""];
		
		_who = (_this select 0) select 0;
		DEBUGLOG format [""RespawnManager:Replace in array""];
		_i = 0;
		_j = 0;
		{
			_actualUnit = _x; 
			_name = _actualUnit select 0;
			_class = _actualUnit select 1;
			_func = _actualUnit select 2;
			if((typeName _name) == ""OBJECT"") then
			{
				if(isNull _name) then
				{
					_actualUnit set [0, _who];
					_crew set [_i, _actualUnit];	
				};			
			};
			_i = _i + 1;	
		}forEach %1;
	",_who getVariable "vehicleCrew"
	
	];
	
	true	
};































































_paramForFunction1 = "";
_paramForFunction2 = "";
_returnValue = 0;
_functionCalled = _this select 0;
if(count _this > 1) then
{
	_paramForFunction1 = _this select 1;
};
if(count _this > 2) then
{
	_paramForFunction2 = _this select 2;
};

private ["_callString"];



if!(isNil "BIS_RespawnManager" && _functionCalled != "Init") then
{
	
	
	if(typeName _paramForFunction1 == "STRING") then
	{
		_callString = "_returnValue = [""%1"", ""%3""] call _%2";
	}
	else
	{
		_callString = "_returnValue = [%1, ""%3"" ] call _%2";
	};	
	call compile format [_callString, _paramForFunction1, _functionCalled, _paramForFunction2];
}
else
{
	DEBUGLOG format["RespawnManager: Initialize the manager first using Init parameter please!"];
	_returnValue = false;
};

_returnValue

