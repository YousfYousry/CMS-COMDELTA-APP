class HistoryJason {
  String _deviceId = "";
  String _changeDate = "";
  String _active = "";
  String _highLight = "";

  void setHighLight(String value) {
    _highLight = value;
  }

  HistoryJason(
      this._deviceId,
      this._changeDate,
      this._active,
      );

  factory HistoryJason.fromJson(Map<String, dynamic> json) {
    String getStr(Object str) {
      return (str != null && !str.toString().contains("null"))
          ? str.toString()
          : "";
    }

    return HistoryJason(
      getStr(json['device_id']),
      getStr(json['change_date']),
      getStr(json['active']),
    );
  }

  bool isActive() => active.compareTo("1") ==0;

  String get highLight => _highLight;

  String get active => _active;

  String get changeDate => _changeDate;

  String get deviceId => _deviceId;
}