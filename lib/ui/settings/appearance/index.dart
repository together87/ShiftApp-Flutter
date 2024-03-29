import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/main/drawer.dart';
import '../../../components/main/switch.dart';
import '../../../types/navigation.dart';
import '../../theme_data/fonts.dart';
import '../index.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                  "App Theme",
                  style: GoogleFonts.dmSans(
                      textStyle: FontThemeData.sectionTitles),
                ),
              ),
              const SizedBox(height: 30.0),
              // Dark mode
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width - 100.0,
                    child: Text(
                      "Dark Mode",
                      style: GoogleFonts.dmSans(
                          textStyle: FontThemeData.settingsListItemPrimary),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                    child: CustomToggleSwitch(
                      key: UniqueKey(),
                      value: false,
                      onChange: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // Font Size
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width - 140.0,
                    child: Text(
                      "Font Size",
                      style: GoogleFonts.dmSans(
                          textStyle: FontThemeData.settingsListItemPrimary),
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Aa",
                          style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.settingsFontSizeXl,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          "Aa",
                          style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.settingsFontSizeLBold,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          "Aa",
                          style: GoogleFonts.dmSans(
                            textStyle: FontThemeData.settingsFontSizeM,
                          ),
                        ),
                      ],
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
}
