part of 'history_bloc.dart';

abstract class HistoryEvent {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class FetchFirstHistory extends HistoryEvent {}
