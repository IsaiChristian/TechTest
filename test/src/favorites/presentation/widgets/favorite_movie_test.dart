import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/src/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:tech_proof/src/favorites/presentation/widgets/favorite_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../mocks.mocks.mocks.dart';

void main() {
  late MockFavoritesBloc mockFavoritesBloc;
  final movie = const MovieEntity(
    id: 1,
    title: 'Test Movie',
    posterPath: '/path.jpg',
    synopsis: 'Overview',
    releaseDate: '2023-01-01',
    rating: 8.0,
    genres: [],
  );

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();
  });

  Widget createWidgetUnderMain(Widget widget) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<FavoritesBloc>.value(
          value: mockFavoritesBloc,
          child: widget,
        ),
      ),
    );
  }

  group('FavoriteMovie', () {
    testWidgets('shows favorite icon when movie is in favorites', (
      tester,
    ) async {
      when(
        mockFavoritesBloc.state,
      ).thenReturn(FavoritesLoaded(favoriteMovies: [movie]));
      when(mockFavoritesBloc.stream).thenAnswer(
        (_) => Stream.value(FavoritesLoaded(favoriteMovies: [movie])),
      );

      await tester.pumpWidget(
        createWidgetUnderMain(FavoriteMovie(movie: movie)),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('shows favorite_border icon when movie is not in favorites', (
      tester,
    ) async {
      when(
        mockFavoritesBloc.state,
      ).thenReturn(const FavoritesLoaded(favoriteMovies: []));
      when(mockFavoritesBloc.stream).thenAnswer(
        (_) => Stream.value(const FavoritesLoaded(favoriteMovies: [])),
      );

      await tester.pumpWidget(
        createWidgetUnderMain(FavoriteMovie(movie: movie)),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('adds favorite when clicked and not favorite', (tester) async {
      when(
        mockFavoritesBloc.state,
      ).thenReturn(const FavoritesLoaded(favoriteMovies: []));
      when(mockFavoritesBloc.stream).thenAnswer(
        (_) => Stream.value(const FavoritesLoaded(favoriteMovies: [])),
      );

      await tester.pumpWidget(
        createWidgetUnderMain(FavoriteMovie(movie: movie)),
      );

      await tester.tap(find.byType(FloatingActionButton));
      verify(mockFavoritesBloc.add(AddFavoriteMovie(movie))).called(1);
    });

    testWidgets('removes favorite when clicked and is favorite', (
      tester,
    ) async {
      when(
        mockFavoritesBloc.state,
      ).thenReturn(FavoritesLoaded(favoriteMovies: [movie]));
      when(mockFavoritesBloc.stream).thenAnswer(
        (_) => Stream.value(FavoritesLoaded(favoriteMovies: [movie])),
      );

      await tester.pumpWidget(
        createWidgetUnderMain(FavoriteMovie(movie: movie)),
      );

      await tester.tap(find.byType(FloatingActionButton));
      verify(mockFavoritesBloc.add(RemoveFavoriteMovie(movie))).called(1);
    });
  });
}
