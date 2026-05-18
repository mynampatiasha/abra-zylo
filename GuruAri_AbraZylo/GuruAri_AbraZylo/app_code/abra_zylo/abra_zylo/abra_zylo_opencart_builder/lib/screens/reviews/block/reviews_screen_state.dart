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

import 'package:equatable/equatable.dart';

import '../../../models/reviewListModel/reviews_list_model.dart';

abstract class ReviewsScreenState extends Equatable {
  const ReviewsScreenState();

  @override
  List<Object> get props => [];
}

class ReviewsScreenInitial extends ReviewsScreenState {}

class ReviewsScreenSuccess extends ReviewsScreenState {
  final ReviewsListModel reviews;
  const ReviewsScreenSuccess(this.reviews);
}

class ReviewsScreenError extends ReviewsScreenState {
  final String message;
  const ReviewsScreenError(this.message);
}
