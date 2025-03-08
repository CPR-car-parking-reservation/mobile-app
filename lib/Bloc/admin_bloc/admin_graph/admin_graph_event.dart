part of 'admin_graph_bloc.dart';

sealed class AdminGraphEvent {
  const AdminGraphEvent();

  @override
  List<Object> get props => [];
}

final class AdminGraphOnLoad extends AdminGraphEvent {
  final int month;
  final int year;
  final String type;

  AdminGraphOnLoad({
    required this.month,
    required this.year,
    required this.type,
  });

  @override
  List<Object> get props => [month, year, type];
}

final class AdminGraphOnRefresh extends AdminGraphEvent {
  final int month;
  final int year;

  AdminGraphOnRefresh({
    required this.month,
    required this.year,
  });

  @override
  List<Object> get props => [month, year];
}
