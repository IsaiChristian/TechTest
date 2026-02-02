import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/data/mappers/movie_mapper.dart';
import 'package:tech_proof/data/models/movie_detail_model.dart';
import 'package:tech_proof/data/models/movie_model.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';

void main() {
  group('MovieMapper', () {
    const tMovieModel = MovieModel(
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

    test('should map MovieModel to MovieEntity', () {
      final result = tMovieModel.toEntity();

      expect(result, isA<MovieEntity>());
      expect(result.id, tMovieModel.id);
      expect(result.title, tMovieModel.title);
      expect(result.posterPath, tMovieModel.posterPath);
      expect(result.releaseDate, tMovieModel.releaseDate);
      expect(result.synopsis, tMovieModel.overview);
      expect(result.rating, tMovieModel.voteAverage);
      expect(result.genres, isEmpty);
    });

    test('should map List<MovieModel> to List<MovieEntity>', () {
      final tList = [tMovieModel];
      final result = tList.toEntityList();

      expect(result, isA<List<MovieEntity>>());
      expect(result.length, 1);
      expect(result.first.id, tMovieModel.id);
    });

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> jsonMap = {
        'adult': false,
        'backdrop_path': 'backdropPath',
        'genre_ids': [1, 2],
        'id': 1,
        'original_language': 'en',
        'original_title': 'Original Title',
        'overview': 'Overview',
        'popularity': 10.0,
        'poster_path': 'posterPath',
        'release_date': '2023-01-01',
        'title': 'Title',
        'video': false,
        'vote_average': 8.0,
        'vote_count': 100,
      };

      final result = MovieModel.fromJson(jsonMap);

      expect(result, isA<MovieModel>());
      expect(result.id, 1);
      expect(result.title, 'Title');
    });

    test('toJson should return a JSON map', () {
      final result = tMovieModel.toJson();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], 1);
      expect(result['title'], 'Title');
    });
  });

  group('MovieDetailMapper', () {
    final tMovieDetail = MovieDetail(
      adult: false,
      budget: 1000000,
      genres: [Genre(id: 1, name: 'Action')],
      homepage: 'homepage',
      id: 1,
      imdbId: 'tt1234567',
      originalLanguage: 'en',
      originalTitle: 'Original Title',
      overview: 'Overview',
      popularity: 10.0,
      posterPath: 'posterPath',
      productionCompanies: [],
      productionCountries: [],
      releaseDate: '2023-01-01',
      revenue: 2000000,
      runtime: 120,
      spokenLanguages: [],
      status: 'Released',
      tagline: 'Tagline',
      title: 'Title',
      video: false,
      voteAverage: 8.0,
      voteCount: 100,
    );

    test('should map MovieDetail to MovieEntity', () {
      final result = tMovieDetail.toEntity();

      expect(result, isA<MovieEntity>());
      expect(result.id, tMovieDetail.id);
      expect(result.title, tMovieDetail.title);
      expect(result.posterPath, tMovieDetail.posterPath);
      expect(result.releaseDate, tMovieDetail.releaseDate);
      expect(result.synopsis, tMovieDetail.overview);
      expect(result.rating, tMovieDetail.voteAverage);
      expect(result.genres, ['Action']);
    });

    test('should map List<MovieDetail> to List<MovieEntity>', () {
      final tList = [tMovieDetail];
      final result = tList.toEntityList();

      expect(result, isA<List<MovieEntity>>());
      expect(result.length, 1);
      expect(result.first.id, tMovieDetail.id);
    });
  });
}
