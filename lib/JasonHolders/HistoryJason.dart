import '../public.dart';
import 'DeviceJason.dart';

class HistoryJason {
  String _deviceId = "";
  String _changeDate = "";
  String _inactivePeriod = "";
  String _active = "";
  String _highLight = "";

  void setHighLight(String value) {
    _highLight = value;
  }

  HistoryJason(
      this._deviceId,
      this._changeDate,
      this._inactivePeriod,
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
      getStr(json['inactive_period']),
      getStr(json['active']),
    );
  }

  bool isActive() => active.compareTo("1") ==0;

  DeviceJason getDevice(){
    if(devices.isNotEmpty) {
      return devices.firstWhere(
              (device) =>
          device.id == this._deviceId,
          orElse: () => null);
    }else{
      return null;
    }
  }

  String get highLight => _highLight;

  String get active => _active;

  String get changeDate => _changeDate;

  String get inactivePeriod => _inactivePeriod;

  String get deviceId => _deviceId;
}