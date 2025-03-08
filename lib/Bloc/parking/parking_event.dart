part of 'parking_bloc.dart';

abstract class ParkingEvent {}

class SetLoading extends ParkingEvent {}

class OnFirstParkingSlot extends ParkingEvent {}

class RefrechParkingSlot extends ParkingEvent {}

class SenderParkingSlot extends ParkingEvent {
  final ParkingSlot parkingSlot;

  SenderParkingSlot(this.parkingSlot);
}

class SelectParkingSlotToReserv extends ParkingEvent {
  final ParkingSlot selectedSlot;

  SelectParkingSlotToReserv(this.selectedSlot);
}
