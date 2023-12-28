// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_elux_app/Widgets/custom_button.dart';
import 'package:flutter_elux_app/Widgets/custom_loading_button.dart';
import 'package:flutter_elux_app/Widgets/custom_navbar.dart';
import 'package:flutter_elux_app/Widgets/leading_iconbutton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../Widgets/logo_container.dart';
import '../../Widgets/or_divider.dart';
import '../../config/constants.dart';
import '../../config/helper_functions.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../Register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const LoginScreen(),
    );
  }

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  String email = "";
  final formKey = GlobalKey<FormState>();
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: const LeadingIconButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LogoContainer(),
              Center(
                child: Text(
                  "LOGIN TO ELUX",
                  style: defaultStyle.copyWith(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: Text(
                  "Explore variety of shopping items online",
                  textAlign: TextAlign.center,
                  style: defaultStyle.copyWith(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Colors.black,
                        style: defaultStyle.copyWith(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.20),
                          hintText: "Email",
                          hintStyle: defaultStyle.copyWith(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },

                        // check tha validation
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        style: defaultStyle.copyWith(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.20),
                          hintText: "Password",
                          hintStyle: defaultStyle.copyWith(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                        ),
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      _isLoading
                          ? CustomLoadingButton(onpress: () {})
                          : CustomButton(onpress: login, buttonLabel: "LOGIN"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const OrDivider(),
                    SizedBox(
                      height: 15.h,
                    ),
                    RoundedLoadingButton(
                      valueColor: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {
                        loginWithGoogle();
                      },
                      controller: googleController,
                      successColor: Theme.of(context).colorScheme.onPrimary,
                      width: MediaQuery.of(context).size.width * 0.80,
                      elevation: 0,
                      borderRadius: 10.r,
                      color: Colors.grey.withOpacity(0.20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h)
                                .copyWith(right: 10.w),
                            child: Image.asset("assets/icons/google.png"),
                          ),
                          Text(
                            "Sign in with Google",
                            style: defaultStyle.copyWith(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: defaultStyle.copyWith(
                      color: Colors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.routeName);
                    },
                    child: Text(
                      "Register",
                      style: defaultStyle.copyWith(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This function will help user login with username and password
  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          Navigator.pushReplacementNamed(
            context,
            CustomNavBar.routeName,
          );
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  // This function will help user login with google
  loginWithGoogle() async {
    await AuthService().signInWithGoogle();

    await HelperFunctions.saveUserLoggedInStatus(true);
    Navigator.pushReplacementNamed(
      context,
      CustomNavBar.routeName,
    );
    setState(() {
      _isLoading = false;
    });
  }
}
