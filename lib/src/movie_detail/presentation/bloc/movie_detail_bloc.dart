import 'dart:async';

import 'package:tech_proof/core/error/logger_service.dart';
import 'package:tech_proof/data/repositories/movies_repository_imp.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final MovieRepositoryImpl movieRepository;
  final int movieId;
  MovieDetailBloc({required this.movieRepository, required this.movieId})
    : super(MovieDetailInitial()) {
    on<MovieDetailEvent>((event, emit) {});
    on<MovieDetailInit>(_movieDetailInit);
  }

  FutureOr<void> _movieDetailInit(
    MovieDetailInit event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());

    final movieDetail = await movieRepository.getMovie(id: movieId);

    movieDetail.fold((l) {
      LoggerService.error("MovieDetailBloc", 'Failed to fetch movie details');
      emit(MovieDetailError(message: 'Failed to fetch movie details'));
    }, (r) => emit(MovieDetailLoaded(r)));
  }
}
