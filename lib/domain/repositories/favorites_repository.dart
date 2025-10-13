import 'package:tech_proof/core/error/failure.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, void>> addMovieToFavorites(MovieEntity movie);
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies();
  Future<Either<Failure, void>> removeMovieFromFavorites(int movieId);
  Future<Either<Failure, bool>> isFavoriteMovie(int movieId);
}
