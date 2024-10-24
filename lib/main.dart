import 'package:child_repository/child_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/app.dart';
import 'package:perfect_childcare/firebase_options.dart';
import 'package:perfect_childcare/simple_bloc_observer.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(
    FirebaseUserRepo(),
    FirebaseChildRepo(),
    FirebaseSessionRepo(),
  ));
}
