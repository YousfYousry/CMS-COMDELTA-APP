import 'package:login_cms_comdelta/Widgets/CustomAppBarWithBack.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'Widgets/Bottom.dart';
import 'Widgets/ProgressBar.dart';
import 'Widgets/SideDrawer.dart';
import 'Classes/device.dart';
import 'dart:convert';

const PrimaryColor = const Color(0xff0065a3);

// ignore: must_be_immutable
class GoogleMapApp extends StatefulWidget {
  String name = '';
  final String title = 'Maps';

  GoogleMapApp({this.name});

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState(name: name);
}

class _GoogleMapPageState extends State<GoogleMapApp>
    with SingleTickerProviderStateMixin {
  String name = '';

  _GoogleMapPageState({this.name});

  Animation<double> _translateButton;
  AnimationController _animationController;
  double lat = 500, lon = 500;
  String title = '';

  // bool isOpened = false;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController mapController;
  final LatLng _center = const LatLng(2.944590144570856, 101.60274569735296);
  bool loading = true;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getDevices();
  }

  Widget nav() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(PrimaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.black12),
          ),
        ),
      ),

      // style: ElevatedButton.styleFrom(primary: PrimaryColor),
      onPressed: () {
        if (lat != 500 && lon != 500 && title.isNotEmpty) {
          MapsLauncher.launchCoordinates(lat, lon, title);
        }
      },
      // tooltip: 'Google maps',
      child: Center(
        child: Container(
          height: 40,
          child: Row(
            children: [
              Spacer(),
              Text(
                "Show on google maps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.all(7),
                child: Image(
                  image: AssetImage('assets/image/google_maps.png'),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });

    _translateButton = Tween<double>(
      begin: 56.0,
      end: -7.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.4,
        curve: Curves.easeOut,
      ),
    ));
    // _animationController.forward();
    super.initState();
  }

  // animate() {
  //   if (!isOpened) {
  //     _animationController.forward();
  //   } else {
  //     _animationController.reverse();
  //   }
  //   isOpened = !isOpened;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: PreferredSize(
        child: CustomAppBarBack(context, 'Map'),
        preferredSize: const Size.fromHeight(50),
      ),
      drawer: SideDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            onTap: (v) => _animationController.reverse(),
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
          bottom(Padding(
            padding: EdgeInsets.only(right: 30,left: 30),
            child:Center(
            child: Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value * 3.0,
                0.0,
              ),
              child: nav(),
            ),
          ),)),
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
        var chosenId;
        for (Device device in devices) {
          if (getDouble(device.getLong()) != 0 &&
              getDouble(device.getLat()) != 0) {
            var id = MarkerId(device.getId());
            if (name != null &&
                name.isNotEmpty &&
                name.toLowerCase().contains(device.getId().toLowerCase())) {
              lon = getDouble(device.getLat());
              lat = getDouble(device.getLong());
              title = device.getDeviceDetail();
              _animationController.forward();
              chosenId = id;
            }
            positions.add(new LatLng(
                getDouble(device.getLong()), getDouble(device.getLat())));
            markers[id] = Marker(
              onTap: () {
                lon = getDouble(device.getLat());
                lat = getDouble(device.getLong());
                title = device.getDeviceDetail();
                _animationController.forward();
              },
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
        // toast(name);
        if (name != null && name.isNotEmpty && lat != 500 && lon != 500) {
          // if (chosenId != null) {
          //   mapController.showMarkerInfoWindow(chosenId);
          // }
          mapController
              .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lon), 12));
        } else {
          if (name != null && name.isNotEmpty) {
            toast("Device not found!");
          }
          mapController.animateCamera(
              CameraUpdate.newLatLngBounds(_bounds(positions), 20));
        }
        loading = false;
      });
    }).onError((error, stackTrace) {
      toast(error.toString());
      setState(() {
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
