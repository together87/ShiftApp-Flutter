import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/auth.dart';
import '../../ui/authentication/login.dart';
import '../../utils/constants.dart';

class BlockedPage extends StatelessWidget {
  const BlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                width: 120.0,
                fit: BoxFit.contain,
                image: AssetImage('assets/images/logo.png'),
              ),
              const SizedBox(height: 40.0),
              Text(
                "The Admin has blocked your account, please contact us at ${AppConstants.CONTACT_EMAIL} to find out why.",
                style: GoogleFonts.dmSans(
                  color: Colors.grey.shade800,
                  fontSize: 18.0,
                  textStyle: const TextStyle(
                    decoration: TextDecoration.none,
                  ),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade400,
                ),
                onPressed: () {
                  authProvider.logout();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false);
                },
                child: Text(
                  "Try Again".toUpperCase(),
                  style: GoogleFonts.dmSans(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
