import 'package:flutter_bloc/flutter_bloc.dart';
import 'compare_product_events.dart';
import 'compare_product_repository.dart';
import 'compare_product_state.dart';

class CompareProductBloc
    extends Bloc<CompareProductEvent, CompareProductState> {
  CompareProductRepository? repository;

  CompareProductBloc({this.repository}) : super(CompareProductInitial()) {
    on<CompareProductEvent>(mapEventToState);
  }

  void mapEventToState(
      CompareProductEvent event, Emitter<CompareProductState> emit) async {
    if (event is CompareProductDataFetchEvent) {
      try {
        var model = await repository?.getCompareProductDetails();
        if (model != null) {
          emit(CompareProductSuccess(model));
        } else {
          emit(CompareProductError(model?.message));
        }
      } catch (error, _) {
        print(error.toString());
        emit(CompareProductError(error.toString()));
      }
    } else if (event is AddToWishlistEvent) {
      emit(CompareProductInitial());
      try {
        var model = await repository?.addRemoveWishlistProduct(
            event.productId ?? "", "");
        if (model != null) {
          emit(AddToWishlistStates(model, event.position));
        }
      } catch (error, _) {
        print(error.toString());
        emit(CompareProductError(error.toString()));
      }
    } else if (event is RemoveFromCompareEvent) {
      emit(CompareProductInitial());
      try {
        var model = await repository?.removeFromCompare(event.productId ?? "");
        if (model != null) {
          emit(RemoveFromCompareStateSuccess(
              model, event.productId ?? '', event.index ?? 0));
        }
      } catch (error, _) {
        print(error.toString());
        emit(CompareProductError(error.toString()));
      }
    } else if (event is AddProductToCartEvent) {
      emit(CompareProductInitial());
      try {
        try {
          var model = await repository?.addProductToCart(event.productId ?? "",
              event.quantity ?? "", event.productOptions ?? "");
          if (model != null && model.error == 0) {
            emit(AddProductToCartSuccess(model));
          } else {
            emit(CompareProductError(model?.message ?? ""));
          }
        } catch (error, _) {
          print(error.toString());
          emit(CompareProductError(error.toString()));
        }
      } catch (error, _) {
        print(error.toString());
        emit(CompareProductError(error.toString()));
      }
    }
  }
}
