# [EPOCH 1.0.6+] Zupa Single Currency
Zupas Single Currency script updated for Epoch 1.0.6+ by salival.

* Discussion URL: https://epochmod.com/forum/topic/43331-zsc-for-epoch-106-and-overwatch-025/
* original install url: https://github.com/EpochSC/SingleCurrencyStorage
* original discussion url: https://epochmod.com/forum/topic/28493-alpha-release-single-currency-30-storage-default-hive-no-global-banking/
	
* Tested as working on a blank Epoch 1.0.6+ and OverWatch 0.25 server.
* Designed to minimize duping/glitching of bank related saving with nearby players (checkWallet etc).
* Lots of code snippets taken from the original Zupa release thread to stop multiple people checking wallet/depositing into the same safe etc.
* Supports multiple configuration types, Safes/lockboxes only, vehicles only, safes/lockboxes AND vehicles.
* No global banking.

# Install:

* This install basically assumes you have NO custom variables.sqf or compiles.sqf or fn_selfActions.sqf, I would recommend diffmerging where possible. 
* This has all the config traders set up for epoch 1.0.6 items and OverWatch guns/items. You will need to install the specific version you want to use, See install notes further down.

**[>> Download <<] (https://github.com/oiad/ZSC/archive/master.zip)**

# REPORTING ERRORS/PROBLEMS

1. Please, if you report issues can you please attach (on pastebin or similar) your CLIENT rpt log file as this helps find out the errors very quickly. To find this logfile:

	```sqf
	C:\users\<YOUR WINDOWS USERNAME>\AppData\Local\Arma 2 OA\ArmA2OA.RPT
	```

# Mission folder install:

1. In mission\init.sqf find: 
	```sqf
	call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";
	```
	
	and add directly below:

	```sqf
	call compile preprocessFileLineNumbers "dayz_code\init\variables.sqf";
	```
	
2. In mission\init.sqf find: 
	```sqf
	call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";
	```
	
	and add directly below:

	```sqf
	call compile preprocessFileLineNumbers "dayz_code\init\compiles.sqf";
	```

3. In mission\init.sqf find: 
	```sqf
	call compile preprocessFileLineNumbers "server_traders.sqf";
	```
	
	and replace with:

	```sqf
	call compile preprocessFileLineNumbers "scripts\traders\server_traders.sqf";
	```

4. In mission\init.sqf find: 
	```sqf
	waitUntil {scriptDone progress_monitor};
	```
	
	and add directly above:

	```sqf
	call compile preprocessFileLineNumbers "scripts\zsc\zscInit.sqf";
	execVM "scripts\zsc\playerHud.sqf";
	```

5. Replace your original description.ext with the one provided or merge the contents if you have modified your own version.

6. If you are running Epoch 1.0.6 and NOT running Epoch 1.0.6.1+ you must uncomment: 

	```sqf
	//player_humanityMorph = compile preprocessFileLineNumbers "dayz_code\compile\player_humanityMorph.sqf";
	```
	in the supplied <code>dayz_code\init\compiles.sqf</code> since it doesn't refresh coins on a skin change. Epoch 1.0.6.1+ fixes this issue so you do not need to uncomment it.

# dayz_server folder install:

1. Replace or merge the contents of <code>server_handleSafeGear.sqf</code> provided with your original copy.

2. Replace or merge the contents of <code>server_updateObject.sqf</code> provided with your original copy.

# Changing from default epoch CfgTraders to OverWatch CfgTraders:

1. In <code>dayz_code\configs</code> move or delete the folder <code>Category</code> and the file <code>cfgServerTrader.hpp</code> 

2. Rename <code>Category - Overwatch</code> to <code>Category</code> 

3. Rename <code>cfgServerTrader - Overwatch.hpp</code> to <code>cfgServerTrader.hpp</code>

4. In <code>scripts\traders</code> move or delete the file <code>server_traders.sqf</code>

5. Rename <code>server_traders - overwatch.sqf</code> to <code>server_traders.sqf</code>

# Adding other classnames to the list of DZE_MoneyStorageClasses:

1. In <code>dayz_code\init\variables.sqf</code> find: 
	```sqf
	DZE_MoneyStorageClasses = DZE_LockableStorage;
	```
	
	and replace with (using Plastic_Pole_EP1_DZ as an example):

	```sqf
	DZE_MoneyStorageClasses = DZE_LockableStorage + ["Plastic_Pole_EP1_DZ"];
	```

# Using vehicles to store coins ONLY:

1. In <code>scripts\zsc\bankDialog.sqf</code> find:
	```sqf
	if !(_typeOf in DZE_MoneyStorageClasses) exitWith {
	```
	
	and replace with:

	```sqf
	if !(ZSC_CurrentStorage isKindOf "AllVehicles") exitWith {
	```
	
2. In <code>dayz_code\compile\fn_selfActions.sqf</code> find: 
	```sqf
	if (_typeOfCursorTarget in DZE_MoneyStorageClasses && {!locked _cursorTarget} && !(_typeOfCursorTarget in DZE_LockedStorage) && {player distance _cursorTarget < 5}) then {
	```
	
	and replace with:

	```sqf
	if (_isVehicle && {!_isMan} && {!locked _cursorTarget} && {_isAlive} && {player distance _cursorTarget < 5}) then {
	```
	
3. #dayz_server folder install:

	Replace or merge the contents of <code>dayz_server\system\server_monitor.sqf/code> provided with your original copy.

# Using vehicles AND DZE_MoneyStorageClasses to store coins:

1. In <code>scripts\zsc\bankDialog.sqf</code> find: 
	```sqf
	if !(_typeOf in DZE_MoneyStorageClasses) exitWith {
	```
	
	and replace with:

	```sqf
	if ((!(_typeOf in DZE_MoneyStorageClasses) && !(cursortarget isKindOf "AllVehicles"))) exitWith {
	```
	
2. In <code>dayz_code\compile\fn_selfActions.sqf</code> find: 
	```sqf
	if (_typeOfCursorTarget in DZE_MoneyStorageClasses && {!locked _cursorTarget} && !(_typeOfCursorTarget in DZE_LockedStorage) && {player distance _cursorTarget < 5}) then {
	```
	
	and replace with:

	```sqf
	if ((_typeOfCursorTarget in DZE_MoneyStorageClasses || _isVehicle) && {!_isMan} && {!locked _cursorTarget} && {_isAlive} && !(_typeOfCursorTarget in DZE_LockedStorage) && {player distance _cursorTarget < 5}) then {
	```
	
3. #dayz_server folder install:

	Replace or merge the contents of <code>dayz_server\system\server_monitor.sqf/code> provided with your original copy.
	
# Battleye filters install:

1. In your config\<yourServerName>\Battleye\scripts.txt around line 12: <code>5 createDialog</code> or <code>5 "createDialog"</code> add this to the end of it:

	```sqf
	!="_dialog = createDialog \"BankDialog\";" !="_dialog = createdialog \"GivePlayerDialog\";"
	```
	
	So it will then look like this for example:

	```sqf
	5 "createDialog" <CUT> !="_dialog = createDialog \"BankDialog\";" !="_dialog = createdialog \"GivePlayerDialog\";"
	```