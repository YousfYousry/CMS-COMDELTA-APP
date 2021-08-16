class LogJason {
  String _id = "";
  String _createDate = "";
  String _details = "";
  String _ls1 = "";
  String _lid1 = "";
  String _ls2 = "";
  String _lid2 = "";
  String _ls3 = "";
  String _lid3 = "";
  String _lg = "";
  String _batteryValue = "";
  String _rssiValue = "";
  String _highLight = "";

  void setHighLight(String value) {
    _highLight = value;
  }

  LogJason(
    this._id,
    this._createDate,
    this._details,
    this._ls1,
    this._lid1,
    this._ls2,
    this._lid2,
    this._ls3,
    this._lid3,
    this._lg,
    this._batteryValue,
    this._rssiValue,
  );

  factory LogJason.fromJson(Map<String, dynamic> json) {
    String getStr(Object str) {
      return (str != null && !str.toString().contains("null"))
          ? str.toString()
          : "";
    }

    return LogJason(
      getStr(json['id']),
      getStr(json['CreateDate']),
      getStr(json['Details']),
      getStr(json['LS1']),
      getStr(json['LID1']),
      getStr(json['LS2']),
      getStr(json['LID2']),
      getStr(json['LS3']),
      getStr(json['LID3']),
      getStr(json['lg']),
      getStr(json['battery_value']),
      getStr(json['rssi_value']),
    );
  }

  bool isFound(String str) {
    for (int i = 0; i < 9; i++) {
      if (getE(i).toLowerCase().contains(str.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  String getE(int index) {
    if (index == 0) {
      return _createDate;
    } else if (index == 1) {
      return _lid1;
    } else if (index == 2) {
      return _ls1;
    } else if (index == 3) {
      return _lid2;
    } else if (index == 4) {
      return _ls2;
    } else if (index == 5) {
      return _lid3;
    } else if (index == 6) {
      return _ls3;
    } else if (index == 7) {
      return _batteryValue;
    } else if (index == 8) {
      return _rssiValue;
    } else {
      return "";
    }
  }

  String get highLight => _highLight;

  String get rssiValue => _rssiValue;

  String get batteryValue => _batteryValue;

  String get lg => _lg;

  String get lid3 => _lid3;

  String get ls3 => _ls3;

  String get lid2 => _lid2;

  String get ls2 => _ls2;

  String get lid1 => _lid1;

  String get ls1 => _ls1;

  String get details => _details;

  String get createDate => _createDate;

  String get id => _id;
}
