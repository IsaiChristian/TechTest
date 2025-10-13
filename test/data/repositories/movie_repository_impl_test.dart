import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/domain/entities/popular_movies_entity.dart';
import 'package:tech_proof/domain/entities/search_response_entity.dart';
import 'package:tech_proof/data/models/popular_movies_model.dart';
import 'package:tech_proof/data/models/search_response_model.dart';
import 'package:tech_proof/data/models/movie_detail_model.dart';
import 'package:tech_proof/data/repositories/movies_repository_imp.dart';

import '../../mocks.mocks.mocks.dart';

class FakePopularMoviesResponseModel extends PopularMoviesResponseModel {
  FakePopularMoviesResponseModel()
    : super(page: 1, results: [], totalPages: 1, totalResults: 0);

  PopularMoviesResponseEntity toEntity() => PopularMoviesResponseEntity(
    page: 1,
    results: [],
    totalPages: 1,
    totalResults: 0,
  );
}

class FakeSearchResponseModel extends SearchResponseModel {
  FakeSearchResponseModel()
    : super(page: 1, results: [], totalPages: 1, totalResults: 0);

  SearchResponseEntity toEntity() => SearchResponseEntity(
    page: 1,
    results: [],
    totalPages: 1,
    totalResults: 0,
  );
}

class FakeMovieDetail extends MovieDetail {
  FakeMovieDetail()
    : super(
        id: 1,
        title: "Fake Movie",
        adult: false,
        budget: 0,
        genres: [],
        homepage: '',
        overview: '',
        popularity: 0.0,
        posterPath: '',
        releaseDate: '',
        revenue: 0,
        runtime: 0,
        status: '',
        tagline: '',
        voteAverage: 0.0,
        voteCount: 0,
        imdbId: '',
        originalLanguage: 'es',
        originalTitle: 'Fake Movie',
        productionCompanies: [],
        productionCountries: [],
        spokenLanguages: [],
        video: false,
      );

  MovieEntity toEntity() => MovieEntity(
    id: 1,
    title: "Fake Movie",
    posterPath: '',
    releaseDate: '',
    synopsis: '',
    rating: 0.0,
    genres: [],
  );
}

void main() {
  late MovieRepositoryImpl repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = MovieRepositoryImpl(mockDio);
  });

  group('getPopularMovies', () {
    test('should return PopularMoviesResponseEntity on success', () async {
      final fakeJson = {
        'page': 1,
        'results': [],
        'total_pages': 1,
        'total_results': 0,
      };
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          data: fakeJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.getPopularMovies(page: 1);

      expect(result.isRight(), true);
      result.fold((_) => fail('Should not fail'), (entity) {
        expect(entity, isA<PopularMoviesResponseEntity>());
      });
    });

    test('should return Failure on Dio error', () async {
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/movie/popular'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repository.getPopularMovies(page: 1);

      expect(result.isLeft(), true);
    });
  });

  group('searchMovies', () {
    test('should return SearchResponseEntity on success', () async {
      final fakeJson = {
        'page': 1,
        'results': [],
        'total_pages': 1,
        'total_results': 0,
      };
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          data: fakeJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.searchMovies(query: 'test', page: 1);

      expect(result.isRight(), true);
      result.fold((_) => fail('Should not fail'), (entity) {
        expect(entity, isA<SearchResponseEntity>());
      });
    });

    test('should return Failure on Dio error', () async {
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/search/movie'),
          type: DioExceptionType.receiveTimeout,
        ),
      );

      final result = await repository.searchMovies(query: 'fail', page: 1);

      expect(result.isLeft(), true);
    });
  });

  group('getMovie', () {
    test('should return MovieEntity on success', () async {
      final fakeJson = {
        'adult': true,
        'backdrop_path': 'backdropPath',
        'belongs_to_collection': 'belongsToCollection',
        'budget': 1000,
        'genres': [],
        'homepage': 'homepage',
        'id': 1,
        'imdb_id': 'imdbId',
        'original_language': 'originalLanguage',
        'original_title': 'originalTitle',
        'overview': 'overview',
        'popularity': 5.5,
        'poster_path': 'posterPath',
        'production_companies': [],
        'production_countries': [],
        'release_date': '1990',
        'revenue': 1200,
        'runtime': 1200,
        'spoken_languages': [],
        'status': 'status',
        'tagline': 'tagline',
        'title': 'title',
        'video': true,
        'vote_average': 5.5,
        'vote_count': 100,
      };
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: fakeJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.getMovie(id: 1);

      expect(result.isRight(), true);
      result.fold((_) => fail('Should not fail'), (entity) {
        expect(entity, isA<MovieEntity>());
        expect(entity.id, 1);
      });
    });

    test('should return Failure when Dio throws', () async {
      when(mockDio.get(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/movie/1'),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.getMovie(id: 1);

      expect(result.isLeft(), true);
    });
  });
}
