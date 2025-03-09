part of 'qr_bloc_bloc.dart';

sealed class QrBlocEvent {
  const QrBlocEvent();

  @override
  List<Object> get props => [];
}

final class FetchQr extends QrBlocEvent {}
