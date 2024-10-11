import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Internet'),
      ),
      body: Center(
        child: Text('No internet connection!'),
      ),
    );
  }
}
