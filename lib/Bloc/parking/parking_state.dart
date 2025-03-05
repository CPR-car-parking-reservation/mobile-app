part of 'parking_bloc.dart';

abstract class ParkingState {
  const ParkingState();

  List<Object> get props => [];
}

class ParkingInitial extends ParkingState {}

class ParkingLoading extends ParkingState {}

class ParkingLoaded extends ParkingState {
  final List<ParkingSlot> parkingSlots;

  ParkingLoaded(this.parkingSlots);

  @override
  List<Object> get props => [parkingSlots];
}

class ParkingError extends ParkingState {
  final String message;

  ParkingError(this.message);

  @override
  List<Object> get props => [message];
}

class ParkingSlotSelected extends ParkingState{
  final ParkingSlot selectedSlot;

  ParkingSlotSelected(this.selectedSlot);

}
