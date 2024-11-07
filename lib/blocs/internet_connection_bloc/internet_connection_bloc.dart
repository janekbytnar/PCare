import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'internet_connection_event.dart';
part 'internet_connection_state.dart';

class InternetConnectionBloc
    extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  InternetConnectionBloc() : super(const InternetConnectionState.unknown()) {
    on<CheckInternetConnection>(_onCheckInternetConnection);

    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      add(const CheckInternetConnection());
    });
  }

  void _onCheckInternetConnection(CheckInternetConnection event,
      Emitter<InternetConnectionState> emit) async {
    final isConnected = await _checkInternetConnection();
    if (isConnected) {
      emit(const InternetConnectionState.connected());
    } else {
      emit(const InternetConnectionState.disconnected());
    }
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
