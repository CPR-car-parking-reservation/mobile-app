part of 'admin_parking_bloc.dart';

@immutable
sealed class AdminParkingState {}

final class AdminParkingInitial extends AdminParkingState {}

final class AdminParkingLoading extends AdminParkingState {}

final class AdminParkingLoaded extends AdminParkingState {
  final List<ModelParkingSlot> parkings;
  final List<ModelFloor> floors;
  final String? search;
  final String? floor;
  final String? status;

  AdminParkingLoaded(
      {required this.parkings,
      this.search,
      required this.floors,
      this.status,
      this.floor});
}

final class AdminParkingError extends AdminParkingState {
  final String message;

  AdminParkingError({required this.message});
}

final class AdminParkingSuccess extends AdminParkingState {
  final String message;

  AdminParkingSuccess({required this.message});
}

final class AdminFloorLoaded extends AdminParkingState {
  final List<ModelFloor> floors;

  AdminFloorLoaded({required this.floors});
}
