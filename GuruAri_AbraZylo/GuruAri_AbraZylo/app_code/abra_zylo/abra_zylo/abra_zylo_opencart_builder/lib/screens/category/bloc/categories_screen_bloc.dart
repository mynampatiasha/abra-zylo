import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/models/catalog/catalog_model.dart';
import 'package:oc_demo/models/catalog/request/catalog_product_request.dart';
import 'package:oc_demo/models/sub_category/sub_category_model.dart';

import '../../../models/productDetail/add_product_wishlist_model.dart';
import 'categories_screen_repository.dart';

part 'categories_screen_event.dart';

part 'categories_screen_state.dart';

class CategoriesScreenBloc
    extends Bloc<CategoriesScreenEvent, CategoriesScreenState> {
  CategoriesScreenRepository? repository;

  CategoriesScreenBloc({this.repository}) : super(CategoriesInitialState()) {
    on<CategoriesScreenEvent>(mapEventToState);
  }

  void mapEventToState(
      CategoriesScreenEvent event, Emitter<CategoriesScreenState> emit) async {
    emit(CategoriesInitialState());
    if (event is FetchCategoriesEvent) {
      try {
        //hive db
        var model = await repository?.getCategoriesDataFromDb(event.id ?? '');
        if (model != null) {
          emit(CategoriesFetchState(model));
        }
        //api
        model = await repository?.getCategoriesData(
            event.id ?? '', model?.eTag ?? "");
        if (model != null) {
          emit(CategoriesFetchState(model));
        } else {
          emit(CategoriescreenErrorState(''));
        }
      } catch (error, _) {
        emit(CategoriescreenErrorState(error.toString()));
      }
    } else if (event is OnClickWishListLoaderEvent) {
      emit(OnClickWishListLoaderState(
          isReqToShowLoader: event.isReqToShowLoader));
    } else if (event is FetchProductsEvent) {
      try {
        //hive db
        var model = await repository?.getCatalogProductsFromDb(event.request);

        if (model != null) {
          emit(ProductsFetchState(model));
        }
        //api
        model = await repository?.getCatalogProducts(
            event.request, model?.eTag ?? "");

        if (model != null) {
          emit(ProductsFetchState(model));
        } else {
          emit(CategoriescreenErrorState(''));
        }
      } catch (error, stack) {
        print('Rishabh ' + stack.toString());
        emit(CategoriescreenErrorState(error.toString()));
      }
    } else if (event is AddToWishlistEvent) {
      try {
        var model = await repository?.addToWishList(event.productId ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductToWishlistStateSuccess(model, event.productId ?? ''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(CategoriescreenErrorState(error.toString()));
      }
    }
  }
}
