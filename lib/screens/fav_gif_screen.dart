import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Constants/colors.dart';
import '../Constants/text_styles.dart';
import '../WidgetHelper/full_image_screen.dart';
import '../WidgetHelper/image_loader.dart';
import '../data/entity/gif_data_entity.dart';
import '../data/model/base_model.dart';
import '../data/model/gif_data_model.dart';

class FavGifScreen extends StatefulWidget {
  const FavGifScreen({super.key});

  @override
  State<FavGifScreen> createState() => _FavGifScreenState();
}

class _FavGifScreenState extends State<FavGifScreen> {
  // late Future<GiphyTrending> giphyTrendingAlbum;
  // late Future<GiphyTrending> giphySearchAlbum;
  late ScrollController scrollController;
  bool showButtomLoader = true;
  bool isSearchQuery = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<GiphsModel>().fetchFavGif();
    scrollController = ScrollController(keepScrollOffset: true);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        showButtomLoader = true;
        // if (context.read<GiphsModel>().offset <= maxNofOfssets) {
        //   // on bottom scroll API Call until last page
        //   // context.read<GiphsModel>().fetchTrendingImages();
        // }
      } else {
        showButtomLoader = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: GiphsModel().fetchFavGif(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          var children = <Widget>[];
          int index = 0;
          GifDataEntity? giphyQuery = GifDataEntity(data: []);
          if (snapshot.hasError) {
            return const Text('Something went wrong try again');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.size == 0) {
            children.add(SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: Text("No favorites data found."),
              ),
            ));
          }
          if (snapshot.data!.size != 0) if (snapshot.data!.docs!.isNotEmpty) {
            children.clear();

            snapshot.data!.docs.forEach((element) => giphyQuery.data
                ?.add(Data.fromJson(jsonDecode(element['gif']))));

            for (var element in giphyQuery.data!) {
              if (element.images?.original?.webp != null) {
                children.add(Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                    child: SizedBox(
                        height: double.parse(
                            element.images!.fixedHeightDownsampled!.height!),
                        child: GestureDetector(
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
                                }))));
              } else {
                children.add(const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Center(
                        child:
                            Text('This Gif is not available at the moment'))));
              }
            }
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Favorites",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              backgroundColor: appBarColor,
              centerTitle: true,
              // onSearch: (value) {

              // },
            ),
            body: ListView(
                shrinkWrap: true,
                controller: scrollController,
                children: [Column(children: children)]),
          );
        });
  }
}
