import 'package:tech_proof/core/error/failure.dart';
import 'package:tech_proof/core/error/logger_service.dart';
import 'package:tech_proof/core/network/safe_call.dart';
import 'package:tech_proof/data/mappers/movie_mapper.dart';
import 'package:tech_proof/data/mappers/popular_movies_mapper.dart';
import 'package:tech_proof/data/mappers/search_response_mapper.dart';
import 'package:tech_proof/data/models/movie_detail_model.dart';
import 'package:tech_proof/data/models/popular_movies_model.dart';
import 'package:tech_proof/data/models/search_response_model.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/domain/entities/popular_movies_entity.dart';
import 'package:tech_proof/domain/entities/search_response_entity.dart';
import 'package:tech_proof/domain/repositories/movies_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class MovieRepositoryImpl implements MovieRepository {
  final Dio dio;

  MovieRepositoryImpl(this.dio);

  @override
  Future<Either<Failure, PopularMoviesResponseEntity>> getPopularMovies({
    int page = 1,
  }) async {
    final response = await safeCall(() async {
      final response = await dio.get(
        "/movie/popular",
        queryParameters: {"page": page},
      );
      return response.data;
    });
    PopularMoviesResponseModel? model;
    response.fold((l) {
      LoggerService.error("Repository", 'Failed to parse popular movies');
      return UnexpectedFailure('message');
    }, (r) => model = PopularMoviesResponseModel.fromJson(r));
    if (model == null) {
      LoggerService.error("Repository", 'Failed to parse popular movies');

      return Left(UnexpectedFailure("Failed to parse popular movies"));
    } else {
      final modelEntity = model!.toEntity();
      return Right(modelEntity);
    }
  }

  @override
  Future<Either<Failure, SearchResponseEntity>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final response = await safeCall(() async {
      final response = await dio.get(
        "/search/movie",
        queryParameters: {"query": query, "page": page},
      );
      return response.data;
    });
    SearchResponseModel? model;

    response.fold((l) {
      LoggerService.error("Repository", 'Failed to parse search results');
      return UnexpectedFailure('message');
    }, (r) => model = SearchResponseModel.fromJson(r));

    if (model == null) {
      LoggerService.error("Repository", 'Failed to parse search results');
      return Left(UnexpectedFailure("Failed to parse search results"));
    } else {
      final modelEntity = model!.toEntity();
      return Right(modelEntity);
    }
  }

  @override
  Future<Either<Failure, MovieEntity>> getMovie({required int id}) async {
    final response = await safeCall(() async {
      final response = await dio.get("/movie/$id");
      return response.data;
    });
    MovieDetail? model;
    response.fold((l) {
      LoggerService.error("Repository", 'Failed to parse movie details');
      return UnexpectedFailure('message');
    }, (r) => model = MovieDetail.fromJson(r));
    if (model != null) {
      return Right(model!.toEntity());
    } else {
      LoggerService.error("Repository", 'Failed to parse movie details');
      return Left(UnexpectedFailure("Failed to parse movie details"));
    }
  }
}
