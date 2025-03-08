part of 'reserved_bloc.dart';

abstract class ReservedState {
  const ReservedState();

  @override
  List<Object> get props => [];
}

class ReservedInitial extends ReservedState {}

class ReserveLoading
    extends ReservedState {} // State ที่กำลังโหลดข้อมูล **จะไมมีข้อมูล แค่เป็นสถานะการโหลดหมุนๆ

class ReservedLoaded extends ReservedState {
  // State เมื่อโหลดข้อมูลเสร็จแล้ว จะมีข้อมูลในนี้
  // final History_data history;

  final String? parking_slot_id;
  final String? start_at;
  final List<car_data> carData;

  ReservedLoaded({
    this.parking_slot_id,
    this.start_at,
    required this.carData,
  });
}

class ReservCreated extends ReservedState {
  final String reservationId;
  final String car_id;
  final String parking_slot_id;

  ReservCreated(this.car_id, this.parking_slot_id, this.reservationId);
}

class ReservedError extends ReservedState {
  // State ที่โหลดข้อมูลไม่สำเร็จ จะมี error message ในนี้
  final String message;

  // สร้าง Constructor รับค่า message
  const ReservedError(this.message);

  @override
  List<Object> get props => [message];
}

class ReservedSuccess extends ReservedState {
  // State ที่โหลดข้อมูลไม่สำเร็จ จะมี error message ในนี้
  final String reservationId;
  final String message;

  // สร้าง Constructor รับค่า message
  ReservedSuccess({required this.reservationId, required this.message});

  @override
  List<Object> get props => [message];
}

// State ที่โหลดข้อมูลไม่สำเร็จ จะมี error message ในนี้
class ReservationCancelled extends ReservedState {
  final String message;

  ReservationCancelled(this.message);
}
