import 'dart:async';

import 'package:tech_proof/data/repositories/favorites_repository_impl.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoriteRepositoryImpl favoriteRepositoryImpl;
  FavoritesBloc({required this.favoriteRepositoryImpl})
    : super(FavoritesInitial()) {
    on<FavoritesEvent>((event, emit) {});
    on<LoadFavorites>(_loadFavorites);
    on<AddFavoriteMovie>(_addFavoriteMovie);
    on<RemoveFavoriteMovie>(_removeFavoriteMovie);
  }

  FutureOr<void> _loadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await favoriteRepositoryImpl.getFavoriteMovies();
    result.fold(
      (l) => emit(FavoritesError(message: l.message)),
      (r) => emit(FavoritesLoaded(favoriteMovies: r)),
    );
  }

  Future<void> _addFavoriteMovie(
    AddFavoriteMovie event,
    Emitter<FavoritesState> emit,
  ) async {
    if (state is! FavoritesLoaded) return;

    final addResult = await favoriteRepositoryImpl.addMovieToFavorites(
      event.movie,
    );

    if (addResult.isLeft()) {
      emit(FavoritesError(message: 'Failed to add favorite movie'));
    } else {
      final getResult = await favoriteRepositoryImpl.getFavoriteMovies();
      getResult.fold(
        (l) => emit(FavoritesError(message: l.message)),
        (r) => emit(FavoritesLoaded(favoriteMovies: r)),
      );
    }
  }

  FutureOr<void> _removeFavoriteMovie(
    RemoveFavoriteMovie event,
    Emitter<FavoritesState> emit,
  ) async {
    if (state is! FavoritesLoaded) return;

    if (state is! FavoritesLoaded) return;

    final addResult = await favoriteRepositoryImpl.removeMovieFromFavorites(
      event.movie.id,
    );

    if (addResult.isLeft()) {
      emit(FavoritesError(message: 'Failed to remove favorite movie'));
    } else {
      final getResult = await favoriteRepositoryImpl.getFavoriteMovies();
      getResult.fold(
        (l) => emit(FavoritesError(message: l.message)),
        (r) => emit(FavoritesLoaded(favoriteMovies: r)),
      );
    }
  }
}
