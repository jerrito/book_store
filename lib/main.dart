import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:book_store/constants/Size_of_screen.dart';
import 'package:book_store/pages/home.dart';
import 'package:book_store/login_signup/login.dart';
import 'package:book_store/login_signup/signUp.dart';
import 'package:book_store/pages/profile.dart';
import 'package:book_store/firebase_options.dart';
import 'package:book_store/login_signup/splash.dart';
import 'package:book_store/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/addProduct.dart';
import 'package:theme_manager/theme_manager.dart';

int indexed = 0;
double w = SizeConfig.W;
double wS = SizeConfig.SW;
double h = SizeConfig.H;
double hS = SizeConfig.SV;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options:
  DefaultFirebaseOptions.currentPlatform);

  runApp(const AppPage());
}

class AppPage extends StatelessWidget {
  final Widget? child;
  const AppPage({Key? key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Colors.white,
          );
        }
        return ThemeManager(
            defaultBrightnessPreference: BrightnessPreference.system,
            data: (Brightness brightness) => ThemeData(
              // colorScheme: ColorScheme.fromSeed(
              //   primary: Color.fromRGBO(50, 250,40, 1),
              //     seedColor: Color.fromRGBO(50, 250,40, 1)),
              useMaterial3: true,
              // primarySwatch: brightness == Brightness.dark
              //     ? Colors.amber
              //     : Colors.green,
              primaryIconTheme: IconThemeData(
                  color: brightness == Brightness.dark
                      ? Colors.amber
                      : Colors.green),
              textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: "PlayfairDisplay-VariableFont_wght",
                  decorationColor: brightness == Brightness.dark
                      ? Colors.amberAccent
                      : Colors.black,
                  bodyColor: brightness == Brightness.dark
                      ? Colors.amberAccent
                      : Colors.black,
                  displayColor: brightness == Brightness.dark
                      ? Colors.amberAccent
                      : Colors.black),
              // GoogleFonts.montserratTextTheme(ThemeData().textTheme),
              //accentColor: Colors.lightBlue,
              fontFamily: "Montserrat",
              brightness: brightness,
            ),
            // loadBrightnessOnStart: true,
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return MultiProvider(
                  providers: [
                    ListenableProvider(
                      create: (_) => CustomerProvider(preferences: snapshot.data),
                    ),


                    ListenableProvider(
                        create: (_) =>
                            BookProvider(preference: snapshot.data)),
                  ],
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: theme,
                    initialRoute: "splash",
                    routes: {
                      "login": (context) => const LoginSignUp(),
                      "splash": (context) => const Splashscreen(),
                      "signup": (context) => const SignUpPage(),
                      "home": (context) => const HomePage(),
                      "profile": (context) =>  Profile(profileUpdate:ProfileUpdate(
                          imagePath: '',
                          check: "see"),),
                      //"editProducts": (context) => const EditProduct(productName: '',),
                      "addProduct": (context) => const AddBook(),
                      // "specificBuyItem": (context) => const SpecificBuyItem(),
                      // "cart": (context) => const Cart(),
                      // // "delivery": (context) => const DeliveryLocation(),
                      // "your_order": (context) => const YourOrder(),
                      // "orderMap": (context) => const OrderMap(),

                    },
                  ));
            });
      },
    );
  }
}