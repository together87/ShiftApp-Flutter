import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/auth.dart';
import '../../types/register_user.dart';
import '../theme_data/fonts.dart';
import '../theme_data/inputs.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  RegisterUser _registerUser = RegisterUser(
    id: 0,
    email: '',
    password: '',
    passwordConfirmation: '',
    firstName: '',
    lastName: '',
    dateOfBirth: '',
    profession: '',
    bio: '',
  );
  String msg = '';

  Future<void> submitForm(BuildContext context) async {
    // ignore: use_build_context_synchronously
    await Provider.of<AuthProvider>(context, listen: false)
        .register(_registerUser)
        .then((value) => {
              if (value)
                {
                  setState(() {
                    msg =
                        'Your account has been created, and a verification token has been sent.';
                  }),
                }
              else
                {
                  setState(() {
                    msg = 'Sorry, couldn\'t create your account.';
                  }),
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    final dateNow = DateTime.now();
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.grey.shade200,
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
              Container(
                height: height,
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                color: Colors.transparent,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80.0),
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
                            "REGISTER",
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
                          onSaved: (value) => _registerUser.email = value!,
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
                          bottom: 20.0,
                        ),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Your Password' : null,
                          onSaved: (value) => _registerUser.password = value!,
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
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: TextFormField(
                          validator: (value) => value!.isEmpty
                              ? 'Enter Your Password Confirmation'
                              : null,
                          onSaved: (value) =>
                              _registerUser.passwordConfirmation = value!,
                          style: const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5.0),
                            hintText: 'Password Confirmation',
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
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Your First Name' : null,
                          onSaved: (value) => _registerUser.firstName = value!,
                          style: const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5.0),
                            hintText: 'First Name',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.text_format_outlined),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15.0),
                            enabledBorder: InputsThemeData.inputBorder,
                            focusedBorder: InputsThemeData.inputBorderSelected,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Your Last Name' : null,
                          onSaved: (value) => _registerUser.lastName = value!,
                          style: const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5.0),
                            hintText: 'Last Name',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.text_format_outlined),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15.0),
                            enabledBorder: InputsThemeData.inputBorder,
                            focusedBorder: InputsThemeData.inputBorderSelected,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: 5.0,
                        ),
                        child: Text("Date of Birth"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(
                                dateNow.year - 100,
                                dateNow.month - 12,
                                dateNow.day - 30,
                              ),
                              maxTime: DateTime(
                                dateNow.year - 12,
                                dateNow.month - 12,
                                dateNow.day - 30,
                              ),
                              currentTime: (_registerUser.dateOfBirth != '')
                                  ? DateFormat('MMMM d, yyyy')
                                      .parse(_registerUser.dateOfBirth)
                                  : dateNow,
                              onConfirm: (date) {
                                setState(() {
                                  _registerUser.dateOfBirth =
                                      DateFormat('MMMM d, yyyy')
                                          .format(date)
                                          .toString();
                                });
                              },
                            );
                          },
                          child: Text(
                            (_registerUser.dateOfBirth == '')
                                ? 'Select Your Date'
                                : _registerUser.dateOfBirth,
                            style: GoogleFonts.dmSans(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Your Profession' : null,
                          onSaved: (value) => _registerUser.profession = value!,
                          style: const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5.0),
                            hintText: 'Profession',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.work),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15.0),
                            enabledBorder: InputsThemeData.inputBorder,
                            focusedBorder: InputsThemeData.inputBorderSelected,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Your Bio' : null,
                          onSaved: (value) => _registerUser.bio = value!,
                          style: const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                          maxLines: 10,
                          maxLength: 500,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
                            hintText: 'Bio',
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15.0),
                            enabledBorder: InputsThemeData.inputBorder,
                            focusedBorder: InputsThemeData.inputBorderSelected,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: (msg.isNotEmpty) ? Text(msg) : const SizedBox(),
                      ),
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
                          "REGISTER",
                          softWrap: true,
                          style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.btnText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50.0),
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
