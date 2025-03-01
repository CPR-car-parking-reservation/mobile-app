part of 'admin_navigator_bloc.dart';

@immutable
sealed class AdminNavigatorEvent {}

final class OnChangeIndex extends AdminNavigatorEvent {
  final int index;

  OnChangeIndex({required this.index});
}
