part of 'children_bloc.dart';

enum ChildrenStatus { hasChildren, childless, unknown }

class ChildrenState extends Equatable {
  final ChildrenStatus status;
  const ChildrenState._({this.status = ChildrenStatus.unknown});

  const ChildrenState.unknown() : this._();

  const ChildrenState.hasChildren()
      : this._(status: ChildrenStatus.hasChildren);

  const ChildrenState.childless() : this._(status: ChildrenStatus.childless);

  @override
  List<Object> get props => [status];
}
