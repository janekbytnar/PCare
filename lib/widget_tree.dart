import 'package:flutter/material.dart';
import 'package:perfect_childcare/auth.dart';
import 'package:perfect_childcare/pages/home_page.dart';
import 'package:perfect_childcare/pages/login_register_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return const LoginPage();
          }
        });
  }
}
