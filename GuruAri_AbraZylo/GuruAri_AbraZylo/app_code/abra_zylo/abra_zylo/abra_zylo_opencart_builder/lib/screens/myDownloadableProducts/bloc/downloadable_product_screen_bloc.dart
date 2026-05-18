import 'package:flutter_bloc/flutter_bloc.dart';

import 'downloadable_product_screen_events.dart';
import 'downloadable_product_screen_repository.dart';
import 'downloadable_product_screen_state.dart';

class DownloadableProductScreenBloc extends Bloc<DownloadableProductScreenEvent,
    DownloadableProductScreenState> {
  DownloadableProductScreenRepositoryImp? repository;

  DownloadableProductScreenBloc({this.repository})
      : super(DownloadableProductScreenInitial()) {
    on<DownloadableProductScreenEvent>(mapEventToState);
  }

  void mapEventToState(DownloadableProductScreenEvent event,
      Emitter<DownloadableProductScreenState> emit) async {
    if (event is DownloadableProductScreenDataFetchEvent) {
      emit(DownloadableProductScreenInitial());
      try {
        var model = await repository?.getDownloadableProducts(event.page);
        if (model != null) {
          emit(DownloadableProductScreenSuccess(model));
        } else {
          emit(const DownloadableProductScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(DownloadableProductScreenError(error.toString()));
      }
    }
  }
}
