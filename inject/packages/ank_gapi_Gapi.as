_global.Inject = _parent._root._level0.inject;
var _loc1 = _parent._global.ank.gapi.Gapi.prototype;
_loc1.getUIComponent = function(sInstanceName) {
	var _loc3 = this._mcLayer_UI[sInstanceName];
	if (_loc3 == undefined) {
		_loc3 = this._mcLayer_UI_Top[sInstanceName];
	}
	// end if 
	if (_loc3 == undefined) {
		_loc3 = this._mcLayer_UI_Ultimate[sInstanceName];
	}
	// end if 
	if (_loc3 == undefined) {
		return (null);
	}
	// end if 
	if(_loc3 != undefined) 	_parent.meteosystem._applyMeteo(sInstanceName);
	return (_loc3);
};