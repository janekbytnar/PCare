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
        final myUser = await userRepository.getCurrentUserData();
        if (myUser != null) {
          final isProfileComplete =
              myUser.firstName.isNotEmpty && myUser.surname.isNotEmpty;
          if (isProfileComplete) {
            emit(AuthenticationState.authenticated(event.user!));
          } else {
            emit(AuthenticationState.authenticatedNoData(event.user!));
          }

          _nannyBloc.add(CheckNannyStatus(event.user!.uid));
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await userRepository.updateFCMToken(event.user!.uid, fcmToken);
          }
        } else {
          emit(const AuthenticationState.unauthenticated());
        }
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });

    on<AuthenticationUserDataChanged>((event, emit) async {
      final myUser = await userRepository.getCurrentUserData();
      final isProfileComplete =
          myUser!.firstName.isNotEmpty && myUser.surname.isNotEmpty;
      if (isProfileComplete) {
        emit(AuthenticationState.authenticated(
            FirebaseAuth.instance.currentUser!));
      } else {
        emit(AuthenticationState.authenticatedNoData(
            FirebaseAuth.instance.currentUser!));
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
