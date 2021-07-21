import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Pages/Admin/AddEditDevice.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';

// ignore: must_be_immutable
class ManageDevicesAppBar extends StatelessWidget {
  String title = '';
  BuildContext context;
  ManageDevicesAppBar(this.context,this.title);

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
                child:Row(
                  children: [
                    Icon(Icons.add),
                    const SizedBox(width: 8),
                    Text('Add Device'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.add_to_photos),
                    const SizedBox(width: 8),
                    Text('Add Multiple Device'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.download),
                    const SizedBox(width: 8),
                    Text('Export PDF'),
                  ],
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem<int>(
                value: 3,
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
        Navigator.push(
          context,
          SizeRoute(
            page: AddDevice(),
          ),
        );
        break;
      case 1:
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => SharePage()),
        // );
        break;
      case 2:
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        //       (route) => false,
        // );
    }
  }
}
