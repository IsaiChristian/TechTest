import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/data/models/movie_detail_model.dart';

void main() {
  group('MovieDetailModel', () {
    final tMovieDetailJson = {
      'adult': false,
      'backdrop_path': '/path.jpg',
      'belongs_to_collection': null,
      'budget': 1000000,
      'genres': [
        {'id': 1, 'name': 'Action'}
      ],
      'homepage': 'https://example.com',
      'id': 1,
      'imdb_id': 'tt1234567',
      'original_language': 'en',
      'original_title': 'Original Title',
      'overview': 'Overview',
      'popularity': 10.0,
      'poster_path': '/poster.jpg',
      'production_companies': [
        {
          'id': 1,
          'logo_path': '/logo.png',
          'name': 'Company',
          'origin_country': 'US'
        }
      ],
      'production_countries': [
        {'iso_3166_1': 'US', 'name': 'USA'}
      ],
      'release_date': '2023-01-01',
      'revenue': 2000000,
      'runtime': 120,
      'spoken_languages': [
        {'english_name': 'English', 'iso_639_1': 'en', 'name': 'English'}
      ],
      'status': 'Released',
      'tagline': 'Tagline',
      'title': 'Title',
      'video': false,
      'vote_average': 8.0,
      'vote_count': 100,
    };

    final tMovieDetail = MovieDetail(
      adult: false,
      backdropPath: '/path.jpg',
      belongsToCollection: null,
      budget: 1000000,
      genres: [Genre(id: 1, name: 'Action')],
      homepage: 'https://example.com',
      id: 1,
      imdbId: 'tt1234567',
      originalLanguage: 'en',
      originalTitle: 'Original Title',
      overview: 'Overview',
      popularity: 10.0,
      posterPath: '/poster.jpg',
      productionCompanies: [
        ProductionCompany(
          id: 1,
          logoPath: '/logo.png',
          name: 'Company',
          originCountry: 'US',
        )
      ],
      productionCountries: [
        ProductionCountry(iso31661: 'US', name: 'USA'),
      ],
      releaseDate: '2023-01-01',
      revenue: 2000000,
      runtime: 120,
      spokenLanguages: [
        SpokenLanguage(englishName: 'English', iso6391: 'en', name: 'English'),
      ],
      status: 'Released',
      tagline: 'Tagline',
      title: 'Title',
      video: false,
      voteAverage: 8.0,
      voteCount: 100,
    );

    test('fromJson should return a valid model', () {
      final result = MovieDetail.fromJson(tMovieDetailJson);

      expect(result.id, tMovieDetail.id);
      expect(result.title, tMovieDetail.title);
      expect(result.genres.length, 1);
      expect(result.genres.first.name, 'Action');
      expect(result.productionCompanies.length, 1);
      expect(result.productionCompanies.first.name, 'Company');
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tMovieDetail.toJson();

      expect(result['id'], tMovieDetail.id);
      expect(result['title'], tMovieDetail.title);
      expect((result['genres'] as List).length, 1);
    });
  });
}
