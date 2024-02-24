import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/auth.dart';
import '../../ui/authentication/blocked.dart';
import '../../ui/authentication/register.dart';
import '../../utils/constants.dart';
import '../homepage/index.dart';
import '../onboarding_screen/index.dart';
import '../theme_data/fonts.dart';
import '../theme_data/inputs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  String errorMessage = '';

  Future<void> submitForm(BuildContext context) async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    bool? initScreen = await prefs.getBool("initScreen");
    setState(() {
      errorMessage = '';
    });
    // ignore: use_build_context_synchronously
    String result = await userProvider.login(_email, _password);
    if (result != '') {
      setState(() {
        errorMessage = result;
      });
    } else {
      if (userProvider.user.blocked) {
        // ignore: use_build_context_synchronously
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const BlockedPage();
        }));
      } else {
        switch (initScreen) {
          case false:
            // ignore: use_build_context_synchronously
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const HomePage();
            }));
            break;
          default:
            // ignore: use_build_context_synchronously
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const OnboardingScreen();
            }));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // BG Splash
              const Positioned(
                top: 250.0,
                child: Image(
                  width: 350.0,
                  image:
                      AssetImage('assets/illustrations/user-app-login-bg.png'),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: height,
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        width: 120.0,
                        fit: BoxFit.contain,
                        image: AssetImage('assets/images/logo.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30.0,
                          bottom: 20.0,
                        ),
                        child: DefaultTextStyle(
                          style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.authHeading,
                          ),
                          child: const Text(
                            "LOGIN",
                            softWrap: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          validator: (value) => value!.isEmpty
                              ? 'Please enter an email address'
                              : null,
                          onSaved: (value) => _email = value!,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5.0),
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.email),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15.0),
                            enabledBorder: InputsThemeData.inputBorder,
                            focusedBorder: InputsThemeData.inputBorderSelected,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 0.0,
                        ),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your password' : null,
                          onSaved: (value) => _password = value!,
                          style: const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5.0),
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.password),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15.0),
                            enabledBorder: InputsThemeData.inputBorder,
                            focusedBorder: InputsThemeData.inputBorderSelected,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 2.0),
                          ),
                          onPressed: () {
                            launchUrl(Uri.parse(
                                "${AppConstants.STATIC_WEB_URL}/user/forgot-password"));
                          },
                          child: Text(
                            "Forgot Password?",
                            softWrap: true,
                            style: GoogleFonts.dmSans(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      (errorMessage != '')
                          ? Text(
                              errorMessage,
                              softWrap: true,
                              style: GoogleFonts.dmSans(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            submitForm(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0,
                          ),
                          backgroundColor:
                              const Color.fromRGBO(21, 192, 182, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          ),
                        ),
                        child: Text(
                          "LOGIN",
                          softWrap: true,
                          style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.btnText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 30.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Register Now".toUpperCase(),
                          softWrap: true,
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
