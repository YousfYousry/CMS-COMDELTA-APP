import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Widgets/CustomeAppBar.dart';
import 'Widgets/FloatingButtonDashBoard.dart';
import 'Widgets/CustomeAppBar.dart';
import 'Classes/device.dart';
import 'Widgets/ProgressBar.dart';
import 'Widgets/SideDrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const PrimaryColor = const Color(0xff0065a3);

class GoogleMapApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps',
      theme: ThemeData(
        primaryColor: PrimaryColor,
      ),
      home: GoogleMapPage(title: 'Google maps'),
    );
  }
}

class GoogleMapPage extends StatefulWidget {
  GoogleMapPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController mapController;
  final LatLng _center = const LatLng(2.944590144570856, 101.60274569735296);
  bool loading = true;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: PreferredSize(
        child: CustomeAppBar('Map'),
        preferredSize: const Size.fromHeight(50),
      ),
      drawer: SideDrawer(),
      floatingActionButton: FloatingButton1(),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 4,
            ),
            markers: Set<Marker>.of(markers.values), // YOUR
          ),
          Center(
            child: Visibility(
              child: CircularProgressIndicatorApp(),
              visible: loading,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getDevices() async {
    load('client_id').then((value) =>
        value != '-1' ? sendPost(value) : toast('User was not found!'));
  }

  void sendPost(String clientId) {
    http.post(Uri.parse('http://103.18.247.174:8080/AmitProject/getDevice.php'),
        body: {
          'client_id': clientId,
        }).then((response) {
      if (response.statusCode == 200) {
        // ignore: deprecated_member_use
        List<Device> devices = new List<Device>();
        // ignore: deprecated_member_use
        List<dynamic> values = new List<dynamic>();
        values = json.decode(response.body);
        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              devices.add(Device.fromJson(map));
            }
          }
        }
        showDevices(devices);
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get devices list");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void showDevices(List<Device> devices) {
    // ignore: deprecated_member_use
    List<LatLng> positions = new List<LatLng>();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(12, 12)), 'assets/image/marker.png')
        .then((customIcon) {
      setState(() {
        for (Device device in devices) {
          if (getDouble(device.getLong()) != 0 &&
              getDouble(device.getLat()) != 0) {
            positions.add(new LatLng(
                getDouble(device.getLong()), getDouble(device.getLat())));
            markers[MarkerId(device.getName())] = Marker(
              anchor: const Offset(0.5, 0.5),
              markerId: MarkerId(device.getName()),
              position: LatLng(
                  getDouble(device.getLong()), getDouble(device.getLat())),
              infoWindow: InfoWindow(
                title: 'Site name: ' + device.getDeviceDetail(),
              ),
              icon: customIcon,
              draggable: false,
              zIndex: 1,
            );
          }
        }
        mapController.animateCamera(
            CameraUpdate.newLatLngBounds(_bounds(positions), 20));
        loading = false;
      });
    });
  }

  LatLngBounds _bounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }

  Future<String> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '-1';
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }

  double getDouble(String str) {
    try {
      return double.parse(str);
    } catch (e) {
      return 0;
    }
  }
}
