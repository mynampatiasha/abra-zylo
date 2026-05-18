import 'package:flutter_bloc/flutter_bloc.dart';

import 'account_info_events.dart';
import 'account_info_repository.dart';
import 'account_info_state.dart';

class AccountInfoBloc extends Bloc<AccountInfoEvent, AccountInfoState> {
  AccountInfoRepositoryImp? repository;

  AccountInfoBloc({this.repository}) : super(AccountInfoInitialState()) {
    on<AccountInfoEvent>(mapEventToState);
  }

  void mapEventToState(
      AccountInfoEvent event, Emitter<AccountInfoState> emit) async {
    if (event is SaveAccountInfoEvent) {
      emit(AccountInfoLoadingState());
      try {
        var model = await repository?.editCustomer(
            event.wkToken,
            event.firstname,
            event.lastname,
            event.email,
            event.telephone,
            event.fax,
            event.changePassword,
            event.password);
        if (model != null) {
          emit(AccountInfoSuccessState(model));
        } else {
          emit(const AccountInfoErrorState(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(AccountInfoErrorState(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is AccountDetailEvent) {
      emit(AccountInfoLoadingState());
      try {
        var model =
            await repository?.getAccountAccountInfo(event.wkToken ?? "");
        if (model != null) {
          emit(AccountDetailSuccessState(model));
        } else {
          emit(const AccountInfoErrorState(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(AccountInfoErrorState(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is DeactivateAccount) {
      emit(AccountInfoLoadingState());
      try {
        var model = true;
        if (model != null) {
          emit(AccountInfoDeactivateState());
        } else {
          emit(const AccountInfoErrorState(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(AccountInfoErrorState(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is LoginEvent) {
      try {
        var model = await repository?.loginCustomer(
            event.wkToken, event.name, event.password, event.fcmToken);
        if (model != null) {
          emit(LoginState(model));
          //AppSharedPref?.setLogin(true);
        } else {
          emit(AccountInfoErrorState(""));
        }
      } catch (error, _) {
        emit(AccountInfoErrorState(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });
    } else if (event is DeleteAccountEvent) {
      try {
        var model = await repository?.deleteAccount();
        if (model != null) {
          emit((DeleteAccountState(model)));
          //AppSharedPref?.setLogin(true);
        } else {
          emit(AccountInfoErrorState(""));
        }
      } catch (error, _) {
        emit(AccountInfoErrorState(error.toString()));
      }
      /*await Future.delayed(const Duration(seconds: 3), () {
        emit(CompleteState());
      });*/
    }
  }
}
