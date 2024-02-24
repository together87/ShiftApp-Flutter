import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../components/welcome_gradient_profile.dart';
import '../../../data/auth.dart';
import '../../../ui/profile/index.dart';
import '../../theme_data/fonts.dart';

class WelcomeHomeSection extends StatefulWidget {
  const WelcomeHomeSection({super.key});

  @override
  State<WelcomeHomeSection> createState() => _WelcomeHomeSectionState();
}

class _WelcomeHomeSectionState extends State<WelcomeHomeSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "Welcome",
              style: GoogleFonts.dmSans(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w100,
                  color: Colors.black,
                ),
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 10.0),
          WelcomeGradientProfile(
            key: UniqueKey(),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(93, 216, 171, 1.0),
                Color.fromRGBO(0, 244, 230, 0.5)
              ],
            ),
            onPressed: () {},
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(auth.user.img),
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.user.name,
                            style: GoogleFonts.dmSans(
                                textStyle: FontThemeData.welcomeTitle),
                          ),
                          SizedBox(
                            width: 180.0,
                            child: Text(
                              auth.user.profession,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSans(
                                  textStyle: FontThemeData.welcomeOccupation),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(5),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: const Icon(Icons.chevron_right, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
