import 'package:flutter/material.dart';

import '../models/media.dart';
import 'center_no_history.dart';
import 'manage_media_item.dart';
import 'media_item_wiggle.dart';

class MediaMovies extends StatelessWidget {
  final List<Media> movies;
  final isEditing;

  MediaMovies(this.movies, this.isEditing);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent.withOpacity(0.06),
                Colors.transparent.withOpacity(0.07),
                Colors.transparent.withOpacity(0.04)
              ],
            ),
          ),
        ),
        movies.isEmpty
            ? CenterNoHistory('No Movies Yet!')
            : isEditing
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, ind) {
                      var movie = movies[ind];
                      return ManageMediaItem(
                        id: movie.id,
                        type: 'Movie',
                        imageUrl: movie.imageUrl,
                        title: movie.title,
                      );
                    },
                    itemCount: movies.length,
                  )
                : GridView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (ctx, ind) {
                      var movie = movies[ind];

                      return MediaItemWiggle(movie);
                    },
                    itemCount: movies.length,
                  ),
      ],
    );
  }
}
