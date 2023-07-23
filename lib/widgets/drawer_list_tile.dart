import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerListTile extends StatelessWidget {
  final String svg;
  final String title;
  final Widget page;
  const DrawerListTile(
      {Key? key, required this.svg, required this.title, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        "./assets/svgs/$svg.svg",
        color: Colors.green,
      ),
      horizontalTitleGap: 30,
      title: Text(title,
          style: const TextStyle(
            fontSize: 15,
          )),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return page;
        }));
      },
    );
  }
}
