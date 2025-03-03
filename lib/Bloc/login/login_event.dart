part of 'login_bloc.dart';

sealed class LoginEvent {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class onSubmit extends LoginEvent {
  final String email;
  final String password;

  onSubmit(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

final class onHome extends LoginEvent {
  @override
  List<Object> get props => [];
}
