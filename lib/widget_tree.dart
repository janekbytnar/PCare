// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:perfect_childcare/auth.dart';
// import 'package:perfect_childcare/controllers/userData_controller.dart';
// import 'package:perfect_childcare/pages/home_page.dart';
// import 'package:perfect_childcare/pages/login_register_page.dart';
// import 'package:perfect_childcare/pages/update_userData.dart';

// class WidgetTree extends StatefulWidget {
//   const WidgetTree({Key? key}) : super(key: key);

//   @override
//   State<WidgetTree> createState() => _WidgetTreeState();
// }

// class _WidgetTreeState extends State<WidgetTree> {
//   Widget _futurebuilder(
//     String uid,
//   ) {
//     return FutureBuilder<bool>(
//       future: UserService().doesUserCollectionExist(uid),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasData) {
//           bool userCollectionExists = snapshot.data!;
//           if (userCollectionExists) {
//             return HomePage();
//           } else {
//             return const UpdateUserData();
//           }
//         } else {
//           return const Text('Error occurred while checking user collection');
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: Auth().authStateChanges,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasData) {
//             final user = snapshot.data as User;
//             final uid = user.uid;
//             return _futurebuilder(uid);
//           } else {
//             return const LoginPage();
//           }
//         });
//   }
// }
