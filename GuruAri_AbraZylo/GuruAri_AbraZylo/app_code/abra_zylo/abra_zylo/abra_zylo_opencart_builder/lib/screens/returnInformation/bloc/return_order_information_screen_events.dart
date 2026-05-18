import 'package:equatable/equatable.dart';

abstract class ReturnOrderInformationScreenEvent extends Equatable {
  const ReturnOrderInformationScreenEvent();

  @override
  List<Object> get props => [];
}

class ReturnOrderInformationScreenDataFetchEvent
    extends ReturnOrderInformationScreenEvent {
  final String? id;
  const ReturnOrderInformationScreenDataFetchEvent(this.id);
}
