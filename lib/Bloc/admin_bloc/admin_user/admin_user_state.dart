part of 'admin_user_bloc.dart';

sealed class AdminUserState {
  const AdminUserState();
}

final class AdminUserInitial extends AdminUserState {}

final class AdminUserLoading extends AdminUserState {}

final class AdminUserLoaded extends AdminUserState {
  final List<ModelUsers> users;
  final String? search;

  AdminUserLoaded({required this.users, this.search});
}

final class AdminUserSuccess extends AdminUserState {
  final String message;

  AdminUserSuccess({required this.message});
}

final class AdminUserError extends AdminUserState {
  final String message;

  AdminUserError({required this.message});
}
