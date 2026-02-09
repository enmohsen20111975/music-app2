import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

// source of all songes ==  https://music.egonair.com/
class AngamyScrapping {
// number of pages=104
  static Stream<List<ItemData>> getAghanynaShabyatList() async* {
    print('-------------------');
    List<ItemData> table = [];
    for (int page = 1; page <= 104; page++) {
      http.Response response = await http.get(Uri.parse(
        'https://aghanyna.net/songs/cat/sha3by/page/$page/#gsc.tab=0',
      ));
      Timer(Duration(milliseconds: 10), () {
        print('just wait for reponse');
      });
      dom.Document webbody =
          dom.Document.html(Utf8Decoder().convert(response.bodyBytes));
      print(response.request);
      try {
        final data = webbody
            .getElementsByClassName("def-block clr cpt_ gt_")[0]
            .getElementsByClassName('item_small mb');
        for (var element in data) {
          String name = element.querySelector('a > img')!.attributes['alt']!;
          String uri = element.querySelector('div > a')!.attributes['href']!;
          String imageUri =
              element.querySelector('a > img')!.attributes['data-src']!;
          table.add(ItemData.itemDataAdding(
              name: name,
              url: uri,
              imageUrl: imageUri,
              songMP3Url: await getSongData(uri),
              songUrl: ''));
          yield table;
          print(name);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<List<ItemData>> getAganynaLastAlboums() async {
    List<ItemData> table = [];
    // panges=6
    {
      for (var page = 1; page <= 6; page++) {
        http.Response response = await http.get(Uri.parse(
          'https://aghanyna.net/songs-albums/page/$page/#gsc.tab=0',
        ));

        // Utf8Decoder().convert( at first step to remove symplies from Arabic words >>>>> bodyBytes
        dom.Document webbody =
            dom.Document.html(Utf8Decoder().convert(response.bodyBytes));
        try {
          final data = webbody
              .getElementsByClassName("def-block clr cpt_ gt_ ")[0]
              .getElementsByClassName('clr');
        } catch (e) {
          print(e);
        }
      }
    }
    return table;
  }

  static Future<List<ItemData>> getShabyatList() async {
    print('-------------------');
    int page = 1;
    List<ItemData> table = [];
    /*   for (int page = 1; page == 104; page++) { */
    http.Response response = await http.get(Uri.parse(
      'https://aghanyna.net/songs/cat/sha3by/page/$page/#gsc.tab=0',
    ));
    dom.Document webbody =
        dom.Document.html(Utf8Decoder().convert(response.bodyBytes));
    print(response.request);
    try {
      final data = webbody
          .getElementsByClassName("def-block clr cpt_ gt_")[0]
          .getElementsByClassName('item_small mb');
      for (var element in data) {
        String name = element.querySelector('a > img')!.attributes['alt']!;
        String uri = element.querySelector('div > a')!.attributes['href']!;
        String imageUri =
            element.querySelector('a > img')!.attributes['data-src']!;
        table.add(ItemData.itemDataAdding(
            name: name,
            url: uri,
            imageUrl: imageUri,
            songMP3Url: await getSongData(uri),
            songUrl: ''));
        table;
        print(name);
      }
    } catch (e) {
      print(e);
    }
    /*  } */
    print(table.length);
    return table;
  }

  static Future<String> getSongData(String uri) async {
    http.Response response = await http.get(Uri.parse(
      uri,
    ));
    String output = '';
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data = webbody
          .getElementsByClassName('player clr mbt ')[0]
          .attributes['data-player']
          .toString();
      var out = json.decode(data)['tracks'];
      dom.Document getHref = dom.Document.html(out.toString());
      output = getHref.querySelector('div > a')!.attributes['href']!;
    } catch (e) {
      print(e);
    }
    return output;
  }
}
