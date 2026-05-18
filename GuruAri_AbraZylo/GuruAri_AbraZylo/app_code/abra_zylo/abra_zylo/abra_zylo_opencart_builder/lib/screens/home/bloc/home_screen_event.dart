part of 'home_screen_bloc.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class HomeScreenDataFetchEvent extends HomeScreenEvent {
  const HomeScreenDataFetchEvent(/*this.etag*/);
  //final String? etag;
  @override
  List<Object> get props => [];
}

class AddToWishlist extends HomeScreenEvent {
  final String? productId;
  const AddToWishlist(this.productId);
}
// class RecentProductEvent extends HomeScreenEvent{
//
//   const RecentProductEvent();
//
// }
