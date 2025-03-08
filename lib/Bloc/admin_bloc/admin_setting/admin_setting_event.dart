part of 'admin_setting_bloc.dart';

sealed class AdminSettingEvent {}

final class OnSettingPageLoad extends AdminSettingEvent {}

class OnUpdatePriceRate extends AdminSettingEvent {
  final  charge_rate;
  OnUpdatePriceRate({required this.charge_rate});
}

class OnUpdatePassword extends AdminSettingEvent {
  final String old_password;
  final String new_password;
  final String confirm_password;

  OnUpdatePassword({
    required this.old_password,
    required this.new_password,
    required this.confirm_password,
  });
}
