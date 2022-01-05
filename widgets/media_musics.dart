import 'package:flutter/material.dart';

import '../models/media.dart';
import 'center_no_history.dart';
import 'manage_media_item.dart';
import 'media_item_wiggle.dart';

class MediaMusics extends StatelessWidget {
  final List<Media> musics;
  final bool isEditing;
  MediaMusics(this.musics, this.isEditing);
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
        musics.isEmpty
            ? CenterNoHistory('No Musics Yet!')
            : isEditing
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, ind) {
                      var music = musics[ind];
                      return ManageMediaItem(
                        id: music.id,
                        type: 'Music',
                        imageUrl: music.imageUrl,
                        title: music.title,
                      );
                    },
                    itemCount: musics.length,
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
                      var music = musics[ind];

                      return MediaItemWiggle(music);
                    },
                    itemCount: musics.length,
                  ),
      ],
    );
  }
}
