// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:car_parking_reservation/model/profile.dart';

@immutable
abstract class SettingState  {
  const SettingState();

  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {
  final List<car_data> cars;

  const SettingLoaded({required this.cars });

  @override
  List<Object> get props => [cars];

}

class SettingError extends SettingState {
  final String message;

  const SettingError({required this.message});

  @override
  List<Object> get props => [message];
}

class EditSuccess extends SettingState {
  final String message;

  const EditSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class EditError extends SettingState {
  final String message;

  const EditError({required this.message});

  @override
  List<Object> get props => [message];
}

class SettingSuccess extends SettingState {
  final String message;

  const SettingSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileLoaded extends SettingState {
    final Profile_data profile;

    const ProfileLoaded({ required this.profile });

    @override
    List<Object> get props => [profile];
}

class UserLoading extends SettingState {}

class UserAndCarsLoaded extends SettingState {
  final Profile_data profile;
  final List<car_data> cars;

  const UserAndCarsLoaded({required this.profile, required this.cars});

  @override
  List<Object> get props => [profile, cars];
}


class CarLoaded extends SettingState {
  final car_data car;
  const CarLoaded({required this.car});

  @override
  List<Object> get props => [car];
}
