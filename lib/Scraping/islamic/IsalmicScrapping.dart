import 'dart:async';

/* import 'package:beautiful_soup_dart/beautiful_soup.dart'; */
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

class IslamicTapeSacrapper {
  static ItemData itemDataAdding({
    String alboumName = '',
    String songerName = '',
    String name = '',
    String songUrl = '',
    String songMP3Url = '',
    String imageUrl = '',
    String url = '',
  }) {
    ItemData temp = ItemData();
    temp.alboumName = alboumName;
    temp.songerName = songerName;
    temp.name = name;
    temp.songUrl = songUrl;
    temp.songMP3Url = songMP3Url;
    temp.imageUrl = imageUrl;
    temp.url = url;
    return temp;
  }

  static late Stream<List<ItemData>> stream;
  static late StreamController<List<ItemData>> controller;
  static late Stream<List<ItemData>> leactureStream;
  static late StreamController<List<ItemData>> leactureController;
  static Stream<List<ItemData>> getMainCategories() async* {
    String siteUrl = 'https://www.khotab.info/';
    http.Response response =
        await http.get(Uri.https('www.khotab.info', 'category'));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data =
          webbody.getElementsByClassName('col-xs-12 col-sm-6 col-md-4');
      for (var element in data) {
        var imageData = element.querySelector(".info_cat");
        String imagepath =
            imageData!.attributes['style']!.replaceAll('background: url(', '');
        imagepath = imagepath.replaceAll(');background-size: 100% 100%', '');
        var nameData = element.querySelector(".arabic");
        String name =
            nameData!.innerHtml.replaceAll('<h4>', '').replaceAll('</h4>', '');
        String categorynumber =
            nameData.attributes['href']!.replaceAll('/category/', '');
        DataProvider.mainCategoryName = name;
        ItemData temp = ItemData();
        temp.name = name;
        temp.url = 'category/' + categorynumber;
        temp.imageUrl = siteUrl + imagepath;
        temp.songMP3Url = '';
        temp.songUrl = '';
        table.add((temp));
        yield table;
      }
    } catch (e) {
      print(e);
    }
    DataProvider.lectcures = table;
  }

  static Future<List<ItemData>> getKhotabList(String countryurl) async {
    String siteUrl = 'https://www.khotab.info/';
    countryurl = countryurl.replaceAll(siteUrl, '');
    http.Response response =
        await http.get(Uri.https('www.khotab.info', countryurl));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data = webbody.getElementsByClassName("panel-body");
      for (var element in data) {
        final namedata = element.querySelector('.col-xs-10');
        String name = namedata!.attributes['data-title']!;
        String mp3Url = namedata.attributes['sound-data']!;
        /*  print('mp3Url =====>>> ( $mp3Url )'); */

        ItemData temp = ItemData();
        temp.name = name;
        temp.url = '';
        temp.imageUrl = DataProvider.subCategoryImage;
        temp.songMP3Url = mp3Url;
        temp.songUrl = '';

        table.add(temp);
        // print(name + '--> ' + mp3Url);
      }
    } catch (e) {
      print(e);
    }
//    DataProvider.alboum = table;
    return table;
  }

  static Future<List<ItemData>> getFromIslamWebMainCategory() async {
    List<ItemData> table = [];
    http.Response response =
        await http.get(Uri.parse('https://ar.alnahj.net/all/audios'));
    dom.Document webbody = dom.Document.html(response.body);
    final data =
        webbody.querySelector('.art-blockcontent-body')!.children[0].children;
    try {
      for (var element in data) {
        String name = element.children[0].innerHtml;
        String url = element.children[0].attributes['href']!;
        if (url.length > 10) {
          table.add(itemDataAdding(
              name: name, url: url, imageUrl: '', songMP3Url: '', songUrl: ''));
        }
      }
    } catch (e) {
      print(e);
    }

    return table;
  }

  static Stream<List<ItemData>> getFromalnahjMainCoursesList(
      String courseindex) async* {
    List<ItemData> table = [];
    http.Response response =
        await http.get(Uri.parse('https://ar.alnahj.net/all/audios'));
    dom.Document webbody = dom.Document.html(response.body);
    final data = webbody
        .querySelector('.art-blockcontent-body')!
        .children[0]
        .children[int.parse(courseindex)]
        .children[1]
        .children;

    try {
      for (var element in data) {
        String name = element.children[0].innerHtml;
        String url = element.children[0].attributes['href']!;
        if (url.length > 10) {
          table.add(itemDataAdding(
              name: name, url: url, imageUrl: '', songMP3Url: '', songUrl: ''));
          yield table;
        }
      }
    } catch (e) {
      print(e);
    }

    //  return table;
  }

  static Future<List<ItemData>> getFromalnahjLactureData(
      String courseindex, String Lactureindex) async {
    List<ItemData> table = [];
    http.Response response =
        await http.get(Uri.parse('https://ar.alnahj.net/all/audios'));
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data = webbody
          .querySelector('.art-blockcontent-body')!
          .children[0] // fixed
          .children[int.parse(courseindex)] // main course index
          .children[1] //
          .children[int.parse(Lactureindex)]
          .children[1] // goto lessons
          .children;
      DataProvider.numberOfLessons = data.length;

      for (var element in data) {
        String name = element.querySelector('li > a')!.innerHtml;
        String url = element.querySelector('li > a')!.attributes['href']!;
        String songMP3Url = await getMP3UrlFromalnahj(url);
        table.add(itemDataAdding(
            name: name,
            url: url,
            imageUrl: '',
            songMP3Url: songMP3Url,
            songUrl: ''));
        streammingLeacture(table);
      }
    } catch (e) {}
    //  DataProvider.alboum = table;
    return table;
  }

  static Stream<List<ItemData>> getFromalnahjLactureDataStreaming(
      String courseindex, String Lactureindex) async* {
    List<ItemData> table = [];
    http.Response response =
        await http.get(Uri.parse('https://ar.alnahj.net/all/audios'));
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data = webbody
          .querySelector('.art-blockcontent-body')!
          .children[0] // fixed
          .children[int.parse(courseindex)] // main course index
          .children[1] //
          .children[int.parse(Lactureindex)]
          .children[1] // goto lessons
          .children;
      DataProvider.numberOfLessons = data.length;

      for (var element in data) {
        String name = element.querySelector('li > a')!.innerHtml;
        String url = element.querySelector('li > a')!.attributes['href']!;
        String songMP3Url = await getMP3UrlFromalnahj(url);
        table.add(itemDataAdding(
            name: name,
            url: url,
            imageUrl: '',
            songMP3Url: songMP3Url,
            songUrl: ''));
        yield table;
        //  leactureStream = streammingLeacture(table);
      }
    } catch (e) {}
    DataProvider.alboum = table;
    yield table;
  }

  static Future<List<ItemData>> getFromAlnahjLssonsDataStream(
      String courseindex, String Lactureindex) async {
    late ItemData sdata;
    List<ItemData> table = [];
    http.Response response =
        await http.get(Uri.parse('https://ar.alnahj.net/all/audios'));
    dom.Document webbody = dom.Document.html(response.body);
    final data = webbody
        .querySelector('.art-blockcontent-body')!
        .children[0] // fixed
        .children[int.parse(courseindex)] // main course index
        .children[1] //
        .children[int.parse(Lactureindex)]
        .children[1] // goto lissons
        .children;
    DataProvider.numberOfLessons = data.length;
    try {
      for (var element in data) {
        String name = element.querySelector('li > a')!.innerHtml;
        String url = element.querySelector('li > a')!.attributes['href']!;
        //  String songMP3Url = await getMP3UrlFromalnahj(url);
        sdata = itemDataAdding(
            name: name, url: url, imageUrl: '', songMP3Url: '', songUrl: '');
        table.add(sdata);
        streamming(table);
      }
    } catch (e) {}
    //  DataProvider.alboum = table;
    return table;
  }

  static Stream<List<ItemData>> streammingLeacture(List<ItemData> data) async* {
    leactureController = StreamController<List<ItemData>>(onListen: (() async {
      leactureController.add(data);
      await leactureController.close();
    }));
    yield* leactureController.stream;
  }

  static Stream<List<ItemData>> streamming(List<ItemData> data) async* {
    controller = StreamController<List<ItemData>>(onListen: (() async {
      controller.add(data);
      await controller.close();
    }));
    yield* controller.stream;
  }

  static getMP3UrlFromalnahj(String fileUrl) async {
    http.Response response = await http.get(Uri.parse(fileUrl));
    dom.Document webbody = dom.Document.html(response.body);
    final data = webbody.querySelector('.audio-info')!.children[0];
    return data.querySelector('li > audio')!.attributes['src'];
  }

/*************************** */
  static Future<List<ItemData>> getMainSongCategories() async {
    // https://www.anasheed.info/singers
    String siteUrl = 'https://www.anasheed.info';
    http.Response response =
        await http.get(Uri.parse('https://www.anasheed.info/singers'));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data =
          webbody.getElementsByClassName('col-xs-12 col-sm-12 col-md-6');
      for (var element in data) {
        String imagepath =
            element.querySelector('div > img')!.attributes['src']!;

        var nameData = element.querySelector(".arabic");
        String name = element.querySelector('a > h2')!.innerHtml;
        String url = element.querySelector('div > a')!.attributes['href']!;
        DataProvider.mainCategoryName = name;
        DataProvider.subCategoryImage = siteUrl + imagepath;
        table.add(itemDataAdding(
            name: name,
            url: url,
            imageUrl: siteUrl + imagepath,
            songMP3Url: '',
            songUrl: ''));
      }
    } catch (e) {
      print(e);
    }
    return table;
  }

  static Future<List<ItemData>> getSongerList(String songerUrl) async {
    // https://www.anasheed.info/singers
    String siteUrl = 'https://www.anasheed.info';
    http.Response response = await http.get(Uri.parse(songerUrl));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data = webbody.getElementsByClassName('panel-body');
      /*   print(
          data[0].children[0].children[0].children[0].attributes['data-title']);
      print(
          data[0].children[0].children[0].children[0].attributes['sound-data']); */
      for (var element in data) {
        var subData = element.children[0].children[0].children[0];
        String mp3Path = subData.attributes['sound-data']!;
        String name = subData.attributes['data-title']!;
        DataProvider.mainCategoryName = name;
        table.add(itemDataAdding(
            name: name,
            url: '',
            imageUrl: DataProvider.subCategoryImage,
            songMP3Url: mp3Path,
            songUrl: ''));
      }
    } catch (e) {
      print(e);
    }
    //  DataProvider.alboum = table;
    return table;
  }
}
