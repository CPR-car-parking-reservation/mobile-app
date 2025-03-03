part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

class RegisterCreated extends RegisterState {
  final String name;
  final String surname;
  final String email;
  final String password;
  final String confirm_password;
  final String phone;

  RegisterCreated( {
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.confirm_password,
    required this.phone
  });
}

final class RegisterError extends RegisterState {
  final String message;

  RegisterError({required this.message});
}

final class RegisterSuccess extends RegisterState {
  final String message;

  RegisterSuccess({required this.message});

  List<Object> get props => [message];
}
