import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/data/mappers/search_response_mapper.dart';
import 'package:tech_proof/data/models/movie_model.dart';
import 'package:tech_proof/data/models/search_response_model.dart';
import 'package:tech_proof/domain/entities/search_response_entity.dart';

void main() {
  group('SearchResponseMapper', () {
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

    final tSearchResponseModel = SearchResponseModel(
      page: 1,
      results: [tMovieModel],
      totalPages: 10,
      totalResults: 100,
    );

    test('should map SearchResponseModel to SearchResponseEntity', () {
      final result = tSearchResponseModel.toEntity();

      expect(result, isA<SearchResponseEntity>());
      expect(result.page, tSearchResponseModel.page);
      expect(result.totalPages, tSearchResponseModel.totalPages);
      expect(result.totalResults, tSearchResponseModel.totalResults);
      expect(result.results.length, 1);
      expect(result.results.first.id, tMovieModel.id);
    });
  });
}
