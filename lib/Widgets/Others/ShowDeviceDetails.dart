import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ShowDevice {
  final primaryColor = const Color(0xff0065a3);

  ShowDevice(BuildContext context,DeviceJason device){
    AwesomeDialog(
      dialogBackgroundColor:
      Color(0xfafafafa),
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.NO_HEADER,
      body: Padding(
        padding: EdgeInsets.only(
            left: 15, right: 15),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            details('ID',
                device.id),
            details(
                'Device Name',
                device.deviceName),
            details(
                'Device Detail',
                device.deviceDetails),
            details(
                'Height',
                device.deviceHeight),
            details(
                'Activation Date',
                device.activationDate),
            details(
                'Location',
                device.deviceLocation),
            details(
                'Batch Number',
                device.batchNum),
            details(
                'Sim Number',
                device.serialNum),
            details(
                'Sim Provider',
                device.simProvider),
            details(
                'Last Signal',
                device.lastSignal),
            l123('L1#',
                device.l1),
            l123('L2#',
                device.l2),
            l123('L3#',
                device.l3),
            battery('Battery',
                device.battery),
            rssi('Rssi',
                device.rssi),
            status('Status',
                device.status),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<
                    Color>((device.lat !=
                    500 &&
                    device.lon !=
                        500 &&
                    device.deviceName
                        .isNotEmpty)
                    ? primaryColor
                    : Colors.grey),
                shape: MaterialStateProperty
                    .all<
                    RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                        10),
                    side: BorderSide(
                        color: Colors
                            .black12),
                  ),
                ),
              ),

              onPressed: () => (device.lat !=
                  500 &&
                  device.lon !=
                      500 &&
                  device.deviceName
                      .isNotEmpty)
                  ? MapsLauncher
                  .launchCoordinates(
                  device.lat,
                  device.lon,
                  device.deviceName)
                  : toast(
                  "Location is unavailable")
              // if (lat != 500 && lon != 500 && title.isNotEmpty) {
              //   MapsLauncher.launchCoordinates(lat, lon, title);
              // }
              ,
              // tooltip: 'Google maps',
              child: Center(
                child: Container(
                  height: 30,
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        "Show on google maps",
                        style: TextStyle(
                            color: (device.lat != 500 &&
                                device.lon !=
                                    500 &&
                                device.deviceName
                                    .isNotEmpty)
                                ? null
                                : Colors
                                .black54,
                            fontSize:
                            15,
                            fontWeight:
                            FontWeight
                                .bold),
                      ),
                      Padding(
                        padding:
                        EdgeInsets
                            .all(5),
                        child: Image(
                          color: (device.lat != 500 &&
                              device.lon !=
                                  500 &&
                              device.deviceName
                                  .isNotEmpty)
                              ? null
                              : Colors
                              .black54,
                          image: AssetImage(
                              'assets/image/google_maps.png'),
                        ),
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
      title: 'This is Ignored',
      desc: 'This is also Ignored',
    )..show();
  }

  Widget details(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 13, color: Colors.black.withOpacity(0.6)),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget l123(String title, bool value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(
              Icons.lightbulb,
              color: value ? Colors.green : Colors.red,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget battery(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 2.5,
              ),
              child: ImageIcon(
                AssetImage("assets/battery/battery" + value + ".png"),
                color: Colors.black,
                size: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rssi(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 2.5,
              ),
              child: ImageIcon(
                AssetImage("assets/rssi/rssi" + value + ".png"),
                color: Colors.black,
                size: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget status(String title, bool value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(
              value ? Icons.check : Icons.close,
              color: value ? Colors.green : Colors.red,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
