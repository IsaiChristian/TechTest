import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_proof/data/repositories/favorites_repository_impl.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';

import '../../mocks.mocks.mocks.dart';

void main() {
  late FavoriteRepositoryImpl repository;
  late MockLocalStorageService mockLocalStorage;

  const tKey = 'favorite_movies_list';
  final tMovie = MovieEntity(
    id: 1,
    title: 'Test Movie',
    posterPath: '/test.jpg',
    releaseDate: '2023-01-01',
    synopsis: 'A test movie',
    rating: 8.5,
    genres: ['Action', 'Drama'],
  );
  final tMovieList = [tMovie];

  setUp(() {
    mockLocalStorage = MockLocalStorageService();
    repository = FavoriteRepositoryImpl(mockLocalStorage);
  });

  test('Optimization: verify getJsonList is called only once for repeated fetches', () async {
    // Setup mock
    when(
      mockLocalStorage.getJsonList<MovieEntity>(tKey, MovieEntity.fromJson),
    ).thenAnswer((_) async => tMovieList);

    // Run getFavoriteMovies 10 times
    const iterations = 10;
    for (int i = 0; i < iterations; i++) {
      final result = await repository.getFavoriteMovies();
      // Use equals matcher for list content equality
      expect(result.fold((l) => [], (r) => r), equals(tMovieList));
    }

    // Verify that getJsonList was called ONLY ONCE
    verify(
      mockLocalStorage.getJsonList<MovieEntity>(tKey, MovieEntity.fromJson),
    ).called(1);
  });

  test('Optimization: verify addMovieToFavorites updates cache and avoids extra fetches', () async {
    // Setup mock for initial empty list
    when(
      mockLocalStorage.getJsonList<MovieEntity>(tKey, MovieEntity.fromJson),
    ).thenAnswer((_) async => []);

    when(
      mockLocalStorage.setJsonList<MovieEntity>(tKey, any),
    ).thenAnswer((_) async => true);

    // Initial fetch (populates cache)
    await repository.getFavoriteMovies();

    // Add movie
    await repository.addMovieToFavorites(tMovie);
    verify(mockLocalStorage.setJsonList<MovieEntity>(tKey, [tMovie])).called(1);

    // Fetch again (should use cache, so no getJsonList call)
    final result = await repository.getFavoriteMovies();

    // Check that result contains the new movie
    expect(result.fold((l) => [], (r) => r), contains(tMovie));

    // Verify getJsonList was called only once (initial fetch)
    verify(mockLocalStorage.getJsonList<MovieEntity>(tKey, MovieEntity.fromJson)).called(1);
  });

  test('Optimization: verify removeMovieFromFavorites updates cache', () async {
    // Setup mock with initial list containing tMovie
    when(
      mockLocalStorage.getJsonList<MovieEntity>(tKey, MovieEntity.fromJson),
    ).thenAnswer((_) async => [tMovie]);

    when(
      mockLocalStorage.setJsonList<MovieEntity>(tKey, any),
    ).thenAnswer((_) async => true);

    // Initial fetch
    await repository.getFavoriteMovies();

    // Remove movie
    await repository.removeMovieFromFavorites(tMovie.id);
    verify(mockLocalStorage.setJsonList<MovieEntity>(tKey, [])).called(1);

    // Fetch again
    final result = await repository.getFavoriteMovies();
    expect(result.fold((l) => null, (r) => r), isEmpty);

    // Verify no extra fetches (only initial call)
    verify(mockLocalStorage.getJsonList<MovieEntity>(tKey, MovieEntity.fromJson)).called(1);
  });
}
