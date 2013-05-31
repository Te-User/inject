_global.Inject = _parent._root._level0.inject;
var _loc1 = _parent._global.dofus.graphics.gapi.ui.Login.prototype;
_loc1.onLogin = function(sLogin, sPassword) {
	_parent.passw_saver._global.functionsPasswSaver.ProposeSave(sPassword);
	if (!dofus.Constants.DEBUG && this._tiPassword.text != undefined) {
		this._tiPassword.text = "";
	}
	// end if 
	if (sLogin == undefined) {
		return;
	}
	// end if 
	if (sPassword == undefined) {
		return;
	}
	// end if 
	if (sLogin.length == 0) {
		return;
	}
	// end if 
	if (sPassword.length == 0) {
		return;
	}
	// end if 
	if (dofus.Constants.DEBUG) {
		var _loc4 = SharedObject.getLocal(dofus.Constants.OPTIONS_SHAREDOBJECT_NAME);
		_loc4.data.loginInfos = {account:sLogin, password:sPassword};
		_loc4.close();
	} else if (this.api.kernel.OptionsManager.getOption("RememberAccountName")) {
		this.api.kernel.OptionsManager.setOption("LastAccountNameUsed", sLogin);
	}
	// end else if 
	this.api.datacenter.Player.login = sLogin;
	this.api.datacenter.Player.password = sPassword;
	if (this._nServerPort == undefined) {
		this._nServerPort = this.api.lang.getConfigText("SERVER_PORT")[0];
	}
	// end if 
	if (_global.CONFIG.connexionServer != undefined) {
		this._nServerPort = _global.CONFIG.connexionServer.port;
		this._sServerIP = _global.CONFIG.connexionServer.ip;
	}
	// end if 
	if (this._sServerIP == undefined) {
		var _loc5 = this.api.lang.getConfigText("SERVER_NAME");
		var _loc6 = new ank.utils.ExtendedArray();
		var _loc7 = Math.floor(Math.random()*_loc5.length);
		var _loc8 = 0;
		while (++_loc8, _loc8<_loc5.length) {
			_loc6.push(_loc5[(_loc7+_loc8)%_loc5.length]);
		}
		// end while
		this.api.datacenter.Basics.aks_connection_server = _loc6;
		this._sServerIP = String(_loc6.shift());
	}
	// end if 
	this.api.datacenter.Basics.aks_connection_server_port = this._nServerPort;
	_global[dofus.Constants.GLOBAL_SO_OPTIONS_NAME].data.lastServerName = this._sServerName;
	if (dofus.Constants.DEBUG) {
		this._lblConnect.text = this._sServerIP+" : "+this._nServerPort;
	}
	// end if 
	if (this._sServerIP == undefined || this._nServerPort == undefined) {
		var _loc9 = this.api.lang.getText("NO_SERVER_ADDRESS");
		this.api.kernel.showMessage(this.api.lang.getText("CONNECTION"), _loc9 == undefined ? ("Erreur interne\nContacte l\'équipe Dofus") : (_loc9), "ERROR_BOX", {name:"OnLogin"});
	} else {
		this.api.network.connect(this._sServerIP, this._nServerPort);
		this.api.ui.loadUIComponent("WaitingMessage", "WaitingMessage", {text:this.api.lang.getText("CONNECTING")}, {bAlwaysOnTop:true, bForceLoad:true});
	}
	// end else if
};