part of 'navigator_bloc.dart';

abstract class NavigatorBlocState {
  const NavigatorBlocState();

  List<Object> get props => [];
}

class NavigatorBlocStateInitial extends NavigatorBlocState {
  final int index;

  const NavigatorBlocStateInitial({required this.index});
  @override
  List<Object> get props => [index];
}

