part of 'nanny_bloc.dart';

enum NannyStatus { isNanny, isNotNanny, unknown }

class NannyState extends Equatable {
  final NannyStatus status;
  const NannyState._({this.status = NannyStatus.unknown});

  const NannyState.unknown() : this._();

  const NannyState.isNanny() : this._(status: NannyStatus.isNanny);

  const NannyState.isNotNanny() : this._(status: NannyStatus.isNotNanny);

  @override
  List<Object> get props => [status];
}
