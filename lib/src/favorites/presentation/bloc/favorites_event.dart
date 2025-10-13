part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddFavoriteMovie extends FavoritesEvent {
  final MovieEntity movie;
  const AddFavoriteMovie(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveFavoriteMovie extends FavoritesEvent {
  final MovieEntity movie;
  const RemoveFavoriteMovie(this.movie);

  @override
  List<Object> get props => [movie];
}
