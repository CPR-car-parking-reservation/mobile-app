part of 'parking_bloc.dart';

@immutable
abstract class ParkingEvent extends Equatable {
  const ParkingEvent();

  @override
  List<Object> get props => [];
}

class FetchSlots extends ParkingEvent {}

class ReserveSlot extends ParkingEvent {
  final ParkingSlot parking;

  const ReserveSlot({required this.parking});

  @override
  List<Object> get props => [parking];
}