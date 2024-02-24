import 'package:flutter/material.dart';

/// Gradient component with rounded corners
/// primarily used for home welcome screen
class WelcomeGradientProfile extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final Function onPressed;

  const WelcomeGradientProfile({
    required Key key,
    required this.child,
    required this.gradient,
    this.width = double.infinity,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed(),
          child: child,
        ),
      ),
    );
  }
}
