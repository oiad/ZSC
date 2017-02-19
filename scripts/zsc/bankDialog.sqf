if (dayz_actionInProgress) exitWith {"You are already performing an action, wait for the current action to finish." call dayz_rollingMessages;};
dayz_actionInProgress = true;

private ["_dialog","_playerNear","_isBusy","_typeOf"];

player setVariable["isBusy",true,true];
_isBusy = true;
ZSC_CurrentStorage = _this select 3;
_typeOf = typeOf ZSC_CurrentStorage;

if !(_typeOf in DZE_UnLockedStorage) exitWith {
	dayz_actionInProgress = false;
	player setVariable["isBusy",false,true];
	format ["%1 is not available for banking",_typeOf] call dayz_rollingMessages;
};

_playerNear = {isPlayer _x} count ((getPosATL cursortarget) nearEntities ["CAManBase", 10]) > 1;
if (_playerNear) exitWith {
	dayz_actionInProgress = false;
	player setVariable["isBusy",false,true];
	localize "str_pickup_limit_5" call dayz_rollingMessages;
};

_isBusy = ZSC_CurrentStorage getVariable["isBusy",false];
if (_isBusy) exitwith {
	dayz_actionInProgress = false;
	player setVariable["isBusy",false,true];
	format ["%1 is currently being banked with",_typeOf] call dayz_rollingMessages;
};

ZSC_CurrentStorage setVariable["isBusy",true,true];
_dialog = createDialog "BankDialog";
call BankDialogUpdateAmounts;

dayz_actionInProgress = false;