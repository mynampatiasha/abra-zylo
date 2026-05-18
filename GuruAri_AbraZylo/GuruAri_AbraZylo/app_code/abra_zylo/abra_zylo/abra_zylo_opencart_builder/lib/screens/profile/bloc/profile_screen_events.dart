import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/base_model.dart';

abstract class ProfileScreenEvent extends Equatable {
  const ProfileScreenEvent();

  @override
  List<Object> get props => [];
}

class AccountDetailEvent extends ProfileScreenEvent {
  //final String? wkToken;

  const AccountDetailEvent(/*this.wkToken*/);
}

class ToBecomeSellerEvent extends ProfileScreenEvent {
  ToBecomeSellerEvent(this.shopName, shopDescription);
  String? shopName;
  String? shopDescription;
}

class GetAccountItemsDataEvent extends ProfileScreenEvent {
  const GetAccountItemsDataEvent();
}

class ProfileScreenImageUploadEvent extends ProfileScreenEvent {
  final String? image, type;
  const ProfileScreenImageUploadEvent(this.image, this.type);
}
