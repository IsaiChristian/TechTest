import 'package:tech_proof/presentation/widgets/tt_app_bar.dart';
import 'package:tech_proof/presentation/widgets/tt_movie_grid.dart' show TtMovieGrid;
import 'package:tech_proof/src/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        return FavoritesPageView();
      },
    );
  }
}

class FavoritesPageView extends StatelessWidget {
  const FavoritesPageView({super.key});

  @override
  Widget build(BuildContext context) {
        final currentState = context.watch<FavoritesBloc>().state;

    if (currentState is FavoritesLoaded) {
   
    return Scaffold(
      appBar: TtAppBar(
        title: 'Favorite Movies',
      ),
      body: SingleChildScrollView(
                         

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             
            Padding(
              padding: .all(24),
              child: 
              
              
             TtMovieGrid(movieList: currentState.favoriteMovies),        
            ),
            if (currentState.favoriteMovies.isEmpty)
                  Center(child: Text('No favorite movies yet. Start adding some!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
          ],
        ),
      ),
    );
  }
  if (currentState is FavoritesError) {
    return Scaffold(
      appBar: TtAppBar(),
      body: Center(
        child: Text('An error occurred. Please try again later.'),
      ),
    );
  }
  return SizedBox.shrink();
  }
}

