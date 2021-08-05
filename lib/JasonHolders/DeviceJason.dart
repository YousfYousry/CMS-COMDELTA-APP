class DeviceJason {
  String _id = "";
  String _client = "";
  String _deviceName = "";
  String _siteRegion = "";
  String _simProvider = "";
  String _batteryStatus = "";
  String _rssiStatus = "";
  String _batchNum = "";
  String _serialNum = "";
  String _deviceLocation = "";
  String _highLight = "";
  String _deviceDetails = "";
  String _deviceHeight = "";
  String _activationDate = "";
  String _lastSignal = "";
  bool _l1 = false;
  bool _l2 = false;
  bool _l3 = false;
  String _battery = "4";
  String _rssi = "4";
  bool _status = false;
  double _lat = 500;
  double _lon = 500;

  void setHighLight(String value) {
    _highLight = value;
  }

  DeviceJason(
      this._id,
      this._client,
      this._deviceName,
      this._siteRegion,
      this._simProvider,
      this._batteryStatus,
      this._rssiStatus,
      this._batchNum,
      this._serialNum,
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

    String getStr(Object str) {
      return (str != null && !str.toString().contains("null"))
          ? str.toString()
          : "";
    }

    String getBattery(String battery) {
      double batteryDouble = getDouble(battery);
      if (500 > batteryDouble && batteryDouble >= 3.23) {
        return "0";
      } else if (3.23 > batteryDouble && batteryDouble >= 3.02) {
        return "1";
      } else if (3.02 > batteryDouble && batteryDouble >= 2.81) {
        return "2";
      } else if (2.81 > batteryDouble && batteryDouble >= 2.60) {
        return "3";
      } else {
        return "4";
      }
    }

    String getRssi(String rssi) {
      double rssiDouble = getDouble(rssi);
      if (500 > rssiDouble && rssiDouble >= 20) {
        return "0";
      } else if (20 > rssiDouble && rssiDouble >= 15) {
        return "1";
      } else if (15 > rssiDouble && rssiDouble >= 10) {
        return "2";
      } else if (10 > rssiDouble && rssiDouble >= 2) {
        return "3";
      } else {
        return "4";
      }
    }

    return DeviceJason(
      getStr(json['device_id']),
      getStr(json['client_id']),
      getStr(json['device_name']),
      getStr(json['site_region']),
      getStr(json['sim_provider']),
      getStr(json['battery_status']),
      getStr(json['rssi_status']),
      getStr(json['client_batch_number']),
      getStr(json['sim_serial_number']),
      deviceLocation,
      getStr(json['device_detail']),
      ((getStr(json['device_height']).contains("0")) ? "Below" : "Above") +
          " 45m",
      getStr(json['device_activation']),
      getStr(json['LatestUpdateDate']),
      getStr(json['LS1']).contains("1"),
      getStr(json['LS2']).contains("1"),
      getStr(json['LS3']).contains("1"),
      // false,
      // false,
      // false,
      getBattery(json['battery_value']),
      getRssi(json['rssi_value']),
      // json['device_name'].toString(),
      // json['device_name'].toString(),
      (getStr(json['status']).contains("1")),
      getDouble(getStr(json['device_longitud'])),
      getDouble(getStr(json['device_latitud'])),
    );
  }

  String get id => _id;

  String get client => _client;

  String get deviceName => _deviceName;

  String get siteRegion => _siteRegion;

  String get simProvider => _simProvider;

  String get batteryStatus => _batteryStatus;

  String get deviceLocation => _deviceLocation;

  String get highLight => _highLight;

  String get rssi => _rssi;

  String get battery => _battery;

  String get batchNum => _batchNum;

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

  String get rssiStatus => _rssiStatus;

  String get serialNum => _serialNum;
}
