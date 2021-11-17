import 'package:login_cms_comdelta/Pages/Client/DeviceStatus.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomeAppBar.dart';
import 'package:login_cms_comdelta/Widgets/Headers/DashBoardHeader.dart';
import 'package:login_cms_comdelta/Widgets/SideDrawers/SideDrawer.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';
import 'GoogleMap.dart';

class DashBoard extends StatefulWidget {

  DashBoard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoard> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/image/background.jpg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          child: CustomeAppBar('Dashboard'),
          preferredSize: const Size.fromHeight(50),
        ),
        drawer: SideDrawer(), // sidebar
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),

              DashBoardHeader(),

              Text(
                'Satellite Management System',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),

              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(context, SizeRoute(page: DeviceStatus()));
                },
                child: Container(
                  width: 320,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 60,
                          height: 110,
                          child: Image.asset('assets/image/statusb.png')),
                      Container(
                        width: 200,
                        height: 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Device Status',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text.rich(TextSpan(
                                text: 'Signal of the Devices',
                                style: TextStyle(fontWeight: FontWeight.bold)))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    SizeRoute(
                      page: GoogleMapApp(),
                    ),
                  );
                },
                child: Container(
                  width: 320,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 110,
                        child: Image.asset('assets/image/mapsb.png'),
                      ),
                      Container(
                        width: 200,
                        height: 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Map',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Location of the Devices',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ), //Container for Map
            ],
          ), // Column for DasbBoard Cards
        ),
      ),
    );
  }
}
