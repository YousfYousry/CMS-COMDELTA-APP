import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Icons/pdf_icons.dart';

class ManageDevicesAppBar extends StatelessWidget {
  final title;
  final context;
  final func1, func2, func3, func4, func5, func6;

  ManageDevicesAppBar(this.context, this.title, this.func1,
      this.func2, this.func3, this.func4, this.func5, this.func6);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff0065a3),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(this.context),
      ),
      title:
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // Text(
          //   subTitle,
          //   style: TextStyle(fontSize: 14, color: Color(0xF4FFFFFF)),
          // ),
      //   ],
      // ),
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
                    Icon(Icons.add),
                    const SizedBox(width: 8),
                    Text('Add Device'),
                  ],
                ),
              ),
              // PopupMenuItem<int>(
              //   value: 1,
              //   child: Row(
              //     children: [
              //       Icon(Icons.add_to_photos),
              //       const SizedBox(width: 8),
              //       Text('Add Multiple Device'),
              //     ],
              //   ),
              // ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Pdf.file_pdf,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('Export PDF'),
                  ],
                ),
              ),
              // PopupMenuDivider(),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(
                      Pdf.file_excel,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('Export Excel'),
                  ],
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.library_add_check_outlined),
                    const SizedBox(width: 8),
                    Text('All Devices'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Row(
                  children: [
                    Icon(Icons.dnd_forwardslash),
                    const SizedBox(width: 8),
                    Text('Failed Devices'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 5,
                child: Row(
                  children: [
                    Icon(Icons.search),
                    const SizedBox(width: 8),
                    Text('Advanced Search'),
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
      case 4:
        func5();
        break;
      case 5:
        func6();
        break;
    }
  }
}
