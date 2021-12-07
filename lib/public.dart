import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_select/smart_select.dart';
import 'JasonHolders/DeviceJason.dart';
import 'JasonHolders/UserInfoJason.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

var dashBoardContext;
var historyPage;
const PrimaryColor = const Color(0xff0065a3);
Uint8List greenIcon;
Uint8List yellowIcon;
Uint8List redIcon;
int daysInactive() => ((userType == clientKeyWord) ? 5 : 3);


//if you want to force logout all users on next updates change these keyWords
String userType = "";
const adminKeyWord = "admin2";
const clientKeyWord = "client2";

UserInfoJason user = UserInfoJason('', '', '', '', '', '');

List<S2Choice<String>> clientStatus = [
  S2Choice<String>(value: 'Hidden', title: 'Hidden'),
  S2Choice<String>(value: 'Shown', title: 'Shown'),
];

List<S2Choice<String>> client = [
  S2Choice<String>(value: 'DHarmoni', title: 'DHarmoni'),
  S2Choice<String>(value: 'Digi', title: 'Digi'),
  S2Choice<String>(value: 'Sacofa', title: 'Sacofa'),
  S2Choice<String>(value: 'U Mobile', title: 'U Mobile'),
  S2Choice<String>(value: 'EDOTCO', title: 'EDOTCO'),
  S2Choice<String>(value: 'Maxis', title: 'Maxis'),
  S2Choice<String>(value: 'Red One', title: 'Red One'),
  S2Choice<String>(value: 'xenox', title: 'xenox'),
  S2Choice<String>(value: 'sampugita', title: 'sampugita'),
  S2Choice<String>(
      value: 'Research & Development Department',
      title: 'Research & Development Department'),
  S2Choice<String>(
      value: 'Comdelta Technologies', title: 'Comdelta Technologies'),
  S2Choice<String>(value: 'Test Log', title: 'Test Log'),
  S2Choice<String>(value: 'YTL', title: 'YTL'),
  S2Choice<String>(value: 'Telekom', title: 'Telekom'),
  S2Choice<String>(value: 'Bullish Aim', title: 'Bullish Aim'),
  S2Choice<String>(value: 'Comdelta Test', title: 'Comdelta Test'),
];
// List<S2Choice<String>> client;

// List<S2Choice<String>> clientCompressed = [
//   S2Choice<String>(value: 'DHarmoni', title: 'DHarmoni'),
//   S2Choice<String>(value: 'Digi', title: 'Digi'),
//   S2Choice<String>(value: 'Sacofa', title: 'Sacofa'),
//   S2Choice<String>(value: 'U Mobile', title: 'U Mobile'),
//   S2Choice<String>(value: 'EDOTCO', title: 'EDOTCO'),
//   S2Choice<String>(value: 'Maxis', title: 'Maxis'),
//   S2Choice<String>(value: 'Red One', title: 'Red One'),
//   S2Choice<String>(value: 'xenox', title: 'xenox'),
//   S2Choice<String>(value: 'sampugita', title: 'sampugita'),
//   S2Choice<String>(
//       value: 'R&D',
//       title: 'R&D'),
//   S2Choice<String>(
//       value: 'Comdelta', title: 'Comdelta'),
//   S2Choice<String>(value: 'Test Log', title: 'Test Log'),
//   S2Choice<String>(value: 'YTL', title: 'YTL'),
//   S2Choice<String>(value: 'Telekom', title: 'Telekom'),
//   S2Choice<String>(value: 'Bullish Aim', title: 'Bullish Aim'),
//   S2Choice<String>(value: 'Comdelta Test', title: 'Comdelta Test'),
// ];

// var route;
bool openHis = false;

String deviceIdentifier = "";
String model = "";

List<DeviceJason> devices = [];

List<S2Choice<String>> location = [
  S2Choice<String>(value: '1', title: 'Kuala Lumpur'),
  S2Choice<String>(value: '2', title: 'Labuan'),
  S2Choice<String>(value: '3', title: 'Putrajaya'),
  S2Choice<String>(value: '4', title: 'Johor'),
  S2Choice<String>(value: '5', title: 'Kedah'),
  S2Choice<String>(value: '6', title: 'Kelantan'),
  S2Choice<String>(value: '7', title: 'Melaka'),
  S2Choice<String>(value: '8', title: 'Negeri Sembilan'),
  S2Choice<String>(value: '9', title: 'pahang'),
  S2Choice<String>(value: '10', title: 'Perak'),
  S2Choice<String>(value: '11', title: 'Perlis'),
  S2Choice<String>(value: '12', title: 'Pulau Pinang'),
  S2Choice<String>(value: '13', title: 'Sabah'),
  S2Choice<String>(value: '14', title: 'Sarawak'),
  S2Choice<String>(value: '15', title: 'Selangor'),
  S2Choice<String>(value: '16', title: 'Terengganu'),
];

List<S2Choice<String>> height = [
  S2Choice<String>(value: 'Below 45m', title: 'Below 45m'),
  S2Choice<String>(value: 'Above 45m', title: 'Above 45m'),
];

List<S2Choice<String>> siteRegion = [
  S2Choice<String>(value: 'Eastern', title: 'Eastern'),
  S2Choice<String>(value: 'Central', title: 'Central'),
  S2Choice<String>(value: 'Northern', title: 'Northern'),
  S2Choice<String>(value: 'Southern', title: 'Southern'),
  S2Choice<String>(value: 'Malaysia East', title: 'Malaysia East'),
];

List<S2Choice<String>> simCardProvider = [
  S2Choice<String>(value: 'Celcom', title: 'Celcom'),
  S2Choice<String>(value: 'Maxis', title: 'Maxis'),
  S2Choice<String>(value: 'ThingsMobile', title: 'ThingsMobile'),
];

List<S2Choice<String>> status = [
  S2Choice<String>(value: 'Inactive', title: 'Inactive'),
  S2Choice<String>(value: 'Active', title: 'Active'),
];

List<S2Choice<String>> deviceStatus = [
  S2Choice<String>(value: 'Inactive Devices', title: 'Inactive'),
  S2Choice<String>(value: 'Active Devices', title: 'Active'),
];

Map<int, Color> customColors = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};



double getDouble(String str) {
  try {
    return double.parse(str);
  } catch (e) {
    return 0;
  }
}

int getInt(String str) {
  try {
    return int.parse(str);
  } catch (e) {
    return 0;
  }
}

void toast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1);
}

String getResponseError(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 400:
      return (response.body.toString());
    case 401:
      return (response.body.toString());
    case 403:
      return (response.body.toString());
    case 500:
    default:
      return 'Error occurred while Communication with Server with StatusCode: ${response.statusCode}';
  }
}

Future<String> load(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? '-1';
}

Future<void> save(String key, String data) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, data);
}


Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
}