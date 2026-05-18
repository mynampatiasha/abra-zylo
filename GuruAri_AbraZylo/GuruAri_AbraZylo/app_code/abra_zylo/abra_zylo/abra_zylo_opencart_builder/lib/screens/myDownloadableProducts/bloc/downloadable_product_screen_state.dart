import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/downloadProductModel/download_product_model.dart';

abstract class DownloadableProductScreenState extends Equatable {
  const DownloadableProductScreenState();

  @override
  List<Object> get props => [];
}

class DownloadableProductScreenInitial extends DownloadableProductScreenState {}

class DownloadableProductScreenSuccess extends DownloadableProductScreenState {
  final DownloadProductModel returns;
  const DownloadableProductScreenSuccess(this.returns);
}

class DownloadableProductScreenError extends DownloadableProductScreenState {
  final String message;
  const DownloadableProductScreenError(this.message);
}
