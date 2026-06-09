// part of 'product_screen_bloc';

import 'package:equatable/equatable.dart';

import '../../../models/productDetail/product_detail_screen_model.dart';

abstract class ReviewScreenState extends Equatable {
  const ReviewScreenState();

  @override
  List<Object> get props => [];
}

class ReviewScreenInitial extends ReviewScreenState {}

/*
* State to get product review
* */
class GetProductReviewStateSuccess extends ReviewScreenState {
  GetProductReviewStateSuccess(this.reviewData);

  ReviewData reviewData;

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ReviewScreenError extends ReviewScreenState {
  ReviewScreenError(this._message);

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
