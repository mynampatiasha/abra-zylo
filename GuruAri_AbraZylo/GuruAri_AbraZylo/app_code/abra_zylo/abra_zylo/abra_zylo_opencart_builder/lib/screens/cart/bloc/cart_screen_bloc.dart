import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/cart/cart_shipping_model.dart';
import 'package:oc_demo/models/cart/country_data_model.dart';

import '../../../models/cart/cart_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';
import 'cart_screen_repository.dart';

part 'cart_screen_event.dart';

part 'cart_screen_state.dart';

class CartScreenBloc extends Bloc<CartScreenEvent, CartScreenState> {
  CartScreenRepository? repository;

  CartScreenBloc({this.repository}) : super(CartScreenStateInitial()) {
    on<CartScreenEvent>(mapEventToState);
  }

  void mapEventToState(
    CartScreenEvent event,
    Emitter<CartScreenState> emit,
  ) async {
    switch (event.runtimeType) {
      case CartScreenDataFetchEvent: //While fetching cart detail
        try {
          var model = await repository?.getCartData();
          if (model != null) {
            emit(CartScreenSuccess(model));
          } else {
            emit(CartScreenError(""));
          }
        } catch (error, stack) {
          print(stack.toString());
          emit(CartScreenError(error.toString()));
        }
        break;

      case CartScreenRemoveItemEvent: // While removing item from cart page
        try {
          var model = await repository
              ?.removeItemFromCart((event as CartScreenRemoveItemEvent).key);
          if (model != null) {
            emit(RemoveCartItemSuccess(model));
          } else {
            emit(CartScreenError(""));
          }
        } catch (error, stack) {
          print(stack.toString());
          emit(CartScreenError(error.toString()));
        }
        break;

      case EmptyCartEvent: // while removing all product from cart
        try {
          var model = await repository?.emptyCart();
          if (model != null) {
            emit(EmptyCartSuccess(model));
          } else {
            emit(CartScreenError(""));
          }
        } catch (error, stack) {
          print(stack.toString());
          emit(CartScreenError(error.toString()));
        }
        break;

      case ApplyCouponEvent: // while applying coupon on cart page
        try {
          var model = await repository
              ?.applyCoupon((event as ApplyCouponEvent).applyCoupon);
          if (model != null && model.error == 0) {
            emit(ApplyCouponSuccess(model));
          } else {
            emit(CartScreenError(model?.message));
          }
        } catch (error, stack) {
          print(stack.toString());
          emit(CartScreenError(error.toString()));
        }
        break;
      case ApplyVoucherEvent: // while applying voucher on cart page
        try {
          var model = await repository
              ?.applyVoucher((event as ApplyVoucherEvent).applyVoucher);
          if (model != null && model.error == 0) {
            emit(ApplyVoucherSuccess(model));
          } else {
            emit(CartScreenError(model?.message));
          }
        } catch (error, stack) {
          print(stack.toString());
          emit(CartScreenError(error.toString()));
        }
        break;
      case ApplyRewardEvent: // While applying rewards on cart page
        try {
          var model = await repository
              ?.applyRewards((event as ApplyRewardEvent).reward);
          if (model != null && model.error == 0) {
            emit(ApplyVoucherSuccess(model));
          } else {
            emit(CartScreenError(model?.message));
          }
        } catch (error, stack) {
          print(stack.toString());
          emit(CartScreenError(error.toString()));
        }
        break;
      case CartUpdateEvent: // While updating the cart
        try {
          var model = await repository
              ?.updateCartData((event as CartUpdateEvent).quantityJson);
          if (model != null && model.error == 0) {
            emit(UpdateCartSuccess(model));
          } else {
            emit(CartScreenError(model?.message ?? ""));
          }
        } catch (error, stack) {
          print(stack.toString());
          emit(CartScreenError(error.toString()));
        }
        break;
      /*
    * For Adding product to wishlist
    * */
      case AddProductToWishListEvent:
        try {
          var model = await repository?.addProductToWishList(
              (event as AddProductToWishListEvent).productId ?? "");
          if (model != null && model.error == 0) {
            emit(AddProductToWishlistStateSuccess(model));
          } else {
            emit(CartScreenError(model?.message ?? ""));
          }
        } catch (error, _) {
          print(error.toString());
          emit(CartScreenError(error.toString()));
        }
        break;
/*------------------------------Estimate shipping and taxes ------------------------------*/
      case GetCountryDataEvent:
        try {
          var model = await repository?.getCountryData();
          if (model != null && model.error == 0) {
            emit(GetCountryDataStateSuccess(model));
          } else {
            emit(CartScreenError(model?.message ?? ""));
          }
        } catch (error, stack) {
          print(stack.toString());
          emit(CartScreenError(error.toString()));
        }
        break;
      case GetShippingMethodEvent:
        try {
          var model = await repository?.getShipping(
              (event as GetShippingMethodEvent).countryId,
              (event as GetShippingMethodEvent).zoneId,
              (event as GetShippingMethodEvent).postCode);
          if (model != null && model.error == 0) {
            emit(GetShippingMethodStateSuccess(model));
          } else {
            emit(CartScreenError(model?.message ?? ""));
          }
        } catch (error, stack) {
          print(stack.toString());
          emit(CartScreenError(error.toString()));
        }
        break;
      case ApplyShippingEvent:
        try {
          var model = await repository
              ?.applyShipping((event as ApplyShippingEvent).shippingMethod);
          if (model != null && model.error == 0) {
            emit(ApplyShippingStateSuccess(model));
          } else {
            emit(CartScreenError(model?.message ?? ""));
          }
        } catch (error, stack) {
          print(stack.toString());
          emit(CartScreenError(error.toString()));
        }
        break;
      default:
        break;
    }
  }
}
