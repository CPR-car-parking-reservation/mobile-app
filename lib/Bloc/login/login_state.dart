part of 'login_bloc.dart';

sealed class LoginState {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final String role;
  final String meaasge;
  LoginSuccess({required this.role, required this.meaasge});

  @override
  List<Object> get props => [role, meaasge];
}

final class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  @override
  List<Object> get props => [message];
}
