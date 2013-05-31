var $mxCookie:String = "passw_saver_";
var $showIcon:Boolean = true;
var $thePassword:String = _parent.GAPI.api.kernel.OptionsManager.getOption($mxCookie+"p");
if (($thePassword != undefined) && ($thePassword != "")) {
	_parent.GAPI.api.ui.getUIComponent("Login")._tiPassword.text = $thePassword;
	_btn_save._visible = true;
} else {
	_btn_save._visible = false;
}
if ($showIcon) {
	_btn_save._x = _parent.GAPI.api.ui.getUIComponent("Login")._tiPassword._x+_parent.GAPI.api.ui.getUIComponent("Login")._tiPassword._width-10;
	_btn_save._y = _parent.GAPI.api.ui.getUIComponent("Login")._tiPassword._y+3;
	_btn_save.onRollOver = function() {
		_parent.GAPI.api.ui.showTooltip("Votre mot de passe est enregistrer.", _root._xmouse, _root._ymouse-30);
	};
	_btn_save.onRollOut = function() {
		_parent.GAPI.api.ui.hideTooltip();
	};
	_btn_save.onRelease = function() {
		_btn_save._visible = false;
		var msgBox = _parent.GAPI.api.ui.loadUIComponent("AskYesNo", "AskYesNoContent", {title:"Connexion automatique", text:"Voulez-vous supprimer votre mot de passe enregister ?"});
		msgBox.addEventListener("yes", functionsPasswSaver.removePassw);
		msgBox.addEventListener("no", functionsPasswSaver.NoremovePassw);
	};
}

_global.functionsPasswSaver = this;
functionsPasswSaver.ProposeSave = function(passw:String) {
	if (($thePassword == undefined) || ($thePassword == "")) {
		$thePassword = passw;
		var msgBox = _parent.GAPI.api.ui.loadUIComponent("AskYesNo", "AskYesNoContent", {title:"Connexion automatique", text:"Voulez-vous que votre mot de passe soit enregistrer pour votre prochaine connexion ?"});
		msgBox.addEventListener("yes", functionsPasswSaver.goSave);
	} else {
		_btn_save._visible = false;
	}
	
};
functionsPasswSaver.goSave = function() {
	_parent.GAPI.api.kernel.OptionsManager.setOption($mxCookie+"p", $thePassword);
};
functionsPasswSaver.removePassw = function() {
	_parent.GAPI.api.kernel.OptionsManager.setOption($mxCookie+"p", "");
	_btn_save._visible = false;
};
functionsPasswSaver.NoremovePassw = function() {
	_btn_save._visible = true;
};
