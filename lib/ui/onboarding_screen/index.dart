import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import '../../ui/homepage/index.dart';
import '../../ui/onboarding_screen/stacked_screens/apply_job.dart';
import '../../ui/onboarding_screen/stacked_screens/find_job.dart';
import '../../ui/onboarding_screen/stacked_screens/intro_theme_data.dart';
import '../../ui/onboarding_screen/stacked_screens/job_alert.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Identify the Onboarding screen
  final PageController _controller = PageController();
  static const List<Widget> _screens = [FindJob(), ApplyJob(), JobAlert()];
  int _pageNo = 0;
  List textList = [
    "Search for an ideal job",
    "Apply for your dream job",
    "Get notified when selected"
  ];
  bool onLastPage = false;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  _setInitScreenToFalse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool("initScreen", false);
  }

  static const TextStyle navText =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(8, 104, 192, 1),
            Color.fromRGBO(1, 41, 79, 1),
          ],
        )),
        child: Stack(alignment: Alignment.center, children: [
          const Positioned(
            right: -10.0,
            bottom: -60.0,
            child: Image(
              width: 350.0,
              image:
                  AssetImage('assets/illustrations/onboarding-splash-bg.png'),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -50.0, 0.0),
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _pageNo = index;
                });
              },
              controller: _controller,
              itemCount: _screens.length,
              itemBuilder: (context, index) {
                return _screens[index];
              },
            ),
          ),
          Positioned(
            top: 90.0,
            right: 30.0,
            child: GestureDetector(
              onTap: () {
                _controller.animateToPage(
                  _screens.length,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              },
              // ignore: unnecessary_brace_in_string_interps
              child: const Text("Skip", style: navText),
            ),
          ),
          Positioned(
            left: 30.0,
            bottom: 130.0,
            width: 250.0,
            child: Text(
              textList[_pageNo],
              softWrap: true,
              style: GoogleFonts.dmSans(
                textStyle: IntroThemeData.introTitleTextStyle,
              ),
            ),
          ),
          // Page View Indicators
          Positioned(
            bottom: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    _screens.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        onTap: () {
                          _controller.animateToPage(index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        child: CircleAvatar(
                          radius: 10,
                          child: _pageNo == index
                              ? Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromRGBO(255, 255, 0, 0.75),
                                        Color.fromRGBO(244, 148, 4, 1.0),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromRGBO(255, 255, 255, 0.5),
                                        Color.fromRGBO(255, 255, 255, 1.0),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 30.0,
            bottom: 30.0,
            child: _pageNo == _screens.length - 1
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: const Color.fromRGBO(0, 112, 255, 1),
                    ),
                    onPressed: () {
                      _setInitScreenToFalse();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomePage();
                      }));
                    },
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30.0,
                    ))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: const Color.fromRGBO(0, 112, 255, 1),
                    ),
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}
