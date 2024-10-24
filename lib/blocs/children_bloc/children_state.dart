part of 'children_bloc.dart';

enum ChildrenStatus { hasChildren, childless, unknown, loading, failure }

class ChildrenState extends Equatable {
  final ChildrenStatus status;
  final List<Child> children;
  final String? error;

  const ChildrenState._({
    this.status = ChildrenStatus.unknown,
    this.children = const [],
    this.error,
  });

  const ChildrenState.unknown() : this._();

  const ChildrenState.loading() : this._(status: ChildrenStatus.loading);

  const ChildrenState.hasChildren(
    List<Child> children,
  ) : this._(status: ChildrenStatus.hasChildren, children: children);

  const ChildrenState.childless() : this._(status: ChildrenStatus.childless);

  const ChildrenState.failure(String error)
      : this._(status: ChildrenStatus.failure, error: error);

  @override
  List<Object?> get props => [status, children, error];
}
