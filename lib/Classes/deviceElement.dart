class DeviceElement {
  String Id = "";
  String ID = "";
  String DeviceDetail = "";
  String Location = "";
  String highLight = "";
  String deviceLongitud;
  String deviceLatitud;

  //	device_longitud	device_latitud

  double getLongitud() {
    return getDoube(deviceLongitud);
  }

  double getLatitud() {
    return getDoube(deviceLatitud);
  }

  String getId() {
    return Id;
  }

  String getID() {
    return ID;
  }

  String getDeviceDetail() {
    return DeviceDetail;
  }

  String getLocation() {
    return Location;
  }

  String getHighLight() {
    return highLight;
  }

  String setHighLight(String high) {
    this.highLight = high;
  }

  DeviceElement(
      {this.ID,
      this.Id,
      this.DeviceDetail,
      this.Location,
      this.deviceLatitud,
      this.deviceLongitud});

  factory DeviceElement.fromJson(Map<String, dynamic> json, String id,
      List<String> locId, List<String> locName) {
    return DeviceElement(
      Id: id,
      ID: json['device_id'].toString(),
      DeviceDetail: json['device_detail'].toString(),
      Location:
          locName.elementAt(locId.indexOf(json['location_id'].toString())),
      deviceLatitud: json['device_longitud'].toString(),
      deviceLongitud: json['device_latitud'].toString(),
    );
  }

  double getDoube(String str) {
    try {
      return double.parse(str);
    } catch (e) {
      return 500;
    }
  }
}
