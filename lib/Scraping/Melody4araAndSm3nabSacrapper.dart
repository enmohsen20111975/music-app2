import 'dart:convert';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class Melody4arabSacrapper {
  static Future<List<ItemData>> getCountriesListFromMap() async {
    http.Response response =
        await http.get(Uri.parse('https://melody4arab.com/view_group.php'));
    List<ItemData> table = [];
    dom.Document webbody =
        dom.Document.html(Utf8Decoder().convert(response.bodyBytes));
    final data = webbody.querySelectorAll("map > area");
    //  print(data.length);
    String name = '';
    String uri = '';
    try {
      int i = 0;
      for (var element in data) {
        i++;
        try {
          name = element.attributes['title']!;
        } catch (e) {
          print('name error =$e');
        }
        try {
          uri = element.attributes['href']!;
        } catch (e) {
          print('Uri error =$e');
        }
        if (uri.contains('#') == false) {
          table.add(ItemData.itemDataAdding(
              name: name, url: uri, imageUrl: '', songMP3Url: '', songUrl: ''));
          //print(i.toString() + "->" + name + " >>  " + uri);
        }
      }
    } catch (e) {
      print(e);
    }
    return table;
  }

  static getSingerByCountry(String countryUri) async {
    http.Response response =
        await http.get(Uri.parse('https://melody4arab.com/view_group.php'));
    List<ItemData> table = [];
    dom.Document webbody =
        dom.Document.html(Utf8Decoder().convert(response.bodyBytes));
    final data = webbody
        .querySelector('body > table')!
        .children[0]
        .querySelectorAll('table > tbody')[1]
        .querySelectorAll('tbody > tr');

    /* .querySelector('table > tr')!
        .children; */
    /* .querySelector(' table > tbody')!
        .children; */
    print(data[1].innerHtml);
  }

/************************************************************************ */
  static Future<List<ItemData>> selectcountrySm3na() async {
    http.Response response =
        await http.get(Uri.parse('https://www.sm3na.com/'));
    List<ItemData> table = [];
    dom.Document webbody =
        dom.Document.html(Utf8Decoder().convert(response.bodyBytes));
    final data = webbody
        .getElementsByClassName('welcome-categories')[0]
        .querySelectorAll('div > a');

    data.forEach((element) {
      table.add(ItemData.itemDataAdding(
          name: element.innerHtml,
          url: element.attributes['href']!,
          imageUrl: '',
          songMP3Url: '',
          songUrl: ''));
    });
    return table;
  }

  static Stream<List<ItemData>> getSongerListNameFromSm3na(
      String countryurl) async* {
    //https://www.albumaty.com/lastalbums.html?id=2021
    String siteUrl = 'https://www.sm3na.com/';
    countryurl = countryurl.replaceAll(siteUrl, '');
    http.Response response = await http.get(Uri.parse(siteUrl + countryurl));

    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data = webbody.querySelectorAll(".artists-container");
      for (var element in data) {
        final namedata = element.querySelectorAll('div > a');
        for (var name in namedata) {
          table.add(ItemData.itemDataAdding(
              name: name.attributes['title']!,
              url: name.attributes['href']!,
              imageUrl: '',
              songMP3Url: '',
              songUrl: ''));
          yield table;
        }
        ;
      }
    } catch (e) {
      print(e);
    }
    //return table;
  }

  static Stream<List<ItemData>> getSongesListFromSm3na(
      String countryurl) async* {
    //https://www.albumaty.com/lastalbums.html?id=2021
    List<ItemData> album = [];
    List<ItemData> table = [];
    try {
      String siteUrl = 'https://www.sm3na.com/';
      //   countryurl = countryurl.replaceAll(siteUrl, '');
      http.Response response = await http.get(Uri.parse(countryurl));
      dom.Document webbody = dom.Document.html(response.body);
      // String body = await scrapeWebPage(countryurl).toString();
      // dom.Document webbody = dom.Document.html(body);
      final data = webbody.querySelectorAll(".song-container");
      for (var element in data) {
        if (element.children.length == 4) {
          final mp3Data = element.children[1].children[0];
          final imageData = element.querySelector('a > img');
          album.add(ItemData.itemDataAdding(
              name: mp3Data.attributes['data-track-name']!,
              songUrl: '',
              songMP3Url: mp3Data.attributes['data-track-url']!,
              imageUrl: imageData!.attributes['src']!,
              url: ''));
          DataProvider.subCategoryImage = imageData.attributes['src']!;
          table.add(ItemData.itemDataAdding(
              name: mp3Data.attributes['data-track-name']!,
              url: mp3Data.attributes['data-track-url']!,
              imageUrl: imageData.attributes['src']!,
              songMP3Url: '',
              songUrl: ''));
          yield table;
        }
      }
    } catch (e) {
      print(e);
    }

    //   DataProvider.alboum = album;
    // return table;
  }

  static Future<List<ItemData>> getSongesListFromSm3naAsStream(
      String countryurl) async {
    //https://www.albumaty.com/lastalbums.html?id=2021
    List<ItemData> table = [];
    try {
      http.Request request = await http.Request('Get', Uri.parse(countryurl));
      final reqresponse = await request.send();
      final response = await reqresponse.stream.bytesToString();
      dom.Document webbody = dom.Document.html(response);
      final data = webbody.querySelectorAll(".song-container");
      for (var element in data) {
        if (element.children.length == 4) {
          final mp3Data = element.children[1].children[0];
          final imageData = element.querySelector('a > img');
          DataProvider.subCategoryImage = imageData!.attributes['src']!;
          table.add(ItemData.itemDataAdding(
              name: mp3Data.attributes['data-track-name']!,
              url: mp3Data.attributes['data-track-url']!,
              imageUrl: imageData.attributes['src']!,
              songMP3Url: '',
              songUrl: ''));
        }
      }
    } catch (e) {
      print(e);
    }

    return table;
  }

 /*  static Future<String> scrapeSeeMoreWebPage(String uri) async {
    final flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.launch(uri);
    List<Map<String, String>> adata = [];
    // Wait for the page to load
    flutterWebviewPlugin.onStateChanged.listen((state) async {
      if (state.type == WebViewState.finishLoad) {
        // Execute the JavaScript function to load additional data
        final code = "exploreTracks(50842, '105')";
        await flutterWebviewPlugin.evalJavascript(code);
        // Get the HTML content of the page
        final html = await flutterWebviewPlugin
            .evalJavascript('document.documentElement.outerHTML');

        // Scrape the additional data from the loaded section
        final document = dom.Document.html(html.toString());
        final List items = document.querySelectorAll('.item');
        final data = items.map((item) {
          final title = item.querySelector('.title').text;
          final description = item.querySelector('.description').text;
          final price = item.querySelector('.price').text;
          return {'title': title, 'description': description, 'price': price};
        }).toList();

        //  adata.addAll(data);

        // Close the WebView
        flutterWebviewPlugin.close();
      }
    });
    return adata.toString();
  } */
}
