import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/loginModel/login_model.dart';

import '../../../models/ApiLoginResponse/api_login_response.dart';
import '../../../models/accountInfoModel/account_info_model.dart';
import '../../../models/accountItemsListModel/account_items_list_model.dart';
import '../../../models/base_model.dart';
import '../../../models/saveImageModel/save_image_model.dart';

abstract class ProfileScreenState extends Equatable {
  const ProfileScreenState();

  @override
  List<Object> get props => [];
}

class ProfileScreenInitial extends ProfileScreenState {}

class ProfileScreenLoading extends ProfileScreenState {}

class ProfileScreenComplete extends ProfileScreenState {}

class ProfileScreenSuccess extends ProfileScreenState {
  ProfileScreenSuccess(this.accountInfoModel);

  AccountInfoModel accountInfoModel;

  @override
  List<Object> get props => [];
}

class ToBecomeSellerSuccess extends ProfileScreenState {
  ToBecomeSellerSuccess(this.baseModel);

  BaseModel baseModel;

  @override
  List<Object> get props => [];
}

class AccountItemDataSuccess extends ProfileScreenState {
  AccountItemDataSuccess(this.model);

  AccountItemsListModel model;

  @override
  List<Object> get props => [];
}

class ProfileScreenError extends ProfileScreenState {
  ProfileScreenError(this._message);

  String? _message;

  String? get message => _message;

  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}

class ProfileScreenImageSuccess extends ProfileScreenState {
  ProfileScreenImageSuccess(this.model);

  SaveImageModel? model;

  @override
  List<Object> get props => [];
}
