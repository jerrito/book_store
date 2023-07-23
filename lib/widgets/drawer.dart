import 'package:flutter/material.dart';
import 'package:book_store/login_signup/login.dart';
import 'package:book_store/pages/profile.dart';
import 'package:book_store/widgets/drawer_list_tile.dart';
import 'package:book_store/main.dart';
import "package:book_store/userProvider.dart";
import 'package:provider/provider.dart';
class Drawers extends StatefulWidget {
  const Drawers({Key? key}) : super(key: key);

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  CustomerProvider? customerProvider;

  @override
  void initState() {
    super.initState();

    customerProvider = context.read<CustomerProvider>();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Container(
            width: double.infinity,
            height: 150,
            color: Colors.green,
            child: Column(
              children: [
                SizedBox(height: hS * 10),
                Text("Joined ",
                    style: TextStyle(
                        fontSize: 15, height: wS * 0.25,color:Colors.white)),
                const SizedBox(height: 10),
                Text("Jerry Boateng",
                    style: TextStyle(
                        fontSize: 15, height: wS * 0.25,color:Colors.white )),
              ],
            ),
          ),
          SizedBox(
            height: hS * 10,
            child: Stack(children: [
              Container(
                height: hS * 6.5,
                width: double.infinity,
                color: Colors.green,
              ),
              const Positioned(
                bottom: 0,
                left: 110,
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 30,
                  child:
                      Icon(Icons.person_rounded, size: 30,
                          color: Colors.white),
                ),
              )
            ]),
          ),
          Flexible(
            child: ListView(children: [

              DrawerListTile(svg: "users", title: "Profile", page:
              Profile(profileUpdate:ProfileUpdate(
                  imagePath: '${customerProvider?.appUser?.image}',
                  check: "see"),)),

              const DrawerListTile(
                  svg: "log-out", title: "Log out", page: LoginSignUp())
            ]),
          ),
        ]));
  }
}
