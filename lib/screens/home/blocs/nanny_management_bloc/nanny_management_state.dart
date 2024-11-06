part of 'nanny_management_bloc.dart';

sealed class NannyManagementState extends Equatable {
  const NannyManagementState();
  
  @override
  List<Object> get props => [];
}

final class NannyManagementInitial extends NannyManagementState {}
