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

abstract class OrdersAndReturnsEvent extends Equatable {
  const OrdersAndReturnsEvent();

  @override
  List<Object> get props => [];
}

class OrdersAndReturnsDetailsEvent extends OrdersAndReturnsEvent {
  String incrementId;
  String email;
  String lastName;
  String zipCode;
  OrdersAndReturnsDetailsEvent(
      this.incrementId, this.email, this.lastName, this.zipCode);
}
