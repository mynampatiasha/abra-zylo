import 'package:flutter_bloc/flutter_bloc.dart';

import 'brand_screen_event.dart';
import 'brand_screen_repository.dart';
import 'brand_screen_state.dart';

class BrandScreenBloc extends Bloc<BrandScreenEvent, BrandScreenState> {
  BrandScreenRepositoryImp? repository;

  BrandScreenBloc({this.repository}) : super(BrandScreenStateInitial()) {
    on<BrandScreenEvent>(mapEventToState);
  }

  void mapEventToState(
      BrandScreenEvent event, Emitter<BrandScreenState> emit) async {
    emit(BrandScreenStateInitial());
    switch (event.runtimeType) {
      case BrandScreenFetchCarousel:
        try {
          var model = await repository?.getCarouselProducts(
              (event as BrandScreenFetchCarousel).request);
          if (model != null) {
            emit(BrandScreenStateSuccess(model));
          } else {
            emit(BrandScreenStateError(''));
          }
        } catch (error, _) {
          print(error.toString());
          emit(BrandScreenStateError(error.toString()));
        }
        break;
    }
  }
}
