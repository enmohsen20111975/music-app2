import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

class RadioScrapping {
  static Future<List<ItemData>> getRadioStationsList() async {
    List<ItemData> table = [];
    String mainUrl = 'https://onlineradiobox.com/';
    http.Response response = await http.get(Uri.parse(
      'https://onlineradiobox.com/eg/',
    ));
    dom.Document webbody =
        dom.Document.html(Utf8Decoder().convert(response.bodyBytes));
    try {
      final data = webbody
          .getElementsByClassName("stations-list")[0]
          .getElementsByClassName('stations__station');
      for (var element in data) {
        String name = element.querySelector('a > img')!.attributes['title']!;
        String uri = element.querySelector('figure > a')!.attributes['href']!;
        String imageUri = element.querySelector('a > img')!.attributes['src']!;
        table.add(ItemData.itemDataAdding(
            name: name,
            url: mainUrl + uri,
            imageUrl: imageUri,
            songMP3Url: '',
            songUrl: ''));
      }
    } catch (e) {
      print(e);
    }
    return table;
  }

  static Future<String> getStationData(String uri) async {
    String output = '';
    String mainUrl = 'https://onlineradiobox.com/';
    http.Response response = await http.get(Uri.parse(
      uri,
    ));
    dom.Document webbody =
        dom.Document.html(Utf8Decoder().convert(response.bodyBytes));
    try {
      final data = webbody
          .getElementsByClassName("b-play station_play")[0]
          .attributes['stream'];
      output = data.toString();
      /*     print(output); */
    } catch (e) {
      print(e);
    }
    return output;
  }
}
