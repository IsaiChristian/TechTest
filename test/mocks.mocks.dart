import 'package:tech_proof/data/repositories/favorites_repository_impl.dart';
import 'package:tech_proof/data/repositories/movies_repository_imp.dart';
import 'package:tech_proof/src/app/bloc/app_bloc.dart';
import 'package:tech_proof/src/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:tech_proof/src/home/presentation/bloc/home_bloc.dart';
import 'package:tech_proof/src/movie_detail/presentation/bloc/movie_detail_bloc.dart';
import 'package:tech_proof/src/search/presentation/bloc/search_bloc.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:tech_proof/core/services/local_storage_service.dart';

@GenerateMocks([LocalStorageService])
@GenerateMocks([MovieRepositoryImpl])
@GenerateMocks([FavoriteRepositoryImpl])
@GenerateMocks([AppBloc])
@GenerateMocks([FavoritesBloc])
@GenerateMocks([HomeBloc])
@GenerateMocks([SearchBloc])
@GenerateMocks([MovieDetailBloc])
@GenerateMocks([Dio])
void main() {}
