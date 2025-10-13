part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class SearchSubmitted extends SearchEvent {
  final String query;
  const SearchSubmitted(this.query);
}

class SearchTextChanged extends SearchEvent {
  final String query;
  const SearchTextChanged(this.query);
}
