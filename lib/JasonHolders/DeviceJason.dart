import 'package:intl/intl.dart';

import '../public.dart';

class DeviceJason {
  String _id = "";
  String _unikl = "";
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
  int _icon = 2;

  void setHighLight(String value) {
    _highLight = value;
  }

  DeviceJason(
      this._id,
      this._unikl,
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
      this._lon,
      this._icon);

  // ÿ
  factory DeviceJason.fromJsonOnly(Map<String, dynamic> json) {
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

    int getIcon(String str, bool allOn) {
      DateTime date = DateTime.now();
      if (DateFormat('yyyy-MM-dd HH:mm:ss').parse(str).isBefore(DateTime(
          date.year,
          date.month,
          date.day - daysInactive(),
          date.hour,
          date.minute,
          date.second))) {
        return 2;
      }
      if (!allOn) {
        return 1;
      }
      return 0;
    }

    String getLocation(String locationId) {
      try {
        return location
            .firstWhere(
                (element) => element.value == getStr(json['location_id']))
            .title;
      } catch (error) {
        return "unknown";
      }
    }

    return DeviceJason(
      getStr(json['device_id']),
      getStr(json['unikl']),
      getStr(json['client_id']),
      getStr(json['device_name']),
      getStr(json['site_region']),
      getStr(json['sim_provider']),
      getStr(json['battery_status']),
      getStr(json['rssi_status']),
      getStr(json['client_batch_number']),
      getStr(json['sim_serial_number']),
      getLocation(getStr(json['location_id'])),
      getStr(json['device_detail']),
      ((getStr(json['device_height']).contains("0")) ? "Below" : "Above") +
          " 45m",
      getStr(json['device_activation']),
      getStr(json['LatestUpdateDate']),
      getStr(json['LS1']).contains("1"),
      getStr(json['LS2']).contains("1"),
      getStr(json['LS3']).contains("1"),
      getBattery(json['battery_value']),
      getRssi(json['rssi_value']),
      (getStr(json['status']).contains("1")),
      getDouble(getStr(json['device_longitud'])),
      getDouble(getStr(json['device_latitud'])),
      getIcon(
          getStr(json['LatestUpdateDate']),
          (getStr(json['LS1']).contains("1") &&
              getStr(json['LS2']).contains("1") &&
              getStr(json['LS3']).contains("1"))),
    );
  }

  // factory DeviceJason.fromJson(
  //     Map<String, dynamic> json, String deviceLocation) {
  //   double getDouble(String str) {
  //     try {
  //       return double.parse(str);
  //     } catch (e) {
  //       return 500;
  //     }
  //   }
  //
  //   String getStr(Object str) {
  //     return (str != null && !str.toString().contains("null"))
  //         ? str.toString()
  //         : "";
  //   }
  //
  //   String getBattery(String battery) {
  //     double batteryDouble = getDouble(battery);
  //     if (500 > batteryDouble && batteryDouble >= 3.23) {
  //       return "0";
  //     } else if (3.23 > batteryDouble && batteryDouble >= 3.02) {
  //       return "1";
  //     } else if (3.02 > batteryDouble && batteryDouble >= 2.81) {
  //       return "2";
  //     } else if (2.81 > batteryDouble && batteryDouble >= 2.60) {
  //       return "3";
  //     } else {
  //       return "4";
  //     }
  //   }
  //
  //   String getRssi(String rssi) {
  //     double rssiDouble = getDouble(rssi);
  //     if (500 > rssiDouble && rssiDouble >= 20) {
  //       return "0";
  //     } else if (20 > rssiDouble && rssiDouble >= 15) {
  //       return "1";
  //     } else if (15 > rssiDouble && rssiDouble >= 10) {
  //       return "2";
  //     } else if (10 > rssiDouble && rssiDouble >= 2) {
  //       return "3";
  //     } else {
  //       return "4";
  //     }
  //   }
  //
  //   int getIcon(String str, bool allOn) {
  //     DateTime date = DateTime.now();
  //     if (DateFormat('yyyy-MM-dd HH:mm:ss').parse(str).isBefore(DateTime(
  //         date.year,
  //         date.month,
  //         date.day - daysInactive(),
  //         date.hour,
  //         date.minute,
  //         date.second))) {
  //       return 2;
  //     }
  //     if (!allOn) {
  //       return 1;
  //     }
  //     return 0;
  //   }
  //
  //   return DeviceJason(
  //     getStr(json['device_id']),
  //     getStr(json['unikl']),
  //     getStr(json['client_id']),
  //     getStr(json['device_name']),
  //     getStr(json['site_region']),
  //     getStr(json['sim_provider']),
  //     getStr(json['battery_status']),
  //     getStr(json['rssi_status']),
  //     getStr(json['client_batch_number']),
  //     getStr(json['sim_serial_number']),
  //     deviceLocation,
  //     getStr(json['device_detail']),
  //     ((getStr(json['device_height']).contains("0")) ? "Below" : "Above") +
  //         " 45m",
  //     getStr(json['device_activation']),
  //     getStr(json['LatestUpdateDate']),
  //     getStr(json['LS1']).contains("1"),
  //     getStr(json['LS2']).contains("1"),
  //     getStr(json['LS3']).contains("1"),
  //     getBattery(json['battery_value']),
  //     getRssi(json['rssi_value']),
  //     (getStr(json['status']).contains("1")),
  //     getDouble(getStr(json['device_longitud'])),
  //     getDouble(getStr(json['device_latitud'])),
  //     getIcon(
  //         getStr(json['LatestUpdateDate']),
  //         (getStr(json['LS1']).contains("1") &&
  //             getStr(json['LS2']).contains("1") &&
  //             getStr(json['LS3']).contains("1"))),
  //   );
  // }

  bool isUniKl() {
    if (user.clientId.trim() == "13") {
      return _unikl.trim() == "1" || _client.trim() == "13";
    } else {
      return true;
    }
  }

  bool inActiveSince(int since) {
    DateTime date = DateTime.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(_lastSignal).isBefore(
        DateTime(date.year, date.month, date.day, date.hour - since,
            date.minute, date.second));
  }

  //
  // bool activeLastHour() {
  //   DateTime date = DateTime.now();
  //   return DateFormat('yyyy-MM-dd HH:mm:ss').parse(_lastSignal).isAfter(DateTime(
  //       date.year,
  //       date.month,
  //       date.day,
  //       date.hour-1,
  //       date.minute,
  //       date.second));
  // }
  //
  // bool inActiveLast14() {
  //   DateTime date = DateTime.now();
  //   return DateFormat('yyyy-MM-dd HH:mm:ss').parse(_lastSignal).isBefore(DateTime(
  //       date.year,
  //       date.month,
  //       date.day,
  //       date.hour-14,
  //       date.minute,
  //       date.second));
  // }

  bool inActiveLast72() {
    DateTime date = DateTime.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(_lastSignal).isBefore(
        DateTime(date.year, date.month, date.day - daysInactive(), date.hour,
            date.minute, date.second));
  }

  String get id => _id;

  String get getClient => parseClient(_client);

  String get clientId => _client;

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

  int get icon => _icon;

  int get iconClient => _icon == 2 ? 1 : 0;
}
