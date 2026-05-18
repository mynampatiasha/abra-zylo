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

import '../../../models/walk_through/walk_through_model.dart';

abstract class WalkThroughState extends Equatable {
  const WalkThroughState();

  @override
  List<Object> get props => [];
}

class WalkThroughInitial extends WalkThroughState {}

class WalkThroughSuccess extends WalkThroughState {
  final WalkThroughModel model;
  const WalkThroughSuccess(this.model);
}

class WalkThroughError extends WalkThroughState {
  final String message;
  const WalkThroughError(this.message);
}
