import 'package:flutter/material.dart';

import '../models/media.dart';
import 'center_no_history.dart';
import 'manage_media_item.dart';
import 'media_item_wiggle.dart';

class MediaBooks extends StatelessWidget {
  final List<Media> books;
  final bool isEditing;
  MediaBooks(this.books, this.isEditing);
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
        books.isEmpty
            ? CenterNoHistory('No Books Yet!')
            : isEditing
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, ind) {
                      var book = books[ind];
                      return ManageMediaItem(
                        id: book.id,
                        type: 'Book',
                        imageUrl: book.imageUrl,
                        title: book.title,
                      );
                    },
                    itemCount: books.length,
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
                      var book = books[ind];
                      return MediaItemWiggle(book);
                    },
                    itemCount: books.length,
                  ),
      ],
    );
  }
}
