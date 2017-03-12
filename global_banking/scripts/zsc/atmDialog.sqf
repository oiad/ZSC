if (dayz_actionInProgress) exitWith {"You are already performing an action, wait for the current action to finish." call dayz_rollingMessages;};
dayz_actionInProgress = true;

private ["_dialog","_playerNear","_isBusy","_typeOf"];

player setVariable["isBusy",true,true];
_isBusy = true;
_typeOf = typeOf cursorTarget;

if !(_typeOf in ZSC_bankObjects || _typeOf in ZSC_bankTraders) exitWith {
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

_dialog = createdialog "atmDialog";
call AtmDialogUpdateAmounts;

dayz_actionInProgress = false;