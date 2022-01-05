import 'package:flutter/material.dart';

import '../models/media.dart';
import 'center_no_history.dart';
import 'manage_media_item.dart';
import 'media_item_wiggle.dart';

class MediaEvents extends StatelessWidget {
  final List<Media> events;
  final isEditing;

  MediaEvents(this.events, this.isEditing);

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
        events.isEmpty
            ? CenterNoHistory('No Events Yet!')
            : isEditing
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, ind) {
                      var event = events[ind];
                      return ManageMediaItem(
                        id: event.id,
                        type: 'Event',
                        imageUrl: event.imageUrl,
                        title: event.title,
                      );
                    },
                    itemCount: events.length,
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
                      var event = events[ind];

                      return MediaItemWiggle(event);
                    },
                    itemCount: events.length,
                  ),
      ],
    );
  }
}
