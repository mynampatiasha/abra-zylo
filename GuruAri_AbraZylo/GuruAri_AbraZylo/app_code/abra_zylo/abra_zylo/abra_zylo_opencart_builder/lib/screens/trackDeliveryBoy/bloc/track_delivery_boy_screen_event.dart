import 'package:equatable/equatable.dart';

import '../../../models/catalog/request/catalog_product_request.dart';

abstract class TrackDeliveryBoyScreenEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TrackDeliveryBoyScreenDatFetchEvent extends TrackDeliveryBoyScreenEvent {
  TrackDeliveryBoyScreenDatFetchEvent(this.id);

  final String id;

  @override
  List<Object> get props => [];
}
