import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/productDetail/add_product_wishlist_model.dart';

import '../../../helper/notification_service.dart';
import '../../../models/homPage/home_screen_model.dart';
import '../../../constants/global_data.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';
import 'home_screen_repository.dart';

part 'home_screen_event.dart';

part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenRepository? repository;

  HomeScreenBloc({this.repository}) : super(HomeScreenInitial()) {
    on<HomeScreenEvent>(mapEventToState);
  }

  @override
  void mapEventToState(
      HomeScreenEvent event, Emitter<HomeScreenState> emit) async {
    // if (event is HomeScreenDataFetchEvent) {
    //   try {
    //
    //     var model = await repository?.getHomeData(/*modelDb?.eTag??*/"");
    //     print("Rishabh model "+model!.languages.toString());
    //     if (model != null) {
    //       GlobalData.rootCategories = model.categories;
    //       GlobalData.cmsPageData = model.footerMenu;
    //       NotificationService.instance.notificationCenter.notify(NotificationService.updateCategoryKey);
    //       AppSharedPref.setAvailableCurrencies(model.currencies);
    //       AppSharedPref.setAvailableLanguages(model.languages);
    //       emit(HomeScreenSuccess(model));
    //     } else {
    //       emit(HomeScreenError(''));
    //     }
    //   } catch (error, stack) {
    //     print("Rishabh error"+error.toString());
    //     print("Rishabh stack"+stack.toString());
    //     emit(HomeScreenError(error.toString()));
    //   }
    // }
    if (event is HomeScreenDataFetchEvent) {
      try {
        // Step 1: Load cached data
        final box = await Hive.openBox('homeBox');
        final cachedJson = box.get('homeData');

        if (cachedJson != null) {
          final cachedModel = HomePageData.fromJson(jsonDecode(cachedJson));
          print("Rishabh Bloc data:= ${cachedModel.toJson()}");
          emit(HomeScreenSuccess(cachedModel));
        }

        // Step 2: Fetch fresh data from API and update
        final freshModel = await repository?.getHomeData("");

        if (freshModel != null) {
          GlobalData.rootCategories = freshModel.categories;
          GlobalData.cmsPageData = freshModel.footerMenu;

          NotificationService.instance.notificationCenter
              .notify(NotificationService.updateCategoryKey);

          AppSharedPref.setAvailableCurrencies(freshModel.currencies);
          AppSharedPref.setAvailableLanguages(freshModel.languages);

          emit(HomeScreenSuccess(freshModel)); // emit updated model
        } else if (cachedJson == null) {
          emit(HomeScreenError('No data found'));
        }
      } catch (error, stack) {
        print("Error: $error");
        print("Stacktrace: $stack");

        emit(HomeScreenError(error.toString()));
      }
    } else if (event is AddToWishlist) {
      print("jkdkjadajs");
      try {
        var model = await repository?.addToWishList(event.productId ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductToWishlistStateSuccess(model));
        } else {
          emit(HomeScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(HomeScreenError(error.toString()));
      }
    } /*else if(event is RecentProductEvent){
      print("jkdkjadajs");
      try {
        var model = await repository?.getRecentProduct();
        if (model != null ) {
          emit(RecentproductStateSuccess(model));
        } */ /*else {
          emit(HomeScreenError(''));
        }*/ /*
      } catch (error, _) {
        print(error.toString());
       // emit(HomeScreenError(error.toString()));
      }

    }*/
  }
}
