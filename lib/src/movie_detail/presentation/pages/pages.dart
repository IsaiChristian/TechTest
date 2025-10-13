import 'package:tech_proof/data/repositories/movies_repository_imp.dart';
import 'package:tech_proof/presentation/widgets/tt_app_bar.dart';
import 'package:tech_proof/src/favorites/presentation/widgets/favorite_movie.dart';
import 'package:tech_proof/src/movie_detail/presentation/bloc/movie_detail_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailPage extends StatelessWidget {
  static const String routeName = '/movieDetail';

  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailBloc(
        movieRepository: context.read<MovieRepositoryImpl>(),
        movieId: id,
      )..add(MovieDetailInit()),

      child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          return MovieDetailsView();
        },
      ),
    );
  }
}

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MovieDetailBloc>().state;
    final isLoaded = state is MovieDetailLoaded;
    if (isLoaded) {
    return Scaffold(appBar: TtAppBar(),
    body: Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(imageUrl: 'https://image.tmdb.org/t/p/w500${state.movieDetail.posterPath}', fit: .fitHeight,)
        ),
        Positioned.fill(
          top: 200,
          
        child: Container(
          color: Colors.black87,
          
          child: SingleChildScrollView(
            child: Padding(
              padding: .symmetric(horizontal: 16, vertical: 24),
              child: Column(
                mainAxisSize: .max,
                crossAxisAlignment: .start,
                children: [
                  Wrap(
                    spacing: 8.0, 
                    runSpacing: 4.0, 
                    children: state.movieDetail.genres.map((tag) => _buildTagChip(tag)).toList(),
                  ),                  
                  Text(state.movieDetail.title, style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white), textAlign: .left,),
                  Text('Release Date: ${state.movieDetail.releaseDate}', style: TextStyle(fontSize: 16, color: Colors.white), textAlign: .left,),
                  SizedBox(height: 8,),
                  Text(state.movieDetail.synopsis, style: TextStyle(fontSize: 16, color: Colors.white70), textAlign: .left,),
                  SizedBox(height: 16,),
                  Text('Rating: ${state.movieDetail.rating}/10', style: TextStyle(fontSize: 16, color: Colors.white), textAlign: .left,),
                  SizedBox(height: 16,),
                  
              
                ],
              ),
            ),
          ),
        ),
      ),
        Positioned(
          top: 175,
          right: 16,
          child: FavoriteMovie(
            movie: state.movieDetail,
          ),
        ),]
    ),);
  }
  return Container();
  }
  
}


Widget _buildTagChip(String tag) {
    return Chip(
      label: Text(tag),
      backgroundColor: Colors.blue.shade100,
      labelStyle: TextStyle(color: Colors.blue.shade800),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }