import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/sub_category_screen/bloc/subcategory_screen_repository.dart';
import 'package:oc_demo/screens/sub_category_screen/bloc/subcategory_screen_state.dart';

import 'subcategory_screen_event.dart';

class SubcategoryBloc
    extends Bloc<SubCategoryScreenEvent, SubCategoryBaseState> {
  SubCategoryRepository? repository;

  SubcategoryBloc({this.repository}) : super(SubCategoryInitialState()) {
    on<SubCategoryScreenEvent>(mapEventToState);
  }

  void mapEventToState(
      SubCategoryScreenEvent event, Emitter<SubCategoryBaseState> emit) async {
    if (event is SubCategoryScreenDatFetchEvent) {
      try {
        //hive db
        var model = await repository?.getCategoriesDataFromDb(event.categoryId);
        if (model != null) {
          emit(SubCategorySuccessState(model));
        }
        //api
        model = await repository?.getSubCategoryData(
            event.categoryId, model?.eTag ?? "");
        if (model != null) {
          emit(SubCategorySuccessState(model));
        } else {
          emit(SubCategoryErrorState(''));
        }
      } catch (error, _) {
        emit(SubCategoryErrorState(error.toString()));
      }
    } else if (event is SubCategoriesProductEvent) {
      try {
        var model = await repository?.getCatalogProductsFromDb(event.request);
        if (model != null) {
          emit(SubCategoriesProductState(model));
        }
        model = await repository?.getCategoryProducts(
            event.request, model?.eTag ?? "");
        if (model != null) {
          emit(SubCategoriesProductState(model));
        } else {
          emit(SubCategoryErrorState(''));
        }
      } catch (error, _) {
        emit(SubCategoryErrorState(error.toString()));
      }
    } else if (event is AddToWishlistEvent) {
      try {
        var model = await repository?.addToWishList(event.productId ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductToWishlistStateSuccess(model, event.productId ?? ''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(SubCategoryErrorState(error.toString()));
      }
    }
  }
}
