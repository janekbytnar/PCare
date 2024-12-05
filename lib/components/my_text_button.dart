import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double elevation;

  const MyTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = Colors.green,
    this.foregroundColor = Colors.black,
    this.disabledBackgroundColor = Colors.grey,
    this.disabledForegroundColor = Colors.white70,
    this.borderRadius = 80.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    this.elevation = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final Color currentBackgroundColor =
        onPressed == null ? disabledBackgroundColor : backgroundColor;
    final Color currentForegroundColor =
        onPressed == null ? disabledForegroundColor : foregroundColor;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: currentBackgroundColor,
          foregroundColor: currentForegroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation,
        ),
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }
}
