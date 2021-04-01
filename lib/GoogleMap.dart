import 'package:flutter/material.dart';
import 'Widgets/FloatingButtonDashBoard.dart';
import 'Widgets/MyAppBar.dart';
import 'Widgets/SideDrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoogleMapController mapController;
    final LatLng _center = const LatLng(45.521563, -122.677433);
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;

    }
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: PreferredSize(
        child: MyAppBar1(),
        preferredSize: const Size.fromHeight(50),
      ),
      drawer: SideDrawer(),
      floatingActionButton: FloatingButton1(),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 4,
        ),
      ),
    );
  }
}
