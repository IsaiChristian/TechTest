import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/presentation/widgets/tt_loading_logo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TtMovieGrid extends StatelessWidget {
  const TtMovieGrid({
    super.key,
    required this.movieList,
  });

  final List<MovieEntity> movieList;

  @override
  Widget build(BuildContext context) {
  return GridView.builder(
          shrinkWrap: true, 
          physics: NeverScrollableScrollPhysics(), 
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
      ), 
        itemCount: movieList.length , 
        itemBuilder: (context, index) {
      
        return GestureDetector(
          onTap: () {
            context.push('/movieDetail/${movieList[index].id}');
          },
          child: Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                        height: double.infinity,
                          color: Colors.grey[400],
                          child: Icon(Icons.movie, size: 64, color: Colors.grey[700]),
                        ),
                      ),
                      if(movieList[index].posterPath != '' )Center(
                        child: SizedBox(
                          width: double.infinity,
                          
                          child: CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w154${movieList[index].posterPath}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(child: TtLoadingLogo( duration: Duration(microseconds: 1500),),),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      ),
                  
                    ],
                  ),
                ),
              
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    movieList[index].title, 
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

