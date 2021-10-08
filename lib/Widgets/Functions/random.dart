import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// class Item {
//   final int id;
//   final String name;
//
//   Item({
//     this.id,
//     this.name,
//   });
// }

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

// Future<void> permissionThen(var permission,var then) async { // you can't pass the permission
//   await permission.request().then((value) async {
//     if (value.isGranted) {
//       then();
//     } else if(value.isPermanentlyDenied) {
//       toast("Accept permission to proceed!");
//       await  openAppSettings();
//     }else if(value.isDenied){
//       toast("Permission is denied");
//     }else if(value.isRestricted){
//       toast("Permission is restricted");
//     }else if(value.isLimited){
//       toast("Permission is limited");
//     }
//     return true;
//   });
// }

void toast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1);
}
Future<String> load(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? '-1';
}

Future<void> save(String key, String data) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, data);
}