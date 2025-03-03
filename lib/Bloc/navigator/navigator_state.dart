part of 'navigator_bloc.dart';

abstract class NavigatorBlocState {
  const NavigatorBlocState();

  List<Object> get props => [];
}

class NavigatorBlocStateInitial extends NavigatorBlocState {
  final int index;
  // final String? reservationId;

  const NavigatorBlocStateInitial({required this.index});
  // const NavigatorBlocStateInitial({required this.index, this.reservationId});

  @override
  List<Object> get props => [index];
  // List<Object> get props => [index, reservationId ?? ''];
}
