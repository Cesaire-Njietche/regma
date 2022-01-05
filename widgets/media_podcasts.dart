import 'package:flutter/material.dart';

import '../models/media.dart';
import 'center_no_history.dart';
import 'manage_media_item.dart';
import 'media_item_wiggle.dart';

class MediaPodcasts extends StatelessWidget {
  final List<Media> podcasts;
  final bool isEditing;
  MediaPodcasts(this.podcasts, this.isEditing);

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
        podcasts.isEmpty
            ? CenterNoHistory('No Podcasts Yet!')
            : isEditing
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, ind) {
                      var podcast = podcasts[ind];
                      return ManageMediaItem(
                        id: podcast.id,
                        type: 'Podcast',
                        imageUrl: podcast.imageUrl,
                        title: podcast.title,
                      );
                    },
                    itemCount: podcasts.length,
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
                      var podcast = podcasts[ind];

                      return MediaItemWiggle(podcast);
                    },
                    itemCount: podcasts.length,
                  ),
      ],
    );
  }
}
