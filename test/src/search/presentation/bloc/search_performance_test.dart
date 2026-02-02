import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_proof/domain/entities/search_response_entity.dart';
import 'package:tech_proof/src/search/presentation/bloc/search_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../mocks.mocks.mocks.dart';

void main() {
  late MockMovieRepositoryImpl mockMovieRepository;
  late SearchBloc searchBloc;

  setUp(() {
    mockMovieRepository = MockMovieRepositoryImpl();
    searchBloc = SearchBloc(movieRepository: mockMovieRepository);
  });

  tearDown(() {
    searchBloc.close();
  });

  test(
    'BASELINE: rapid SearchSubmitted events trigger multiple repository calls (non-debounced)',
    () async {
      // Setup mock response
      when(
        mockMovieRepository.searchMovies(query: anyNamed('query')),
      ).thenAnswer(
        (_) async => Right(
          SearchResponseEntity(
            page: 1,
            results: [],
            totalPages: 1,
            totalResults: 0,
          ),
        ),
      );

      // Simulate rapid typing by adding events without waiting
      searchBloc.add(const SearchSubmitted('a'));
      searchBloc.add(const SearchSubmitted('ab'));
      searchBloc.add(const SearchSubmitted('abc'));

      // Allow event loop to process events
      await Future.delayed(Duration(milliseconds: 50));

      // Verify repository was called 3 times (once for each event)
      // Note: restartable() might cancel the *completion* but the call is initiated.
      verify(mockMovieRepository.searchMovies(query: 'a')).called(1);
      verify(mockMovieRepository.searchMovies(query: 'ab')).called(1);
      verify(mockMovieRepository.searchMovies(query: 'abc')).called(1);
    },
  );

  test(
    'OPTIMIZATION: rapid SearchTextChanged events trigger only ONE repository call (debounced)',
    () async {
      // Setup mock response
      when(
        mockMovieRepository.searchMovies(query: anyNamed('query')),
      ).thenAnswer(
        (_) async => Right(
          SearchResponseEntity(
            page: 1,
            results: [],
            totalPages: 1,
            totalResults: 0,
          ),
        ),
      );

      // Simulate rapid typing
      searchBloc.add(const SearchTextChanged('a'));
      searchBloc.add(const SearchTextChanged('ab'));
      searchBloc.add(const SearchTextChanged('abc'));

      // Wait for less than debounce time (should not call yet)
      await Future.delayed(Duration(milliseconds: 100));
      verifyNever(mockMovieRepository.searchMovies(query: anyNamed('query')));

      // Wait for remaining debounce time + buffer
      await Future.delayed(Duration(milliseconds: 300));

      // Verify repository was called ONLY once (with the last value)
      verify(mockMovieRepository.searchMovies(query: 'abc')).called(1);

      // Verify it wasn't called for intermediate values
      verifyNever(mockMovieRepository.searchMovies(query: 'a'));
      verifyNever(mockMovieRepository.searchMovies(query: 'ab'));
    },
  );
}
