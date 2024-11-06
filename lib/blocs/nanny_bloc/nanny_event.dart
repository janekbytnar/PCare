part of 'nanny_bloc.dart';

sealed class NannyEvent extends Equatable {
  const NannyEvent();

  @override
  List<Object> get props => [];
}

class CheckNannyStatus extends NannyEvent {
  final String userId;

  const CheckNannyStatus(this.userId);

  @override
  List<Object> get props => [userId];
}
