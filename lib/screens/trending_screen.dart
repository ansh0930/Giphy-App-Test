import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giphy_app_test/screens/fav_gif_screen.dart';
import 'package:giphy_app_test/screens/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Constants/colors.dart';
import '../Constants/text_styles.dart';
import '../WidgetHelper/full_image_screen.dart';
import '../WidgetHelper/image_loader.dart';
import '../data/entity/gif_data_entity.dart';
import '../data/model/base_model.dart';
import '../data/model/gif_data_model.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  late ScrollController scrollController;
  bool showButtomLoader = true;
  bool isSearchQuery = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<GiphsModel>().fetchTrendingImages();

    scrollController = ScrollController(keepScrollOffset: true);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        showButtomLoader = true;
        if (context.read<GiphsModel>().offset <= maxNofOfssets) {
          context.read<GiphsModel>().fetchTrendingImages();
        }
      } else {
        showButtomLoader = false;
      }
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      print('User signed out');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  var children = <Widget>[];
  @override
  Widget build(BuildContext context) {
    return Consumer<GiphsModel>(builder: (context, model, child) {
      GifDataEntity? giphyQuery;
      if (searchQuery == '') isSearchQuery = false;
      if (isSearchQuery == true) {
        giphyQuery = model.giphySearchAlbum;
      } else {
        giphyQuery = model.giphyTrendingAlbum;
      }

      if (giphyQuery != null) {
        children.clear();

        for (var element in giphyQuery.data!) {
          if (element.images?.original?.webp != null) {
            children.add(Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                child: SizedBox(
                    height: double.parse(
                        element.images!.fixedHeightDownsampled!.height!),
                    child: Stack(
                      children: [
                        GestureDetector(
                            child: ImageLoader(
                              imageUrl:
                                  element.images!.fixedHeightDownsampled!.url!,
                            ),
                            onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullImageScreen(
                                              gifData: element,
                                            )),
                                  )
                                }),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () async {
                              addFavGif(element);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  color: Colors.black.withOpacity(0.3)),
                              child: Icon(
                                Icons.favorite,
                                size: 25,
                                color: context
                                        .read<GiphsModel>()
                                        .favGif
                                        .contains(element.id)
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ))));
          } else {
            children.add(const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Center(
                    child: Text('This Gif is not available at the moment'))));
          }
        }
        showButtomLoader && !isSearchQuery
            ? children.add(const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ))))
            : children.add(const SizedBox());
      }

      return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                child: const Text(
                  'Trending',
                  style: TextStyle(color: Colors.deepPurple),
                ),
                onPressed: () {
                  isSearchQuery = false;
                  scrollController.jumpTo(0);
                }),
            SizedBox(
                width: 25,
                child: IconButton(
                    onPressed: () {
                      _logout();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ))),
            SizedBox(
              width: 15,
            )
          ],
          title: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black)),
            height: 40,
            child: SearchBar(
              hintText: "Search",
              onChanged: (value) {
                isSearchQuery = true;
                searchQuery = value;
                model.searchImages(value);
                scrollController.jumpTo(0);
              },
            ),
          ),
          backgroundColor: appBarColor,
          centerTitle: true,
        ),
        floatingActionButton: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavGifScreen()),
          ),
          child: SizedBox(
            height: 80,
            child: Column(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 50,
                ),
                Text(
                  "Favorites",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        body: Center(
            child: ListView(
                shrinkWrap: true,
                controller: scrollController,
                children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: isSearchQuery
                          ? Text('Search : $searchQuery')
                          : RichText(
                              overflow: TextOverflow.visible,
                              maxLines: 4,
                              text: TextSpan(
                                  text: 'Whats trending\n',
                                  style: trendingScreenHeading,
                                  children: [
                                    TextSpan(
                                        text:
                                            ' ${DateFormat('dd MMMM').format(DateTime.now())}',
                                        style: trendingScreenSubHeading),
                                  ]),
                            ))),
              model.loadingStatus == LoadingStatusE.idle
                  ? gifListView()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const LinearProgressIndicator()),
            ])),
      );
    });
  }

  Future<void> addFavGif(element) async {
    if (context.read<GiphsModel>().favGif.contains(element.id)) {
      await context.read<GiphsModel>().removeFav(element.id);
      setState(() {});
    } else {
      await context
          .read<GiphsModel>()
          .addFav(jsonEncode(element.toJson()), id: element.id);
      setState(() {});
    }
  }

  gifListView() {
    return Column(children: children);
  }
}
