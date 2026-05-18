import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_event.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_repository.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_state.dart';

import '../../../models/productDetail/product_detail_screen_model.dart';

class ProductDetailBloc
    extends Bloc<ProductDetailScreenEvent, ProductDetailScreenState> {
  ProductDetailRepository? repository;

  ProductDetailBloc({this.repository}) : super(ProductDetailStateInitial()) {
    on<ProductDetailScreenEvent>(mapEventToState);
  }

  @override
  void mapEventToState(ProductDetailScreenEvent event,
      Emitter<ProductDetailScreenState> emit) async {
    /*
    * For Getting Product Detail
    * */
    // if (event is GetProductDetailEvent) {
    //   try {
    //     var model =
    //         await repository?.getProductDetail(event.productId ?? "", "","");
    //
    //     if (model != null) {
    //
    //       emit(ProductDetailStateSuccess(model));
    //     } else {
    //       emit(ProductDetailStateError(''));
    //     }
    //   } catch (error, stackTrace) {
    //     // Print the error with a detailed stack trace
    //     print('Error: ${error.toString()}');
    //     print('StackTrace: ${stackTrace.toString()}');
    //
    //     // Extract the file and line number from the stack trace
    //     final traceString = stackTrace.toString().split('\n').first;
    //     print('Trace Info: $traceString');
    //
    //     emit(ProductDetailStateError('Error: ${error.toString()} \nTrace Info: $traceString'));
    //   }
    //
    // }
    if (event is GetProductDetailEvent) {
      try {
        final box = await Hive.openBox('productBox');
        final cachedJson = box.get('product_${event.productId}');

        // Step 1: Emit cached data if available
        if (cachedJson != null) {
          final cachedModel =
              ProductDetailScreenModel.fromJson(jsonDecode(cachedJson));
          emit(ProductDetailStateSuccess(cachedModel));
        }

        // Step 2: Fetch fresh data from API
        final model =
            await repository?.getProductDetail(event.productId ?? "", "", "");

        if (model != null) {
          // Step 3: Cache the fresh data
          await box.put(
              'product_${event.productId}', jsonEncode(model.toJson()));

          // Step 4: Emit fresh data
          emit(ProductDetailStateSuccess(model));
        } else if (cachedJson == null) {
          emit(ProductDetailStateError('No product data found'));
        }
      } catch (error, stackTrace) {
        print('Error: ${error.toString()}');
        print('StackTrace: ${stackTrace.toString()}');

        final traceString = stackTrace.toString().split('\n').first;
        print('Trace Info: $traceString');

        emit(ProductDetailStateError(
            'Error: ${error.toString()} \nTrace Info: $traceString'));
      }
    }

    /*
    * For adding product review
    *
    * */

    if (event is AddProductReviewEvent) {
      try {
        var model = await repository?.addProductReview(
            event.name ?? "",
            event.productId ?? "",
            event.reviewComment ?? "",
            event.rating ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductReviewStateSuccess(model));
        } else {
          emit(ProductDetailStateError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ProductDetailStateError(error.toString()));
      }
    }
    if (event is AddListProductToWishListEvent) {
      try {
        var model =
            await repository?.addProductToWishList(event.productId ?? "");
        if (model != null && model.error == 0) {
          emit(AddListProductToWishlistStateSuccess(
              model, event.productId ?? ""));
        } else {
          emit(ProductDetailStateError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ProductDetailStateError(error.toString()));
      }
    }

    /*
    * For adding product to cart
    *
    * */

    if (event is AddProductToCartEvent) {
      try {
        var model = await repository?.addProductToCart(event.productId ?? "",
            event.quantity ?? "", event.productOptions ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductToCartStateSuccess(model));
        } else {
          emit(ProductDetailStateError(model?.message ?? ""));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ProductDetailStateError(error.toString()));
      }
    }
    /*
    * For buy product
    * */

    if (event is BuyNowEvent) {
      try {
        var model = await repository?.addProductToCart(event.productId ?? "",
            event.quantity ?? "", event.productOptions ?? "");
        if (model != null && model.error == 0) {
          emit(BuyProductStateSuccess(model));
        } else {
          emit(ProductDetailStateError(model?.message ?? ""));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ProductDetailStateError(error.toString()));
      }
    }

    /*
    * For Adding product to wishlist
    * */

    if (event is AddProductToWishListEvent) {
      try {
        var model =
            await repository?.addProductToWishList(event.productId ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductToWishlistStateSuccess(model));
        } else {
          emit(ProductDetailStateError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ProductDetailStateError(error.toString()));
      }
    }
    /*
    * For Adding product to compare
    * */

    if (event is AddCompareProduct) {
      try {
        var model = await repository?.addCompareProduct(event.productId ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductCompareSuccessState(model));
        } else {
          emit(ProductDetailStateError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ProductDetailStateError(error.toString()));
      }
    }
  }
}
