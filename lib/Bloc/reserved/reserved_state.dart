part of 'reserved_bloc.dart';

@immutable
abstract class ReservedState extends Equatable {
  const ReservedState();

  @override
  List<Object> get props => [];
}

class ReservedInitial extends ReservedState {}

class ReserveLoading
    extends ReservedState {} // State ที่กำลังโหลดข้อมูล **จะไมมีข้อมูล แค่เป็นสถานะการโหลดหมุนๆ

class ReservedLoaded extends ReservedState {
  // State เมื่อโหลดข้อมูลเสร็จแล้ว จะมีข้อมูลในนี้
  final List<History_data> history;

  const ReservedLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class ReservedError extends ReservedState {
  // State ที่โหลดข้อมูลไม่สำเร็จ จะมี error message ในนี้
  final String message;

  // สร้าง Constructor รับค่า message
  const ReservedError(this.message);

  @override
  List<Object> get props => [message];
}
