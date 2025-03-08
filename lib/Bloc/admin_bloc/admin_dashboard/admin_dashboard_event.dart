part of 'admin_dashboard_bloc.dart';

sealed class AdminDashboardEvent {
  const AdminDashboardEvent();

  @override
  List<Object> get props => [];
}

final class AdminDashboardOnLoad extends AdminDashboardEvent {}

final class AdminDashboardRefresh extends AdminDashboardEvent {}
