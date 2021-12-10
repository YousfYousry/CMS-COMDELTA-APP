import 'DeviceCountHolder.dart';

class DeviceCount {
  String _date = "";
  List<DeviceCountHolder> _deviceHolder = [];
  String _total = "";
  String _active = "";
  String _inactive = "";
  String _highLight = "";

  void setHighLight(String value) {
    _highLight = value;
  }

  DeviceCount(this._date, this._deviceHolder) {
    this._total = this._deviceHolder.length.toString();
    this._active = this
        ._deviceHolder
        .where((element) => element.isActive)
        .toList()
        .length
        .toString();
    this._inactive = this
        ._deviceHolder
        .where((element) => !element.isActive)
        .toList()
        .length
        .toString();
  }

  bool isFound(String str) {
    for (int i = 0; i < 4; i++) {
      if (getE(i).toLowerCase().contains(str.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  String getE(int index) {
    if (index == 0) {
      return _date;
    } else if (index == 1) {
      return _total;
    } else if (index == 2) {
      return _active;
    } else if (index == 3) {
      return _inactive;
    } else {
      return "";
    }
  }

  String get inactive => _inactive;

  String get active => _active;

  String get total => _total;

  List<DeviceCountHolder> get deviceHolder => _deviceHolder;

  String get date => _date;

  String get highLight => _highLight;
}
