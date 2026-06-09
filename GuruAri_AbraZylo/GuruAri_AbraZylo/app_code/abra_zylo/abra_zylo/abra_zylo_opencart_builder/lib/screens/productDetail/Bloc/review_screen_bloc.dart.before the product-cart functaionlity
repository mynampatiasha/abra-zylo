import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_event.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_repository.dart';
import 'package:oc_demo/screens/productDetail/Bloc/review_screen_state.dart';

class ReviewScreenBloc
    extends Bloc<ProductDetailScreenEvent, ReviewScreenState> {
  ProductDetailRepository? repository;

  ReviewScreenBloc({this.repository}) : super(ReviewScreenInitial()) {
    on<ProductDetailScreenEvent>(mapEventToState);
  }

  void mapEventToState(
      ProductDetailScreenEvent event, Emitter<ReviewScreenState> emit) async {
    /*
    * For getting product review
    *
    * */

    if (event is GetProductReviewEvent) {
      try {
        var model = await repository?.getProductReview(
            event.productId ?? "", event.page ?? "");
        if (model != null) {
          emit(GetProductReviewStateSuccess(model));
        } else {
          emit(ReviewScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ReviewScreenError(error.toString()));
      }
    }
  }
}
