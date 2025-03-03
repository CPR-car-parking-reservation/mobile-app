part of 'admin_navigator_bloc.dart';

@immutable
sealed class AdminNavigatorState {
  const AdminNavigatorState();

  @override
  List<Object> get props => [];
}

final class AdminNavigatorInitial extends AdminNavigatorState {
  final int index;
  const AdminNavigatorInitial({required this.index});
}
