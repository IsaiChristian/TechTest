import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/src/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:tech_proof/src/favorites/presentation/pages/pages.dart';
import 'package:tech_proof/presentation/widgets/tt_movie_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../mocks.mocks.mocks.dart';

void main() {
  late MockFavoritesBloc mockFavoritesBloc;

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();
  });

  Widget createWidgetUnderMain(Widget widget) {
    return MaterialApp(
      home: BlocProvider<FavoritesBloc>.value(
        value: mockFavoritesBloc,
        child: widget,
      ),
    );
  }

  group('FavoritesPage', () {
    testWidgets('renders FavoritesPageView when loaded', (tester) async {
      when(
        mockFavoritesBloc.state,
      ).thenReturn(const FavoritesLoaded(favoriteMovies: []));
      when(mockFavoritesBloc.stream).thenAnswer(
        (_) => Stream.value(const FavoritesLoaded(favoriteMovies: [])),
      );

      await tester.pumpWidget(createWidgetUnderMain(const FavoritesPage()));

      expect(find.byType(FavoritesPageView), findsOneWidget);
    });
  });

  group('FavoritesPageView', () {
    testWidgets('shows empty message when favorites list is empty', (
      tester,
    ) async {
      when(
        mockFavoritesBloc.state,
      ).thenReturn(const FavoritesLoaded(favoriteMovies: []));
      when(mockFavoritesBloc.stream).thenAnswer(
        (_) => Stream.value(const FavoritesLoaded(favoriteMovies: [])),
      );

      await tester.pumpWidget(createWidgetUnderMain(const FavoritesPageView()));

      expect(
        find.text('No favorite movies yet. Start adding some!'),
        findsOneWidget,
      );
      expect(find.byType(TtMovieGrid), findsOneWidget);
    });

    testWidgets('shows list of movies when favorites list is not empty', (
      tester,
    ) async {
      final List<MovieEntity> movies = [
        const MovieEntity(
          id: 1,
          title: 'Test Movie',
          posterPath: '/path.jpg',
          synopsis: 'Overview',
          releaseDate: '2023-01-01',
          rating: 8.0,
          genres: [],
        ),
      ];
      when(
        mockFavoritesBloc.state,
      ).thenReturn(FavoritesLoaded(favoriteMovies: movies));
      when(mockFavoritesBloc.stream).thenAnswer(
        (_) => Stream.value(FavoritesLoaded(favoriteMovies: movies)),
      );

      await tester.pumpWidget(createWidgetUnderMain(const FavoritesPageView()));

      expect(
        find.text('No favorite movies yet. Start adding some!'),
        findsNothing,
      );
      expect(find.byType(TtMovieGrid), findsOneWidget);
      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('shows error message when state is FavoritesError', (
      tester,
    ) async {
      when(
        mockFavoritesBloc.state,
      ).thenReturn(const FavoritesError(message: 'Error message'));
      when(mockFavoritesBloc.stream).thenAnswer(
        (_) => Stream.value(const FavoritesError(message: 'Error message')),
      );

      await tester.pumpWidget(createWidgetUnderMain(const FavoritesPageView()));

      expect(
        find.text('An error occurred. Please try again later.'),
        findsOneWidget,
      );
    });

    testWidgets('renders SizedBox when state is Initial', (tester) async {
      when(mockFavoritesBloc.state).thenReturn(FavoritesInitial());
      when(
        mockFavoritesBloc.stream,
      ).thenAnswer((_) => Stream.value(FavoritesInitial()));

      await tester.pumpWidget(createWidgetUnderMain(const FavoritesPageView()));

      expect(find.byType(SizedBox), findsWidgets);
      expect(find.text('Favorite Movies'), findsNothing); // AppBar title
    });
  });
}
