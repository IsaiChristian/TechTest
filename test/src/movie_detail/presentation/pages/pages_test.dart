import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/src/movie_detail/presentation/bloc/movie_detail_bloc.dart';
import 'package:tech_proof/src/movie_detail/presentation/pages/pages.dart';
import 'package:tech_proof/src/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../mocks.mocks.mocks.dart';

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockFavoritesBloc mockFavoritesBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockFavoritesBloc = MockFavoritesBloc();
  });

  Widget createWidgetUnderMain(Widget widget) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
          BlocProvider<FavoritesBloc>.value(value: mockFavoritesBloc),
        ],
        child: widget,
      ),
    );
  }

  group('MovieDetailsView', () {
    testWidgets('renders movie details when state is MovieDetailLoaded', (
      tester,
    ) async {
      final movie = const MovieEntity(
        id: 1,
        title: 'Test Movie',
        posterPath: '/path.jpg',
        synopsis: 'Overview',
        releaseDate: '2023-01-01',
        rating: 8.0,
        genres: ['Action', 'Drama'],
      );

      when(mockMovieDetailBloc.state).thenReturn(MovieDetailLoaded(movie));
      when(
        mockMovieDetailBloc.stream,
      ).thenAnswer((_) => Stream.value(MovieDetailLoaded(movie)));

      // Also mock FavoritesBloc for FavoriteMovie widget
      when(
        mockFavoritesBloc.state,
      ).thenReturn(const FavoritesLoaded(favoriteMovies: []));
      when(mockFavoritesBloc.stream).thenAnswer(
        (_) => Stream.value(const FavoritesLoaded(favoriteMovies: [])),
      );

      await tester.pumpWidget(createWidgetUnderMain(const MovieDetailsView()));

      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('renders nothing when state is not loaded', (tester) async {
      when(mockMovieDetailBloc.state).thenReturn(MovieDetailInitial());
      when(
        mockMovieDetailBloc.stream,
      ).thenAnswer((_) => Stream.value(MovieDetailInitial()));

      when(
        mockFavoritesBloc.state,
      ).thenReturn(const FavoritesLoaded(favoriteMovies: []));
      when(mockFavoritesBloc.stream).thenAnswer(
        (_) => Stream.value(const FavoritesLoaded(favoriteMovies: [])),
      );

      await tester.pumpWidget(createWidgetUnderMain(const MovieDetailsView()));

      expect(find.byType(Scaffold), findsNothing);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
