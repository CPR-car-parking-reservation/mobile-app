part of 'admin_setting_bloc.dart';

sealed class AdminSettingState {}

final class AdminSettingInitial extends AdminSettingState {}

final class AdminSettingLoading extends AdminSettingState {}

final class AdminSettingSuccess extends AdminSettingState {
  final String message;
  AdminSettingSuccess({required this.message});
}

final class AdminSettingFailed extends AdminSettingState {
  final String message;
  AdminSettingFailed({required this.message});
}

final class AdminSettingChangeRatePrice extends AdminSettingState {
  final charge_rate;
  AdminSettingChangeRatePrice({required this.charge_rate});
}
