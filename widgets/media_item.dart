import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/cart_provider.dart';
import '../providers/media_provider.dart';
import '../screens/media_detail_screen.dart';

class MediaItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String type;
  final String contentUrl;
  final double price;
  final bool
      isBought; //Useful to give the opportunity to the user to download purchased items. In this case, isFree is set to true
  final bool isFree;
  Function(bool) hasDownloaded;
  Function(bool) hasClicked;

  MediaItem({
    @required this.id,
    @required this.title,
    @required this.isBought,
    @required this.isFree,
    @required this.contentUrl,
    this.type,
    this.price,
    @required this.imageUrl,
    this.hasDownloaded,
    this.hasClicked,
  });
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var fontSizeRegma = w >= 410 ? 15.0 : 12.0;
    var textStyle = TextStyle(
      fontSize: w >= 410 ? 16 : 13,
      fontWeight: FontWeight.w800,
      color: Colors.white,
    );
    var textStyle2 = GoogleFonts.quicksand(
      fontSize: w >= 410 ? 14 : 10,
      color: myOrange,
      fontWeight: FontWeight.bold,
    );

    var cart = Provider.of<CartProvider>(context, listen: false);
    var paymentOption =
        Provider.of<MediaProvider>(context, listen: false).paymentOptions;

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(MediaDetailScreen.routeName, arguments: id);
      },
      child: Card(
        color: Colors.white.withOpacity(.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: LayoutBuilder(builder: (ctx, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: constraints.maxHeight * .8,
                width: constraints.maxWidth,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          10,
                        ),
                        topRight: Radius.circular(
                          10,
                        ),
                      ),
                      child: Container(
                        height: constraints.maxHeight * .8,
                        //width: constraints.maxWidth * 1,
                        color: myOrange,
                        child: Opacity(
                          opacity: .95,
                          child: Hero(
                            tag: id,
                            child: FadeInImage(
                              placeholder: AssetImage(
                                  'assets/images/placeholder_course_regma.png'),
                              image: NetworkImage(
                                imageUrl,
                              ),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          //shape: BoxShape.circle,
                          color: Colors.white.withOpacity(.85),
                        ),
                        child: isFree || !paymentOption
                            ? Text(
                                'Free',
                                style: textStyle2,
                              )
                            : Text(
                                isBought ? 'Bought' : 'Buy',
                                style: textStyle2,
                              ),
                      ),
                      top: 5,
                      right: 5,
                    ),
                    Positioned(
                      child: Container(
                        width: constraints.maxWidth,
                        alignment: Alignment.center,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          // height: constraints.maxHeight * .15,
                          width: constraints.maxWidth * .8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            color: Colors.black54,
                          ),
                          child: Text(
                            title,
                            style: textStyle,
                          ),
                        ),
                      ),
                      bottom: 10,
                    )
                  ],
                ),
              ),
              Container(
                //color: Colors.limeAccent,
                height: constraints.maxHeight * .2,
                alignment: Alignment.centerRight,
                width: double.infinity,
                margin: EdgeInsets.only(left: 5, right: 5),
                child: isFree || isBought || !paymentOption
                    ? Row(
                        children: [
                          OpenButton(contentUrl: contentUrl, type: type),
                          Spacer(),
                          DownloadButton(
                            title: title,
                            url: contentUrl,
                            fontSizeRegma: fontSizeRegma,
                            hasDownloaded: (value) => hasDownloaded(value),
                            hasClicked: (value) => hasClicked(value),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '€${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: w >= 410 ? 17 : 13,
                              // fontWeight: FontWeight.w700,
                              color: myOrange,
                            ),
                          ),
                          FittedBox(
                            child: IconButton(
                              icon: Icon(
                                Icons.shopping_cart,
                                color: myOrange,
                                size: w >= 410 ? 30 : 25,
                              ),
                              onPressed: () {
                                var added =
                                    cart.addItem(id, title, imageUrl, price);
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                if (!added) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: RichText(
                                        text: TextSpan(
                                            text: title,
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
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: RichText(
                                      text: TextSpan(
                                          text: title,
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
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        }),
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
  String title;
  String url;
  double fontSizeRegma;
  Function(bool) hasDownloaded;
  Function(bool) hasClicked;

  DownloadButton({
    this.title,
    this.url,
    this.fontSizeRegma,
    this.hasDownloaded,
    this.hasClicked,
  });

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool isLoading = false;
  String progress = '0%';

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        progress = (received / total * 100).toStringAsFixed(0) + '%';
        widget.hasDownloaded(progress.compareTo('100%') == 0);
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
            icon: Icon(
              Icons.file_download,
              size: 20,
            ),
            label: Text(
              'Download',
              style: TextStyle(fontSize: widget.fontSizeRegma),
            ),
            onPressed: () async {
              widget.hasClicked(true);
              setState(() {
                isLoading = true;
              });
              var success =
                  await Provider.of<MediaProvider>(context, listen: false)
                      .downloadMedia(widget.url, _onReceiveProgress);

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
              }
              setState(() {
                isLoading = false;
              });
            },
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.headline3,
            ),
          );
  }
}
