import 'dart:io';
import 'dart:ui';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/JasonHolders/LogJason.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../Choices.dart';

class ExportExcel {
  final name;
  final items;
  final progressBar;
  final workbook = Workbook();
  Style styleHeader, styleCellWhite, styleCellGrey;

  ExportExcel(this.name, this.items, this.progressBar) {
    progressBar(true);
    //Header Style
    styleHeader = workbook.styles.add('Style1');
    styleHeader.backColorRgb = Color.fromARGB(255, 0, 101, 163);
    styleHeader.fontName = 'Times New Roman';
    styleHeader.fontColorRgb = Color.fromARGB(255, 255, 255, 255);
    styleHeader.fontSize = 14;
    styleHeader.bold = true;
    styleHeader.hAlign = HAlignType.left;
    styleHeader.vAlign = VAlignType.top;
    styleHeader.borders.all.lineStyle = LineStyle.thin;
    styleHeader.borders.all.colorRgb = Color.fromARGB(255, 0, 0, 0);
    styleHeader.wrapText = true;
    styleHeader.numberFormat = '_(\$* #,##0_)';
    workbook.styles.addStyle(styleHeader);

    //Cell Style White
    styleCellWhite = workbook.styles.add('Style2');
    styleCellWhite.backColorRgb = Color.fromARGB(255, 255, 255, 255);
    styleCellWhite.fontName = 'Times New Roman';
    styleCellWhite.fontColorRgb = Color.fromARGB(255, 0, 0, 0);
    styleCellWhite.fontSize = 12;
    styleCellWhite.bold = false;
    styleCellWhite.hAlign = HAlignType.left;
    styleCellWhite.vAlign = VAlignType.top;
    styleCellWhite.borders.all.lineStyle = LineStyle.thin;
    styleCellWhite.borders.all.colorRgb = Color.fromARGB(255, 0, 0, 0);
    styleCellWhite.wrapText = true;
    styleCellWhite.numberFormat = '_(\$* #,##0_)';
    workbook.styles.addStyle(styleCellWhite);

    //Cell Style Grey
    styleCellGrey = workbook.styles.add('Style3');
    styleCellGrey.backColorRgb = Color.fromARGB(255, 170, 170, 170);
    styleCellGrey.fontName = 'Times New Roman';
    styleCellGrey.fontColorRgb = Color.fromARGB(255, 0, 0, 0);
    styleCellGrey.fontSize = 12;
    styleCellGrey.bold = false;
    styleCellGrey.hAlign = HAlignType.left;
    styleCellGrey.vAlign = VAlignType.top;
    styleCellGrey.borders.all.lineStyle = LineStyle.thin;
    styleCellGrey.borders.all.colorRgb = Color.fromARGB(255, 0, 0, 0);
    styleCellGrey.wrapText = true;
    styleCellGrey.numberFormat = '_(\$* #,##0_)';
    workbook.styles.addStyle(styleCellGrey);

    if (items is List<DeviceJason>) {
      exportDevices();
    } else if (items is List<LogJason>) {
      exportLogs();
    } else {
      progressBar(false);
      toast("Failed");
    }
  }

  Future<void> exportDevices() async {
    final Worksheet sheet = workbook.worksheets[0];

    //Header
    sheet.getRangeByName('A1').setText('No.');
    sheet.getRangeByName('B1').setText('Device Name');
    sheet.getRangeByName('C1').setText('Client name');
    sheet.getRangeByName('D1').setText('Site Details');
    sheet.getRangeByName('E1').setText('Location');
    sheet.getRangeByName('F1').setText('Latitude');
    sheet.getRangeByName('G1').setText('longitude');
    sheet.getRangeByName('H1').setText('Height');
    sheet.getRangeByName('I1').setText('Sim serial no.');
    sheet.getRangeByName('J1').setText('Sim provider');
    sheet.getRangeByName('K1').setText('Batch no.');
    sheet.getRangeByName('L1').setText('Activation date');
    sheet.getRangeByName('M1').setText('Last update');
    sheet.getRangeByName('A1:M1').cellStyle = styleHeader;

    //Cells
    for (int i = 0; i < items.length; i++) {
      String num = (i + 2).toString();
      sheet.getRangeByName('A' + num).setText(items[i].id.toString());
      sheet.getRangeByName('B' + num).setText(items[i].deviceName.toString());
      sheet
          .getRangeByName('C' + num)
          .setText(client[getInt(items[i].client) - 1].value.toString());
      sheet
          .getRangeByName('D' + num)
          .setText(items[i].deviceDetails.toString());
      sheet
          .getRangeByName('E' + num)
          .setText(items[i].deviceLocation.toString());
      sheet
          .getRangeByName('F' + num)
          .setText((items[i].lat == 500 ? "" : items[i].lat).toString());
      sheet
          .getRangeByName('G' + num)
          .setText((items[i].lon == 500 ? "" : items[i].lon).toString());
      sheet.getRangeByName('H' + num).setText(items[i].deviceHeight.toString());
      sheet.getRangeByName('I' + num).setText(items[i].serialNum.toString());
      sheet.getRangeByName('J' + num).setText(items[i].simProvider.toString());
      sheet.getRangeByName('K' + num).setText(items[i].batchNum.toString());
      sheet
          .getRangeByName('L' + num)
          .setText(items[i].activationDate.toString());
      sheet.getRangeByName('M' + num).setText(items[i].lastSignal.toString());
      sheet.getRangeByName('A' + num + ':M' + num).cellStyle =
          (i % 2 == 0) ? styleCellWhite : styleCellGrey;
    }

    //saving file
    saveFile(workbook);
  }

  Future<void> exportLogs() async {
    final Worksheet sheet = workbook.worksheets[0];

    //Header
    sheet.getRangeByName('A1').setText('Detail');
    sheet.getRangeByName('B1').setText('L1#');
    sheet.getRangeByName('C1').setText('L1@');
    sheet.getRangeByName('D1').setText('L2#');
    sheet.getRangeByName('E1').setText('L2@');
    sheet.getRangeByName('F1').setText('L3#');
    sheet.getRangeByName('G1').setText('L3@');
    sheet.getRangeByName('H1').setText('Battery');
    sheet.getRangeByName('I1').setText('Rssi');
    sheet.getRangeByName('A1:I1').cellStyle = styleHeader;

    //Cells
    for (int i = 0; i < items.length; i++) {
      String num = (i + 2).toString();
      sheet.getRangeByName('A' + num).setText(items[i].createDate.toString());
      sheet.getRangeByName('B' + num).setText(items[i].lid1.toString());
      sheet.getRangeByName('C' + num).setText(items[i].ls1.toString());
      sheet.getRangeByName('D' + num).setText(items[i].lid2.toString());
      sheet.getRangeByName('E' + num).setText(items[i].ls2.toString());
      sheet.getRangeByName('F' + num).setText(items[i].lid3.toString());
      sheet.getRangeByName('G' + num).setText(items[i].ls3.toString());
      sheet.getRangeByName('H' + num).setText(items[i].batteryValue.toString());
      sheet.getRangeByName('I' + num).setText(items[i].rssiValue.toString());
      sheet.getRangeByName('A' + num + ':I' + num).cellStyle =
          (i % 2 == 0) ? styleCellWhite : styleCellGrey;
    }

    //saving file
    saveFile(workbook);
  }

  Future<void> saveFile(Workbook workbook) async {
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        Platform.isWindows ? '$path\\'+name.toString()+'.xlsx' : '$path/'+name.toString()+'.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
    progressBar(false);
  }

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
