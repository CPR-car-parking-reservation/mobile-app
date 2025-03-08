part of 'admin_reservation_bloc.dart';

sealed class AdminReservationEvent {
  const AdminReservationEvent();

  @override
  List<Object> get props => [];
}

final class AdminReservationOnLoad extends AdminReservationEvent {
  final String date;
  final String order;

  AdminReservationOnLoad({
    required this.date,
    required this.order,
  });

  @override
  List<Object> get props => [
        date,
        order,
      ];
}

final class AdminReservationOnRefresh extends AdminReservationEvent {
  final int date;
  final String order;

  AdminReservationOnRefresh({
    required this.date,
    required this.order,
  });

  @override
  List<Object> get props => [
        date,
        order,
      ];
}
