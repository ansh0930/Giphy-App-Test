import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/gif_data_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as AT;
import 'base_model.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://api.giphy.com/v1';
const apiKey = 'OJGGdBnlo0s9qkQLWv6QAQiIK3WNfOn2';
const giphsPerPage = 5;
const maxNofOfssets = 100;

class GiphsModel extends BaseModel {
  GifDataEntity? giphyTrendingAlbum;
  GifDataEntity? giphySearchAlbum;
  List<String> favGif = [];
  // AT.User? user;
  int offset = 0;
  int limit = giphsPerPage;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static AT.FirebaseAuth _auth = AT.FirebaseAuth.instance;
  static AT.User get user => _auth.currentUser!;

  fetchTrendingImages() async {
    loadingStatus = LoadingStatusE.busy;
    final response = await http.get(Uri.parse(
        '$baseUrl/gifs/trending?api_key=$apiKey&limit=$limit&offset=$offset'));
    print('$baseUrl/gifs/trending?api_key=$apiKey&limit=$limit&offset=$offset');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      giphyTrendingAlbum = GifDataEntity.fromJson(jsonDecode(response.body));
      loadingStatus = LoadingStatusE.idle;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      loadingStatus = LoadingStatusE.error;
      throw Exception('Failed to load album');
    }
    offset += 1;
    limit += giphsPerPage;
    updateFavGifList();
    notifyListeners();
  }

  searchImages(String searchString) async {
    loadingStatus = LoadingStatusE.busy;
    final response = await http.get(Uri.parse(
        '$baseUrl/gifs/search?api_key=$apiKey&q=$searchString&limit=$limit&offset=$offset/'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      giphySearchAlbum = GifDataEntity.fromJson(jsonDecode(response.body));
      loadingStatus = LoadingStatusE.idle;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      loadingStatus = LoadingStatusE.error;
      throw Exception('Failed to load album');
    }
    notifyListeners();
  }

  addFav(String gif, {String? id}) async {
    await FirebaseFirestore.instance
        .collection('fav_giphy')
        .add({'user_email': user.email, 'gif': gif, 'gif_id': id, 'delete': 0});
    updateFavGifList();
  }

  removeFav(String? id) async {
    await FirebaseFirestore.instance
        .collection('fav_giphy')
        .where('user_email', isEqualTo: user.email)
        .where('gif_id', isEqualTo: id)
        .get()
        .then((onValue) {
      onValue.docs.forEach((doc) async {
        await doc.reference.delete();
      });
    });
    updateFavGifList();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchFavGif() {
    return FirebaseFirestore.instance
        .collection('fav_giphy')
        .where('user_email', isEqualTo: user.email)
        .snapshots();
  }

  updateFavGifList([BuildContext? context]) async {
    favGif.clear();
    await FirebaseFirestore.instance
        .collection('fav_giphy')
        .where('user_email', isEqualTo: user.email)
        .get()
        .then((onValue) {
      print("Fav :- ${onValue.docChanges.length}");
      onValue.docChanges.forEach((element) {
        favGif.add(element.doc.data()?["gif_id"]);
      });
    });
    notifyListeners();
  }
}
