import 'package:flutter/material.dart';
import 'intro_theme_data.dart';

class JobAlert extends StatelessWidget {
  const JobAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: IntroThemeData.introTextPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Image(image: AssetImage('assets/images/job-alert.png')),
          )
        ],
      ),
    );
  }
}
