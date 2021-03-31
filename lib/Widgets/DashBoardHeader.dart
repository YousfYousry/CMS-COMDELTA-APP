import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/DashBoard.dart';

class DashBoardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoard(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 100,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                color: Colors.white,
                height: 60,
                width: 60,
                child: Image.asset(
                    'assets/image/dashboard5.png')), //Container for Dashboard icon
            Container(
              color: Colors.white,
              height: 100,
              width: 240,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.home),
                        ),
                        TextSpan(
                          text: 'Home',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ), // Container for DashBoard Header and textspan
          ],
        ),
      ),
    );
  }
}
