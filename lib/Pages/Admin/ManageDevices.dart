import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_cms_comdelta/JasonHolders/LogJason.dart';
import 'package:login_cms_comdelta/Widgets/Functions/ExportExcel.dart';
import 'package:login_cms_comdelta/Widgets/Others/AdvancedSearch.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

// import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/Pages/Admin/AddEditDevice.dart';
import 'package:login_cms_comdelta/Pages/Admin/DeviceLogs.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/ManageDevicesAppBar.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
import 'package:login_cms_comdelta/Widgets/Others/ShowDeviceDetails.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';
import 'package:login_cms_comdelta/Widgets/Position/MiddleLeft.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/SnackBar.dart';

// import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartDate.dart';
// import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartSelect.dart';
// import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:permission_handler/permission_handler.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:math' as math;

// import '../../Choices.dart';

const PrimaryColor = const Color(0xff0065a3);

class ManageDevice extends StatefulWidget {
  @override
  _ManageDevice createState() => _ManageDevice();
}

var spanUp = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 2, bottom: 2),
        child: ImageIcon(
          AssetImage('assets/image/sortup.png'),
          size: 12,
          color: Colors.black,
        ),
      ),
    ),
    spanDown = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 2, bottom: 2),
        child: ImageIcon(
          AssetImage('assets/image/sortdown.png'),
          size: 12,
          color: Colors.black,
        ),
      ),
    ),
    spanDefault = WidgetSpan(
      child: Transform.rotate(
          angle: 90 * math.pi / 180,
          child: Icon(
            Icons.sync_alt,
            size: 15,
            color: Colors.grey,
          )),
    );

class _ManageDevice extends State<ManageDevice> with WidgetsBindingObserver {
  TextEditingController searchController = new TextEditingController();
  bool loading = true, validate = false;
  int sortState = 1;
  Snack deleteSnack;

  AdvancedSearch advancedSearch;

  // String clientAd = "", simProviderAd = "";
  // TextEditingController batchNumAd = new TextEditingController(),
  //     activationFromAd = new TextEditingController(),
  //     activationToAd = new TextEditingController(),
  //     lastSignalAd = new TextEditingController();

  var span1 = spanUp, span2 = spanDefault, span3 = spanDefault;
  List<DeviceJason> devices = [];
  List<DeviceJason> duplicateDevices = [];

  void _sort1() {
    if (span1 != spanDown) {
      sortState = 0;
      devices.sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
      span1 = spanDown;
    } else {
      sortState = 1;
      devices.sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
      span1 = spanUp;
    }
    span2 = spanDefault;
    span3 = spanDefault;
  }

  void _sort2() {
    if (span2 != spanDown) {
      sortState = 2;
      devices.sort((a, b) => a.deviceName.compareTo(b.deviceName));
      span2 = spanDown;
    } else {
      sortState = 3;
      devices.sort((a, b) => b.deviceName.compareTo(a.deviceName));
      span2 = spanUp;
    }
    span1 = spanDefault;
    span3 = spanDefault;
  }

  void _sort3() {
    if (span3 != spanDown) {
      sortState = 4;
      devices.sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
      span3 = spanDown;
    } else {
      sortState = 5;
      devices.sort((a, b) => b.deviceLocation.compareTo(a.deviceLocation));
      span3 = spanUp;
    }
    span2 = spanDefault;
    span1 = spanDefault;
  }

  void filterSearchResults(String query) {
    bool resultFound = false;
    var dummySearchList = [];
    dummySearchList.addAll(duplicateDevices);
    if (query.isNotEmpty) {
      List<DeviceJason> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.id.toLowerCase().contains(query.toLowerCase()) ||
            item.deviceName.toLowerCase().contains(query.toLowerCase()) ||
            item.deviceLocation.toLowerCase().contains(query.toLowerCase())) {
          resultFound = true;
          item.setHighLight(query);
          dummyListData.add(item);
        }
      });
      setState(() {
        validate = !resultFound;
        devices.clear();
        devices.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        validate = false;
        span1 = spanUp;
        span2 = spanDefault;
        span3 = spanDefault;
        devices.clear();
        devices.addAll(duplicateDevices);
        devices.forEach((item) => item.setHighLight(''));
      });
    }
  }

  @override
  void initState() {
    getLocations();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getLocations();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (advancedSearch == null)
      advancedSearch = AdvancedSearch(context, getLocations, searchController);
    deleteSnack = new Snack(this.context, "Deleting...", 100);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xfafafafa),
        appBar: PreferredSize(
          child: ManageDevicesAppBar(
              context,
              "Manage Device",
              addDevice,
              exportPDF,
              exportExcel,
              advancedSearch.show,
              advancedSearch.reset),
          preferredSize: const Size.fromHeight(50),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(context, SizeRoute(page: AddClient()));
        //   },
        //   child: const Icon(Icons.add),
        //   backgroundColor: Color(0xff0065a3),
        // ),
        // drawer: SideDrawerAdmin(),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (text) {
                      filterSearchResults(text);
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      errorText: validate ? 'No result was found' : null,
                      labelText: "Search",
                      hintText: "Search",
                      contentPadding: EdgeInsets.all(20.0),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          color: Colors.black12,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _sort1();
                                    });
                                  },
                                  child: MiddleLeft(Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(text: 'ID'),
                                          span1,
                                        ],
                                      ),
                                    ),
                                  )),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                flex: 4,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _sort2();
                                    });
                                  },
                                  child: MiddleLeft(Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(text: 'Device Name'),
                                          span2,
                                        ],
                                      ),
                                    ),
                                  )),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _sort3();
                                    });
                                  },
                                  child: MiddleLeft(Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(text: 'Location'),
                                          span3,
                                        ],
                                      ),
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: new BoxDecoration(color: Colors.white),
                            child: ListView.builder(
                              itemCount: devices.length,
                              itemBuilder: (context, index) {
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.20,
                                  child: new Column(
                                    children: [
                                      Material(
                                        color: (index % 2 == 0)
                                            ? Colors.white
                                            : Color(0xf1f1f1f1),
                                        child: InkWell(
                                          onTap: () {
                                            ShowDevice(context, devices[index]);
                                          },
                                          child: Container(
                                            height: 40,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: SubstringHighlight(
                                                      text: devices[index].id,
                                                      term: devices[index]
                                                          .highLight,
                                                      textStyleHighlight:
                                                          TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textStyle: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                    ),

                                                    // Text(
                                                    //   ID,
                                                    //   textAlign: TextAlign.left,
                                                    //   style: TextStyle(fontSize: 12),
                                                    // ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 1,
                                                  color: Colors.grey,
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: SubstringHighlight(
                                                      text: devices[index]
                                                          .deviceName,
                                                      term: devices[index]
                                                          .highLight,
                                                      textStyleHighlight:
                                                          TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textStyle: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   Details,
                                                    //   textAlign: TextAlign.left,
                                                    //   style: TextStyle(fontSize: 12),
                                                    // ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 1,
                                                  color: Colors.grey,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: SubstringHighlight(
                                                      text: devices[index]
                                                          .deviceLocation,
                                                      term: devices[index]
                                                          .highLight,
                                                      textStyleHighlight:
                                                          TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textStyle: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   Location,
                                                    //   textAlign: TextAlign.left,
                                                    //   style: TextStyle(fontSize: 12),
                                                    // ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    new IconSlideAction(
                                      caption: 'Logs',
                                      color: Color(0xffFFB61E),
                                      icon: Icons.signal_cellular_alt,
                                      onTap: () => deviceLogs(devices[index]),
                                    ),
                                    new IconSlideAction(
                                      caption: 'Download',
                                      color: Colors.green,
                                      icon: Icons.download,
                                      onTap: () => downloadLogs(devices[index].id),
                                    ),
                                  ],
                                  secondaryActions: <Widget>[
                                    new IconSlideAction(
                                      caption: 'Edit',
                                      color: Color(0xff62D0F1),
                                      icon: Icons.edit,
                                      onTap: () => editDevice(devices[index]),
                                    ),
                                    new IconSlideAction(
                                      caption: 'Delete',
                                      color: Color(0xffE5343D),
                                      icon: Icons.delete,
                                      onTap: () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Delete Device',
                                          desc:
                                              'Do you really want to delete ' +
                                                  devices[index].deviceName,
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            deleteSnack.show();
                                            sendDeleteReq(devices[index].id);
                                          },
                                        )..show();
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Loading(
                loading: loading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editDevice(DeviceJason deviceJason) {
    Navigator.push(
      context,
      SizeRoute(
        page: AddDevice("Edit Device", deviceJason),
      ),
    ).then((value) => getLocations());
  }

  void addDevice() {
    Navigator.push(
      context,
      SizeRoute(
        page: AddDevice("Add Device", null),
      ),
    ).then((value) => getLocations());
  }

  void deviceLogs(DeviceJason device) {
    Navigator.push(
      context,
      SizeRoute(
        page: DeviceLogs(device),
      ),
    );
  }

  Future<void> exportPDF() async {
    await Permission.storage.request().then((value) async {
      if (value.isGranted) {
        PdfDocument document = PdfDocument();
        document.pageSettings.margins.all = 0;

        PdfFont font = PdfStandardFont(
          PdfFontFamily.timesRoman,
          12,
        );

        PdfFont fontTitle = PdfStandardFont(
          PdfFontFamily.timesRoman,
          12,
          style: PdfFontStyle.bold,
        );

        PdfFont fontGridTitle = PdfStandardFont(
          PdfFontFamily.timesRoman,
          10,
          style: PdfFontStyle.bold,
        );

        PdfFont fontGrid = PdfStandardFont(
          PdfFontFamily.timesRoman,
          10,
        );

        String text =
            'This is a computer-generated document. No signature is required.\nContact Us: info@comdelta.com.my | www.comdelta.com.my | +603-83228898';
        Size size = font.measureString(text);
        Size size1 = font.measureString(
            'Contact Us: info@comdelta.com.my | www.comdelta.com.my | +603-83228898');
        Size size2 = font.measureString('Contact Us: ');
        Size size3 = font.measureString('Contact Us: info@comdelta.com.my |');
        Size size4 =
            fontTitle.measureString('DEVICE DETAILS – For company purpose');
        Size size5 = fontGridTitle.measureString('No.');

        PdfPage page = document.pages.add();
        PdfGraphics graphics = page.graphics;
        double width = graphics.clientSize.width,
            height = graphics.clientSize.height;

        PdfGrid grid = PdfGrid();
        grid.style = PdfGridStyle(
            font: fontGrid,
            cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

        grid.columns.add(count: 9);
        grid.headers.add(1);

        PdfGridRow header = grid.headers[0];
        header.cells[0].value = 'No.';
        header.cells[1].value = 'Device Name';
        header.cells[2].value = 'Site Details';
        header.cells[3].value = 'Location';
        header.cells[4].value = 'Height';
        header.cells[5].value = 'Sim serial no';
        header.cells[6].value = 'Sim provider';
        header.cells[7].value = 'Batch no.';
        header.cells[8].value = 'Activation date';

        for (int i = 0; i < 9; i++) {
          header.cells[i].style = PdfGridCellStyle(
              font: fontGridTitle,
              cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));
          header.cells[i].style.backgroundBrush =
              PdfSolidBrush(PdfColor(0, 101, 163));
          header.cells[i].style.textBrush =
              PdfSolidBrush(PdfColor(255, 255, 255));
          header.cells[i].style.textBrush =
              PdfSolidBrush(PdfColor(255, 255, 255));
        }

        PdfGridRow row;

        for (int i = 0; i < devices.length; i++) {
          row = grid.rows.add();
          row.cells[0].value = devices[i].id;
          row.cells[1].value = devices[i].deviceName;
          row.cells[2].value = devices[i].deviceDetails;
          row.cells[3].value = devices[i].deviceLocation;
          row.cells[4].value = devices[i].deviceHeight;
          row.cells[5].value = devices[i].serialNum;
          row.cells[6].value = devices[i].simProvider;
          row.cells[7].value = devices[i].batchNum;
          row.cells[8].value = devices[i].activationDate;

          for (int l = 0; l < 9; l++) {
            if (i % 2 != 0) {
              row.cells[l].style = PdfGridCellStyle(
                  font: fontGrid,
                  cellPadding:
                      PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));
              row.cells[l].style.backgroundBrush = PdfBrushes.lightGray;
            }
          }
        }

        grid.columns[0].width = size5.width + 10;
        grid.repeatHeader = true;

        grid.draw(
            page: page,
            format: PdfLayoutFormat(
                paginateBounds: Rect.fromLTWH(
                    40, 40, width - 40, height - (size.height + 30))),
            bounds: Rect.fromLTWH(40, 40 + width / 7 + 10 + size4.height + 10,
                width - 40, height - (size.height + 30)));

        for (int num = 0; num < document.pages.count; num++) {
          page = document.pages[num];
          graphics = document.pages[num].graphics;
          Rect rect =
              Rect.fromLTWH((width) / 2, height - size.height - 20, 0, 0);
          PdfGraphicsState state = graphics.save();
          graphics.setTransparency(0.20);
          graphics.drawImage(PdfBitmap(await _readImageData('water.png')),
              Rect.fromLTWH(0, 0, width, height));
          graphics.restore(state);
          graphics.drawString(text, font,
              brush: PdfBrushes.black,
              bounds: rect,
              format: PdfStringFormat(
                alignment: PdfTextAlignment.center,
              ));
          PdfTextWebLink(
                  url: 'mailto:info@comdelta.com.my',
                  text: ' info@comdelta.com.my',
                  font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
                      style: PdfFontStyle.underline),
                  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                  pen: PdfPens.cornflowerBlue,
                  format: PdfStringFormat(
                      alignment: PdfTextAlignment.left,
                      lineAlignment: PdfVerticalAlignment.middle))
              .draw(
                  page,
                  Offset((width - size1.width) / 2 + size2.width,
                      height - size1.height - 20));
          PdfTextWebLink(
                  url: 'www.comdelta.com.my',
                  text: ' www.comdelta.com.my',
                  font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
                      style: PdfFontStyle.underline),
                  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                  pen: PdfPens.cornflowerBlue,
                  format: PdfStringFormat(
                      alignment: PdfTextAlignment.left,
                      lineAlignment: PdfVerticalAlignment.middle))
              .draw(
                  page,
                  Offset((width - size1.width) / 2 + size3.width,
                      height - size1.height - 20));
        }

        page = document.pages[0];
        graphics = document.pages[0].graphics;

        graphics.drawImage(
            PdfBitmap(await _readImageData('logonew.png')),
            Rect.fromLTWH(
                40, 40, (width / 7) * 2.181818181818181818182, width / 7));

        graphics.drawString('DEVICE DETAILS – For company purpose', fontTitle,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH(40, 40 + width / 7 + 10, 0, 0),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
            ));

        graphics.drawString(
            'Date of generated: ' +
                DateFormat('dd MMM yyyy').format(DateTime.now()),
            font,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH(width - 40, 40 + width / 7 + 10, 0, 0),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.right,
            ));

        List<int> bytes = document.save();
        document.dispose();

        saveAndLaunchFile(bytes, 'Device List.pdf');
      } else if (value.isPermanentlyDenied) {
        toast("Accept permission to proceed!");
        await openAppSettings();
      } else if (value.isDenied) {
        toast("Permission is denied");
      } else if (value.isRestricted) {
        toast("Permission is restricted");
      } else if (value.isLimited) {
        toast("Permission is limited");
      }
      return true;
    });
  }

  Future<void> downloadLogs(String id) async{
    await Permission.storage.request().then((value) async {
      if (value.isGranted) {
        toast('Downloading');
        progressBar(true);
        http.post(
            Uri.parse('http://103.18.247.174:8080/AmitProject/admin/getLogs.php'),
            body: {
              'device_id': id,
            }).then((value) {
          if (value.statusCode == 200) {
            List<LogJason> logs = [];
            List<dynamic> values = [];
            values = json.decode(value.body);

            if (values.length > 0) {
              for (int i = 0; i < values.length; i++) {
                if (values[i] != null) {
                  Map<String, dynamic> map = values[i];
                  logs.add(LogJason.fromJson(map));
                }
              }
            }
            ExportExcel(id,logs,progressBar);
          } else {
            progressBar(false);
            throw Exception("Unable to get Log list");
          }
        }).onError((error, stackTrace) {
          progressBar(false);
          toast('Error: ' + error.message);
        });
      } else if (value.isPermanentlyDenied) {
        toast("Accept permission to proceed!");
        await openAppSettings();
      } else if (value.isDenied) {
        toast("Permission is denied");
      } else if (value.isRestricted) {
        toast("Permission is restricted");
      } else if (value.isLimited) {
        toast("Permission is limited");
      }
      return true;
    });
  }

  Future<void> exportExcel() async {
    await Permission.storage.request().then((value) async {
      if (value.isGranted) {
        ExportExcel("Device List",devices, progressBar);
      } else if (value.isPermanentlyDenied) {
        toast("Accept permission to proceed!");
        await openAppSettings();
      } else if (value.isDenied) {
        toast("Permission is denied");
      } else if (value.isRestricted) {
        toast("Permission is restricted");
      } else if (value.isLimited) {
        toast("Permission is limited");
      }
      return true;
    });
  }

  void progressBar(bool loading) {
    setState(() {
      this.loading = loading;
    });
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/image/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory()).path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }

  // Future<String> getDirectoryPath() async {
  //   Directory appDocDirectory = await getApplicationDocumentsDirectory();
  //
  //   Directory directory =
  //       await new Directory(appDocDirectory.path + '/' + 'dir')
  //           .create(recursive: true);
  //
  //   return directory.path;
  // }

  // void advancedSearch() {
  //   Navigator.of(context).push(
  //     new MaterialPageRoute<String>(
  //         builder: (BuildContext context) {
  //           return new Scaffold(
  //             backgroundColor: Color(0xfafafafa),
  //             appBar: new AppBar(
  //               centerTitle: true,
  //               backgroundColor: Color(0xff0065a3),
  //               title: const Text('Advanced Search'),
  //               actions: [
  //                 IconButton(
  //                   icon: Icon(
  //                     Icons.restart_alt,
  //                     color: Colors.white,
  //                   ),
  //                   onPressed: () {
  //                     clientAd = "";
  //                     simProviderAd = "";
  //                     batchNumAd.text = "";
  //                     activationFromAd.text = "";
  //                     activationToAd.text = "";
  //                     lastSignalAd.text = "";
  //                     Navigator.pop(this.context);
  //                     getLocations();
  //                   },
  //                 )
  //               ],
  //             ),
  //             body: GestureDetector(
  //               onTap: () {
  //                 FocusScopeNode currentFocus = FocusScope.of(context);
  //                 if (!currentFocus.hasPrimaryFocus &&
  //                     currentFocus.focusedChild != null) {
  //                   FocusManager.instance.primaryFocus.unfocus();
  //                 }
  //               },
  //               child: SingleChildScrollView(
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: MediaQuery.of(context).size.height,
  //                   padding: EdgeInsets.all(15),
  //                   color: Color(0xfafafafa),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Client',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       ModalFilter(clientAd, "Client", client,
  //                           (val) => clientAd = val, "", false),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Client Batch Number',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       SmartField(
  //                         controller: batchNumAd,
  //                         hintText: "Client Batch Number",
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Activation Date From',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       SmartDate(
  //                         controller: activationFromAd,
  //                         hintText: "Activation Date From",
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Activation Date To',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       SmartDate(
  //                         controller: activationToAd,
  //                         hintText: "Activation Date To",
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Sim Provider',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       ModalFilter(
  //                           simProviderAd,
  //                           "Sim Provider",
  //                           simCardProvider,
  //                           (val) => simProviderAd = val,
  //                           "",
  //                           false),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Last Signal From',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       SmartDate(
  //                         controller: lastSignalAd,
  //                         hintText: "Last Signal From",
  //                       ),
  //                       SizedBox(
  //                         height: 70,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             floatingActionButton: FloatingActionButton(
  //               onPressed: () {
  //                 if (clientAd == "" &&
  //                     simProviderAd == "" &&
  //                     batchNumAd.text == "" &&
  //                     activationFromAd.text == "" &&
  //                     activationToAd.text == "" &&
  //                     lastSignalAd.text == "") {
  //                   toast("Please fill in any field to search");
  //                   return;
  //                 }
  //                 advancedSearchBool = true;
  //                 Navigator.pop(this.context);
  //                 getLocations();
  //               },
  //               child: const Icon(Icons.search),
  //               backgroundColor: Color(0xff0065a3),
  //             ),
  //           );
  //         },
  //         fullscreenDialog: true),
  //   );
  // }

  void sendDeleteReq(String deviceId) {
    http.post(
        Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/deleteDevice.php'),
        body: {
          'device_id': deviceId,
        }).then((response) {
      if (response.statusCode == 200) {
        String body = json.decode(response.body);
        if (body == '0') {
          toast("Device has been deleted successfully");
          getLocations();
        } else {
          toast("Something wrong with the server");
          print(body);
        }
      } else {
        toast("Something wrong with the server");
        print(response.body);
      }
      deleteSnack.hide();
      getLocations();
    }).onError((error, stackTrace) {
      deleteSnack.hide();
      getLocations();
      toast('Error: ' + error.message);
    });
  }

  void getLocations() {
    setState(() {
      loading = true;
      validate = false;
    });
    http
        .get(Uri.parse(
            'http://103.18.247.174:8080/AmitProject/getLocations.php'))
        .then((value) {
      List<String> id = [];
      List<String> locationName = [];
      if (value.statusCode == 200) {
        List<dynamic> values = [];
        values = json.decode(value.body);
        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              id.add(map['location_id'].toString());
              locationName.add(map['location_name'].toString());
            }
          }
        }
        getDevices(id, locationName);
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get locations");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void getDevices(List<String> id, List<String> locationName) {
    http
        .get(Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/getDevices.php'))
        .then((value) {
      if (value.statusCode == 200) {
        List<DeviceJason> devices = [];
        this.duplicateDevices.clear();

        List<dynamic> values = [];
        values = json.decode(value.body);

        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              String query = searchController.text;
              DeviceJason device = DeviceJason.fromJson(
                  map,
                  locationName
                      .elementAt(id.indexOf(map['location_id'].toString())));

              if (advancedSearch.filterDevice(device)) {
                if (query.isNotEmpty) {
                  if (device.id.toLowerCase().contains(query.toLowerCase()) ||
                      device.deviceName
                          .toLowerCase()
                          .contains(query.toLowerCase()) ||
                      device.deviceLocation
                          .toLowerCase()
                          .contains(query.toLowerCase())) {
                    device.setHighLight(query);
                    devices.add(device);
                  }

                  this.duplicateDevices.add(device);
                } else {
                  devices.add(device);
                  this.duplicateDevices.add(device);
                }
              }
            }
          }
        }
        showDevices(devices);
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get device list");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void showDevices(List<DeviceJason> devices) {
    setState(() {
      this.devices.clear();
      this.devices.addAll(devices);
      if (sortState == 0) {
        this.devices.sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
        this
            .duplicateDevices
            .sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
      } else if (sortState == 1) {
        this.devices.sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
        this
            .duplicateDevices
            .sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
      } else if (sortState == 2) {
        this.devices.sort((a, b) => a.deviceName.compareTo(b.deviceName));
        this
            .duplicateDevices
            .sort((a, b) => a.deviceName.compareTo(b.deviceName));
      } else if (sortState == 3) {
        this.devices.sort((a, b) => b.deviceName.compareTo(a.deviceName));
        this
            .duplicateDevices
            .sort((a, b) => b.deviceName.compareTo(a.deviceName));
      } else if (sortState == 4) {
        this
            .devices
            .sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
        this
            .duplicateDevices
            .sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
      } else if (sortState == 5) {
        this
            .devices
            .sort((a, b) => b.deviceLocation.compareTo(a.deviceLocation));
        this
            .duplicateDevices
            .sort((a, b) => b.deviceLocation.compareTo(a.deviceLocation));
      }
      loading = false;
    });
  }

  // bool filterDevice(DeviceJason device) {
  //   bool clientBool = (clientAd.isEmpty ||
  //       client[getInt(device.client) - 1].contains(clientAd));
  //   bool batchBool = (batchNumAd.text.isEmpty ||
  //       device.batchNum.toLowerCase().contains(batchNumAd.text.toString()));
  //   bool activationFromBool;
  //   try {
  //     activationFromBool = (activationFromAd.text.isEmpty ||
  //         DateFormat('dd-MM-yyyy')
  //             .parse(device.activationDate)
  //             .isAfter(DateFormat('dd-MM-yyyy').parse(activationFromAd.text)) ||
  //         DateFormat('dd-MM-yyyy')
  //             .parse(device.activationDate)
  //             .isAtSameMomentAs(
  //                 DateFormat('dd-MM-yyyy').parse(activationFromAd.text)));
  //   } catch (Exception) {
  //     activationFromBool = false;
  //   }
  //   bool activationToBool;
  //   try {
  //     activationToBool = (activationToAd.text.isEmpty ||
  //         DateFormat('dd-MM-yyyy')
  //             .parse(device.activationDate)
  //             .isBefore(DateFormat('dd-MM-yyyy').parse(activationToAd.text)) ||
  //         DateFormat('dd-MM-yyyy')
  //             .parse(device.activationDate)
  //             .isAtSameMomentAs(
  //                 DateFormat('dd-MM-yyyy').parse(activationToAd.text)));
  //   } catch (Exception) {
  //     activationToBool = false;
  //   }
  //   bool simBool =
  //       (simProviderAd.isEmpty || device.simProvider.contains(simProviderAd));
  //
  //   bool lastSignalBool;
  //   try {
  //     lastSignalBool = (lastSignalAd.text.isEmpty ||
  //         DateFormat('yyyy-MM-dd HH:mm:ss')
  //             .parse(device.lastSignal)
  //             .isAfter(DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)) ||
  //         DateFormat('yyyy-MM-dd HH:mm:ss')
  //             .parse(device.lastSignal)
  //             .isAtSameMomentAs(
  //                 DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)));
  //   } catch (Exception) {
  //     lastSignalBool = false;
  //   }
  //
  //   if (clientBool &&
  //       batchBool &&
  //       activationFromBool &&
  //       activationToBool &&
  //       simBool &&
  //       lastSignalBool) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  //
  // void reset() {
  //   clientAd = "";
  //   simProviderAd = "";
  //   batchNumAd.text = "";
  //   activationFromAd.text = "";
  //   activationToAd.text = "";
  //   lastSignalAd.text = "";
  //   searchController.text = "";
  //   getLocations();
  // }

  int getInt(String s) {
    try {
      if (s == null || int.parse(s) == null) {
        return 0;
      }
      return int.parse(s);
    } catch (Exception) {
      return 0;
    }
  }
}
