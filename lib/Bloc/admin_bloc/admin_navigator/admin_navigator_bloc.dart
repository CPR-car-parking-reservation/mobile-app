import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'admin_navigator_event.dart';
part 'admin_navigator_state.dart';

class AdminNavigatorBloc
    extends Bloc<AdminNavigatorEvent, AdminNavigatorState> {
  AdminNavigatorBloc() : super(AdminNavigatorInitial(index: 0)) {
    on<OnChangeIndex>((event, emit) {
      emit(AdminNavigatorInitial(index: event.index)); // ← Emit state ใหม่
    });
  }
}
