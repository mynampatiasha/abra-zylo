import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/base_model.dart';

abstract class AccountInfoEvent extends Equatable {
  const AccountInfoEvent();

  @override
  List<Object> get props => [];
}

class DownloadInformationEvent extends AccountInfoEvent {
  const DownloadInformationEvent();
}

class SaveAccountInfoEvent extends AccountInfoEvent {
  final String wkToken, firstname, lastname, email, fax, telephone;
  final bool changePassword;
  final String? password;

  const SaveAccountInfoEvent(this.wkToken, this.firstname, this.lastname,
      this.email, this.telephone, this.fax, this.changePassword, this.password);
}

class AccountDetailEvent extends AccountInfoEvent {
  final String? wkToken;

  const AccountDetailEvent(this.wkToken);
}

class DeactivateAccount extends AccountInfoEvent {
  final String type;

  const DeactivateAccount(this.type);
}

class ReSendVerificationEvent extends AccountInfoEvent {
  const ReSendVerificationEvent();
}

class LoginEvent extends AccountInfoEvent {
  const LoginEvent(this.name, this.password, this.fcmToken, this.wkToken);

  final String name;
  final String password;
  final String wkToken;
  final String fcmToken;

  @override
  List<Object> get props => [name, password, fcmToken, wkToken];
}

class DeleteAccountEvent extends AccountInfoEvent {
  const DeleteAccountEvent();
}
