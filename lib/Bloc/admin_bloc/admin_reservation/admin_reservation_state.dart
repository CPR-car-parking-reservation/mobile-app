part of 'admin_reservation_bloc.dart';

sealed class AdminReservationState {
  const AdminReservationState();

  @override
  List<Object> get props => [];
}

final class AdminReservationInitial extends AdminReservationState {}

final class AdminReservationLoading extends AdminReservationState {}

final class AdminReservationLoaded extends AdminReservationState {
  final List<Model_History_data> adminReservationData;
  final String date;
  final String order;

  AdminReservationLoaded({
    required this.adminReservationData,
    required this.date,
    required this.order,
  });

  @override
  List<Object> get props => [adminReservationData, date, order];
}

final class AdminReservationError extends AdminReservationState {
  final String message;

  AdminReservationError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
