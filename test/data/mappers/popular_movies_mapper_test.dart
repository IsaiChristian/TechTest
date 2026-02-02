import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/data/mappers/popular_movies_mapper.dart';
import 'package:tech_proof/data/models/movie_model.dart';
import 'package:tech_proof/data/models/popular_movies_model.dart';
import 'package:tech_proof/domain/entities/popular_movies_entity.dart';

void main() {
  group('PopularMoviesMapper', () {
    final tMovieModel = MovieModel(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2],
      id: 1,
      originalLanguage: 'en',
      originalTitle: 'Original Title',
      overview: 'Overview',
      popularity: 10.0,
      posterPath: 'posterPath',
      releaseDate: '2023-01-01',
      title: 'Title',
      video: false,
      voteAverage: 8.0,
      voteCount: 100,
    );

    final tPopularMoviesModel = PopularMoviesResponseModel(
      page: 1,
      results: [tMovieModel],
      totalPages: 10,
      totalResults: 100,
    );

    test(
      'should map PopularMoviesResponseModel to PopularMoviesResponseEntity',
      () {
        final result = tPopularMoviesModel.toEntity();

        expect(result, isA<PopularMoviesResponseEntity>());
        expect(result.page, tPopularMoviesModel.page);
        expect(result.totalPages, tPopularMoviesModel.totalPages);
        expect(result.totalResults, tPopularMoviesModel.totalResults);
        expect(result.results.length, 1);
        expect(result.results.first.id, tMovieModel.id);
      },
    );
  });
}
