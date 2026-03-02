// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/presentation/widgets/tt_movie_grid.dart';

void main() {
  testWidgets('Performance Baseline: TtMovieGrid widget build count', (WidgetTester tester) async {
    // Create 100 fake movies
    final tMovies = List.generate(
      100,
      (index) => MovieEntity(
        id: index,
        title: 'Movie $index',
        posterPath: 'poster$index',
        releaseDate: '2023',
        synopsis: 'synopsis$index',
        rating: 5.0,
        genres: [],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              TtMovieGrid(movieList: tMovies),
            ],
          ),
        ),
      ),
    );

    // Using pump() instead of pumpAndSettle() because TtLoadingLogo might have a continuous animation
    // which prevents the app from "settling".
    await tester.pump();

    // With SliverGrid, only the children visible on the screen should be built.
    // In a default test environment (800x600 resolution), it should be a fraction of the 100 movies.
    final cardCount = find.byType(Card).evaluate().length;

    print('====================================================');
    print('PERFORMANCE BENCHMARK RESULT');
    print('Total movies provided: ${tMovies.length}');
    print('Total Card widgets built: $cardCount');
    print('====================================================');

    // We expect the card count to be significantly less than 100.
    // Given the childAspectRatio of 0.7, screen width 800, height 600, cross axis count 2.
    // It should build around 6-12 cards. Let's assert it's less than 20.
    expect(cardCount, lessThan(20));
  });
}
