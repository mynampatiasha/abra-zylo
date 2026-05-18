import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_review_screen_event.dart';
import 'add_review_screen_repository.dart';
import 'add_review_screen_state.dart';

class AddReviewScreenBloc extends Bloc<AddReviewEvent, AddReviewScreenState> {
  AddReviewRepositoryImp? repository;

  AddReviewScreenBloc({this.repository}) : super(AddReviewInitialState()) {
    on<AddReviewEvent>(mapEventToState);
  }

  void mapEventToState(
      AddReviewEvent event, Emitter<AddReviewScreenState> emit) async {
    if (event is AddReviewSaveEvent) {
      emit(AddReviewLoadingState());
      try {
        var model = await repository?.addReview(
            event.name ?? "",
            event.productId ?? "",
            event.reviewComment ?? "",
            event.rating ?? "");
        if (model != null && model.error == 0) {
          emit(AddReviewSuccessState(model));
        } else {
          emit(AddReviewErrorState(model?.message ?? ""));
        }
      } catch (error, _) {
        print(error.toString());
        emit(AddReviewErrorState(error.toString()));
      }
    }
  }
}
