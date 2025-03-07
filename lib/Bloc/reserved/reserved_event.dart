part of 'reserved_bloc.dart';

abstract class ReservedEvent {}

class SendReservation extends ReservedEvent {
  final String car_id;
  final String parking_slot_id;
  final String start_at;

  SendReservation(this.car_id, this.parking_slot_id, this.start_at);
}


// event สำหรับยกเลิกการจอง
class CancelReservation extends ReservedEvent {
  final String reservationId;

  CancelReservation(this.reservationId);
}

final class FectchFirstReserved
    extends ReservedEvent {} // สร้าง Event เพื่อเรียกข้อมูลครั้งแรก

// final class FetchAllReservation extends ReservedEvent {} /// สร้าง Event เพื่อเรียกข้อมูลทั้งหมด
