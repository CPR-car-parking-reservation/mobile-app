import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:car_parking_reservation/model/car.dart';

@immutable
abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {
  final List<car_data> cars;

  const SettingLoaded({required this.cars});

  @override
  List<Object> get props => [cars];
}

class SettingError extends SettingState {
  final String message;

  const SettingError({required this.message});

  @override
  List<Object> get props => [message];
}

class SettingSuccess extends SettingState {
  final String message;

  const SettingSuccess({required this.message});

  @override
  List<Object> get props => [message];
}