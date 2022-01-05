import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/media_provider.dart';
import '../widgets/center_no_history.dart';
import '../widgets/paid_media_item.dart';

class PaidMediaScreen extends StatelessWidget {
  static String routeName = '/paid-media-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: myOrange,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('My Paid Media'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent.withOpacity(0.05),
                  Colors.transparent.withOpacity(0.1),
                  Colors.transparent.withOpacity(0.05)
                ],
              ),
            ),
          ),
          FutureBuilder(
              future: Provider.of<MediaProvider>(context).fetchPaidMedias(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Consumer<MediaProvider>(
                    //Implement a future builder that will fetch data from Firebase and notify all the listeners along with CircularProgressIndicator
                    builder: (ctx, paidMedias, _) =>
                        paidMedias.items.length == 0
                            ? CenterNoHistory('No Paid Media Yet!')
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (ctx, ind) {
                                  var paidMedia = paidMedias.items[ind];
                                  return PaidMediaItem(
                                    id: paidMedia.id,
                                    date: paidMedia.dateTime,
                                    name: paidMedia.name,
                                    price: paidMedia.price,
                                    image: paidMedia.image,
                                  );
                                },
                                itemCount: paidMedias.items.length,
                              ),
                  );
                }
              })
        ],
      ),
    );
  }
}
