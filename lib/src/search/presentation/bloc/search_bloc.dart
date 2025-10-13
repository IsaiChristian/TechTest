import 'package:tech_proof/data/repositories/movies_repository_imp.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepositoryImpl movieRepository;

  SearchBloc({required this.movieRepository}) : super(SearchInitial()) {
    on<SearchSubmitted>(_onSearchSubmitted, transformer: restartable());
  }

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    if (state is! SearchLoaded) {
      emit(SearchLoading());
    }

    final movies = await movieRepository.searchMovies(query: event.query);
    movies.fold(
      (l) => emit(SearchError('Something went wrong with your query')),
      (r) {
        if (r.results.isEmpty) {
          emit(SearchInitial());
        } else {
          emit(SearchLoaded(r.results));
        }
      },
    );
  }
}
