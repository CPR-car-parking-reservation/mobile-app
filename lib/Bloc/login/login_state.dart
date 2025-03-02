part of 'login_bloc.dart';

sealed class LoginState {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final String emai;
  final String password;

  LoginSuccess(this.emai, this.password);

  @override
  List<Object> get props => [emai, password];
}

final class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  @override
  List<Object> get props => [message];
}
