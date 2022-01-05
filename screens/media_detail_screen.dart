import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../models/media.dart';
import '../providers/cart_provider.dart';
import '../providers/media_provider.dart';
import '../widgets/badge.dart';
import 'cart_screen.dart';

class MediaDetailScreen extends StatelessWidget {
  static String routeName = '/media-detail-screen';
  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context).settings.arguments as String;
    var media =
        Provider.of<MediaProvider>(context, listen: false).findMediaById(id);
    var paymentOption =
        Provider.of<MediaProvider>(context, listen: false).paymentOptions;
    var mediaQuery = MediaQuery.of(context);
    //print(mediaQuery.size.width);
    var textStyle = TextStyle(
      color: myOrange,
    );
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
        title: FittedBox(
          child: Text(media.title),
        ),
        actions: [
          media.isFree || !paymentOption
              ? Text(' ')
              : Consumer<CartProvider>(
                  builder: (_, cart, ch) => Badge(
                    child: ch,
                    value: '${cart.count()}',
                    color: Colors.lime.shade300,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: myOrange,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                ),
        ],
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent.withOpacity(0.06),
                Colors.transparent.withOpacity(0.1),
                Colors.transparent.withOpacity(0.04)
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                height: 200,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 30),
                //color: Colors.blueGrey,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: media.id,
                    child: Image.network(
                      media.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                media.title,
                style: GoogleFonts.quicksand(
                    color: Colors.black.withOpacity(.6), fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              media.isFree || !paymentOption
                  ? Text(
                      'Free Access',
                      style: textStyle,
                    )
                  : Text(
                      media.isBought
                          ? 'Bought'
                          : '€${media.price.toStringAsFixed(2)}',
                      style: textStyle,
                    ),
              buildAbout(media),
              buildDescription(media),
              media.isFree || media.isBought || !paymentOption
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          OpenButton(
                              contentUrl: media.contentUrl,
                              type: media.type == 'Podcast'
                                  ? 'Music'
                                  : media.type == 'Event'
                                      ? 'Movie'
                                      : media.type),
                          Spacer(),
                          DownloadButton(media: media),
                        ],
                      ),
                    )
                  : Consumer<CartProvider>(
                      builder: (_, cart, __) => ElevatedButton.icon(
                        onPressed: () {
                          var added = cart.addItem(
                            id,
                            media.title,
                            media.imageUrl,
                            media.price,
                          );
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          if (!added) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: RichText(
                                  text: TextSpan(
                                      text: media.title,
                                      style: GoogleFonts.quicksand(
                                        color: myOrange,
                                      ),
                                      children: [
                                        TextSpan(
                                          style: GoogleFonts.quicksand(
                                            color: Colors.white,
                                          ),
                                          text: ' already in the cart',
                                        )
                                      ]),
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: RichText(
                                text: TextSpan(
                                    text: media.title,
                                    style: GoogleFonts.quicksand(
                                      color: myOrange,
                                    ),
                                    children: [
                                      TextSpan(
                                        style: GoogleFonts.quicksand(
                                            color: Colors.white),
                                        text: ' added to the cart',
                                      )
                                    ]),
                              ),
                              duration: Duration(seconds: 3),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  cart.removeItem(id);
                                },
                              ),
                            ));
                          }
                        },
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white.withOpacity(.9),
                        ),
                        label: Text('Add to Cart'),
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container buildDescription(Media media) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      //height: screenHeight * .3,
      child: Material(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: myOrange.shade800,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Description',
                style: TextStyle(color: myOrange, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                media.description,
                maxLines: 20,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildAbout(Media media) {
    return Container(
      margin: EdgeInsets.only(
        right: 30,
        left: 30,
        top: 20,
      ),
      //height: screenHeight * .3,
      child: Material(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: myOrange.shade800,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'About',
                style: TextStyle(color: myOrange, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: Row(
                children: [
                  Text(
                    'Type:     ',
                  ),
                  Text(
                    media.type,
                  ),
                ],
              ),
            ),
            media.type == 'Event'
                ? Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          'Place:    ',
                        ),
                        Text(
                          media.author,
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          'Author:  ',
                        ),
                        Text(
                          media.author,
                        ),
                      ],
                    ),
                  ),
            media.type != 'Book'
                ? Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          'Length: ',
                        ),
                        Text(
                          ' ${media.length} mn',
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class OpenButton extends StatefulWidget {
  const OpenButton({
    Key key,
    @required this.contentUrl,
    @required this.type,
  }) : super(key: key);

  final String contentUrl;
  final String type;

  @override
  State<OpenButton> createState() => _OpenButtonState();
}

class _OpenButtonState extends State<OpenButton> {
  bool opening = false;

  @override
  Widget build(BuildContext context) {
    return opening
        ? Text(
            'Opening ...',
            style: TextStyle(color: myOrange, fontSize: 13),
          )
        : TextButton.icon(
            onPressed: () async {
              setState(() {
                opening = true;
              });
              await Provider.of<MediaProvider>(context, listen: false)
                  .openMedia(widget.contentUrl);
              setState(() {
                opening = false;
              });
            },
            icon: Icon(
              widget.type == 'Movie'
                  ? Icons.live_tv
                  : widget.type == 'Music'
                      ? Icons.queue_music
                      : Icons.library_books,
              color: myOrange,
              size: 20,
            ),
            label: Text('Open'),
          );
  }
}

class DownloadButton extends StatefulWidget {
  DownloadButton({
    Key key,
    @required this.media,
  }) : super(key: key);

  final Media media;

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  var isLoading = false;
  String progress = '0%';

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        progress = (received / total * 100).toStringAsFixed(0) + '%';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) progress = '0%';
    return isLoading
        ? Text(
            progress,
            style: GoogleFonts.quicksand(color: myOrange),
          )
        : TextButton.icon(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              var success = await Provider.of<MediaProvider>(context,
                      listen: false)
                  .downloadMedia(widget.media.contentUrl, _onReceiveProgress);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: myOrange.withOpacity(0.9),
                  content: Text(
                    'Media successfully downloaded',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  duration: Duration(seconds: 3),
                ));

                setState(() {
                  isLoading = false;
                });
              }
            },
            icon: Icon(
              Icons.download_rounded,
              size: 20,
            ),
            label: Text(
              'Download',
              style: TextStyle(fontSize: 15),
            ),
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.headline3,
            ),
          );
  }
}
