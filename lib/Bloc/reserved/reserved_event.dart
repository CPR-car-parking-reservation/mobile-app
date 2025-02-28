part of 'reserved_bloc.dart';

@immutable
abstract class ReservedEvent {}

class SendReservation extends ReservedEvent {
  // ส่งตัวแปรในตาราง History_data
  final History_data history;

  SendReservation(this.history);

  @override
  List<Object> get props => [history];
}

final class FectchFirstReserved
    extends ReservedEvent {} // สร้าง Event เพื่อเรียกข้อมูลครั้งแรก

final class FetchAllReservation extends ReservedEvent {} /// สร้าง Event เพื่อเรียกข้อมูลทั้งหมด