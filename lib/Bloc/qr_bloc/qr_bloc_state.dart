part of 'qr_bloc_bloc.dart';

sealed class QrBlocState {
  const QrBlocState();

  @override
  List<Object> get props => [];
}

final class QrBlocInitial extends QrBlocState {}

final class QrBlocLoading extends QrBlocState {}

final class QrBlocLoaded extends QrBlocState {
  final String reservationId;

  const QrBlocLoaded({required this.reservationId});

  @override
  List<Object> get props => [reservationId];
}

final class QrBlocError extends QrBlocState {
  final String message;

  const QrBlocError(this.message);

  @override
  List<Object> get props => [message];
}
