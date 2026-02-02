import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/src/search/presentation/bloc/search_bloc.dart';
import 'package:tech_proof/src/search/presentation/pages/pages.dart';
import 'package:tech_proof/presentation/widgets/tt_movie_grid.dart';
import 'package:tech_proof/presentation/widgets/tt_loading_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../mocks.mocks.mocks.dart';

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

  group('SearchPageView', () {
    testWidgets('shows initial state with search input centered', (tester) async {
      when(mockSearchBloc.state).thenReturn(SearchInitial());
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(SearchInitial()));

      await tester.pumpWidget(createWidgetUnderMain(const SearchPageView()));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(TtMovieGrid), findsNothing);
    });

    testWidgets('shows loading state', (tester) async {
      when(mockSearchBloc.state).thenReturn(SearchLoading());
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(SearchLoading()));

      await tester.pumpWidget(createWidgetUnderMain(const SearchPageView()));

      expect(find.byType(TtLoadingLogo), findsOneWidget);
    });

    testWidgets('shows results when state is SearchLoaded', (tester) async {
       final List<MovieEntity> movies = [
        const MovieEntity(
          id: 1,
          title: 'Test Movie',
          posterPath: '/path.jpg',
          synopsis: 'Overview',
          releaseDate: '2023-01-01',
          rating: 8.0,
          genres: [],
        )
      ];
      when(mockSearchBloc.state).thenReturn(SearchLoaded(movies));
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(SearchLoaded(movies)));

      await tester.pumpWidget(createWidgetUnderMain(const SearchPageView()));

      expect(find.byType(TtMovieGrid), findsOneWidget);
      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('shows error message when state is SearchError', (tester) async {
      when(mockSearchBloc.state).thenReturn(SearchError('Not found'));
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(SearchError('Not found')));

      await tester.pumpWidget(createWidgetUnderMain(const SearchPageView()));

      expect(find.text('Error: Not found'), findsOneWidget);
    });

    testWidgets('triggers SearchSubmitted on text input', (tester) async {
      when(mockSearchBloc.state).thenReturn(SearchInitial());
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(SearchInitial()));

      await tester.pumpWidget(createWidgetUnderMain(const SearchPageView()));

      await tester.enterText(find.byType(TextField), 'query');

      verify(mockSearchBloc.add(any)).called(1); // One for enterText
    });
  });
}
