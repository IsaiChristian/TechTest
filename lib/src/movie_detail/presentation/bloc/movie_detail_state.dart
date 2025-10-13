part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  const MovieDetailError({required this.message});
  final String message;
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieEntity movieDetail;
  const MovieDetailLoaded(this.movieDetail);
  @override
  List<Object> get props => [movieDetail];
}
