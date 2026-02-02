import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_proof/core/error/failure.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/src/favorites/presentation/bloc/favorites_bloc.dart';

import '../../../../mocks.mocks.mocks.dart';

void main() {
  late MockFavoriteRepositoryImpl mockFavoriteRepository;
  late FavoritesBloc favoritesBloc;

  final tMovie = MovieEntity(
    id: 1,
    title: 'Test Movie',
    posterPath: 'path',
    releaseDate: '2023',
    synopsis: 'synopsis',
    rating: 5.0,
    genres: [],
  );

  final tFavoritesList = [tMovie];

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepositoryImpl();
    favoritesBloc = FavoritesBloc(favoriteRepositoryImpl: mockFavoriteRepository);
  });

  tearDown(() {
    favoritesBloc.close();
  });

  test('initial state is FavoritesInitial', () {
    expect(favoritesBloc.state, FavoritesInitial());
  });

  blocTest<FavoritesBloc, FavoritesState>(
    'emits [FavoritesLoading, FavoritesLoaded] when LoadFavorites is added and repository returns success',
    build: () {
      when(mockFavoriteRepository.getFavoriteMovies()).thenAnswer(
        (_) async => Right(tFavoritesList),
      );
      return favoritesBloc;
    },
    act: (bloc) => bloc.add(LoadFavorites()),
    expect: () => [
      FavoritesLoading(),
      FavoritesLoaded(favoriteMovies: tFavoritesList),
    ],
  );

  blocTest<FavoritesBloc, FavoritesState>(
    'emits [FavoritesLoading, FavoritesError] when LoadFavorites is added and repository returns failure',
    build: () {
      when(mockFavoriteRepository.getFavoriteMovies()).thenAnswer(
        (_) async => Left(UnexpectedFailure('Error')),
      );
      return favoritesBloc;
    },
    act: (bloc) => bloc.add(LoadFavorites()),
    expect: () => [
      FavoritesLoading(),
      const FavoritesError(message: 'Error'),
    ],
  );

  blocTest<FavoritesBloc, FavoritesState>(
    'emits [FavoritesLoaded] (updated) when AddFavoriteMovie is added and success',
    seed: () => const FavoritesLoaded(favoriteMovies: []),
    build: () {
      when(mockFavoriteRepository.addMovieToFavorites(tMovie)).thenAnswer(
        (_) async => const Right(null),
      );
      when(mockFavoriteRepository.getFavoriteMovies()).thenAnswer(
        (_) async => Right(tFavoritesList),
      );
      return favoritesBloc;
    },
    act: (bloc) => bloc.add(AddFavoriteMovie(tMovie)),
    expect: () => [
      FavoritesLoaded(favoriteMovies: tFavoritesList),
    ],
  );

  blocTest<FavoritesBloc, FavoritesState>(
    'emits [FavoritesError] when AddFavoriteMovie fails',
    seed: () => const FavoritesLoaded(favoriteMovies: []),
    build: () {
      when(mockFavoriteRepository.addMovieToFavorites(tMovie)).thenAnswer(
        (_) async => Left(UnexpectedFailure('Error')),
      );
      return favoritesBloc;
    },
    act: (bloc) => bloc.add(AddFavoriteMovie(tMovie)),
    expect: () => [
      const FavoritesError(message: 'Failed to add favorite movie'),
    ],
  );

    blocTest<FavoritesBloc, FavoritesState>(
    'emits [FavoritesLoaded] (updated) when RemoveFavoriteMovie is added and success',
    seed: () => FavoritesLoaded(favoriteMovies: tFavoritesList),
    build: () {
      when(mockFavoriteRepository.removeMovieFromFavorites(tMovie.id)).thenAnswer(
        (_) async => const Right(null),
      );
      when(mockFavoriteRepository.getFavoriteMovies()).thenAnswer(
        (_) async => const Right([]),
      );
      return favoritesBloc;
    },
    act: (bloc) => bloc.add(RemoveFavoriteMovie(tMovie)),
    expect: () => [
      const FavoritesLoaded(favoriteMovies: []),
    ],
  );

   blocTest<FavoritesBloc, FavoritesState>(
    'emits [FavoritesError] when RemoveFavoriteMovie fails',
    seed: () => FavoritesLoaded(favoriteMovies: tFavoritesList),
    build: () {
      when(mockFavoriteRepository.removeMovieFromFavorites(tMovie.id)).thenAnswer(
        (_) async => Left(UnexpectedFailure('Error')),
      );
      return favoritesBloc;
    },
    act: (bloc) => bloc.add(RemoveFavoriteMovie(tMovie)),
    expect: () => [
      const FavoritesError(message: 'Failed to remove favorite movie'),
    ],
  );
}
