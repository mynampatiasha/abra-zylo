import 'package:equatable/equatable.dart';

abstract class DownloadableProductScreenEvent extends Equatable {
  const DownloadableProductScreenEvent();

  @override
  List<Object> get props => [];
}

class DownloadableProductScreenDataFetchEvent
    extends DownloadableProductScreenEvent {
  final String page;
  const DownloadableProductScreenDataFetchEvent(this.page);
}
