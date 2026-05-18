part of 'home_screen_bloc.dart';

abstract class HomeScreenState {
  const HomeScreenState();
}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenSuccess extends HomeScreenState {
  HomeScreenSuccess(this.homePageData);

  HomePageData homePageData;
}

class AddProductToWishlistStateSuccess extends HomeScreenState {
  const AddProductToWishlistStateSuccess(this.wishListModel);

  final AddProductToWishListModel wishListModel;
}
/*class RecentproductStateSuccess extends HomeScreenState {
  const RecentproductStateSuccess(this.RecentProductList);

  final List<Product> RecentProductList;

}*/

class HomeScreenError extends HomeScreenState {
  HomeScreenError(this._message);

  String? _message;

  String? get message => _message;

  set message(String? message) {
    _message = message;
  }
}
