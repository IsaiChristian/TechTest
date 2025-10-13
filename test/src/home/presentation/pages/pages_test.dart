import 'package:tech_proof/core/error/failure.dart';
import 'package:tech_proof/domain/entities/popular_movies_entity.dart';
import 'package:tech_proof/src/home/presentation/bloc/home_bloc.dart';
import 'package:tech_proof/src/home/presentation/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:tech_proof/presentation/widgets/tt_loading_logo.dart';
import 'package:tech_proof/presentation/widgets/tt_movie_grid.dart';
import 'package:tech_proof/data/repositories/movies_repository_imp.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';

import '../../../../mocks.mocks.mocks.dart';

void main() {
  late MockMovieRepositoryImpl mockMovieRepository;
  late List<MovieEntity> movies;
  late HomeBloc homeBloc;

  setUp(() {
    mockMovieRepository = MockMovieRepositoryImpl();
    homeBloc = HomeBloc(movieRepository: mockMovieRepository);
    movies = List.generate(
      20,
      (i) => MovieEntity(
        id: 1,
        title: 'Test Movie $i',
        posterPath: '',
        releaseDate: '2023-01-01',
        synopsis: 'A test movie',
        rating: 8.5,
        genres: ['Action', 'Drama'],
      ),
    );
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: RepositoryProvider<MovieRepositoryImpl>(
        create: (_) => mockMovieRepository,
        child: BlocProvider(create: (context) => homeBloc, child: HomePage()),
      ),
    );
  }

  testWidgets('Shows loading initially', (WidgetTester tester) async {
    final fakeResponse = PopularMoviesResponseEntity(
      results: [],
      page: 1,
      totalPages: 1,
      totalResults: 0,
    );

    when(
      mockMovieRepository.getPopularMovies(),
    ).thenAnswer((_) async => Right(fakeResponse));

    await tester.pumpWidget(makeTestableWidget());

    // Assert
    expect(find.byType(TtLoadingLogo), findsOneWidget);
  });
  testWidgets('Shows movie grid when HomeReady state', (
    WidgetTester tester,
  ) async {
    final fakeResponse = PopularMoviesResponseEntity(
      results: movies,
      page: 1,
      totalPages: 2,
      totalResults: 20,
    );

    // Stub repository with proper parameter
    when(
      mockMovieRepository.getPopularMovies(),
    ).thenAnswer((_) async => Right(fakeResponse));
    homeBloc.emit(
      HomeReady(movies: fakeResponse.results, page: 1, totalPages: 2),
    );
    await tester.pumpWidget(makeTestableWidget());

    // Allow Bloc to emit HomeReady
    await tester.pumpAndSettle();

    expect(find.byType(TtMovieGrid), findsOneWidget);
    expect(find.text('Test Movie 1'), findsOneWidget);
    expect(find.text('Test Movie 2'), findsOneWidget);
  });
  testWidgets('Triggers load more when scrolled near bottom', (
    WidgetTester tester,
  ) async {
    final fakeResponse = PopularMoviesResponseEntity(
      results: movies,
      page: 1,
      totalPages: 2,
      totalResults: 20,
    );

    when(
      mockMovieRepository.getPopularMovies(page: anyNamed('page')),
    ).thenAnswer((_) async => Right(fakeResponse));

    homeBloc.emit(
      HomeReady(
        movies: fakeResponse.results,
        page: 1,
        totalPages: 2,
        isLoadingMore: false,
      ),
    );
    await tester.pumpWidget(makeTestableWidget());

    // Allow Bloc to emit HomeReady
    await tester.pumpAndSettle();
    // Scroll to bottom
    final scrollable = find.byKey(ValueKey('home_scroll_view'));
    expect(scrollable, findsOneWidget);
    await tester.drag(scrollable, const Offset(0, -6000));
    await tester.pumpAndSettle();

    // Verify that HomeLoadMore event was added (you can verify bloc events using mock bloc)
    verify(mockMovieRepository.getPopularMovies(page: 2)).called(1);
  });

  testWidgets('Shows error when HomeError state', (WidgetTester tester) async {
    // Arrange: make repository throw error
    when(
      mockMovieRepository.getPopularMovies(page: 1),
    ).thenAnswer((_) async => Left(UnexpectedFailure('Failed') as dynamic));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(
      find.text('An error occurred. Please try again later.'),
      findsOneWidget,
    );
  });
}
