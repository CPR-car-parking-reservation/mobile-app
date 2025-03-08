part of 'admin_user_bloc.dart';

sealed class AdminUserEvent {
  const AdminUserEvent();

  @override
  List<Object> get props => [];
}

final class OnUsersPageLoad extends AdminUserEvent {}

final class OnRefresh extends AdminUserEvent {
  final String? search;

  const OnRefresh({this.search});
}

final class OnSearch extends AdminUserEvent {
  final String? search;

  const OnSearch({this.search});
}

final class SetLoading extends AdminUserEvent {}
