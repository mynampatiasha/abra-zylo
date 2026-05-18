import 'package:equatable/equatable.dart';

import '../../../models/carousel/carousel_model.dart';

abstract class BrandScreenState extends Equatable {
  const BrandScreenState();

  @override
  List<Object> get props => [];
}

class BrandScreenStateInitial extends BrandScreenState {}

class BrandScreenStateSuccess extends BrandScreenState {
  BrandScreenStateSuccess(this.carouselModel);

  final CarouselModel carouselModel;

  @override
  List<Object> get props => [carouselModel];
}

// ignore: must_be_immutable
class BrandScreenStateError extends BrandScreenState {
  BrandScreenStateError(this._message);

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
