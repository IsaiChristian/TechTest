import 'package:tech_proof/data/mappers/movie_mapper.dart';
import 'package:tech_proof/data/models/popular_movies_model.dart';
import 'package:tech_proof/domain/entities/popular_movies_entity.dart';

extension PopularMoviesMapper on PopularMoviesResponseModel {
  PopularMoviesResponseEntity toEntity() {
    return PopularMoviesResponseEntity(
      page: page,
      results: results.toEntityList(),
      totalPages: totalPages,
      totalResults: totalResults,
    );
  }
}
