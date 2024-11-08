import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:perfect_childcare/blocs/nanny_bloc/nanny_bloc.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  final NannyBloc _nannyBloc;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc({
    required this.userRepository,
    required NannyBloc nannyBloc,
  })  : _nannyBloc = nannyBloc,
        super(const AuthenticationState.unknown()) {
    _userSubscription = userRepository.user.listen((user) {
      add(AuthenticationUserChanged(user));
    });

    on<AuthenticationUserChanged>((event, emit) async {
      if (event.user != null) {
        emit(AuthenticationState.authenticated(event.user!));

        _nannyBloc.add(CheckNannyStatus(event.user!.uid));
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await userRepository.updateFCMToken(event.user!.uid, fcmToken);
        }
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
