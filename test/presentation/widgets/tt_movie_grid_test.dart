import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/presentation/widgets/tt_movie_grid.dart';

void main() {
  final tMovies = [
    MovieEntity(
      id: 1,
      title: 'Movie 1',
      posterPath: 'poster1',
      releaseDate: '2023',
      synopsis: 'synopsis1',
      rating: 5.0,
      genres: [],
    ),
    MovieEntity(
      id: 2,
      title: 'Movie 2',
      posterPath: 'poster2',
      releaseDate: '2023',
      synopsis: 'synopsis2',
      rating: 6.0,
      genres: [],
    ),
  ];

  testWidgets('TtMovieGrid renders grid of movies', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TtMovieGrid(movieList: tMovies)),
      ),
    );

    expect(find.byType(TtMovieGrid), findsOneWidget);
    expect(find.text('Movie 1'), findsOneWidget);
    expect(find.text('Movie 2'), findsOneWidget);
  });

  testWidgets('TtMovieGrid handles empty list', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TtMovieGrid(movieList: [])),
      ),
    );

    expect(find.byType(TtMovieGrid), findsOneWidget);
    expect(find.byType(Card), findsNothing);
  });
}
