//import 'package:mobile_money_project/Size_of_screen.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:book_store/pages/home.dart';
import 'package:book_store/login_signup/login.dart';
import 'package:book_store/login_signup/signUp.dart';
import 'package:book_store/userProvider.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, userProvider, widget) {
        if (userProvider.appUser != null) {
          return const HomePage();
        }

        return const SignUpPage();
      },
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      //FlutterNativeSplash.remove();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const IndexPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
