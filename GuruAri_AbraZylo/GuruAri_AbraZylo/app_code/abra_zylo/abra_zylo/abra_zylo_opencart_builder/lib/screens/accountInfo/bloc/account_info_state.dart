import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/accountInfoModel/account_info_model.dart';
import 'package:oc_demo/models/base_model.dart';

import '../../../models/loginModel/login_model.dart';

abstract class AccountInfoState extends Equatable {
  const AccountInfoState();

  @override
  List<Object> get props => [];
}

class AccountInfoInitialState extends AccountInfoState {}

class AccountInfoLoadingState extends AccountInfoState {}

class AccountInfoSuccessState extends AccountInfoState {
  final BaseModel data;

  const AccountInfoSuccessState(this.data);
}

class AccountDetailSuccessState extends AccountInfoState {
  final AccountInfoModel data;

  const AccountDetailSuccessState(this.data);
}

class AccountInfoDeactivateState extends AccountInfoState {
  // final AccountInfoModel data;
  const AccountInfoDeactivateState();
}

class AccountInfoErrorState extends AccountInfoState {
  final String message;

  const AccountInfoErrorState(this.message);
}

class AccountInfoDownloadSuccessState extends AccountInfoState {
  // final AccountInfoModel data;
  const AccountInfoDownloadSuccessState();
}

class LoginState extends AccountInfoState {
  LoginState(this.data);

  LoginModel data;

  @override
  List<Object> get props => [data];
}

class DeleteAccountState extends AccountInfoState {
  DeleteAccountState(this.data);

  BaseModel data;

  @override
  List<Object> get props => [data];
}

class CompleteState extends AccountInfoState {}
