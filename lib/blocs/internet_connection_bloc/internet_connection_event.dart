part of 'internet_connection_bloc.dart';

sealed class InternetConnectionEvent extends Equatable {
  const InternetConnectionEvent();

  @override
  List<Object> get props => [];
}

class CheckInternetConnection extends InternetConnectionEvent {
  const CheckInternetConnection();
}
