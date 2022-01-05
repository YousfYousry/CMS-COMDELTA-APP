class DeviceCountHolder {
  String _id = "";
  String _clientId = "";
  String _createdDate = "";
  bool _isActive = false;

  void setActive(bool isActive){
    this._isActive = isActive;
  }

  DeviceCountHolder(this._id,this._clientId,this._createdDate, this._isActive);

  String get clientId => _clientId;

  String get id => _id;

  String get createdDate => _createdDate;

  bool get isActive => _isActive;
}
