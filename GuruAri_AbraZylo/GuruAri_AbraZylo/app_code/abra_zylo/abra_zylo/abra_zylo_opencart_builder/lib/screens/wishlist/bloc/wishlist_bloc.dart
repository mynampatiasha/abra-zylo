import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/wishlist/bloc/wishlist_event.dart';
import 'package:oc_demo/screens/wishlist/bloc/wishlist_repository.dart';
import 'package:oc_demo/screens/wishlist/bloc/wishlist_state.dart';

class WishlistScreenBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistRepository? repository;

  WishlistScreenBloc({this.repository}) : super(WishlistInitialState()) {
    on<WishlistEvent>(mapEventToState);
  }

  @override
  void mapEventToState(WishlistEvent event, Emitter<WishlistState> emit) async {
    if (event is WishlistDataFetchEvent) {
      try {
        var model = await repository?.getWishListFromDb();
        if (model != null) {
          emit(WishlistScreenSuccess(model));
        }
        model = await repository?.getWishlistItems(model?.eTag ?? "");
        if (model != null) {
          emit(WishlistScreenSuccess(model));
        } else {
          emit(WishlistScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        print(_.toString());
        emit(WishlistScreenError(error.toString()));
      }
    } else if (event is MoveToCartEvent) {
      try {
        var model = await repository?.moveToCart(event.productId ?? "",
            event.quantity ?? "", event.productOptions ?? "");
        if (model != null && model.error == 0) {
          emit(MoveToCartSuccess(model));
        } else {
          emit(WishlistScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(WishlistScreenError(error.toString()));
      }
    } else if (event is RemoveItemEvent) {
      try {
        var model = await repository?.removeFromWishlist(event.productId);
        if (model != null && model.error != 1) {
          emit(RemoveItemSuccess(model));
        } else {
          emit(WishlistScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(WishlistScreenError(error.toString()));
      }
    } else if (event is ShareWishlistCollectionEvent) {
      emit(WishlistInitialState());
      try {
        var model = await repository?.shareWishlist(event.email ?? "");
        if (model != null && model.error != 1) {
          emit(WishlistShareCollectionSuccess(model));
        } else {
          emit(WishlistScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(WishlistScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 2), () {
        emit(WishlistCompleteState());
      });
    }
  }
}
