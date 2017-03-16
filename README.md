# [EPOCH 1.0.6+] Zupa Single Currency
Zupas Single Currency script updated for Epoch 1.0.6+ by salival.

* Discussion URL: https://epochmod.com/forum/topic/43331-zsc-for-epoch-106-and-overwatch-025/
* original install url: https://github.com/EpochSC/SingleCurrencyStorage
* original discussion url: https://epochmod.com/forum/topic/28493-alpha-release-single-currency-30-storage-default-hive-no-global-banking/
	
* Tested as working on a blank Epoch 1.0.6+ and OverWatch 0.25 server.
* Designed to minimize duping/glitching of bank related saving with nearby players (checkWallet etc).
* Lots of code snippets taken from the original Zupa release thread to stop multiple people checking wallet/depositing into the same safe etc.
* Supports multiple configuration types, Safes/lockboxes only, vehicles only, safes/lockboxes AND vehicles.
* Supports any map, currently only has server_traders files for Chernarus (default), napf and tavi.
* To install global banking: https://github.com/oiad/ZSC#changing-to-global-banking

# Thanks to:
* Zupa for his awesome script being a really good base to start from.
* JasonTM for getting a working copy of the global banking (https://github.com/worldwidesorrow)
* kingpapawawa for helping with testing and supplying the bank icon

# Install:

* This install basically assumes you have NO custom variables.sqf or compiles.sqf or fn_selfActions.sqf, I would recommend diffmerging where possible. 
* This has all the config traders set up for epoch 1.0.6+ items and OverWatch guns/items. You will need to install the specific version you want to use, See install notes further down.

# Epoch 1.0.6.1
* Please note, to keep things simple I have removed files/information pertaining to 1.0.6, onwards to the future of 1.0.6.1!

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
	[] execVM "dayz_code\compile\remote_message.sqf";
	```

5. Replace your original description.ext with the one provided or merge the contents if you have modified your own version.

# dayz_server folder install:

1. Replace or merge the contents of <code>server_handleSafeGear.sqf</code> provided with your original copy.

2. Replace or merge the contents of <code>server_updateObject.sqf</code> provided with your original copy.

# Battleye filter install.

1. In your config\<yourServerName>\Battleye\scripts.txt around line 12: <code>5 createDialog</code> or <code>5 "createDialog"</code> add this to the end of it:

	```sqf
	!="_dialog = createDialog \"BankDialog\";" !="_dialog = createdialog \"GivePlayerDialog\";"
	```
	
	So it will then look like this for example:

	```sqf
	5 "createDialog" <CUT> !="_dialog = createDialog \"BankDialog\";" !="_dialog = createdialog \"GivePlayerDialog\";"
	```

# Changing to global banking:

1. Install ZSC as above to use as a base, global banking is a modular based install so ZSC is required.

2. In mission\init.sqf find:
	```sqf
	call compile preprocessFileLineNumbers "scripts\zsc\zscInit.sqf";
	```
	
	and add directly below:
	```sqf
	call compile preprocessFileLineNumbers "scripts\zsc\zscATMInit.sqf";
	```

3. In mission\description.ext find:
	```sqf
	#include "dayz_code\configs\zscDialogs.hpp"
	```
	
	and add directly below:
	```sqf
	#include "dayz_code\configs\zscATMdialogs.hpp"
	```

4. In mission\dayz_code\init\compiles.sqf find:
	```sqf
	fnc_usec_selfactions = compile preprocessFileLineNumbers "dayz_code\compile\fn_selfActions.sqf";
	```
	
	and add directly below:
	```sqf
	player_humanityMorph = compile preprocessFileLineNumbers "dayz_code\compile\player_humanityMorph.sqf"; // This line can be removed when Epoch 1.0.6.2 comes out.
	```
	
5. In mission\dayz_code\init\variables.sqf find:
	```sqf
	ZSC_MaxMoneyInStorageMultiplier = 50000; // Multiplier for how much money a bank object can hold, example: 200 magazine slots in the object (or the default value above ^^) multiplied by the 50,000 multiplier is 10 million coin storage. (200*50000=10m coins)
	```
	
	and add directly below:
	```sqf
	Z_bankVariable = "moneySpecial"; // If using single currency this is the variable name used to store object bank wealth.
	Z_globalVariable = "GlobalMoney"; // If using single currency this is the variable name used to store coins globally.
	//Z_moneyVariable = "GlobalMoney"; // Uncomment this this to make it so players don't lose coins on death. Will need to disable checkWallet as you can dupe if you have this and check wallet running.
	
	/*
		IMPORTANT: The following 2 variables below are CASE SENSITIVE! If you don't put the object/trader classname EXACTLY how
		they appear in game, THEY WILL NOT WORK!
	*/

	ZSC_bankObjects = [""]; // Array of objects that are available for banking (i.e Suitcase, Info_Board_EP1)
	ZSC_bankTraders = ["Functionary1_EP1_DZ"]; // Array of trader classnames that are available for banking (i.e Functionary1_EP1_DZ)
	ZSC_limitOnBank = true; // Have a limit on the bank? (i.e true or false) limits the global banking to the number below.
	ZSC_maxBankMoney = 5000000; // Default limit for bank objects.
	```

6. Copy the following files to your mission folder preserving the directory structure:
	```sqf
	dayz_code\compiles\player_humanityMorph.sqf
	dayz_code\configs\zscATMdialogs.hpp
	dayz_code\scripts\zsc\images\bank.paa
	dayz_code\scripts\zsc\atmDialog.sqf
	dayz_code\scripts\zsc\playerHud.sqf
	dayz_code\scripts\zsc\zscATMInit.sqf
	```
	
7. Battleye filters for global banking:

	In your config\<yourServerName>\Battleye\scripts.txt around line 12: <code>5 createDialog</code> or <code>5 "createDialog"</code> add this to the end of it:
	```sqf
	!"_dialog = createdialog \"atmDialog\";"
	```

	So it will then look like this for example:

	```sqf
	5 "createDialog" <CUT> !"_dialog = createDialog \"BankDialog\";" !"_dialog = createdialog \"GivePlayerDialog\";" !"_dialog = createdialog \"atmDialog\";"
	```

# Installing NPC based banks (optional)

1. Copy the following directory to your dayz_server folder:
	```sqf
	dayz_server\bankTraders
	```

2. In mission\init.sqf find this line:
	```sqf
	execVM "\z\addons\dayz_server\traders\chernarus11.sqf"; //Add trader agents
	```
	
	add this line directly below:
	```sqf
	execVM "\z\addons\dayz_server\bankTraders\chernarus.sqf"; //Add banking agents
	```
	You can chose from the following files depending on your map:
	```sqf
	chernarus.sqf
	lingor.sqf
	namalsk.sqf
	napf.sqf
	panthera.sqf
	tavi.sqf
	```

# Changing so players don't lose coins on death (PVE weenies)

1. In mission\dayz_code\init\variables.sqf find:
	```sqf
	//Z_moneyVariable = "GlobalMoney"; // Uncomment this this to make it so players don't lose coins on death. Will need to disable checkWallet as you can dupe if you have this and check wallet running.
	```
	
	Uncomment this line and coins will not be lost on death. You will also need to disable/remove check wallet as then players can get unlimited coins by constantly checking their body.

# Changing from default epoch CfgTraders to OverWatch CfgTraders:

1. In <code>dayz_code\configs</code> move or delete the folder <code>Category</code> and the file <code>cfgServerTrader.hpp</code> 

2. Rename <code>Category - Overwatch</code> to <code>Category</code> 

3. Rename <code>cfgServerTrader - Overwatch.hpp</code> to <code>cfgServerTrader.hpp</code>

4. In <code>scripts\traders</code> move or delete the file <code>server_traders.sqf</code>

5. Rename <code>server_traders - overwatch.sqf</code> to <code>server_traders.sqf</code>

# Changing from default Chernarus server_traders to any other map:

1. In <code>scripts\traders</code> move or delete the file <code>server_traders.sqf</code>

2. Rename <code>server_traders - whatever-map-name.sqf</code> to <code>server_traders.sqf</code>

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
	
3. dayz_server folder install:

	Replace or merge the contents of <code>dayz_server\system\server_monitor.sqf</code> provided with your original copy.

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
	
3. dayz_server folder install:

	Replace or merge the contents of <code>dayz_server\system\server_monitor.sqf</code> provided with your original copy.
	
# Giving NEW players coins on their first login:

1. In <code>dayz_server\compile\server_playerLogin.sqf</code> find:
	```sqf
	PVCDZ_plr_Login = [_charID,_inventory,_backpack,_survival,_isNew,dayz_versionNo,_model,_isHiveOk,_newPlayer,_isInfected,_group,_CharacterCoins,_playerCoins,_BankCoins];
	```
	
	If you want to give the player (so coins are on the body) 5k coins, add this line before it:
	
	```sqf
	if (_newPlayer) then {_characterCoins = 5000};
	```
	
	If you want to give the player 5k coins into their bank, add this line instead:
	```sqf
	if (_newPlayer) then {_bankCoins = 5000};
	```	