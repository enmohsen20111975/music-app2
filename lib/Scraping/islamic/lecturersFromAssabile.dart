import 'dart:convert';

import 'dart:async';

/* import 'package:beautiful_soup_dart/beautiful_soup.dart'; */
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

class ScrappingOfAssbile {
  static String siteUrl = 'https://ar.assabile.com';
  static Future<List<ItemData>> getMainLectures(int page) async {
    http.Response response =
        await http.get(Uri.parse('https://ar.assabile.com/lesson/page:$page/'));
    dom.Document webbody = dom.Document.html(response.body);
    List<ItemData> table = [];
    int i = 0;
    try {
      i++;
      final data = webbody
          .getElementsByClassName('portfolio-item pf-uielements isotope-item');
      data.forEach((element) {
        String uri = siteUrl +
            element.querySelector('div > a')!.attributes['href'].toString();
        String imageUri = siteUrl +
            element.querySelector('a > img')!.attributes['src'].toString();
        String name =
            element.querySelector('a > img')!.attributes['title'].toString();
        table.add(ItemData.itemDataAdding(
            name: name,
            songUrl: '',
            songMP3Url: '',
            imageUrl: imageUri,
            url: uri));
        //   print(i);
      });
    } catch (e) {
      print(e);
    }
    return table;
  }

  static Stream<List<ItemData>> getAllLeacters() async* {
    for (int page = 1; page <= 4; page++) {
      List<ItemData> out = [];
      out.addAll(await getMainLectures(page));
      yield out;
    }
  }

  static Future<List<ItemData>> getLessonsAlboum(String uri) async {
    http.Response response = await http.get(Uri.parse(uri));
    dom.Document webbody = dom.Document.html(response.body);
    List<ItemData> table = [];
    try {
      final data = webbody.getElementsByClassName('table table-striped')[1];

      /*  print(data.children.length); */
    } catch (e) {
      print(e);
    }
    return table;
  }

  // https://archive.org/serve/mohamed-hassan-mp3/001.mp3
  static Stream<List<ItemData>> archiveOrgScrapper(String uri) async* {
    http.Response response = await http.get(Uri.parse(uri));
    dom.Document webbody = dom.Document.html(response.body);
    List<ItemData> table = [];
    try {
      final data = webbody.getElementsByClassName(
          'container container-ia width-max js-playset-list  no-padding audio')[0];
      data.children.forEach(
        (element) {
          if (element.attributes['itemprop'].toString() == 'hasPart') {
            String name =
                element.querySelector('div > meta')!.attributes['content']!;

            String songMP3Url = element
                .querySelector('div > link')!
                .attributes['href']!
                .replaceAll('.ogg', '.mp3');
            ItemData temp = ItemData.itemDataAdding();
            temp.name = name;
            temp.songMP3Url = songMP3Url;
            table.add(temp);
          }
        },
      );

      yield table;
    } catch (e) {
      print(e);
    }
    DataProvider.alboum = table;
  }

  ///   https://archive.org/details/audio_bookspoetry?and%5B%5D=mediatype%3A%22audio%22&sort=-week&page=2
}
