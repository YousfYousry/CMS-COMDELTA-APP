import 'dart:io';

import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ExportExcel {
  final devices;

  ExportExcel(this.devices) {
    create();
  }

  Future<void> create() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('Hello World!');
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    //
    // if (kIsWeb) {
    //   AnchorElement(
    //       href:
    //       'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
    //     ..setAttribute('download', 'Output.xlsx')
    //     ..click();
    // } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
      Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    // }
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory()).path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }
}
