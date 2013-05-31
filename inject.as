// Variable global.
_global.$modules_path = "modules/";
_global.$inject_path = $modules_path+"inject/";
_global.$inject_addons = $inject_path+"addons/";
_global.$inject_packages = $inject_path+"packages/";
_global.$inject_config = $inject_path+"config.inj";
_global.$inject_addons_list = $inject_path+"addons.inj";
_global.$inject_packages_list = $inject_path+"packages.inj";
_global.$inject_list_addons;
_global.$inject_list_packages;
_global.$inject_file_config;
_global.$inject_debug_mod = true;
functions.wait();

String.prototype.replace = function(searchStr, replaceStr):String {
    return this.split(searchStr).join(replaceStr);
};

///////////////////////////////
// Déclaration de variable. //
/////////////////////////////
_global.functions = this;
_global.mDOFUS = _root._level0.mcModules.mcCORE.GAPI;
_global.mAddons = new Array();
_global.mPackages = new Array();
_global.etatLoad = new Array(false, false);
_global.statment = 0;
_global.max_statment = 0;
_global.ActualReboot = 0;
_global.bootAddon = 0;
_global.bootPackage = 0;

///////////////////////////
// Chargement d'Inject. //
/////////////////////////
functions.wait = function() {
	if(_global.ActualReboot == 0) {
		setTimeout(function () {
			if (_root._level0.mcModules.mcCORE.GAPI._visible == true) {
				functions.getConfigContent($inject_config);
				_global.ActualReboot = functions.getTimeUnix();
				if($inject_debug_mod) debug.write("[DEBUG] Récupération du fichier de configuration...");
			} else {
				functions.wait();
			}
		}, 3000);
	} else {
		if($inject_debug_mod) debug.write("[DEBUG] Inject est déjà en cours d'éxécution...");
	}
};

// Récupére le timestamp unix.
functions.getTimeUnix = function() {
	return Math.floor(new Date().getTime());
}
functions.countchar = function(value:String, char:String) {
	var countChar:Number = 0;
	for (var i = 0; i<value.length; i++) {
		if (value.charAt(i) == char) {
			countChar++;
		}
	}
	return countChar;
};

////////////////////////////
// Chargement des addons //
///////////////////////////
functions.load_addons = function() {
	_global.mAddons = [];
	_global.mPackages = [];
	var $addons_number:Number = functions.countchar($inject_list_addons, "|")+1;
	var $addons_explode:Object = $inject_list_addons.split("|");
	for (var i = 0; i<$addons_number; i++) {
		var _getLineAddonsName:String = $addons_explode[i].toString();
		if ((_getLineAddonsName.indexOf(";") == -1) && (_getLineAddonsName.length >= 1)) {
			functions.load_addons_ifexist(_getLineAddonsName, i, $addons_number);
			if($inject_debug_mod) debug.write("[DEBUG] Chargement de l'addon <b>"+_getLineAddonsName+"</b>...");
		}
		// Si tout les addons sont charger.
		if (i == $addons_number - 1) {
			_global.statment++;
		}
	}
};

//////////////////////////////////////
// Vérifie l'existance des addons. //
////////////////////////////////////
functions.load_addons_ifexist = function(addon:String, gid:Number, maxid:Number) {
	fileExists = new LoadVars();
	fileExists.onLoad = function(success) {
		if (success) {
			_root._level0.mcModules.mcCORE.createEmptyMovieClip(addon, 2000+gid);
			loadMovie($inject_addons+addon+".swf", _root._level0.mcModules.mcCORE[addon]);
			_global.mAddons.push(addon);
			if($inject_debug_mod) debug.write("[DEBUG] Addon <b>"+addon+"</b> chargé.");
		} else {
			if ((functions.getVar("ALERT_ADDON_INTROUVABLE", $inject_file_config) == "true") && (addon != " "))  {
				functions.showbox(undefined, $error_loadaddon+" "+addon+" ("+$inject_addons+addon+".swf).");
			}
			if($inject_debug_mod) debug.write("[DEBUG] Addon <b>"+addon+"</b> non-chargé (introuvable).");
		}

		// Si tout les addons sont charger.
		if (gid == maxid - 1){
			_global.etatLoad[0] = true; // On informe que tout les addons sont charger.
			// Si les packages doivent être également charger.
			if (functions.getVar("LOAD_PACKAGES", $inject_file_config) != "false") {
					if($inject_debug_mod) debug.write("[DEBUG] Chargement du fichier de la liste des packages...");
					_global.max_statment++; // Un deuxieme type de fichier doit être charger.
					functions.getPackagesContent($inject_packages_list);
			} else {
				if($inject_debug_mod) debug.write("[DEBUG] Inject est prêt.");
				$etatLoad[1] = true; // On défini directement l'état TRUE.
				functions.InjectReady(); // On informe que le chargement est fini.
			}
		}
	};
	fileExists.load($inject_addons+addon+".swf");
};

///////////////////////////////
// Chargement des packages. //
/////////////////////////////
functions.load_packages = function() {
	var $packages_number:Number = functions.countchar($inject_list_packages, "|")+1;
	var $packages_explode:Object = $inject_list_packages.split("|");
	for (var i = 0; i<$packages_number; i++) {
		var _getLinePackageName:String = $packages_explode[i].toString();
		if ((_getLinePackageName.indexOf(";") == -1) && (_getLinePackageName.length >= 2)) {
			functions.load_packages_ifexist(_getLinePackageName, i, $packages_number);
			if($inject_debug_mod) debug.write("[DEBUG] Chargement du package <b>"+_getLinePackageName+"</b>...");
		}
		if (i == $packages_number - 1) {
			_global.statment++;
		}
	}
};

////////////////////////////////////////
// Verifie l'existance des packages. //
//////////////////////////////////////
functions.load_packages_ifexist = function(package:String, gid:Number, maxid:Number) {
	fileExists = new LoadVars();
	fileExists.onLoad = function(success) {
		if (success) {
			_root._level0.mcModules.mcCORE.createEmptyMovieClip(package, 5000+gid);
			loadMovie($inject_packages+package+".swf", _root._level0.mcModules.mcCORE[package]);
			_global.mPackages.push(package);
			if($inject_debug_mod) debug.write("[DEBUG] Package <b>"+package+"</b> chargé.");
		} else {
			if (functions.getVar("ALERT_PACKAGE_INTROUVABLE", $inject_file_config) == "true") {
				functions.showbox(undefined, $error_loadpackage+" "+package+" ("+$inject_packages+package+".swf).");
			}
			if($inject_debug_mod) debug.write("[DEBUG] Package <b>"+package+"</b> non-chargé (introuvable).");
		}

		// Si tout les packages sont charger.
		if(gid == (maxid - 1)) {
			_global.etatLoad[1] = true;  // On informe que tout les packages sont charger.
			functions.InjectReady(); // On informe que le chargement est fini.
		}
	};
	fileExists.load($inject_packages+package+".swf");
};

///////////////////////////////
// Afficher un message box. //
/////////////////////////////
functions.showbox = function(title:String, content:String) {
	_root._level0.mcModules.mcCORE.GAPI.api.kernel.showMessage(title, content, "ERROR_BOX");
};

//////////////////////////////////////////////
// Récupére une valeur dans le config.inj. //
////////////////////////////////////////////
functions.getVar = function(variable:String, content:String) {
	return content.split("$"+variable+" = ")[1].toString().split(";")[0].toString();
};

///////////////////////////////////////////////////
// Récupére le contenu du fichier packages.ing. //
/////////////////////////////////////////////////
functions.getPackagesContent = function(destination:String) {
	var fileContent:XML = new XML();
	fileContent.nodeType = 1;
	fileContent.ignoreWhite = true;
	fileContent.load(destination);
	fileContent.onLoad = function(success:Boolean) {
		if (success) {
			$inject_list_packages = functions.convertArr(fileContent.toString());
			if (($inject_list_packages != "") && ($inject_list_packages != undefined)) {
				if($inject_debug_mod) debug.write("[DEBUG] Fichier de la liste des packages chargé avec succès.");
				functions.load_packages();
			}
		}
	};
};

/////////////////////////////////////////////////
// Récupére le contenu du fichier addons.ing. //
///////////////////////////////////////////////
functions.getFileContent = function(destination:String) {
	var fileContent:XML = new XML();
	fileContent.nodeType = 1;
	fileContent.ignoreWhite = true;
	fileContent.load(destination);
	fileContent.onLoad = function(success:Boolean) {
		if (success) {
			$inject_list_addons = functions.convertArr(fileContent.toString());
			if (($inject_list_addons.length >= 2) && ($inject_list_addons != undefined)) {
				if($inject_debug_mod) debug.write("[DEBUG] Fichier de la liste des addons chargé avec succès.");
				functions.load_addons();
			}
		} else {
			functions.showbox(undefined, $error_loadaddons);
		}
	};
};

/////////////////////////////////////////////////
// Récupére le contenu du fichier config.inj. //
///////////////////////////////////////////////
functions.getConfigContent = function(destination:String) {
	var fileContent:XML = new XML();
	fileContent.nodeType = 1;
	fileContent.ignoreWhite = true;
	fileContent.load(destination);
	fileContent.onLoad = function(success:Boolean) {
		if (success) {
			$inject_file_config = fileContent.toString()+"\r\n";
			if($inject_debug_mod) debug.write("[DEBUG] Application des variables de configuration...");
			functions.applyConfigSet();
		}
		if (functions.getVar("LOAD_ADDONS", $inject_file_config) != "false") {
			if($inject_debug_mod) debug.write("[DEBUG] Chargement du fichier de la liste des addons...");
			functions.getFileContent($inject_addons_list);
			_global.max_statment++;
		}
	};
};


///////////////////////////////////////////
// Applique les réglages du config.inj. //
/////////////////////////////////////////
functions.applyConfigSet = function() {
	if (functions.getVar("STARTUP_DEBUG", $inject_file_config) != "false") {
		_debug._visible = true;
		debug.write("[STARTUP_DEBUG: TRUE] Démarrage de la console au lancement. `exit` pour la fermer.");
	}
};

///////////////////////////////////////////
// Corrige le fichier de configuration. //
/////////////////////////////////////////
functions.convertArr = function(valuee) {
	var newValuee:String = valuee.replace("\r\n", "|");
	var nb_char = newValuee.length;
	var nb_b:Number = functions.countchar(newValuee, "|");
	for (var i = 1; i<nb_b; i++) {
		if(newValuee.substring(nb_char-i) == "|") {
			newValuee = newValuee.substring(0, nb_char - i);
		}
	}
	return newValuee;
};

////////////////////////////////////////////////////
// Récupére la destination d'un addon (inutile). //
//////////////////////////////////////////////////
functions.getAddon = function(addon:String) {
	return _global.functions._root._level0.mcModules.mcCORE[addon];
}

///////////////////////////////////////////////
// Message d'information : Inject est prêt. //
/////////////////////////////////////////////
_global.functions.InjectReady = function() {
	if((_global.ActualReboot != 0) && (statment == _global.max_statment) && ($etatLoad[0] != true) && ($etatLoad[1] != true)) {
		var TimeBoot:Number = (functions.getTimeUnix() - _global.ActualReboot);
		debug.write("===================================");
		debug.write("Inject est prêt a être utiliser. (Temps de chargement: " + TimeBoot + "ms.)");
		debug.write("Addons chargé(s) : " + _global.mAddons.length, "e5edb9");
		debug.write("Packages chargé(s) : " + _global.mPackages.length, "e5edb9");
		debug.write("===================================");
		_global.ActualReboot = 0;
	}
};

_global.functions.showNotif = function(value:String) {
	_notif._alpha = 0;
	_notif._visible = true;
	_notif._input.htmlText = value;
	var applyWait:Boolean = false;
	_global._showNotif = setInterval(function () {
		if (_notif._alpha<=70) {
			_notif._alpha++;
		}
	}, 10);
	setTimeout(function () {
		_notif._alpha = 0;
		_notif._visible = false;
		clearInterval(_global._showNotif);
	}, 7000);
};

_global.debug = this;
_global.$debug_entry = new Array();
var $debug_nbKeyUp:Number = 0;
var keyListener:Object = new Object();
keyListener.onKeyDown = function() {
	if (Key.isDown(Key.INSERT)) {
		if (functions.getVar("KEY_OPENDEBUG", $inject_file_config) == "true") {
			_debug._visible = true;
			Selection.setFocus("_debug._cmd");
		}
	}
	if ((Key.isDown(Key.SHIFT)) && (Key.isDown(Key.SPACE))) {
		if (functions.getVar("KEY_RELOAD", $inject_file_config) == "true") {
			gotoAndPlay(2);
		}
	}
	if ((Key.isDown(Key.UP)) && (_debug._visible)) {
		$debug_nbKeyUp++;
		if ($debug_entry[$debug_entry.length-$debug_nbKeyUp] != undefined) {
			_debug._cmd.text = $debug_entry[$debug_entry.length-$debug_nbKeyUp];
		}
	}
	if ((Key.isDown(Key.ESCAPE)) && (_debug._visible)) {
		_debug._visible = false;
	}
	if ((Key.isDown(Key.ENTER)) && (_debug._visible) && (_debug._cmd.length>=2)) {
		debug.set(_debug._cmd.text);
		_debug._cmd.text = "";
	}
};
Key.addListener(keyListener);
_debug._cmd.onChanged = function() {
	$debug_nbKeyUp = 0;
};
debug.write = function(value:String, colorF:String) {
	TimeNow = new Date();
	var $NOW:String = "<b>["+TimeNow.getHours()+":"+TimeNow.getMinutes()+":"+TimeNow.getSeconds()+"]</b> ";
	if (colorF == undefined) {
		colorF = "#BFDF09";
	}
	_debug._logs.htmlText = "<font color=\">"+colorF+"\">"+$NOW+value+"</font><br/>"+_debug._logs.htmlText;
};
debug.set = function(value:String) {
	$debug_entry.push(value);
	switch (value.toLowerCase()) {
	default :
		debug.write("Commande `"+value+"` est non reconnu. Taper `help`pour avoir de l'aide.");
		break;
	case "addons" :
		debug.write("Addon(s) chargé(s) : \n"+_global.mAddons);
		break;
	case "packages" :
		debug.write("Packages chargé(s) : \n"+_global.mPackages);
		break;
	case "clear" :
		_debug._logs.text = "";
		break;
	case "exit" :
		_debug._visible = false;
		break;
	case "reload" :
		// functions.wait();
		gotoAndPlay(2);
		debug.write("Rechargement d'Inject...");
		break;
	case "help" :
		debug.write("RELOAD : RECHARGER INJECT.");
		debug.write("CLEAR : EFFACER LA CONSOLE.");
		debug.write("ADDONS : LISTE DES ADDONS.");
		debug.write("PACKAGES : LISTE DES PACKAGES.");
		debug.write("EXIT : FERMER LA CONSOLE");
		break;
	}
};
stop();

var $error_loadaddons:String = "Le fichier " + $inject_addons_list + " est introuvable.";
var $error_loadaddon:String = "Le coeur de l'addon suivant est introuvable :";
var $error_loadpackage:String = "Le package suivant est introuvable : ";
