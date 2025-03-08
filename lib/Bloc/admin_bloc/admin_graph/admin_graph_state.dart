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

  AdminGraphLoaded({
    required this.adminGraphData,
  });

  @override
  List<Object> get props => [adminGraphData];
}

final class AdminGraphError extends AdminGraphState {
  final String message;

  AdminGraphError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
