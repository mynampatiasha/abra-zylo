import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/address_book/bloc/addressbook_screen_repository.dart';

import 'addressbook_screen_event.dart';
import 'addressbook_screen_state.dart';

class AddressBookScreenBloc extends Bloc<AddressBookEvent, AddressBookState> {
  AddressBookRepository? repository;

  AddressBookScreenBloc({this.repository}) : super(AddressBookInitial()) {
    on<AddressBookEvent>(mapEventToState);
  }

  void mapEventToState(
      AddressBookEvent event, Emitter<AddressBookState> emit) async {
    switch (event.runtimeType) {
      case AddressBookDataFetchEvent:
        try {
          var model = await repository?.getAddressListFromDb();
          if (model != null && model.fault != 1 && model.error != 1) {
            emit(AddressBookSuccess(model));
          }
          model = await repository?.getAddressList(model?.eTag ?? "");
          if (model != null) {
            if (model.fault != 1 && model.error != 1) {
              emit(AddressBookSuccess(model));
            } else {
              emit(AddressBookError(model.message));
            }
          } else {
            emit(AddressBookError(''));
          }
        } catch (error, _) {
          emit(AddressBookError(error.toString()));
        }
        break;
      case DeleteAddressEvent:
        try {
          var model = await repository
              ?.deleteAddress((event as DeleteAddressEvent).addressId);
          if (model != null && model.error == 0) {
            emit(DeleteAddressSuccess(model));
          } else {
            emit(AddressBookError(model?.message ?? ""));
          }
        } catch (error, _) {
          emit(AddressBookError(error.toString()));
        }
        break;
      case LoadingAddressEvent:
        emit(AddressBookInitial());
        break;
    }
  }
}
