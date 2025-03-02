import 'dart:io';
import 'package:flutter/material.dart';

@immutable
abstract class SettingEvent   {
  const SettingEvent();


  List<Object> get props => [];
}

class LoadCars extends SettingEvent {}

class LoadUser extends SettingEvent {}

class LoadUserAndCars extends SettingEvent {}

class FetchCarById extends SettingEvent {
  final String carId;

  const FetchCarById({required this.carId});

  @override
  List<Object> get props => [carId];
}


class AddCar extends SettingEvent {
  final String plate;
  final String model;
  final String type;
  final File imageFile;

  const AddCar({
    required this.plate,
    required this.model,
    required this.type,
    required this.imageFile,
  });

  @override
  List<Object> get props => [plate, model, type, imageFile];
}


class UpdateCar extends SettingEvent {
  final String id;
  final String plate;
  final String model;
  final String type;
  final File? imageFile;

  const UpdateCar({
    required this.id,
    required this.plate,
    required this.model,
    required this.type,
    this.imageFile,
  });

  @override
  List<Object> get props => [id, plate, model, type, imageFile ?? ''];
}


class DeleteCar extends SettingEvent {
  final String id;

  const DeleteCar({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateProfile extends SettingEvent {
  final String name;
  final File? imageFile;

  const UpdateProfile({
    required this.name,
    this.imageFile,
  });

  @override
  List<Object> get props => [name, imageFile ?? ''];
}

class UpdatePassword extends SettingEvent {
  final String oldPassword;
  final String newPassword;

  const UpdatePassword({required this.oldPassword, required this.newPassword});
}






