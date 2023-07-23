import 'dart:math';
import 'dart:convert';


import 'package:crypto/crypto.dart';
import 'package:book_store/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:book_store/constants/Size_of_screen.dart';
import 'package:book_store/models/user.dart' as Users;
import 'package:book_store/constants/strings.dart';
import 'package:book_store/widgets/MainButton.dart';
import 'package:book_store/widgets/MainInput.dart';
import 'package:book_store/databases/firebase_services.dart';
import 'package:book_store/main.dart';
import 'package:book_store/models/user.dart' as User_main;
import 'package:book_store/userProvider.dart';
import 'package:provider/provider.dart';

// showExceptionAlertDialog(
// context,
// exception: e,
// title: 'Sign In Failed',
// );

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey();
  GlobalKey<FormState> form = GlobalKey();
  var firebaseService = FirebaseServices();
  CustomerProvider? userProvider;
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool checkLoading = true;
  bool isLoading = false;
  int index_2 = 0;
  bool obscure_2 = true;


  @override
  void initState() {
    userProvider = context.read<CustomerProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Color.fromRGBO(210, 230, 250, 0.2),
                //     Color.fromRGBO(210, 230, 250, 0.2)
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                color: Color.fromRGBO(210, 230, 250, 0.2)),
            padding: const EdgeInsets.all(10),
            child: Visibility(
              visible: !isLoading,
              replacement: const Center(
                  child: SpinKitFadingCube(
                color: Colors.amber,
                size: 50.0,
              )),
              child: Form(
                key: form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(height: 30),
                          const Center(
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Center(
                            child: CircleAvatar(
                              //backgroundColor: Colors.grey,
                              radius: hS * 15,
                              backgroundImage: Image.asset(
                                "./assets/images/Dictionary-amico.png",
                                //height: h / 3,
                                //width: w,
                                fit:BoxFit.fitWidth
                              ).image,
                            ),
                          ),
                          //Center(child: Text("Let's get things going by signing up", style: TextStyle(fontSize: 17, color: Colors.black),)),
                          const SizedBox(height: 15),
                          MainInput(
                            validator: fullNameValidator,
                            controller: fullName,
                            label: const Text("Full Name"),
                            prefixIcon: const Icon(Icons.person),
                            obscureText: false,
                            // suffixIcon:Icon(Icons.person) ,
                          ),

                          const SizedBox(height: 15),
                          MainInput(
                            validator: emailValidator,
                            controller: email,
                            label: const Text("Email"),
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email),
                            obscureText: false,
                            // suffixIcon:Icon(Icons.person) ,
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          MainInput(
                            validator: pinValidator,
                            controller: password,
                            label: const Text("Password"),
                            prefixIcon: const Icon(Icons.password_outlined),
                            suffixIcon: IconButton(
                                icon: obscure_2 == true
                                    ? SvgPicture.asset("./assets/svgs/eye.svg",
                                        color: Colors.green)
                                    : SvgPicture.asset(
                                        "./assets/svgs/eye-off.svg",
                                        color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    obscure_2 = false;
                                    index_2++;
                                    if (index_2 % 2 == 0) {
                                      obscure_2 = true;
                                    }
                                  });
                                }),
                            obscureText: obscure_2,
                          ),
                        ],
                      ),
                    ),
                    SecondaryButton(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (form.currentState?.validate() == true) {
                                setState(() {
                                  isLoading = true;
                                });
                                await checkEmailBeforeRegister();

                                // Navigator.pushNamed(context,"homepage");
                              }
                            },
                      color: Colors.green,
                      text: 'Signup',
                    ),
                    Center(
                        child: Row(
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          child: const Text("Signin"),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "login");
                          },
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            )));
  }

  Future<bool> checkEmailBeforeRegister() async {
    try {
      // Fetch the sign-in methods for the email address
      final list = await auth.fetchSignInMethodsForEmail(email.text);

      // Confirm if there is already an account with the email
      if (list.isNotEmpty) {
        // Show a snackbar message indicating that the email is already in use
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.blue,
            content: Text("Email already in use")));
        setState((){isLoading=false;});

        // Return true to indicate that the email is already in use
        return true;
      } else {
        try {
          // Create a new user account with the provided email and password
          await auth
              .createUserWithEmailAndPassword(
              email: email.text,
              password: sha256.convert(utf8.encode(password.text)).toString())
              .whenComplete(() async {
            // Save the user data
            var user = Users.User(
              fullName:fullName.text,
                id:"",
                image:"",
                password: sha256.convert(utf8.encode(password.text)).toString(),
                email: auth.currentUser?.email,
                registrationDate: DateTime.now().toString());
            var result =   await FirebaseServices().saveUser(user: user);

            // Check if the context is still mounted
            if (!context.mounted) {
              return;
            }

            // Show a snackbar message indicating successful registration
            if (result?.status == QueryStatus.successful) {

                         print("ff");
              var result_2 = await userProvider?.getUser(
                  email:auth.currentUser!.email!);
              userProvider = context.read<CustomerProvider>();
              if (result_2?.status == QueryStatus.successful) {
                print("ffuu");
                setState((){isLoading=false;});
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.blue,
                    content: Text(
                        "Successful Registration ${auth.currentUser?.email}")));


                // Redirect the user to the home page
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const HomePage();
                    }));
              
              }
              return;
            }

            setState(() {
              isLoading = false;
            });

          });
          // Return false to indicate successful registration
          return false;
        } on FirebaseAuthException catch (error) {
          if (error.code == 'weak-password') {
            setState(() {
              isLoading = false;
            });
            // Show a snackbar message indicating weak password
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.blue,
                content: Text("Password is weak")));
          }

          // Return false to indicate unsuccessful registration due to an error
          return false;
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Show a snackbar message with the error
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.blue, content: Text("$error")));

      // Return true to indicate unsuccessful registration due to an error
      return true;
    }
  }

  String? pinValidator(String? value) {
    final pattern = RegExp("([A-Z][a-z]+)[/s/ ]+([A-Z][a-z]+)");

    if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    }


    return null;
  }

  String? fullNameValidator(String? value) {
    final pattern = RegExp("([A-Z][a-z]+)[/s/ ]+([A-Z][a-z]+)");

    if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    }

    return null;
  }

  String? nameValidator(String? value) {
    final pattern = RegExp("[A-Z]([a-z]+)");

    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidName;
    }

    return null;
  }

  String? emailValidator(String? value) {
    final pattern =
        RegExp("^([a-zA-Z0-9_/-/./]+)@([a-zA-Z0-9_/-/.]+)[.]([a-zA-Z]{2,5})");
    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidEmails;
    }
    return null;
  }








}
