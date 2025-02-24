part of 'parking_bloc.dart';

@immutable
abstract class ParkingState extends Equatable {
  const ParkingState();

  @override
  List<Object> get props => [];
}

class ParkingInitial extends ParkingState {}

class SlotsLoaded extends ParkingState {
  final List<ParkingSlot> slots;

  const SlotsLoaded({required this.slots});

  @override
  List<Object> get props => [slots];
}

class ParkingError extends ParkingState {
  final String message;

  const ParkingError(this.message);

  @override
  List<Object> get props => [message];
}
