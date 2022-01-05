import 'dart:math';

import 'package:flutter/material.dart';

import '../models/media.dart';
import '../widgets/media_item.dart';

class MediaItemWiggle extends StatefulWidget {
  Media media;
  MediaItemWiggle(this.media);

  @override
  _MediaItemWiggleState createState() => _MediaItemWiggleState();
}

class _MediaItemWiggleState extends State<MediaItemWiggle> {
  Media media;
  var hasDownloaded = false;
  var hasClicked = false;
  var sinePeriod = 2 * pi;
  var endValue = 0.0;
  @override
  void initState() {
    media = widget.media;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        key: Key(media.id),
        tween: Tween(begin: 0.0, end: endValue),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, _) {
          double offset = sin(value);
          return Transform.translate(
            offset: Offset(0, offset),
            child: MediaItem(
              id: media.id,
              title: media.title,
              imageUrl: media.imageUrl,
              contentUrl: media.contentUrl,
              isBought: media.isBought,
              isFree: media.isFree,
              price: media.price,
              type: media.type == 'Book'
                  ? 'Book'
                  : media.type == 'Music' || media.type == 'Podcast'
                      ? 'Music'
                      : 'Movie',
              hasClicked: (value) {
                hasClicked = value;
                if (hasClicked) {
                  setState(() {
                    endValue = 0.0;
                  });
                }
              },
              hasDownloaded: (value) {
                hasDownloaded = value;
                if (hasDownloaded) {
                  setState(() {
                    endValue = sinePeriod;
                  });
                }
              },
            ),
          );
        });
    ;
  }
}
