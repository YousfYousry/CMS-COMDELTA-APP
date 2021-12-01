import 'package:flutter/material.dart';

class UserInfoJason {
  String _firsName = "";
  String _lastName = "";
  ImageProvider _logo = NetworkImage(
      'http://cmscomdelta.com/assets/dist/img/profile_picture/92a2fb1a7d6a2342b1ccca2b6e5d740d.png');
  String _userName = "";
  String _clientId = "";
  String _status = "";

  void setLogo(ImageProvider value) {
    _logo = value;
  }

  UserInfoJason(
    String firsName,
    String lastName,
    String logo,
    String userName,
    String clintId,
    String status,
  ) {
    this._firsName = firsName;
    this._lastName = lastName;
    this._logo = getImage(logo);
    this._userName = userName;
    this._clientId = clintId;
    this._status = status;
  }

  factory UserInfoJason.fromJson(Map<String, dynamic> json) {
    String getStr(Object str) {
      return (str != null && !str.toString().contains("null"))
          ? str.toString()
          : "";
    }

    if (json['res'] != '0') {
      return UserInfoJason(
        '',
        '',
        '',
        '',
        '',
        '',
      );
    }
    return UserInfoJason(
      getStr(json['first_name']),
      getStr(json['last_name'].toString()),
      getStr(json['logo'].toString()),
      getStr(json['username'].toString()),
      getStr(json['client_id'].toString()),
      getStr(json['status'].toString()),
    );
  }

  ImageProvider getImage(String str) {
    try {
      if (str.isEmpty) {
        return NetworkImage(
            'http://cmscomdelta.com/assets/dist/img/profile_picture/92a2fb1a7d6a2342b1ccca2b6e5d740d.png');
      } else {
        return NetworkImage(str);
      }
    } catch (error) {
      return NetworkImage(
          'http://cmscomdelta.com/assets/dist/img/profile_picture/92a2fb1a7d6a2342b1ccca2b6e5d740d.png');
    }
  }

  String get userName => _userName;

  ImageProvider get logo => _logo;

  String get lastName => _lastName;

  String get firsName => _firsName;

  String get clientId => _clientId;

  String get status => _status;

  String get fulName => _firsName + " " + _lastName;
}
