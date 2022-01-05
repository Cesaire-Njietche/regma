import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../models/media.dart';
import '../providers/cart_provider.dart';
import '../providers/media_provider.dart';
import '../widgets/badge.dart';
import '../widgets/media_books.dart';
import '../widgets/media_events.dart';
import '../widgets/media_movies.dart';
import '../widgets/media_musics.dart';
import '../widgets/media_podcasts.dart';
import 'add_new_media_screen.dart';
import 'cart_screen.dart';
import 'media_detail_screen.dart';

class MediaScreen extends StatefulWidget {
  static String routeName = '/media-screen';
  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      var value =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      isEditing = value['isEditing'];
    }
    bool paymentOptions =
        Provider.of<MediaProvider>(context, listen: false).paymentOptions;

    var media = Provider.of<MediaProvider>(context, listen: false);
    var mediaQuery = MediaQuery.of(context).orientation;
    var w = MediaQuery.of(context).size.width;
    bool isLoading = false;

    //var _index = 0;
    return DefaultTabController(
      // initialIndex: _index,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: isEditing
              ? IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: myOrange,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : null,
          title: Text('Media'),
          actions: [
            if (!isEditing)
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: myOrange,
                ),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: DataSearch(media.allMedia),
                  );
                },
              ),
            if (!isEditing && paymentOptions)
              Consumer<CartProvider>(
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
            if (isEditing)
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: myOrange,
                ),
                onPressed: () => Navigator.of(context)
                    .pushNamed(AddNewMediaScreen.routeName),
              )
          ],
          bottom: TabBar(
            isScrollable: mediaQuery == Orientation.portrait ? true : false,
            labelStyle: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              fontSize: w >= 410 ? 16 : 14,
            ),
            unselectedLabelStyle: GoogleFonts.quicksand(
              fontSize: w >= 410 ? 15 : 13,
            ),
            unselectedLabelColor: Colors.grey,
            labelColor: myOrange,
            tabs: [
              Tab(
                text: 'Movies',
              ),
              Tab(
                text: 'Books',
              ),
              Tab(
                text: 'Musics',
              ),
              Tab(
                text: 'Podcasts',
              ),
              Tab(
                text: 'Events',
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: media.fetchAllMedia(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<MediaProvider>(
                builder: (ctx, media, _) => TabBarView(
                  children: [
                    MediaMovies(media.videos, isEditing),
                    MediaBooks(media.books, isEditing),
                    MediaMusics(media.musics, isEditing),
                    MediaPodcasts(media.podcasts, isEditing),
                    MediaEvents(media.events, isEditing),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<Media> _media;
  DataSearch(this._media)
      : super(searchFieldLabel: "Search Books, Movies and more");

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildWidget(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: myOrange,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.chevron_left,
        color: myOrange,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      textTheme: TextTheme(
        headline6: GoogleFonts.quicksand(
          color: Colors.black87,
          decoration: TextDecoration.none,
        ),
      ),
      // inputDecorationTheme: InputDecorationTheme(
      //   hintStyle: GoogleFonts.quicksand(
      //     fontSize: 15,
      //     color: Colors.black54,
      //   ),
      // ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildWidget(context);
  }

  Widget _buildWidget(BuildContext context) {
    var _mediaList = query.isEmpty
        ? null
        : _media
            .where((media) =>
                media.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return _mediaList == null
        ? Text('')
        : _mediaList.length == 0
            ? Center(
                child: Text(
                  'No Item Found! ',
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            : ListView.builder(
                //Show CircularProgressIndicator when searching from the database
                itemBuilder: (context, ind) {
                  var media = _mediaList[ind];
                  return ListTile(
                      //leading: ,
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            MediaDetailScreen.routeName,
                            arguments: media.id);
                      },
                      title: RichText(
                        text: TextSpan(
                          style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          text: media.title,
                          children: [
                            TextSpan(
                              style: GoogleFonts.quicksand(
                                color: myOrange,
                                fontWeight: FontWeight.bold,
                              ),
                              text: ' (${media.type})',
                            ),
                          ],
                        ),
                      ));
                },
                itemCount: _mediaList.length,
              );
  }
}
