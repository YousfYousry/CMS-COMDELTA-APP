import 'dart:async';

// import 'dart:typed_data';
// import 'package:connectivity/connectivity.dart';
// import 'package:countup/countup.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/JasonHolders/RemoteApi.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/ClientAppBar.dart';
import 'package:login_cms_comdelta/Widgets/Cards/ShowDevice.dart';

// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/Loading.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';
import 'package:login_cms_comdelta/Widgets/SideDrawers/SideDrawer.dart';

// import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../public.dart';
import 'DeviceHistory.dart';

class ClientDashBoard extends StatefulWidget {
  ClientDashBoard({Key key}) : super(key: key);

  @override
  _ClientDashBoard createState() => _ClientDashBoard();
}

class _ClientDashBoard extends State<ClientDashBoard>
    with WidgetsBindingObserver {
  double activeNum = 0, inActiveNum = 0, totalNum = 0;

  // StreamSubscription<ConnectivityResult> subscription;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final LatLng _center = const LatLng(2.944590144570856, 101.60274569735296);
  GoogleMapController mapController;
  var icons = [];
  var mapType = MapType.hybrid;
  bool loading = false;
  double selectedLon = 500;
  double selectedLat = 500;
  String selectedTitle = '';
  List<LatLng> positions = [];

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getLocations();
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    try {
      mapController = controller;
      icons = [
        BitmapDescriptor.fromBytes(greenIcon),
        BitmapDescriptor.fromBytes(redIcon)
      ];
      // location = await RemoteApi.getLocationList();
      setLocations();
    } catch (error) {
      toast(error.toString());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.push(
          context,
          SizeRoute(
            page: DeviceHistoryClient(),
          ),
        );
      }
    });

    // subscription =
    //     Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  //
  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   if (result == ConnectivityResult.none) {
  //     toast("internet disconnected");
  //   } else {
  //     getLocations();
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    dashBoardContext = context;
    historyPage = DeviceHistoryClient();
    return WillPopScope(
      child: Scaffold(
        appBar: ClientAppBar(
          totalDevices: totalNum,
          activeDevices: activeNum,
          inActiveDevices: inActiveNum,
          totalClicked: displayTotal,
          activeClicked: displayActive,
          inActiveClicked: displayInactive,
        ),
        drawer: SideDrawer(setOpen: isOpen), // sidebar
        body: Stack(
          children: [
            GoogleMap(
              // onTap: (v) => _animationController.reverse(),
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              rotateGesturesEnabled: false,
              mapType: mapType,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 4,
              ),
              markers: Set<Marker>.of(markers.values), // YOUR
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.all(10),
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setStateBuilder
                                /*You can rename this!*/) {
                          return Container(
                            height: 200,
                            // color: Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, top: 10, right: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Map Type"),
                                      Spacer(),
                                      InkWell(
                                        customBorder: CircleBorder(),
                                        onTap: () => Navigator.pop(context),
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(Icons.close),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        customBorder: CircleBorder(),
                                        onTap: () => setState(() =>
                                            setStateBuilder(() =>
                                                mapType = MapType.normal)),
                                        child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Tab(
                                              icon: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 3,
                                                      color: mapType ==
                                                              MapType.normal
                                                          ? Colors.blueAccent
                                                          : Colors.transparent),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          10.0) //                 <--- border radius here
                                                      ),
                                                ),
                                                child: Image.asset(
                                                    "assets/image/def.png"),
                                                height: 45,
                                                width: 45,
                                              ),
                                              text: "Default"),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        customBorder: CircleBorder(),
                                        onTap: () => setState(() =>
                                            setStateBuilder(() =>
                                                mapType = MapType.hybrid)),
                                        child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Tab(
                                              icon: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 3,
                                                      color: mapType ==
                                                              MapType.hybrid
                                                          ? Colors.blueAccent
                                                          : Colors.transparent),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          10.0) //                 <--- border radius here
                                                      ),
                                                ),
                                                child: Image.asset(
                                                    "assets/image/sat.png"),
                                                height: 45,
                                                width: 45,
                                              ),
                                              text: "Satellite"),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        customBorder: CircleBorder(),
                                        onTap: () => setState(() =>
                                            setStateBuilder(() =>
                                                mapType = MapType.terrain)),
                                        child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Tab(
                                              icon: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 3,
                                                      color: mapType ==
                                                              MapType.terrain
                                                          ? Colors.blueAccent
                                                          : Colors.transparent),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          10.0) //                 <--- border radius here
                                                      ),
                                                ),
                                                child: Image.asset(
                                                    "assets/image/ter.png"),
                                                height: 45,
                                                width: 45,
                                              ),
                                              text: "Terrain"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    );
                  },
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.layers_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Loading(
              loading: loading,
              // color: Colors.white,
            ),
          ],
        ),
      ),
      onWillPop: onWillPop,
    );
  }

  void setLocations() {
    try {
      double total = 0, inActiveLast72 = 0;
      devices.forEach((device) {
        total++;
        if (device.inActiveLast72()) {
          inActiveLast72++;
        }
        if (device.lat != 500 && device.lon != 500) {
          addMarker(device);
          positions.add(new LatLng(device.lat, device.lon));
        }
      });
      setState(() {
        if (positions.isNotEmpty) {
          activeNum = (total - inActiveLast72);
          inActiveNum = inActiveLast72;
          totalNum = total;

          mapController.animateCamera(
              CameraUpdate.newLatLngBounds(_bounds(positions), 20));
        } else {
          toast("No device was found!");
          mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 4));
        }
      });
    } catch (error) {
      print('Error: ' + error.message);
    }
  }

  Future<void> getLocations() async {
    try {
      // if(loading) return;
      setState(() {
        loading = true;
      });
      final clientId = await load('client_id');
      if (clientId == '-1') {
        toast('User was not found!');
        return;
      }
      devices = await RemoteApi.getClientDevicesList(clientId);
      markers.clear();
      positions.clear();
      double total = 0, inActiveLast72 = 0;
      devices.forEach((device) {
        total++;
        if (device.inActiveLast72()) {
          inActiveLast72++;
        }
        if (device.lat != 500 && device.lon != 500) {
          addMarker(device);
          positions.add(new LatLng(device.lat, device.lon));
        }
      });
      setState(() {
        if (positions.isNotEmpty) {
          activeNum = (total - inActiveLast72);
          inActiveNum = inActiveLast72;
          totalNum = total;

          mapController.animateCamera(
              CameraUpdate.newLatLngBounds(_bounds(positions), 20));
        } else {
          toast("No device was found!");
          mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 4));
        }
      });
    } catch (error) {
      print('Error: ' + error.message);
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> displayTotal() async {
    try {
      setState(() {
        loading = true;
      });
      markers.clear();
      positions.clear();
      devices.forEach((device) {
        if (device.lat != 500 && device.lon != 500
            // &&device.inActiveLast72()
            ) {
          addMarker(device);
          positions.add(new LatLng(device.lat, device.lon));
        }
      });
      setState(() {
        if (positions.isNotEmpty) {
          mapController.animateCamera(
              CameraUpdate.newLatLngBounds(_bounds(positions), 20));
        } else {
          toast("No device was found!");
          mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 4));
        }
      });
    } catch (error) {
      print('Error: ' + error.message);
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> displayActive() async {
    try {
      setState(() {
        loading = true;
      });
      markers.clear();
      positions.clear();
      devices.forEach((device) {
        if (device.lat != 500 &&
            device.lon != 500 &&
            !device.inActiveLast72()) {
          addMarker(device);
          positions.add(new LatLng(device.lat, device.lon));
        }
      });
      setState(() {
        if (positions.isNotEmpty) {
          mapController.animateCamera(
              CameraUpdate.newLatLngBounds(_bounds(positions), 20));
        } else {
          toast("No device was found!");
          mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 4));
        }
      });
    } catch (error) {
      print('Error: ' + error.message);
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> displayInactive() async {
    try {
      setState(() {
        loading = true;
      });
      markers.clear();
      positions.clear();
      devices.forEach((device) {
        if (device.lat != 500 && device.lon != 500 && device.inActiveLast72()) {
          addMarker(device);
          positions.add(new LatLng(device.lat, device.lon));
        }
      });
      setState(() {
        if (positions.isNotEmpty) {
          mapController.animateCamera(
              CameraUpdate.newLatLngBounds(_bounds(positions), 20));
        } else {
          toast("No device was found!");
          mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 4));
        }
      });
    } catch (error) {
      print('Error: ' + error.message);
    }
    setState(() {
      loading = false;
    });
  }

  void addMarker(DeviceJason device) {
    markers[MarkerId(device.id)] = Marker(
      onTap: () {
        selectedLat = device.lat;
        selectedLon = device.lon;
        selectedTitle = device.deviceDetails;
        ShowDevice(this.context, device);
        // _animationController.forward();
      },
      anchor: const Offset(0.5, 0.5),
      markerId: MarkerId(device.id),
      position: LatLng(device.lat, device.lon),
      infoWindow: InfoWindow(
        title: device.deviceName,
      ),
      icon: icons[device.iconClient],
      draggable: false,
      zIndex: 1,
    );
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

  void isOpen(bool isOpen) {
    drawerOpen = isOpen;
  }

  DateTime currentBackPressTime;
  bool drawerOpen = false;

  Future<bool> onWillPop() {
    if (!drawerOpen) {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        toast("Press back again to exit");
        return Future.value(false);
      }
    }
    return Future.value(true);
  }
}
