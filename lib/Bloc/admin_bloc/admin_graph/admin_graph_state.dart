part of 'admin_graph_bloc.dart';

sealed class AdminGraphState {
  const AdminGraphState();

  @override
  List<Object> get props => [];
}

final class AdminGraphInitial extends AdminGraphState {}

final class AdminGraphLoading extends AdminGraphState {}

final class AdminGraphLoaded extends AdminGraphState {
  final List<ModelGraph> adminGraphData;
  final int month;
  final int year;
  final String type;

  AdminGraphLoaded({
    required this.adminGraphData,
    required this.month,
    required this.year,
    required this.type,
  });

  @override
  List<Object> get props => [adminGraphData, month, year, type];
}

final class AdminGraphError extends AdminGraphState {
  final String message;

  AdminGraphError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
