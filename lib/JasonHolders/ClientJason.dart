class ClientJason {
  String _id = "";
  String _clientName = "";
  String _clientAddress = "";
  String _clientContact = "";
  String _clientEmail = "";
  String _clientLogo = "";
  String _statThree = "";
  String _statTwo = "";
  String _status = "";
  String _createdBy = "";
  String _createdDate = "";
  String _modifiedBy = "";
  String _modifiedDate = "";
  String _highLight = "";

  void setHighLight(String value) {
    _highLight = value;
  }

  ClientJason(
    this._id,
    this._clientName,
    this._clientAddress,
    this._clientContact,
    this._clientEmail,
    this._clientLogo,
    this._statThree,
    this._statTwo,
    this._status,
    this._createdBy,
    this._createdDate,
    this._modifiedBy,
    this._modifiedDate,
  );

  factory ClientJason.fromJson(Map<String, dynamic> json) {
    return ClientJason(
      (json['client_id'].toString().contains("null"))?" ":json['client_id'].toString(),
      (json['client_name'].toString().contains("null"))?" ":json['client_name'].toString(),
      (json['client_address'].toString().contains("null"))?" ":json['client_address'].toString(),
      (json['client_contact'].toString().contains("null"))?" ":json['client_contact'].toString(),
      (json['client_email'].toString().contains("null"))?" ":json['client_email'].toString(),
      (json['client_logo'].toString().contains("null"))?" ":json['client_logo'].toString(),
      (json['stat_three'].toString().contains("null"))?" ":json['stat_three'].toString(),
      (json['stat_two'].toString().contains("null"))?" ":json['stat_two'].toString(),
      (json['status'].toString().contains("null"))?" ":json['status'].toString(),
      (json['CreatedBy'].toString().contains("null"))?" ":json['CreatedBy'].toString(),
      (json['CreatedDate'].toString().contains("null"))?" ":json['CreatedDate'].toString(),
      (json['ModifiedBy'].toString().contains("null"))?" ":json['ModifiedBy'].toString(),
      (json['ModifiedDate'].toString().contains("null"))?" ":json['ModifiedDate'].toString(),
    );
  }

  double getDouble(String str) {
    try {
      return double.parse(str);
    } catch (e) {
      return 500;
    }
  }

  String get id => _id;

  String get clientName => _clientName;

  String get clientAddress => _clientAddress;

  String get clientContact => _clientContact;

  String get clientEmail => _clientEmail;

  String get clientLogo => _clientLogo;

  String get statThree => _statThree;

  String get statTwo => _statTwo;

  String get status => _status;

  String get createdBy => _createdBy;

  String get createdDate => _createdDate;

  String get modifiedBy => _modifiedBy;

  String get modifiedDate => _modifiedDate;

  String get highLight => _highLight;
}
