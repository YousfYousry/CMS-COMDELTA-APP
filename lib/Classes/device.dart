class Device {
  String id;
  String name;
  String long;
  String lat;
  String deviceDetail;

  String getId(){
    return id;
  }

  String getName(){
    return name;
  }

  String getLong(){
    return long;
  }

  String getLat(){
    return lat;
  }

  String getDeviceDetail(){
    return deviceDetail;
  }

  Device({this.id,this.name, this.long, this.lat, this.deviceDetail});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['device_id'].toString(),
      name: json['device_name'].toString(),
      long: json['device_longitud'].toString(),
      lat: json['device_latitud'].toString(),
      deviceDetail: json['device_detail'].toString(),
    );
  }
}