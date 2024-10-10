part of 'internet_connection_bloc.dart';

enum InternetConnectionStatus { connected, disconnected, unknown }

class InternetConnectionState extends Equatable {
  final InternetConnectionStatus status;
  const InternetConnectionState._(
      {this.status = InternetConnectionStatus.unknown});

  const InternetConnectionState.unknown() : this._();

  const InternetConnectionState.connected()
      : this._(status: InternetConnectionStatus.connected);

  const InternetConnectionState.disconnected()
      : this._(status: InternetConnectionStatus.disconnected);

  @override
  List<Object> get props => [status];
}
