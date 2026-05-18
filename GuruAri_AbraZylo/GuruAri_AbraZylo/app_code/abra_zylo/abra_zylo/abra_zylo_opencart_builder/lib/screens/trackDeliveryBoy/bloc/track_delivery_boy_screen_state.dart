import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/locationModel/location_model.dart';
import 'package:oc_demo/models/sub_category/sub_category_model.dart';

import '../../../models/catalog/catalog_model.dart';

abstract class TrackDeliveryBoyBaseState extends Equatable {
  const TrackDeliveryBoyBaseState();

  @override
  List<Object> get props => [];
}

class TrackDeliveryBoyInitialState extends TrackDeliveryBoyBaseState {}

class TrackDeliveryBoySuccessState extends TrackDeliveryBoyBaseState {
  final LocationModel? locationModel;

  const TrackDeliveryBoySuccessState(this.locationModel);
}

class TrackDeliveryBoyErrorState extends TrackDeliveryBoyBaseState {
  TrackDeliveryBoyErrorState(this._message);

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
