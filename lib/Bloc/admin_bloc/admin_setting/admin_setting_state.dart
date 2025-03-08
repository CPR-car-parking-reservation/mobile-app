part of 'admin_setting_bloc.dart';

sealed class AdminSettingState {
  const AdminSettingState();

}

final class AdminSettingInitial extends AdminSettingState {}

final class AdminSettingLoading extends AdminSettingState {}


final class AdminSettingChangeRatePrice extends AdminSettingState {
  final String ratePrice;

  const AdminSettingChangeRatePrice({required this.ratePrice});
}

final class AdminSettingChangePassword extends AdminSettingState {
  final String password;
  final String newPassword;
  final String confirmPassword;

  const AdminSettingChangePassword({
    required this.password,
    required this.newPassword,
    required this.confirmPassword,
  });
}

final class AdminSettingSuccess extends AdminSettingState {
  final String message;

  const AdminSettingSuccess({required this.message});
}

final class AdminSettingFailed extends AdminSettingState {
  final String message;

  AdminSettingFailed({required this.message});
}
