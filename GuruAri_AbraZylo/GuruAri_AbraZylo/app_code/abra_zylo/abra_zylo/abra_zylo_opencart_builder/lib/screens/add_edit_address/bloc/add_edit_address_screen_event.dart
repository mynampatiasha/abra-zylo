import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/address/add_address_request.dart';

abstract class AddEditAddressEvent extends Equatable {
  const AddEditAddressEvent();

  @override
  List<Object> get props => [];
}

class AddEditAddressDataFetchEvent extends AddEditAddressEvent {
  const AddEditAddressDataFetchEvent();

  @override
  List<Object> get props => [];
}

class AddressDetailFetchEvent extends AddEditAddressEvent {
  final String? addressId;

  const AddressDetailFetchEvent(this.addressId);

  @override
  List<Object> get props => [];
}

class UpdateAddressEvent extends AddEditAddressEvent {
  final String endPoint, name, phone, street, city, zip, countryId, stateId;

  const UpdateAddressEvent(this.endPoint, this.name, this.phone, this.street,
      this.city, this.zip, this.countryId, this.stateId);

  @override
  List<Object> get props => [];
}

class AddAddressEvent extends AddEditAddressEvent {
  final AddAddressRequest addAddressRequest;

  const AddAddressEvent(this.addAddressRequest);

  @override
  List<Object> get props => [];
}

class LoadingAddAddressEvent extends AddEditAddressEvent {}
