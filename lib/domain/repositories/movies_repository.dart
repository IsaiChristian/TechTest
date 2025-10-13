import 'package:tech_proof/core/error/failure.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/domain/entities/popular_movies_entity.dart';
import 'package:tech_proof/domain/entities/search_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MovieRepository {
  Future<Either<Failure, PopularMoviesResponseEntity>> getPopularMovies({
    int page = 1,
  });
  Future<Either<Failure, SearchResponseEntity>> searchMovies({
    required String query,
    int page = 1,
  });
  Future<Either<Failure, MovieEntity>> getMovie({required int id});
}
