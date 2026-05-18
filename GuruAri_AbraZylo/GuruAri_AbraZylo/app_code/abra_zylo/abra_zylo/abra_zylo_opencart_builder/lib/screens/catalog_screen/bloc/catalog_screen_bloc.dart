import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/models/catalog/brand/manufacture_model.dart';
import 'package:oc_demo/screens/catalog_screen/bloc/catalog_screen_state.dart';

import 'catalog_screen_event.dart';
import 'catalog_screen_repository.dart';

class CatalogScreenBloc extends Bloc<CatalogScreenEvent, CatalogScreenState> {
  CatalogRepository? repository;

  CatalogScreenBloc({this.repository}) : super(CatalogInitialState()) {
    on<CatalogScreenEvent>(mapEventToState);
  }

  void mapEventToState(
      CatalogScreenEvent event, Emitter<CatalogScreenState> emit) async {
    if (event is FetchCatalogEvent) {
      try {
        //hive db
        var model = await repository?.getCatalogProductsFromDb(event.request);

        if (model != null) {
          emit(CatalogFetchState(model, true));
        }
        //api
        model = await repository?.getCatalogProducts(
            event.request, model?.eTag ?? "");
        //var model = await repository?.getCatalogProducts(event.request);

        if (model != null) {
          emit(CatalogFetchState(model, false));
        } else {
          emit(CatalogErrorState(''));
        }
      } catch (error, stack) {
        print("Rishabh");
        print(stack);
        print(error);
        emit(CatalogErrorState(error.toString()));
      }
    } else if (event is FetchCatalogBrandEvent) {
      try {
        ManufactureModel? cacheModel =
            await repository?.getManufactureDetailsFromDb(event.request);
        if (cacheModel != null) {
          emit(BrandFetchState(cacheModel, true));
        }

        cacheModel = await repository?.getManufactureDetails(
            event.request, cacheModel?.eTag ?? "");

        if (cacheModel != null) {
          emit(BrandFetchState(cacheModel, false));
        } else {
          emit(CatalogErrorState(''));
        }
      } catch (error, _) {
        emit(CatalogErrorState(error.toString()));
      }
    } else if (event is FetchPopularEvent) {
      try {
        var cacheModel =
            await repository?.getPopularProductsFromDb(event.request);

        if (cacheModel != null) {
          emit(CatalogFetchState(cacheModel, true));
        }

        cacheModel = await repository?.getPopularProducts(
            event.request, cacheModel?.eTag);
        if (cacheModel != null) {
          emit(CatalogFetchState(cacheModel, false));
        } else {
          emit(CatalogErrorState(''));
        }
      } catch (error, _) {
        emit(CatalogErrorState(error.toString()));
      }
    } else if (event is FetchBestEvent) {
      try {
        var cacheModel = await repository?.getBestProductsFromDb(event.request);

        if (cacheModel != null) {
          emit(CatalogFetchState(cacheModel, true));
        }
        cacheModel =
            await repository?.getBestProducts(event.request, cacheModel?.eTag);

        if (cacheModel != null) {
          emit(CatalogFetchState(cacheModel, false));
        } else {
          emit(CatalogErrorState(''));
        }
      } catch (error, _) {
        emit(CatalogErrorState(error.toString()));
      }
    } else if (event is FetchFeatureEvent) {
      try {
        var model = await repository?.getFeatureProductsFromDb(event.request);

        if (model != null) {
          emit(CatalogFetchState(model, true));
        }
        model = await repository?.getFeaturedProducts(
            event.request, model?.eTag ?? "");

        if (model != null) {
          emit(CatalogFetchState(model, false));
        } else {
          emit(CatalogErrorState(''));
        }
      } catch (error, _) {
        emit(CatalogErrorState(error.toString()));
      }
    } else if (event is FetchLatestEvent) {
      try {
        var model = await repository?.getLatestProductsFromDb(event.request);

        if (model != null) {
          emit(CatalogFetchState(model, true));
        }
        model = await repository?.getLatestProduct(
            event.request, model?.eTag ?? "");

        if (model != null) {
          emit(CatalogFetchState(model, false));
        } else {
          emit(CatalogErrorState(''));
        }
      } catch (error, _) {
        emit(CatalogErrorState(error.toString()));
      }
    } else if (event is FetchCustomCollection) {
      var model = await repository?.getCustomCollection(event.request);
      try {
        if (model != null) {
          emit(CatalogFetchState(model, false));
        } else {
          emit(CatalogErrorState(''));
        }
      } catch (error, _) {
        emit(CatalogErrorState(error.toString()));
      }
    } else if (event is LoadingEvent) {
      emit(CatalogInitialState());
    } else if (event is ChangeViewEvent) {
      emit(ChangeViewState(event.isGrid));
    }
    if (event is FetchCarouselsEvent) {
      var model = await repository?.getCarouselProducts(event.request);
      try {
        if (model != null) {
          emit(CatalogFetchState(model, false));
        } else {
          emit(CatalogErrorState(''));
        }
      } catch (error, _) {
        emit(CatalogErrorState(error.toString()));
      }
    } else if (event is AddToWishlistEvent) {
      try {
        var model = await repository?.addToWishList(event.productId ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductToWishlistStateSuccess(model, event.productId ?? ''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(CatalogErrorState(error.toString()));
      }
    } else if (event is GetSearchResultEvent) {
      try {
        var model = await repository?.getSearchResult(
            event.search ?? "", event.category_id ?? "");
        if (model != null) {
          if (event.currentSearch == event.search) {
            emit(GetSearchStateSuccess(model, event.search ?? ""));
          }
        }
      } catch (e) {
        emit(CatalogErrorState(e.toString()));
      }
    }
  }
}
