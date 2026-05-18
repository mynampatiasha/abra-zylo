import 'package:equatable/equatable.dart';

abstract class AddReviewEvent extends Equatable {
  const AddReviewEvent();
  @override
  List<Object> get props => [];
}

class AddReviewSaveEvent extends AddReviewEvent {
  final String? productId;
  final String? reviewComment;
  final String? rating;
  final String? name;

  const AddReviewSaveEvent(
      this.name, this.rating, this.reviewComment, this.productId);
}
