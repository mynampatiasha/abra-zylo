import 'package:flutter_bloc/flutter_bloc.dart';

import 'return_order_screen_events.dart';
import 'return_order_screen_repository.dart';
import 'return_order_screen_state.dart';

class ReturnOrderScreenBloc
    extends Bloc<ReturnOrderScreenEvent, ReturnOrderScreenState> {
  ReturnOrderScreenRepositoryImp? repository;

  ReturnOrderScreenBloc({this.repository}) : super(ReturnOrderScreenInitial()) {
    on<ReturnOrderScreenEvent>(mapEventToState);
  }

  void mapEventToState(ReturnOrderScreenEvent event,
      Emitter<ReturnOrderScreenState> emit) async {
    if (event is ReturnOrderScreenDataFetchEvent) {
      emit(ReturnOrderScreenInitial());
      try {
        var model = await repository?.getReturnFromDb(event.page);
        if (model != null) {
          emit(ReturnOrderScreenSuccess(model));
        }
        model =
            await repository?.getReturnOrders(event.page, model?.eTag ?? "");
        if (model != null) {
          emit(ReturnOrderScreenSuccess(model));
        } else {
          emit(const ReturnOrderScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ReturnOrderScreenError(error.toString()));
      }
    }
  }
}
