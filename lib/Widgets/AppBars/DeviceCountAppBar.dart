import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Icons/pdf_icons.dart';

class DeviceCountAppBar extends StatelessWidget {
  final title;
  final context;
  final func1;
  final func2;
  final func3;
  final func4;

  DeviceCountAppBar(
      this.context, this.title, this.func1, this.func2, this.func3, this.func4);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff0065a3),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(this.context),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white),
            textTheme: TextTheme().apply(bodyColor: Colors.white),
          ),
          child: PopupMenuButton<int>(
            color: Color(0xff0065a3),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.library_add_check),
                    const SizedBox(width: 8),
                    Text('Display All'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.calendar_view_day),
                    const SizedBox(width: 8),
                    Text('Select Day'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text('Select Month'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Icon(
                      Pdf.file_pdf,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('Export Pdf'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        func1();
        break;
      case 1:
        func2();
        break;
      case 2:
        func3();
        break;
      case 3:
        func4();
        break;
    }
  }
}
