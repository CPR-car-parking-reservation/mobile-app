part of 'admin_dashboard_bloc.dart';

sealed class AdminDashboardState {
  const AdminDashboardState();

  @override
  List<Object> get props => [];
}

final class AdminDashboardInitial extends AdminDashboardState {}

final class AdminDashboardLoading extends AdminDashboardState {}

final class AdminDashboardLoaded extends AdminDashboardState {
  final List<ModelDashboard> adminDashboardData;

  AdminDashboardLoaded({
    required this.adminDashboardData,
  });
}

final class AdminDashboardError extends AdminDashboardState {
  final String message;

  AdminDashboardError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
