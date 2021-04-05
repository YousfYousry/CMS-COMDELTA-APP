class DeviceElement {
  String Id = "";
  String DeviceDetail = "";
  String Location = "";
  String highLight = "";

  String getId() {
    return Id;
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

  DeviceElement({this.Id, this.DeviceDetail, this.Location});

  factory DeviceElement.fromJson(Map<String, dynamic> json, String id,
      List<String> locId, List<String> locName) {
    return DeviceElement(
      Id: id,
      DeviceDetail: json['device_detail'].toString(),
      Location:
          locName.elementAt(locId.indexOf(json['location_id'].toString())),
    );
  }
}
