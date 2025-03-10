part of 'parking_bloc.dart';

abstract class ParkingEvent {}

class SetLoading extends ParkingEvent {}

class OnFirstParkingSlot extends ParkingEvent {}

class RefrechParkingSlot extends ParkingEvent {}

