part of 'navigator_bloc.dart';

sealed class NavigatorBlocState {
  const NavigatorBlocState();

  List<Object> get props => [];
}

final class NavigatorBlocStateInitial extends NavigatorBlocState {
  final int index;
  const NavigatorBlocStateInitial({required this.index});

  @override
  List<Object> get props => [index];
}

final class NavigatorBlocStateUpdate extends NavigatorBlocState {
  final int index;
  const NavigatorBlocStateUpdate({required this.index});

  @override
  List<Object> get props => [index];
}
