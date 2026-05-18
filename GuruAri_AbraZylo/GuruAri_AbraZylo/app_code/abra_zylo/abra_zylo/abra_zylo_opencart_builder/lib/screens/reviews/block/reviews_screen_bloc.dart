/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/reviews/block/reviews_screen_events.dart';
import 'package:oc_demo/screens/reviews/block/reviews_screen_repository.dart';
import 'package:oc_demo/screens/reviews/block/reviews_screen_state.dart';

class ReviewsScreenBloc extends Bloc<ReviewsScreenEvent, ReviewsScreenState> {
  ReviewsScreenRepositoryImp? repository;

  ReviewsScreenBloc({this.repository}) : super(ReviewsScreenInitial()) {
    on<ReviewsScreenEvent>(mapEventToState);
  }

  void mapEventToState(
      ReviewsScreenEvent event, Emitter<ReviewsScreenState> emit) async {
    if (event is ReviewsScreenDataFetchEvent) {
      emit(ReviewsScreenInitial());
      try {
        var model = await repository?.getReviewsList(event.page);
        if (model != null) {
          emit(ReviewsScreenSuccess(model));
        } else {
          emit(const ReviewsScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ReviewsScreenError(error.toString()));
      }
    }
  }
}
