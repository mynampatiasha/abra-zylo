import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/screens/profile/bloc/profile_repository.dart';
import 'package:oc_demo/screens/profile/bloc/profile_screen_events.dart';
import 'package:oc_demo/screens/profile/bloc/profile_screen_state.dart';

import '../../../models/saveImageModel/save_image_model.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  ProfileRepositoryImp? repository;

  ProfileScreenBloc({this.repository}) : super(ProfileScreenInitial()) {
    on<ProfileScreenEvent>(mapEventToState);
  }

  void mapEventToState(
      ProfileScreenEvent event, Emitter<ProfileScreenState> emit) async {
    if (event is AccountDetailEvent) {
      emit(ProfileScreenInitial());
      try {
        var model = await repository?.getAccountAccountInfo();
        if (model != null) {
          emit(ProfileScreenSuccess(model));
        } else {
          emit(ProfileScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ProfileScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 2), () {
        emit(ProfileScreenComplete());
      });
    }

    if (event is ToBecomeSellerEvent) {
      emit(ProfileScreenInitial());
      try {
        var model = await repository?.toBecomeSeller(
            event.shopName ?? "", event.shopDescription ?? "");
        if (model != null) {
          emit(ToBecomeSellerSuccess(model));
        } else {
          emit(ProfileScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ProfileScreenError(error.toString()));
      }
    }

    if (event is GetAccountItemsDataEvent) {
      emit(ProfileScreenInitial());
      try {
        var model = await repository?.getAccountItemsList();
        if (model != null) {
          emit(AccountItemDataSuccess(model));
        } else {
          emit(ProfileScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ProfileScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 2), () {
        emit(ProfileScreenComplete());
      });
    }
    if (event is ProfileScreenImageUploadEvent) {
      emit(ProfileScreenInitial());
      try {
        SaveImageModel? model;
        if (event.type == "profile") {
          model = await repository?.uploadProfileImage(
              profileImage: event.image ?? "");
        } else {
          model = await repository?.uploadBannerImage(
              bannerImage: event.image ?? "");
        }
        if (model != null) {
          emit(ProfileScreenImageSuccess(model));
        } else {
          emit(ProfileScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(ProfileScreenError(error.toString()));
      }
      await Future.delayed(const Duration(seconds: 2), () {
        emit(ProfileScreenComplete());
      });
    }
  }
}
