class DeviceJason {
  String _id = "";
  String _deviceName = "";
  String _deviceLocation = "";
  String _highLight = "";
  String _deviceDetails = "";
  String _deviceHeight = "";
  String _activationDate = "";
  String _lastSignal = "";
  bool _l1 = false;
  bool _l2 = false;
  bool _l3 = false;
  String _battery = "";
  String _rssi = "";
  bool _status = false;
  double _lat = 500;
  double _lon = 500;

  void setHighLight(String value) {
    _highLight = value;
  }

  DeviceJason(
      this._id,
      this._deviceName,
      this._deviceLocation,
      this._deviceDetails,
      this._deviceHeight,
      this._activationDate,
      this._lastSignal,
      this._l1,
      this._l2,
      this._l3,
      this._battery,
      this._rssi,
      this._status,
      this._lat,
      this._lon);

  factory DeviceJason.fromJson(
      Map<String, dynamic> json, String deviceLocation) {
    double getDouble(String str) {
      try {
        return double.parse(str);
      } catch (e) {
        return 500;
      }
    }
    return DeviceJason(
      json['device_id'].toString(),
      json['device_name'].toString(),
      deviceLocation,
      json['device_detail'].toString(),
      ((json['device_height'].toString().contains("0")) ? "Below" : "Above") +
          " 45m",
      json['device_activation'].toString(),
      json['LatestUpdateDate'].toString(),
      false,
      false,
      false,
      "",
      "",
      // json['device_name'].toString(),
      // json['device_name'].toString(),
      (json['status'].toString().contains("1")),
      getDouble(json['device_longitud'].toString()),
      getDouble(json['device_latitud'].toString()),
    );
  }

  String get id => _id;

  String get deviceName => _deviceName;

  String get deviceLocation => _deviceLocation;

  String get highLight => _highLight;

  String get rssi => _rssi;

  String get battery => _battery;

  bool get l3 => _l3;

  bool get l2 => _l2;

  bool get l1 => _l1;

  String get lastSignal => _lastSignal;

  String get activationDate => _activationDate;

  String get deviceHeight => _deviceHeight;

  String get deviceDetails => _deviceDetails;

  bool get status => _status;

  double get lon => _lon;

  double get lat => _lat;
}
