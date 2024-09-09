import 'dart:convert';
import '../entity/gif_data_entity.dart';
import 'base_model.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://api.giphy.com/v1';
const apiKey = 'OJGGdBnlo0s9qkQLWv6QAQiIK3WNfOn2';
const giphsPerPage = 5;
const maxNofOfssets = 100;

class GiphsModel extends BaseModel {
  GifDataEntity? giphyTrendingAlbum;
  GifDataEntity? giphySearchAlbum;

  int offset = 0;
  int limit = giphsPerPage;

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

  GiphsModel();
}
