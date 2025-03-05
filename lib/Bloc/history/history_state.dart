part of 'history_bloc.dart';

abstract class HistoryState {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final Reservation_Model history;

  HistoryLoaded(this.history);
}

class HistoryError extends HistoryState {
  // State ที่โหลดข้อมูลไม่สำเร็จ จะมี error message ในนี้
  final String message;

  // สร้าง Constructor รับค่า message
  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}
