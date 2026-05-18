import 'package:bloc/bloc.dart';
import 'package:oc_demo/screens/home/widgets/item_card_bloc/item_card_repository.dart';

import 'item_card_event.dart';
import 'item_card_state.dart';

class ItemCardBloc extends Bloc<ItemCardEvent, ItemCardState> {
  ItemCardRepository? repository;

  ItemCardBloc({this.repository}) : super(ItemCardInitial()) {
    on<ItemCardEvent>(mapEventToState);
  }

  void mapEventToState(ItemCardEvent event, Emitter<ItemCardState> emit) async {
    emit(ItemCardInitial());
    //AddToWishList
    if (event is AddToWishlistEvent) {
      try {
        var model = await repository?.addToWishList(event.productId ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductToWishlistStateSuccess(model, event.productId ?? ''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ItemCardErrorState(error.toString()));
      }
    }
  }
}
