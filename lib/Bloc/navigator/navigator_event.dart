part of 'navigator_bloc.dart';

abstract class NavigatorBlocEvent {
  const NavigatorBlocEvent();

  @override
  List<Object> get props => [];
}

class ChangeIndex extends NavigatorBlocEvent {
  final int index;
  const ChangeIndex({required this.index});

  @override
  List<Object> get props => [index];
}
