import 'package:book_store/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:glorycity/wdgets/MainButton.dart';

class BottomNavBar extends StatefulWidget {
  int idx;
  BottomNavBar({Key? key, required this.idx}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      // selectedItemColor: Colors.pink,
      //unselectedItemColor: Colors.black,
      //showSelectedLabels: false,
      //showUnselectedLabels: false,
      // color: Color.fromRGBO(0, 110, 255, 1),
      onTap: (index) {
        if (index == 0) {
          setState(() {
            Navigator.pushReplacementNamed(context, "home");
            widget.idx = index;
          });
        } else if (index == 1) {
          setState(() {
            Navigator.pushReplacementNamed(context, "addProduct");
            widget.idx = index;
          });
        } else if (index == 2) {
          setState(() {
            showSearch(context: context,
                delegate:
                BookSearching());
            widget.idx = index;
          });
        } else if (index == 3) {
          setState(() {
            Navigator.pushReplacementNamed(context, "profile");
            widget.idx = index;
          });
        }
      },
      currentIndex: widget.idx,
      items: [
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset('./assets/svgs/home.svg',
              color: Colors.blue),
          label: "Home",
          tooltip: "Home",
          icon: SvgPicture.asset('./assets/svgs/home.svg',
              color: Colors.black, width: 18, height: 18),
        ),
        BottomNavigationBarItem(
          label: "Add Book",
          tooltip: "Add Book",
          icon: SvgPicture.asset('./assets/svgs/plus-square.svg',
              color: Colors.black, width: 18, height: 18),
          activeIcon: SvgPicture.asset('./assets/svgs/plus-square.svg',
              color: Colors.blue),
        ),
        BottomNavigationBarItem(
          label: "Search",
          tooltip: "Search for book",
          //backgroundColor: Color.fromRGBO(0, 110, 255, 1),
          icon: SvgPicture.asset('./assets/svgs/search.svg',
              color: Colors.black, width: 18, height: 18),
          activeIcon:
          SvgPicture.asset('./assets/svgs/search.svg', color: Colors.blue),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          tooltip: "Profile management",
          icon: SvgPicture.asset('./assets/svgs/users.svg',
              color: Colors.black, width: 18, height: 18),
          activeIcon:
          SvgPicture.asset('./assets/svgs/users.svg', color: Colors.blue),
        ),

      ],
    );
  }
}