import 'package:equatable/equatable.dart';

abstract class ReturnOrderScreenEvent extends Equatable {
  const ReturnOrderScreenEvent();

  @override
  List<Object> get props => [];
}

class ReturnOrderScreenDataFetchEvent extends ReturnOrderScreenEvent {
  final String page;
  const ReturnOrderScreenDataFetchEvent(this.page);
}
