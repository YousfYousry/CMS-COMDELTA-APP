import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:login_cms_comdelta/DeviceStatus.dart';
import 'package:login_cms_comdelta/SideDrawer.dart';

import 'SideDrawer.dart';
import 'MyAppBar.dart';
import './GoogleMap.dart';
import './DashBoardHeader.dart';

const PrimaryColor = const Color(0xff0065a3);

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMS Login UI',
      theme: ThemeData(
        primaryColor: PrimaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: DashBoardPage(title: 'CMS Dashboard'),
    );
  }
}

class DashBoardPage extends StatefulWidget {
  DashBoardPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: PreferredSize(
        child: MyAppBar1(),
        preferredSize: const Size.fromHeight(50),
      ),
      drawer: SideDrawer(), // sidebar
      body: SingleChildScrollView(
        child: Column(
          children: [
            DashBoardHeader(),

            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DeviceStatus()));
              },
              child: Container(
                width: 320,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                        child: Image.asset('assets/image/status.png')),
                    Container(
                      width: 200,
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Device Status',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
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
            ), //Container for Device Status

            SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GoogleMapApp()));
              },
              child: Container(
                width: 320,
                height: 130,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 80,
                        height: 110,
                        child: Image.asset('assets/image/maps.png')),
                    Container(
                      width: 200,
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Map',
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold)),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Location of the Devices',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ) //Container for Map
          ],
        ), // Column for DasbBoard Cards
      ),
    );
  }
}
