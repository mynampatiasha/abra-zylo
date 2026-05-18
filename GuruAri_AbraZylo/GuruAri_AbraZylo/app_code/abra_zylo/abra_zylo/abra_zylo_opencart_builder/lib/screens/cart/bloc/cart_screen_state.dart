part of 'cart_screen_bloc.dart';

abstract class CartScreenState extends Equatable {
  const CartScreenState();

  @override
  List<Object> get props => [];
}

/*
* Initial state
* */
class CartScreenStateInitial extends CartScreenState {}

class CartScreenSuccess extends CartScreenState {
  const CartScreenSuccess(this.data);

  final CartModel data;

  @override
  List<Object> get props => [data];
}

/*
* Success sate called when any item remove from cart
*
* */
class RemoveCartItemSuccess extends CartScreenState {
  const RemoveCartItemSuccess(this.data);

  final BaseModel data;

  @override
  List<Object> get props => [data];
}

/*
* Empty cart state
*
* */
class EmptyCartSuccess extends CartScreenState {
  const EmptyCartSuccess(this.data);

  final BaseModel data;

  @override
  List<Object> get props => [data];
}

/*
* success sate called when update the cart.
* */
class UpdateCartSuccess extends CartScreenState {
  const UpdateCartSuccess(this.data);

  final BaseModel data;

  @override
  List<Object> get props => [data];
}

/*
* Success state called when apply coupon on cart page
* */
class ApplyCouponSuccess extends CartScreenState {
  const ApplyCouponSuccess(this.data);

  final BaseModel data;

  @override
  List<Object> get props => [data];
}

/*
* Success state called when apply Voucher on cart page
* */
class ApplyVoucherSuccess extends CartScreenState {
  const ApplyVoucherSuccess(this.data);

  final BaseModel data;

  @override
  List<Object> get props => [data];
}

/*
* success state called when apply for rewards on cart page.
* */
class ApplyRewardsSuccess extends CartScreenState {
  const ApplyRewardsSuccess(this.data);

  final BaseModel data;

  @override
  List<Object> get props => [data];
}

/*----------------------Error State---------------------------------*/
/*
* Error state will call if there is any error in cart page api
* */
class CartScreenError extends CartScreenState {
  CartScreenError(this._message);

  String? _message;

  String? get message => _message;

  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}

/*-------------------------Estimate shipping and tax -----------------------------------*/
/*
* success state for getting country data on cart page.
* */
class GetCountryDataStateSuccess extends CartScreenState {
  const GetCountryDataStateSuccess(this.data);

  final CountryDataModel data;

  @override
  List<Object> get props => [data];
}

/*
* Success sate to get shipping method on cart page
* */
class GetShippingMethodStateSuccess extends CartScreenState {
  const GetShippingMethodStateSuccess(this.data);

  final CartShippingModel data;

  @override
  List<Object> get props => [data];
}

/*
* Success sate to get shipping method on cart page
* */
class ApplyShippingStateSuccess extends CartScreenState {
  const ApplyShippingStateSuccess(this.data);

  final BaseModel data;

  @override
  List<Object> get props => [data];
}

/*
* Add product to wishlist state
*
* */
class AddProductToWishlistStateSuccess extends CartScreenState {
  AddProductToWishlistStateSuccess(this.wishListModel);

  AddProductToWishListModel wishListModel;

  @override
  List<Object> get props => [];
}
