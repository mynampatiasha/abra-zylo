import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/address/country_datum.dart';
import 'package:oc_demo/models/address/edit_address_book.dart';
import 'package:oc_demo/models/base_model.dart';

abstract class AddEditAddressState extends Equatable {
  const AddEditAddressState();

  @override
  List<Object> get props => [];
}

class AddEditAddressInitial extends AddEditAddressState {}

class AddEditAddressCountrySuccess extends AddEditAddressState {
  final CountryDatum model;

  const AddEditAddressCountrySuccess(this.model);

  @override
  List<Object> get props => [];
}

class AddressDetailFetchSuccess extends AddEditAddressState {
  final EditAddressBook model;

  const AddressDetailFetchSuccess(this.model);

  @override
  List<Object> get props => [];
}

class UpdateAddressSuccess extends AddEditAddressState {
  final BaseModel model;

  const UpdateAddressSuccess(this.model);

  @override
  List<Object> get props => [];
}

class AddAddressSuccess extends AddEditAddressState {
  final BaseModel model;

  const AddAddressSuccess(this.model);

  @override
  List<Object> get props => [];
}

class AddEditAddressError extends AddEditAddressState {
  AddEditAddressError(this._message);

  String? _message;

  // ignore: unnecessary_getters_setters
  String? get message => _message;

  // ignore: unnecessary_getters_setters
  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}
