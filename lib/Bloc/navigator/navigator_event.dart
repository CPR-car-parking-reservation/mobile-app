part of 'navigator_bloc.dart';

abstract class NavigatorBlocEvent {
  const NavigatorBlocEvent();

  @override
  List<Object> get props => [];
}

class ChangeIndex extends NavigatorBlocEvent {
  final int index;
  final String? reservationId;
  const ChangeIndex({required this.index, this.reservationId});

  @override
  List<Object> get props => [index, reservationId ?? ''];
}
