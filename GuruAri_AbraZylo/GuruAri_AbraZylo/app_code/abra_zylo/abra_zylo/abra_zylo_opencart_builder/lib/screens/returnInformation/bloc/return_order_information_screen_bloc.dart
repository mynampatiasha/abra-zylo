import 'package:flutter_bloc/flutter_bloc.dart';

import 'return_order_information_screen_events.dart';
import 'return_order_information_screen_repository.dart';
import 'return_order_information_screen_state.dart';

class ReturnOrderInformationScreenBloc extends Bloc<
    ReturnOrderInformationScreenEvent, ReturnOrderInformationScreenState> {
  ReturnOrderInformationScreenRepositoryImp? repository;

  ReturnOrderInformationScreenBloc({this.repository})
      : super(ReturnOrderInformationScreenInitial()) {
    on<ReturnOrderInformationScreenEvent>(mapEventToState);
  }

  void mapEventToState(ReturnOrderInformationScreenEvent event,
      Emitter<ReturnOrderInformationScreenState> emit) async {
    if (event is ReturnOrderInformationScreenDataFetchEvent) {
      emit(ReturnOrderInformationScreenInitial());
      try {
        var model = await repository?.getReturnOrderDetail(event.id ?? "");
        if (model != null) {
          emit(ReturnOrderInformationScreenSuccess(model));
        } else {
          emit(const ReturnOrderInformationScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ReturnOrderInformationScreenError(error.toString()));
      }
    }
  }
}
