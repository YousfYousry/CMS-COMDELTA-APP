import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Pages/Admin/AddEditDevice.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';

class FailedDevicesAppBar extends StatelessWidget {
  final title;
  final context;
  final func1;

  FailedDevicesAppBar(this.context,this.title,this.func1);

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
    }
  }
}
