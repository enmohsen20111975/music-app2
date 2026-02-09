import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

///  'https://www.mrmazika.com/' == 'https://www.albumaty.com/'
class MrMazikkaScrapping {
  static Stream<List<ItemData>> getMainAlboumsListByYear(int year) async* {
    String siteUrl = 'https://www.mrmazika.com/';
    http.Response response = await http
        .get(Uri.parse('https://www.mrmazika.com/lastalbums.html?id=$year'));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data = webbody.getElementsByClassName("country-singers");

      for (var element in data) {
        String href = element.querySelector('div > a')!.attributes['href']!;
        String src = element.querySelector('a > img')!.attributes['src']!;
        String alt = element.querySelector('a > img')!.attributes['alt']!;
        String inner = element
            .querySelector('div > a')!
            .innerHtml
            .replaceAll('<img src="$src" alt="$alt">', "");

        table.add(ItemData.itemDataAdding(
            name: inner,
            url: href,
            songUrl: alt,
            songMP3Url: '',
            imageUrl: src));
        yield table;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<List<ItemData>> getSongerAlboumsList(String uri) async {
    String siteUrl = 'https://www.mrmazika.com/';
    http.Response response = await http.get(Uri.parse(uri));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data = webbody.getElementsByClassName(
          "col-md-4 col-xs-12 pull-right nomobilepadding");

      for (var element in data) {
        String href = element.querySelector('li > a')!.attributes['href']!;
        String src = element.querySelector('a > img')!.attributes['src']!;
        String inner = element
            .querySelector('li > a')!
            .innerHtml
            .replaceAll('<img src="$src">', "")
            .toString();
        table.add(ItemData.itemDataAdding(
            name: inner,
            url: href,
            songUrl: '',
            songMP3Url: '',
            imageUrl: src));
        // yield table;
      }
    } catch (e) {
      print(e);
    }
    return table;
  }

  static Stream<List<ItemData>> singerAllSonges(String uri) async* {
    http.Response response = await http.get(Uri.parse(uri));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data =
          webbody.getElementsByClassName("col-md-4 col-xs-12 pull-right");
      for (var element in data) {
        String name = element.querySelector('li > a')!.innerHtml;
        String uri = element.querySelector('li > a')!.attributes['href']!;
        ItemData songData = await getSongUrl(uri);
        ItemData temp = ItemData.itemDataAdding(
            name: name,
            url: uri,
            songUrl: '',
            songMP3Url: songData.songMP3Url,
            imageUrl: songData.imageUrl);
        table.add(temp);
        yield table;
      }
    } catch (e) {
      print(e);
    }
    // return table;
  }

  static Stream<List<ItemData>> getAlboumSongesList(String uri) async* {
    String siteUrl = 'https://www.mrmazika.com/';
    http.Response response = await http.get(Uri.parse(uri));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data =
          webbody.getElementsByClassName("col-md-6 col-xs-12 pull-right");

      for (var element in data) {
        String href = element.querySelector('li > a')!.attributes['href']!;
        String inner = element.querySelector('li > a')!.innerHtml;

        //   print(getSongUrl(href));
        ItemData temp = await getSongUrl(href);
        table.add(ItemData.itemDataAdding(
            name: inner,
            url: href,
            songUrl: '',
            songMP3Url: temp.songMP3Url,
            imageUrl: temp.imageUrl));
        yield table;
      }
    } catch (e) {
      print(e);
    }
    DataProvider.alboum = table;
  }

  static Future<String> getSongerImage(String uri) async {
    String siteUrl = 'https://www.mrmazika.com/';
    String output = '';
    http.Response response = await http.get(Uri.parse(uri));
    dom.Document webbody = dom.Document.html(response.body);
    try {
      String data = webbody
          .getElementsByClassName('col-md-3 col-xs-12 pull-right')[0]
          .querySelector('a > img')!
          .attributes['src']
          .toString();
      if (data.contains('http')) {
        output = data.toString();
      } else {
        data = webbody
            .getElementsByClassName('col-md-3 col-xs-12 pull-right')[1]
            .querySelector('a > img')!
            .attributes['src']
            .toString();
        output = data;
      }

      ///  print('Image Url is ------>> ${data}  From Url >>>>> $uri');
    } catch (e) {
      //print('Error for Image Url ==>>>>$e');
    }

    return output;
  }

  static Future<ItemData> getSongUrl(String uri) async {
    String output = '';
    http.Response response = await http.get(Uri.parse(uri));
    late ItemData table = ItemData.itemDataAdding(
        name: 'name',
        songUrl: 'songUrl',
        songMP3Url: 'songMP3Url',
        imageUrl: 'imageUrl',
        url: 'url');
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data1 = webbody.getElementsByClassName("player")[0];
      output = data1.querySelector('div > audio')!.attributes['src']!;
      final data2 = webbody.getElementsByClassName(
          "col-md-4 col-xs-12 pull-right nomobilepadding")[0];
      output = data2.querySelector('div > img')!.attributes['src']!;
      table = ItemData.itemDataAdding(
          name: 'name',
          songUrl: 'songUrl',
          songMP3Url: data1.querySelector('div > audio')!.attributes['src']!,
          imageUrl: data2.querySelector('div > img')!.attributes['src']!,
          url: 'url');
    } catch (e) {}

    return table;
  }

  static Stream<List<ItemData>> getAllSongersName_uri() async* {
    http.Response response = await http.get(Uri.parse(
        'https://www.mrmazika.com/cat/1-%D8%A3%D8%BA%D8%A7%D9%86%D9%89-%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9.html'));
    List<ItemData> table = [];
    dom.Document webbody =
        dom.Document.html(Utf8Decoder().convert(response.bodyBytes));
    final data = webbody.getElementsByClassName('country-singers');

    try {
      for (var element in data) {
        DataProvider.savedIndex++;
        String name = element.querySelector('div > a')!.innerHtml;
        String uri = element.querySelector('div > a')!.attributes['href']!;
        String imgeUrl = await getSongerImage(uri);
        /* DataModelForDB ddData = DataModelForDB(
            alboumName: '',
            alboum_song: 1,
            alboumurl: uri,
            category: 'Songe',
            imageurl: imgeUrl,
            mp3url: '',
            savedIndex: DataProvider.savedIndex,
            singer: name,
            songeName: '');
        DbHelper.addSongeData(ddData); */
        table.add(ItemData.itemDataAdding(
            name: name,
            url: uri,
            imageUrl: imgeUrl,
            songMP3Url: '',
            songUrl: ''));
        yield table;
      }
    } catch (e) {
      print(e);
    }
    DataProvider.allSongers = table;
  }

  static Stream<List<ItemData>> allAlboumsForSelectedSonger(
      String songerUri) async* {
    http.Response response = await http.get(Uri.parse(songerUri));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data =
          webbody.getElementsByClassName("col-md-3 col-xs-12 pull-right");
      for (var element in data) {
        String href = element.querySelector('li > a')!.attributes['href']!;
        String src = element.querySelector('a > img')!.attributes['src']!;
        String inner = element
            .querySelector('li > a')!
            .innerHtml
            .replaceAll('<img src="$src">', "")
            .toString();
        table.add(ItemData.itemDataAdding(
            name: inner,
            url: href,
            songUrl: '',
            songMP3Url: '',
            imageUrl: src));

        yield table;
      }
    } catch (e) {
      print(e);
    }
  }

  static Stream<List<ItemData>> getLastSongesList() async* {
    String siteUrl = 'https://www.mrmazika.com/';
    http.Response response =
        await http.get(Uri.parse('https://www.mrmazika.com/lastsongs.html'));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final main = webbody.getElementsByClassName('singer-songs')[0];
      final data = main.getElementsByClassName('pull-right');
      for (var element in data) {
        String href = element.querySelector('div > a')!.attributes['href']!;
        String inner = element.querySelector('div > a')!.innerHtml;
        ItemData temp = await getSongUrl(href);
        DataProvider.savedIndex++;
        table.add(ItemData.itemDataAdding(
            name: inner,
            url: href,
            songUrl: '',
            songMP3Url: temp.songMP3Url,
            imageUrl: temp.imageUrl));

        yield table;
        //  print(DataProvider.savedIndex);
      }
    } catch (e) {}
    //  DataProvider.lastsonges = table;
  }

/********************************************** */

  static Future<List<ItemData>> allAlboumsForSelectedSongerFuture(
      String songerUri) async {
    http.Response response = await http.get(Uri.parse(songerUri));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data =
          webbody.getElementsByClassName("col-md-3 col-xs-12 pull-right");
      for (var element in data) {
        String href = element.querySelector('li > a')!.attributes['href']!;
        String src = element.querySelector('a > img')!.attributes['src']!;
        String inner = element
            .querySelector('li > a')!
            .innerHtml
            .replaceAll('<img src="$src">', "")
            .toString();
        table.add(ItemData.itemDataAdding(
            name: inner,
            url: href,
            songUrl: '',
            songMP3Url: '',
            imageUrl: src));
      }
    } catch (e) {
      print(e);
    }
    return table;
  }

  static Future<List<ItemData>> getAlboumSongesListFuture(String uri) async {
    String siteUrl = 'https://www.mrmazika.com/';
    http.Response response = await http.get(Uri.parse(uri));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data =
          webbody.getElementsByClassName("col-md-6 col-xs-12 pull-right");

      for (var element in data) {
        String href = element.querySelector('li > a')!.attributes['href']!;
        String inner = element.querySelector('li > a')!.innerHtml;

        //   print(getSongUrl(href));
        ItemData temp = await getSongUrl(href);
        table.add(ItemData.itemDataAdding(
            name: inner,
            url: href,
            songUrl: '',
            songMP3Url: temp.songMP3Url,
            imageUrl: temp.imageUrl));
      }
    } catch (e) {
      print(e);
    }
    return table;
  }
}
