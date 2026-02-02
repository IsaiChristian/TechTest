import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_proof/core/error/failure.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/domain/entities/popular_movies_entity.dart';
import 'package:tech_proof/src/home/presentation/bloc/home_bloc.dart';

import '../../../../mocks.mocks.mocks.dart';

void main() {
  late MockMovieRepositoryImpl mockMovieRepository;
  late HomeBloc homeBloc;

  final tMovies = [
    MovieEntity(
      id: 1,
      title: 'Test Movie',
      posterPath: 'path',
      releaseDate: '2023',
      synopsis: 'synopsis',
      rating: 5.0,
      genres: [],
    ),
  ];

  final tPopularMovies = PopularMoviesResponseEntity(
    page: 1,
    results: tMovies,
    totalPages: 2,
    totalResults: 20,
  );

  final tPopularMoviesPage2 = PopularMoviesResponseEntity(
    page: 2,
    results: [
      MovieEntity(
        id: 2,
        title: 'Test Movie 2',
        posterPath: 'path2',
        releaseDate: '2023',
        synopsis: 'synopsis2',
        rating: 6.0,
        genres: [],
      ),
    ],
    totalPages: 2,
    totalResults: 20,
  );

  setUp(() {
    mockMovieRepository = MockMovieRepositoryImpl();
    homeBloc = HomeBloc(movieRepository: mockMovieRepository);
  });

  tearDown(() {
    homeBloc.close();
  });

  test('initial state is HomeInitial', () {
    expect(homeBloc.state, HomeInitial());
  });

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeReady] when HomeInit is added and repository returns success',
    build: () {
      when(
        mockMovieRepository.getPopularMovies(),
      ).thenAnswer((_) async => Right(tPopularMovies));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeInit()),
    expect: () => [
      HomeLoading(),
      HomeReady(movies: tMovies, page: 1, totalPages: 2),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeError] when HomeInit is added and repository returns failure',
    build: () {
      when(
        mockMovieRepository.getPopularMovies(),
      ).thenAnswer((_) async => Left(ServerFailure('Error')));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeInit()),
    expect: () => [HomeLoading(), HomeError()],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeReady] with isLoadingMore=true when HomeShowLoading is added',
    seed: () => HomeReady(movies: tMovies, page: 1, totalPages: 2),
    build: () => homeBloc,
    act: (bloc) => bloc.add(const HomeShowLoading()),
    expect: () => [
      HomeReady(movies: tMovies, page: 1, totalPages: 2, isLoadingMore: true),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeReady] with new movies when HomeLoadMore is added and repository returns success',
    seed: () =>
        HomeReady(movies: tMovies, page: 1, totalPages: 2, isLoadingMore: true),
    build: () {
      when(
        mockMovieRepository.getPopularMovies(page: 2),
      ).thenAnswer((_) async => Right(tPopularMoviesPage2));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadMore()),
    expect: () => [
      HomeReady(
        movies: [...tMovies, ...tPopularMoviesPage2.results],
        page: 2,
        totalPages: 2,
        isLoadingMore: false,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeError] when HomeLoadMore is added and repository returns failure',
    seed: () =>
        HomeReady(movies: tMovies, page: 1, totalPages: 2, isLoadingMore: true),
    build: () {
      when(
        mockMovieRepository.getPopularMovies(page: 2),
      ).thenAnswer((_) async => Left(ServerFailure('Error')));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const HomeLoadMore()),
    expect: () => [HomeError()],
  );
}
