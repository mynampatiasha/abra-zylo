import 'package:equatable/equatable.dart';

abstract class NewsLetterScreenEvent extends Equatable {
  const NewsLetterScreenEvent();

  @override
  List<Object> get props => [];
}

class GetNewsLetterEvent extends NewsLetterScreenEvent {
  GetNewsLetterEvent();

  @override
  List<Object> get props => [];
}

class SetNewsLetterEvent extends NewsLetterScreenEvent {
  SetNewsLetterEvent(this.newsLetter);
  String newsLetter;

  @override
  List<Object> get props => [];
}
