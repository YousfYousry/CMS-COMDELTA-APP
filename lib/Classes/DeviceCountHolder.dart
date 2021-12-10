class DeviceCountHolder {
  String _id = "";
  String _clientId = "";
  bool _isActive = false;

  void setActive(bool isActive){
    this._isActive = isActive;
  }

  DeviceCountHolder(this._id,this._clientId, this._isActive);


  String get clientId => _clientId;

  String get id => _id;

  bool get isActive => _isActive;
}
