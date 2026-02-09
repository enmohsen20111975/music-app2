import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

class AudioBooks {
  //https://www.tahmil-kutubpdf.net/audio/books/1.html
  static String imgeUrl = '';
  static Stream<List<ItemData>> getMainBooksList() async* {
    List<ItemData> table = [];
    String siteUrl = 'https://www.tahmil-kutubpdf.net/';
    for (int pagenumber = 1; pagenumber <= 11; pagenumber++) {
      http.Response response = await http.get(
          Uri.https('www.tahmil-kutubpdf.net', 'audio/books/$pagenumber.html'));

      dom.Document webbody = dom.Document.html(response.body);
      try {
        final data = webbody
            .getElementsByClassName('col-lg-3 c0l-md-3 col-sm-4 col-xs-4');
        String rejecteImageUrl =
            'https://www.tahmil-kutubpdf.net/assets/aimgs/iconaudio.png';
        for (var element in data) {
          final url = element.querySelector('div > a')!.attributes['href'];
          final namedata =
              element.querySelector('a > img')!.attributes['title'];
          imgeUrl =
              element.querySelector('a > img')!.attributes['src'].toString();
          if (imgeUrl.toString() == rejecteImageUrl) {
            imgeUrl = '';
          }
          String name = namedata!
              .split('|')[0]
              .replaceAll('mp3', '')
              .replaceAll('تحميل كتب مسموعة', '')
              .replaceAll('-', ' ');
          //String auther = name.split('ل')[1];
          DataProvider.mainCategoryName = name.toString();
          table.add(ItemData.itemDataAdding(
              name: name.toString(),
              url: url.toString(),
              imageUrl: imgeUrl.toString(),
              songMP3Url: '',
              songUrl: ''));
          yield table;
        }
      } catch (e) {
        print(e);
      }
      DataProvider.sounBooks = table;
    }
  }

  static Future<List<ItemData>> getDownloadUrlPath(String url) async {
    http.Response response1 = await http.get(Uri.parse(url));
    dom.Document webbody1 = dom.Document.html(response1.body);
    final data1 = webbody1.getElementsByClassName('btn btn-primary');
    String downloadUrl = data1[0].attributes['href'].toString();
    http.Response response = await http.get(Uri.parse(downloadUrl));
    List<ItemData> table = [];
    dom.Document webbody = dom.Document.html(response.body);
    final data = webbody
        .getElementsByClassName(
            'col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center')[0]
        .querySelectorAll('div >a');

    data.forEach(
      (element) {
        try {
          String bookData = element.attributes['href'].toString();
          if (bookData.contains('.mp3')) {
            table.add(ItemData.itemDataAdding(
                name: element.innerHtml.toString().replaceAll('تحميل', ''),
                url: bookData,
                imageUrl: imgeUrl,
                songMP3Url: bookData,
                songUrl: ''));
          }
        } catch (e) {}
      },
    );
    /*  DataProvider.alboum = table; */
    return table;
  }
}
