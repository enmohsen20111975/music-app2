import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SongsController extends GetxController {
  var songs = [].obs;

  @override
  void onInit() {
    fetchSongs();
    super.onInit();
  }

  Future<void> fetchSongs() async {
    var response = await http
        .get(Uri.parse('http://example.com/wp-json/my-plugin/v1/songs'));
    if (response.statusCode == 200) {
      songs.value = json.decode(response.body);
    } else {
      print('Error fetching songs: ${response.statusCode}');
    }
  }

  Future<void> addSong(Map<String, dynamic> song) async {
    var response = await http.post(
        Uri.parse('http://example.com/wp-json/my-plugin/v1/songs'),
        body: song);
    if (response.statusCode == 200) {
      fetchSongs();
    } else {
      print('Error adding song: ${response.statusCode}');
    }
  }

  Future<void> updateSong(int id, Map<String, dynamic> song) async {
    var response = await http.put(
        Uri.parse('http://example.com/wp-json/my-plugin/v1/songs/$id'),
        body: song);
    if (response.statusCode == 200) {
      fetchSongs();
    } else {
      print('Error updating song: ${response.statusCode}');
    }
  }

  Future<void> deleteSong(int id) async {
    var response = await http
        .delete(Uri.parse('http://example.com/wp-json/my-plugin/v1/songs/$id'));
    if (response.statusCode == 200) {
      fetchSongs();
    } else {
      print('Error deleting song: ${response.statusCode}');
    }
  }
}
