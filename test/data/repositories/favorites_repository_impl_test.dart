import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_proof/data/repositories/favorites_repository_impl.dart';
import 'package:tech_proof/core/services/local_storage_service.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:dartz/dartz.dart';

import 'favorites_repository_impl_test.mocks.dart';

@GenerateMocks([LocalStorageService])
void main() {
  late FavoriteRepositoryImpl repository;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() {
    mockLocalStorageService = MockLocalStorageService();
    repository = FavoriteRepositoryImpl(mockLocalStorageService);
  });

  const tMovie = MovieEntity(
    id: 1,
    title: 'Test Movie',
    posterPath: 'test.jpg',
    releaseDate: '2022-01-01',
    synopsis: 'Test overview',
    genres: [],
    rating: 8.5,
  );

  group('getFavoriteMovies', () {
    test('should return list of movies from local storage', () async {
      // arrange
      when(mockLocalStorageService.getJsonList<MovieEntity>(
        any,
        any,
      )).thenAnswer((_) async => [tMovie]);
      // act
      final result = await repository.getFavoriteMovies();
      // assert
      verify(
        mockLocalStorageService.getJsonList<MovieEntity>(any, any),
      );
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, tMovie.id);
        },
      );
    });

    test('should return failure when exception occurs', () async {
      // arrange
      when(mockLocalStorageService.getJsonList<MovieEntity>(
        any,
        any,
      )).thenThrow(Exception());
      // act
      final result = await repository.getFavoriteMovies();
      // assert
      expect(result.isLeft(), true);
    });
  });

  group('addMovieToFavorites', () {
    test('should add movie if not already favorite', () async {
      // arrange
      when(mockLocalStorageService.getJsonList<MovieEntity>(
        any,
        any,
      )).thenAnswer((_) async => []);
      when(mockLocalStorageService.setJsonList<MovieEntity>(
        any,
        any,
      )).thenAnswer((_) async => true);

      // act
      final result = await repository.addMovieToFavorites(tMovie);
      // assert
      verify(mockLocalStorageService.setJsonList(any, any));
      expect(result.isRight(), true);
    });
  });

  group('isFavoriteMovie', () {
    test('should return true if movie is in favorites', () async {
      // arrange
      when(mockLocalStorageService.getJsonList<MovieEntity>(any, any))
          .thenAnswer((_) async => [tMovie]);

      // act
      final result = await repository.isFavoriteMovie(1);

      // assert
      expect(result, equals(const Right(true)));
    });
  });
}
