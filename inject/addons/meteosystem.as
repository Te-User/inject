_global.MeteoSystem = this;
_global.Inject = _parent._root._level0.inject;
var $mxCookie:String = "meteosystem_";
var $postal_code:String = _parent.GAPI.api.kernel.OptionsManager.getOption($mxCookie+"cp");
var $id_city:String = _parent.GAPI.api.kernel.OptionsManager.getOption($mxCookie+"idv");
_global.MeteoSystem.loaded = false;
var $actual_stt:Number = 1;
$load();

_global.infoMeteo = new Object();
var $tentaNumb:Number = 0;
var $applying:Boolean = false;
function $load() {
	if (($postal_code == undefined) || ($postal_code == "no") || ($postal_code == "") || ($id_city == "") || ($id_city == undefined)) {
		_meteo._visible = true;
		_meteo._no._visible = true;
		_meteo._yesb._visible = true;
		_meteo._stt.text = "Voulez-vous activer le système de météo in-game ?";
	} else {
		_meteo._visible = false;
		if (($id_city != undefined) && ($id_city != "")) {
			getMeteo($id_city, false);
		} else {		
			var $link_get_meteo:String = "http://www.tv5.org/cms/chaine-francophone/meteo/p-139-lg0-La_meteo_internationale.htm?form_submit=1&cp="+$postal_code+"";
			getVille($link_get_meteo);
		}
	}
}
function getVille($link:String, $reg:Boolean) {
	var fileContent:XML = new XML();
	fileContent.nodeType = 1;
	fileContent.ignoreWhite = true;
	fileContent.load($link);
	fileContent.onLoad = function(success:Boolean) {
		if (success) {
			var ID_VILLE:String = fileContent.toString().split("id_ville_france=")[1].toString().split('"')[0].toString();
			if (ID_VILLE != undefined) {
				getMeteo(ID_VILLE, $reg);
				if ($reg) {
					_meteo._stt.text = "\nChargement des informations sur votre ville...";
				}
			} else {
				if($tentaNumb == 5) {
					$actual_stt = 5;
					replyForm(2);
					$tentaNumb = 0;
				} else {
					_meteo._stt.text = "\nMeteoSystem ne parvient pas à trouver votre ville...\n\nRe-tentative ("+$tentaNumb+") dans 5 secondes...";
					setTimeout(function () {
						_meteo._stt.text = "\nEnvoie d'une requête aux serveurs météorologique...";
						debug.write("Re-tentative d'envoie de requête..."+$link);
						getVille($link, $reg);
						$tentaNumb++;
					}, 5000);
				}
			}
		} else {
			error_found(2, $reg);
		}
	};
}
function getMeteo($id_ville:String, $reg:Boolean) {
	var fileContent:XML = new XML();
	fileContent.nodeType = 1;
	fileContent.ignoreWhite = true;
	fileContent.load("http://www.tv5.org/cms/chaine-francophone/meteo/p-15357-lg0-Les-previsions-en-France.htm?id_ville_france="+$id_ville);
	fileContent.onLoad = function(success:Boolean) {
		if (success) {
			infoMeteo.id_ville = $id_ville;
			infoMeteo.ville_is = fileContent.toString().split("définir comme ville favorite</a>")[1].toString().split('</h3>')[0].toString();
			infoMeteo.id_temp = fileContent.toString().split('<div class="descrLune"><p>')[1].toString().split('</p>')[0].toString();
			if (infoMeteo.ville_is == undefined) {
				error_found(1, $reg);
			} else {
				debug.write("Information météorologique de "+infoMeteo.ville_is+" chargé : "+infoMeteo.id_temp+".");
				if ($reg) {
					_meteo._stt.text = "Votre ville : "+infoMeteo.ville_is+"\nTemps qu'il fait chez vous (approximatif) : "+infoMeteo.id_temp+"\n\n Les informations sont-elles correct ?";
					$actual_stt = 3;
					replyForm(2);
				}
			}
		} else {
			error_found(2, $reg);
		}
	};
}
function error_found($type:Number, $reg:Boolean) {
	var $msg_var:String = "Erreur lors de la récupération de la météo : ";
	switch ($type) {
	default :
		break;
	case 1 :
		$msg_var += "code postal ("+$postal_code+") incorrect.";
		break;
	case 2 :
		$msg_var += "Problème de connexion aux serveurs météorologique.";
		break;
	}
	if ($reg) {
		$msg_var;
	}
	trace($msg_var);
}
_meteo._no.onRelease = function() {
	replyForm(0);
};
_meteo._yesb.onRelease = function() {
	replyForm(1);
};
_meteo._ok.onRelease = function() {
	replyForm(2);
};
function replyForm($bool) {
	switch ($actual_stt) {
	default :
		_meteo._visible = false;
		break;
	case 1 :
		if ($bool == 1) {
			_meteo._stt.text = "\nVeuillez entrer votre code postal : ";
			_meteo._no._visible = false;
			_meteo._yesb._visible = false;
			_meteo._ok._visible = true;
			_meteo._postal._visible = true;
			$actual_stt++;
		} else {
			_parent.GAPI.api.kernel.OptionsManager.setOption($mxCookie+"cp", "no");
			_meteo._visible = false;
		}
		break;
	case 2 :
		if ($bool == 2) {
			$postal_code = _meteo._postal.text;
			var $link_get_meteo:String = "http://www.tv5.org/cms/chaine-francophone/meteo/p-139-lg0-La_meteo_internationale.htm?form_submit=1&cp="+_meteo._postal.text+"&Submit=Rechercher";
			_meteo._stt.text = "\nEnvoie d'une requête aux serveurs météorologique...";
			getVille($link_get_meteo, true);
			_meteo._load._visible = true;
			_meteo._ok._visible = false;
			_meteo._postal._visible = false;
		}
		break;
	case 3 :
		_meteo._no._visible = true;
		_meteo._yesb._visible = true;
		_meteo._load._visible = false;
		$actual_stt++;
		break;
	case 4 :
		if ($bool==1) {
			_parent.GAPI.api.kernel.OptionsManager.setOption($mxCookie+"idv", infoMeteo.id_ville);
			_parent.GAPI.api.kernel.OptionsManager.setOption($mxCookie+"cp", _meteo._postal.text);
			functions.showbox("MeteoSystem", "Votre jeu s'adaptera désormais au temps météorologique qu'il fait chez vous à "+infoMeteo.ville_is+".");
			_meteo._visible = false;
		} else {
			_meteo._no._visible = true;
			_meteo._yesb._visible = true;
			_meteo._stt.text = "Voulez-vous activer le système de météo in-game ?";
			$actual_stt = 1;
		}
		break;
	case 5:
		_meteo._stt.text = "Veuillez entrer votre code postal : \n MeteoSystem ne parvient pas à récupérer les informations, verifier votre code postal.";
		_meteo._no._visible = false;
		_meteo._yesb._visible = false;
		_meteo._ok._visible = true;
		_meteo._postal._visible = true;
		_meteo._load._visible = false;
		_meteo._postal.text = $postal_code;
		$actual_stt = 2;
		break;
	}
}


function _applyMeteo($instance) {
	if (($instance == "Banner") && (infoMeteo.id_temp != undefined)) {
		if (!_global.MeteoSystem.loaded) {
			_global.MeteoSystem.createEmptyMovieClip(effectMeteo, 2);
			functions.showNotif("<br/>Environnement <b>"+infoMeteo.id_temp+"</b> appliqué en jeu  !");
			_global.MeteoSystem.loaded = true;
			if (infoMeteo.id_temp.indexOf("soleil") != -1) {
				loadMovie("modules/inject/addons/meteosystem/soleil.swf", _global.MeteoSystem.effectMeteo);
			}
			if (infoMeteo.id_temp.indexOf("pluie") != -1) {
				loadMovie("modules/inject/addons/meteosystem/pluie.swf", _global.MeteoSystem.effectMeteo);
				_root._quality = "LOW";
			}
			if (infoMeteo.id_temp.indexOf("averses") != -1) {
				loadMovie("modules/inject/addons/meteosystem/averses.swf", _global.MeteoSystem.effectMeteo);
				_root._quality = "LOW";
			}
			if (infoMeteo.id_temp.indexOf("orage") != -1) {
				loadMovie("modules/inject/addons/meteosystem/orage.swf", _global.MeteoSystem.effectMeteo);
				_root._quality = "LOW";
			}
			if (infoMeteo.id_temp.indexOf("neige") != -1) {
				loadMovie("modules/inject/addons/meteosystem/neige.swf", _global.MeteoSystem.effectMeteo);
				_root._quality = "LOW";
			}
			if (infoMeteo.id_temp.indexOf("couvert") != -1) {
				loadMovie("modules/inject/addons/meteosystem/couvert.swf", _global.MeteoSystem.effectMeteo);
			}
		}
	}
}

_meteo._postal._visible = false;
_meteo._ok._visible = false;
_meteo._load._visible = false;