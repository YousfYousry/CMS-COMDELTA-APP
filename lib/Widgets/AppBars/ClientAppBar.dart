import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import '../../Choices.dart';

class ClientAppBar extends StatelessWidget with PreferredSizeWidget {
  final totalDevices,activeDevices,inActiveDevices;
  final totalClicked,activeClicked,inActiveClicked;

  ClientAppBar({this.totalDevices,this.activeDevices,this.inActiveDevices,this.totalClicked,this.activeClicked,this.inActiveClicked});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff0065a3),
      title: Container(
        height: 30,
        child: Image.asset('assets/image/onlycomdelta.png'),
      ),
      centerTitle: true,
      elevation: 10,
      flexibleSpace: ClipRRect(
        child: Container(
          height: double.infinity,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              // color: Colors.white,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 2,
                      child: Divider(
                        color: Colors.white.withOpacity(0.25),
                        thickness: 1,
                      )),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => totalClicked(),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  Text(
                                    "Total Devices",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Countup(
                                    begin: 0,
                                    end: totalDevices,
                                    duration: Duration(seconds: 2),
                                    separator: ',',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                            height: 25,
                            width: 2,
                            child: VerticalDivider(
                              color: Colors.white.withOpacity(0.25),
                              thickness: 1,
                            )),
                        Expanded(
                          child: InkWell(
                            onTap: () => activeClicked(),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  Text(
                                    "Active Devices",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Countup(
                                    begin: 0,
                                    end: activeDevices,
                                    duration: Duration(seconds: 2),
                                    separator: ',',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                            height: 25,
                            width: 2,
                            child: VerticalDivider(
                              color: Colors.white.withOpacity(0.25),
                              thickness: 1,
                            )),
                        Expanded(
                          child: InkWell(
                            onTap: () => inActiveClicked(),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Spacer(),
                                  Text(
                                    "Inactive Devices",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Countup(
                                    begin: 0,
                                    end: inActiveDevices,
                                    duration: Duration(seconds: 2),
                                    separator: ',',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(105);
}
