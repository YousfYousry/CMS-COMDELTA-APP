import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Widgets/CustomeAppBar.dart';


import 'Widgets/FloatingButtonDashBoard.dart';
import 'Widgets/CustomeAppBar.dart';
import 'Widgets/SideDrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class GoogleMapApp extends StatelessWidget {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 4,
        ),
      ),
    );
  }
}
