part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class OnCreateRegister extends RegisterEvent {
  final String email;
  final String password;
  final String confirm_password;
  final String name;
  final String surname;

  OnCreateRegister(this.name, this.surname, this.email, this.password, this.confirm_password);
}
