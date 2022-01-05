import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/media_provider.dart';

class TestScreen extends StatelessWidget {
  static String routeName = '/test-screen';

  @override
  Widget build(BuildContext context) {
    var mediaId = ModalRoute.of(context).settings.arguments as String;
    var media = Provider.of<MediaProvider>(context).findMediaById(mediaId);
    return Scaffold(
      body: Center(
        child: Text(media.title),
      ),
    );
  }
}
