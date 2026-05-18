part of 'cart_screen_bloc.dart';

abstract class CartScreenEvent extends Equatable {
  const CartScreenEvent();

  @override
  List<Object> get props => [];
}

/*
* Fetch cart details from server event
* */
class CartScreenDataFetchEvent extends CartScreenEvent {
  const CartScreenDataFetchEvent();
}

/*
* remove any item from cart event
* */
class CartScreenRemoveItemEvent extends CartScreenEvent {
  const CartScreenRemoveItemEvent(this.key);

  final String key;

  @override
  List<Object> get props => [key];
}

/*
* Update cart event
* */
class CartUpdateEvent extends CartScreenEvent {
  const CartUpdateEvent(this.quantityJson);

  final String quantityJson;

  @override
  List<Object> get props => [quantityJson];
}

/*
* To empty the cart event
* */
class EmptyCartEvent extends CartScreenEvent {
  const EmptyCartEvent();

  @override
  List<Object> get props => [];
}

/*
* Apply voucher on cart page event .
* */
class ApplyVoucherEvent extends CartScreenEvent {
  const ApplyVoucherEvent(this.applyVoucher);

  final String applyVoucher;

  @override
  List<Object> get props => [applyVoucher];
}

/*
* Event to apply coupon on cart page
* */
class ApplyCouponEvent extends CartScreenEvent {
  const ApplyCouponEvent(this.applyCoupon);

  final String applyCoupon;

  @override
  List<Object> get props => [applyCoupon];
}

/*
* Event to apply rewards on cart page
* */
class ApplyRewardEvent extends CartScreenEvent {
  const ApplyRewardEvent(this.reward);

  final String reward;

  @override
  List<Object> get props => [reward];
}
/*-----------------------------Estimate shipping and taxes feature Events------------------------------------------*/

/*
* Event to get country data
* */
class GetCountryDataEvent extends CartScreenEvent {
  const GetCountryDataEvent();

  @override
  List<Object> get props => [];
}

/*
* Event to get shipping methods from server
* */
class GetShippingMethodEvent extends CartScreenEvent {
  const GetShippingMethodEvent(this.countryId, this.zoneId, this.postCode);

  final String countryId;
  final String zoneId;
  final String postCode;

  @override
  List<Object> get props => [countryId, zoneId, postCode];
}

/*
* Event to apply rewards on cart page
* */
class ApplyShippingEvent extends CartScreenEvent {
  const ApplyShippingEvent(this.shippingMethod);

  final String shippingMethod;

  @override
  List<Object> get props => [shippingMethod];
}

/*
* Add Product to wishlist event
*
* */
class AddProductToWishListEvent extends CartScreenEvent {
  String? productId;
  AddProductToWishListEvent(this.productId);
}
