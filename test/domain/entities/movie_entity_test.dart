import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';

void main() {
  group('MovieEntity', () {
    const tId = 1;
    const tPosterPath = '/poster.jpg';
    const tTitle = 'Test Movie';
    const tReleaseDate = '2023-10-27';
    const tSynopsis = 'This is a test movie synopsis.';
    const tRating = 8.5;
    final tGenres = ['Action', 'Adventure'];

    const tMovieEntity = MovieEntity(
      id: tId,
      posterPath: tPosterPath,
      title: tTitle,
      releaseDate: tReleaseDate,
      synopsis: tSynopsis,
      rating: tRating,
      genres: ['Action', 'Adventure'],
    );

    final tMovieEntityJson = {
      'id': tId,
      'posterPath': tPosterPath,
      'title': tTitle,
      'releaseDate': tReleaseDate,
      'synopsis': tSynopsis,
      'rating': tRating,
      'genres': tGenres,
    };

    test('fromJson should return a valid model', () {
      // Act
      final result = MovieEntity.fromJson(tMovieEntityJson);

      // Assert
      expect(result.id, tId);
      expect(result.posterPath, tPosterPath);
      expect(result.title, tTitle);
      expect(result.releaseDate, tReleaseDate);
      expect(result.synopsis, tSynopsis);
      expect(result.rating, tRating);
      expect(result.genres, tGenres);
    });

    test('toJson should return a JSON map containing proper data', () {
      // Act
      final result = tMovieEntity.toJson();

      // Assert
      expect(result, tMovieEntityJson);
    });
  });
}
