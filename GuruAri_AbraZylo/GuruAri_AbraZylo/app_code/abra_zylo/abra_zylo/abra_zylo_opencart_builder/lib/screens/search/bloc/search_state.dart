import 'package:equatable/equatable.dart';

import '../../../models/searchModel/search_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchScreenSuccess extends SearchState {
  final SearchModel model;

  const SearchScreenSuccess(this.model);
}

class SearchActionState extends SearchState {}

class SearchEmptyState extends SearchState {}

class SearchScreenError extends SearchState {
  const SearchScreenError(this.message);

  final String message;
}
