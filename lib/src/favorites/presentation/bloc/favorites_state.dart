// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];

  FavoritesState copyWith() {
    return this;
  }
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<MovieEntity> favoriteMovies;
  final bool isFavoriteMovie;

  const FavoritesLoaded({
    this.favoriteMovies = const [],
    this.isFavoriteMovie = false,
  });

  @override
  List<Object> get props => [favoriteMovies];
  @override
  FavoritesLoaded copyWith({
    List<MovieEntity>? favoriteMovies,
    bool? isFavoriteMovie,
  }) {
    return FavoritesLoaded(
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      isFavoriteMovie: isFavoriteMovie ?? this.isFavoriteMovie,
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError({this.message = 'An unknown error occurred.'});

  @override
  List<Object> get props => [message];
}
