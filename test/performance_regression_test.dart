import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/presentation/widgets/tt_loading_logo.dart';
import 'package:tech_proof/presentation/widgets/tt_movie_grid.dart';
import 'package:tech_proof/src/search/presentation/bloc/search_bloc.dart';
import 'package:tech_proof/src/search/presentation/pages/pages.dart';

import 'mocks.mocks.mocks.dart';

void main() {
  late MockSearchBloc mockSearchBloc;

  setUp(() {
    mockSearchBloc = MockSearchBloc();
  });

  Widget createWidgetUnderMain(Widget widget) {
    return MaterialApp(
      home: BlocProvider<SearchBloc>.value(
        value: mockSearchBloc,
        child: widget,
      ),
    );
  }

  group('Performance Regression Tests', () {
    testWidgets('SearchPageView LoadingLogo has correct duration (1500ms)', (tester) async {
      when(mockSearchBloc.state).thenReturn(SearchLoading());
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(SearchLoading()));

      await tester.pumpWidget(createWidgetUnderMain(const SearchPageView()));

      final logoFinder = find.byType(TtLoadingLogo);
      expect(logoFinder, findsOneWidget);

      final TtLoadingLogo logo = tester.widget(logoFinder);
      // We expect the fix to be present: 1500 milliseconds
      expect(logo.duration, const Duration(milliseconds: 1500));
    });

    testWidgets('TtMovieGrid CachedNetworkImage placeholder has correct duration (1500ms)', (tester) async {
       final tMovies = [
          MovieEntity(
            id: 1,
            title: 'Movie 1',
            posterPath: '/poster1.jpg',
            releaseDate: '2023',
            synopsis: 'synopsis1',
            rating: 5.0,
            genres: [],
          ),
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TtMovieGrid(movieList: tMovies)),
        ),
      );

      // We hope to catch it in placeholder state
      final logoFinder = find.byType(TtLoadingLogo);
      expect(logoFinder, findsOneWidget);

      final TtLoadingLogo logo = tester.widget(logoFinder.first);
      expect(logo.duration, const Duration(milliseconds: 1500));
    });
  });
}
