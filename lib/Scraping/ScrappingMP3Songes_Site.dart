import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

// Due to https://mp3songs.alarab.com is very Slow and it was turned off so i turnned to use https://www.mrmazika.com/ for Selectring countries and so on

class Sacrapper {
  static Stream<List<ItemData>> getCategoriesList() async* {
    String siteUrl = 'https://mp3songs.alarab.com';
    http.Response response = await http.get(Uri.https(
      'mp3songs.alarab.com',
    ));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data = webbody.querySelector(".countries");
      final countries = data!.querySelectorAll('li > a');
      for (var element in countries) {
        String name =
            element.attributes['title']!.replaceAll('استماع تحميل', '');
        table.add(ItemData.itemDataAdding(
            name: name,
            url: siteUrl + element.attributes['href']!,
            songUrl: '',
            songMP3Url: '',
            imageUrl: ''));
        yield table;
        //    print(name);
      }
    } catch (e) {
      print(e);
    }

    // return table;
  }

  static Future<List<ItemData>> getSongerList(String categoryurl) async {
    String siteUrl = 'https://mp3songs.alarab.com';
    categoryurl = categoryurl.replaceAll('https://mp3songs.alarab.com/', '');
    http.Response response =
        await http.get(Uri.https('mp3songs.alarab.com', categoryurl));

    List<ItemData> out = [];
    dom.Document webbody = dom.Document.html(response.body);

    final part1 = webbody.querySelector(".content");
    final countries = part1!.querySelectorAll('div > a');

    for (var element in countries) {
      try {
        String url = element.attributes['href']!;
        final data = element.querySelector('picture > img');
        String image = data!.attributes['src']!;
        String name = data.attributes['alt']!;
        out.add(ItemData.itemDataAdding(
            name: name,
            url: url,
            imageUrl: image,
            songMP3Url: '',
            songUrl: ''));
        //  print(name + " --> " + image + " --> " + url);
      } catch (e) {
        print(e);
      }
    }

    return out;
  }

  static Future<List<ItemData>> getAlboumrList(String categoryurl) async {
    String siteUrl = 'https://mp3songs.alarab.com';
    categoryurl = categoryurl.replaceAll('/', '');
    http.Response response =
        await http.get(Uri.https('mp3songs.alarab.com', categoryurl));
    List<ItemData> out = [];
    dom.Document webbody = dom.Document.html(response.body);
    final part1 = webbody.querySelector(".albums");
    final countries = part1!.querySelectorAll('li > a');
    for (var element in countries) {
      try {
        String url = element.attributes['href']!;
        String name = element.innerHtml;
        out.add(ItemData.itemDataAdding(
          name: name,
          url: url,
          imageUrl: '',
          songMP3Url: '',
          songUrl: '',
        ));
        // print(name + " --> " + " --> " + url);
      } catch (e) {
        print(e);
      }
    }
    return out;
  }

  static Future<List<ItemData>> getAlboumSongesList(String alboumUrl) async {
    String siteUrl = 'https://mp3songs.alarab.com';
    alboumUrl = alboumUrl.replaceAll('/', '');
    http.Response response =
        await http.get(Uri.https('mp3songs.alarab.com', alboumUrl));
    List<ItemData> out = [];
    dom.Document webbody = dom.Document.html(response.body);
    final part1 = webbody.querySelector(".list");
    final countries = part1!.querySelectorAll('strong > a');
    int i = 0;
    for (var element in countries) {
      try {
        if (i > 0) {
          String url = element.attributes['href']!;
          String name = element.innerHtml;
          out.add(ItemData.itemDataAdding(
            name: name,
            url: url,
            songMP3Url: await getSongeUrl(url),
            imageUrl: DataProvider.subCategoryImage,
            songUrl: '',
          ));
        }
        i++;
      } catch (e) {
        print(e);
      }
    }
    DataProvider.alboum = out;
    return out;
  }

  static Future<String> getSongeUrl(String songUrl) async {
    String siteUrl = 'https://mp3songs.alarab.com';
    songUrl = songUrl.replaceAll('/', '');
    http.Response response =
        await http.get(Uri.https('mp3songs.alarab.com', songUrl));
    String out = '';
    try {
      dom.Document webbody = dom.Document.html(response.body);
      final part1 = webbody.querySelector(".content");
      final songData = part1!.querySelectorAll('audio > source')[0];
      out = songData.attributes['src']!;
      DataProvider.songMP3Url = out;
    } catch (e) {}
    return out;
  }

//
  static Future<List<ItemData>> getAlboumData(List<ItemData> alboum) async {
    List<ItemData> ouput = [];
    alboum.forEach((song) async {
      String mp3url = await getSongeUrl(song.url);
      ouput.add(ItemData.itemDataAdding(
          songMP3Url: mp3url,
          name: song.name,
          songUrl: song.url,
          imageUrl: '',
          url: ''));
    });
    return ouput;
  }

  ///************************************************************************** */
  static Stream<List<ItemData>> getMainAnashedCategories() async* {
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
        DataProvider.savedIndex++;

        table.add(ItemData.itemDataAdding(
            name: name,
            url: url,
            imageUrl: siteUrl + imagepath,
            songMP3Url: '',
            songUrl: ''));
        yield table;
      }
    } catch (e) {
      print(e);
    }
    DataProvider.anasheed = table;
    //  return table;
  }

  static Future<List<ItemData>> getAnashedList(String songerUrl) async {
    // https://www.anasheed.info/singers
    String siteUrl = 'https://www.anasheed.info';
    http.Response response = await http.get(Uri.parse(songerUrl));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    try {
      final data = webbody.getElementsByClassName('panel-body');
      for (var element in data) {
        var subData = element.children[0].children[0].children[0];
        String mp3Path = subData.attributes['sound-data']!;
        String name = subData.attributes['data-title']!;
        DataProvider.mainCategoryName = name;
        table.add(ItemData.itemDataAdding(
            name: name,
            url: '',
            imageUrl: DataProvider.subCategoryImage,
            songMP3Url: mp3Path,
            songUrl: ''));
      }
    } catch (e) {
      print(e);
    }
    DataProvider.alboum = table;
    return table;
  }
}
