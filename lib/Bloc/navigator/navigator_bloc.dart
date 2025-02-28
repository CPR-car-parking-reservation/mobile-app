import 'package:bloc/bloc.dart';

part 'navigator_event.dart';
part 'navigator_state.dart';

class NavigatorBloc extends Bloc<NavigatorBlocEvent, NavigatorBlocState> {
  NavigatorBloc() : super(NavigatorBlocStateInitial(index: 0)) {
    on<ChangeIndex>((event, emit) {
      emit(NavigatorBlocStateUpdate(index: event.index));
    });
  }
}
