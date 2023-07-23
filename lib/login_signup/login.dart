import 'dart:convert';
import 'dart:math';
import 'package:book_store/pages/home.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:book_store/constants/Size_of_screen.dart';
import 'package:book_store/constants/strings.dart';
import 'package:book_store/widgets/MainButton.dart';
import 'package:book_store/widgets/MainInput.dart';
import 'package:book_store/databases/firebase_services.dart';
import 'package:book_store/main.dart';
import 'package:book_store/userProvider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:book_store/userProvider.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {

  CustomerProvider? userProvider;

  int index_2 = 0;
  bool obscure_2 = true;
  var firebaseService = FirebaseServices();

  final FirebaseAuth auth = FirebaseAuth.instance;
  GlobalKey<FormState> formLogin = GlobalKey();
  bool isLoading = false;
  // final TextEditingController number=TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String? pic;
  int x=0;

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

              color: Color.fromRGBO(210, 230, 250, 0.2)),
          padding: const EdgeInsets.all(10),
          child: Visibility(
            visible: !isLoading,
            replacement: const Center(
              child: SpinKitChasingDots(
                color: Colors.pink,
                size: 50.0,
              ),
            ),
            child: Form(
              key: formLogin,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: hS * 15,
                            backgroundImage: Image.asset("./assets/images/Dictionary-amico.png",
                                    height: h / 3,
                                    width: w,
                                    fit: BoxFit.scaleDown)
                                .image,
                          ),
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
                        const SizedBox(height: 15),

                        MainInput(
                          validator: phoneNumberValidator,
                          controller: password,
                          label: const Text("Password"),
                          //hintText: "0244444444",
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(Icons.password),
                          suffixIcon:IconButton(
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
                            obscureText: obscure_2 ,
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
                            if (formLogin.currentState?.validate() == true) {
                              await loginEmail();
                            }
                          },
                    color: Colors.green,
                    text: "Login",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                        child: Row(
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          child: const Text("Signup"),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "signup");
                          },
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          )),
    );
  }



  String? emailValidator(String? value) {
    final pattern =
    RegExp("^([a-zA-Z0-9_/-/./]+)@([a-zA-Z0-9_/-/.]+)[.]([a-zA-Z]{2,5})");
    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidEmails;
    }
    return null;
  }
  String? phoneNumberValidator(String? value) {
    // final pattern = RegExp("([0][2358])[0-9]{8}");
    //
    // if (pattern.stringMatch(value ?? "") != value) {
    //   return AppStrings.invalidPhoneNumber;
    // }

    if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    }
    return null;
  }

  String? pinValidator(String? value) {
    final pattern = RegExp("[0-9]{4}");
    if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    } else if (pattern.stringMatch(value ?? "") != value) {
      return "";
    }
    return null;
  }


  Future<void> loginEmail() async {
    try {
      // Attempt to sign in with email and password
      final login = await auth.signInWithEmailAndPassword(
          email: email.text,
          password: sha256.convert(utf8.encode(password.text)).toString());

      if (true) {
        var result_2 = await userProvider?.getUser(
            email: auth.currentUser!.email!);
        userProvider=context.read<CustomerProvider>();

        if (result_2?.status == QueryStatus.successful) {
          // Check if the context is still mounted
          if (!context.mounted) {
            return;
          }

          // Show a success message with the logged-in user's email
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.blue,
              content: Text("Successful login ${auth.currentUser?.email}")));

          // Redirect the user to the home page
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return const HomePage();
              }));
        }
      }

      // Print a message indicating failed login
      return print("Failed");

      // TODO: Uncomment the following line to fetch user data
      // await userProvider?.getUser(email: auth.currentUser!.email!);
    } on FirebaseAuthException catch (error) {
      // Handle specific Firebase authentication exceptions

      if (error.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.blue, content: Text("Unknown user")));

        // Check if the context is still mounted
        if (!context.mounted) {
          return;
        }

        // Set the loading state to true
        setState(() {
          isLoading = false;
        });

        // Show a snackbar with a user not found message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.blue, content: Text("User not found")));
      } else if (error.code == 'wrong-password') {
        // Check if the context is still mounted
        if (!context.mounted) {
          return;
        }

        // Set the loading state to true
        setState(() {
          isLoading = false;
        });

        // Show a snackbar with a wrong password message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.blue, content: Text("Wrong password")));
      }
    }
  }


}

class Login{
  int x=0;
  void increment(){
    x++;
  }
}