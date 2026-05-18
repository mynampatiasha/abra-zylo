/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/walk_through/bloc/walk_through_event.dart';
import 'package:oc_demo/screens/walk_through/bloc/walk_through_repository.dart';
import 'package:oc_demo/screens/walk_through/bloc/walk_through_state.dart';

import '../../../constants/app_string_constant.dart';

class WalkThroughBloc extends Bloc<WalkThroughEvent, WalkThroughState> {
  WalkThroughRepositoryImp? repository;

  WalkThroughBloc({this.repository}) : super(WalkThroughInitial()) {
    on<WalkThroughEvent>(mapEventToState);
  }

  void mapEventToState(
      WalkThroughEvent event, Emitter<WalkThroughState> emit) async {
    if (event is WalkThroughFetchEvent) {
      emit(WalkThroughInitial());
      try {
        var model = await repository?.getWalkThroughData();
        if (model != null) {
          emit(WalkThroughSuccess(model));
        } else {
          emit(WalkThroughError(AppStringConstant.somethingWentWrong));
        }
      } catch (error, _) {
        print(error.toString());
        emit(WalkThroughError(error.toString()));
      }
    }
  }
}
