// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/main/drawer.dart';
import '../../../data/auth.dart';
import '../../../types/navigation.dart';
import '../../../ui/authentication/login.dart';
import '../../../utils/constants.dart';
import '../../theme_data/fonts.dart';
import '../index.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  _launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  deleteUser(BuildContext ctx) async {
    final userProvider = Provider.of<AuthProvider>(ctx, listen: false);
    String? token = await userProvider.getToken();
    final userId = userProvider.user.id;
    final Uri url = Uri.parse(
        "${AppConstants.API_URL}${AppConstants.USER_DELETE_URL}/$userId");
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'_method': 'DELETE'}),
    );
    if (response.statusCode == 200) {
      userProvider.logout();
      Navigator.of(ctx).pop();
      await Navigator.of(ctx).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
      return;
    } else {
      throw Exception("Couldn't delete user profile.");
    }
  }

  showAlertDialogDeleteAccount(BuildContext context) {
    // set up the buttons
    Widget consentBtn = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 0, 0, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
      ),
      child: Text("Yes, I Understand", style: GoogleFonts.dmSans()),
      onPressed: () async {
        await deleteUser(context);
      },
    );
    Widget contactUsBtn = TextButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
            side: const BorderSide(color: Color.fromRGBO(226, 232, 240, 1.0))),
      ),
      child: Text("No, Exit", style: GoogleFonts.dmSans(color: Colors.black)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Center(
          child: Text("CAUTION!!! You're about to delete your profile")),
      titleTextStyle:
          GoogleFonts.dmSans(textStyle: FontThemeData.jobPostSecondHeadingBold),
      content: Text(
        "Once you delete your profile there's no going back, all data related to your profile will be delete and removed from our servers.",
        style: GoogleFonts.dmSans(textStyle: FontThemeData.jobPostText),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            consentBtn,
            const SizedBox(width: 10.0),
            contactUsBtn,
          ],
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final privacyUrl =
        Uri.parse("${AppConstants.STATIC_WEB_URL}/privacy-policy");
    final tosUrl = Uri.parse("${AppConstants.STATIC_WEB_URL}/terms-conditions");
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: Image(
            width: 85.0,
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1.0),
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: PageDrawer(key: UniqueKey(), page: PAGES.explore),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(height: 15.0),
              SizedBox(
                width: 130.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.chevron_left,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          "Go Back",
                          style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.btnText,
                            color: Colors.black,
                          ),
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                width: width - 40.0,
                child: Text(
                  "Privacy & Security",
                  style: GoogleFonts.dmSans(
                      textStyle: FontThemeData.sectionTitles),
                ),
              ),
              const SizedBox(height: 30.0),
              // Terms of Services
              InkWell(
                onTap: () {
                  _launchURL(privacyUrl);
                },
                child: SizedBox(
                  width: width - 140.0,
                  child: Text(
                    "Our Privacy Policy",
                    style: GoogleFonts.dmSans(
                        textStyle: FontThemeData.settingsListItemPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // Terms of Services
              InkWell(
                onTap: () {
                  _launchURL(tosUrl);
                },
                child: SizedBox(
                  width: width - 140.0,
                  child: Text(
                    "Terms of Services",
                    style: GoogleFonts.dmSans(
                        textStyle: FontThemeData.settingsListItemPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // Delete Account
              InkWell(
                onTap: () {
                  showAlertDialogDeleteAccount(context);
                },
                child: SizedBox(
                  width: width - 140.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 5.0),
                      Text(
                        "Delete Account",
                        style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.settingsListItemPrimary,
                            color: Colors.red),
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
