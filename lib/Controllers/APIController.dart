import 'dart:convert';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
class APIController {
  List<ItemData> allData = [];
  Future<List<ItemData>> loadlastsongesAPI() async {
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
        'https://t3limsmart.com/wp-json/custom-api/v1/lastsonges/'));
    var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(son);
    for (var element in songs) {
      table.add(ItemData.itemDataAdding(
        name: element['name'],
        url: element['url'],
        imageUrl: element['imageUrl'],
        songMP3Url: element['songMP3Url'],
      ));
    }

    return table;
  }

  Future<List<ItemData>> shabyatAPI() async {
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
        'https://t3limsmart.com/wp-json/custom-api/v1/shabyat/'));
    var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(son);
    for (var element in songs) {
      table.add(ItemData.itemDataAdding(
        name: element['name'],
        url: element['url'],
        imageUrl: element['imageUrl'],
        songMP3Url: element['songMP3Url'],
      ));
    }

    return table;
  }

  Future<List<ItemData>> loadlAllAnasheedDataAPI() async {
    // AllSingersData  , AllAnashed , lectcures , sounBooks
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
        'https://t3limsmart.com/wp-json/custom-api/v1/AllAnashed/'));
    var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(son);
    for (var element in songs) {
      // table.add(ItemData.fromMap(element));
      table.add(ItemData.itemDataAdding(
        // alboumName: element['alboumName'], not foun in table
        songerName: element['songerName'],
        name: element['name'],
        url: element['url'],
        imageUrl: element['imageUrl'],
        songMP3Url: element['songMP3Url'],
      ));
    }

    return table;
  }

  Future<List<ItemData>> loadlAlllectcuresDataAPI() async {
    // AllSingersData  , AllAnashed , lectcures , sounBooks
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
        'https://t3limsmart.com/wp-json/custom-api/v1/lectcures/'));
    var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(son);
    for (var element in songs) {
      // table.add(ItemData.fromMap(element));
      table.add(ItemData.itemDataAdding(
        //  alboumName: element['alboumName'],
        songerName: element['songerName'],
        name: element['name'],
        url: element['url'],
        imageUrl: element['imageUrl'],
        songMP3Url: element['songMP3Url'],
      ));
    }

    return table;
  }

  Future<List<ItemData>> loadlAllsounBooksDataAPI() async {
    // AllSingersData  , AllAnashed , lectcures , sounBooks
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
        'https://t3limsmart.com/wp-json/custom-api/v1/sounBooks/'));
    var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(son);
    for (var element in songs) {
      // table.add(ItemData.fromMap(element));
      table.add(ItemData.itemDataAdding(
        alboumName: element['alboumName'],
        // songerName: element['songerName'], not found in table
        name: element['name'],
        url: element['url'],
        imageUrl: element['imageUrl'],
        songMP3Url: element['songMP3Url'],
      ));
    }

    return table;
  }

  Future<List<ItemData>> loadlAllDataAPI() async {
    // AllSingersData  , AllAnashed , lectcures , sounBooks
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
        'https://t3limsmart.com/wp-json/custom-api/v1/AllData/'));
    var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(son);
    for (var element in songs) {
      // table.add(ItemData.fromMap(element));
      {try {
        table.add(ItemData.itemDataAdding(
         /*  savedIndex: int.parse(element['savedIndex']),
          Category: element['Category'],
          Class: element['Class'], */
          alboumName: element['alboumName'],
          songerName: element['songerName'],
          name: element['name'],
          url: element['url'],
          imageUrl: element['imageUrl'],
          songMP3Url: element['songMP3Url'],
        ));
      }  catch (e) {
       print('error===> $e');
      }
      }
    }
    return table;
  }

Future<void> fetchLargeJson() async {
  List<ItemData> table = [];
  Uri url=Uri.parse(
        'https://t3limsmart.com/wp-json/custom-api/v1/ArchiveOrg/');
  final response = await http.get(url).asStream().listen((data) {
   var songs = json.decode(data.body);
 // var son = Utf8Decoder(allowMalformed :false).convert(data.bodyBytes);
 /* List songl=son.split('\n');
    ;
      songl.forEach((l) {
      print(l);
      }); */
         /*  for (var element in songs) {
          try  {table.add(ItemData.itemDataAdding(
            /*   savedIndex: int.parse(element['savedIndex']),
              Category: element['Category'],
              Class: element['Class'], */
              alboumName: element['alboumName'],
              songerName: element['songerName'],
              name: element['name'],
              url: element['url'],
              imageUrl: element['imageUrl'],
              songMP3Url: element['songMP3Url'],
            ));}catch(e){print('error===> $e'); }} */
            print(songs);
    });
}

  Future<List<ItemData>> loadlArchiveOrgDataAPI() async {
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
        'https://t3limsmart.com/wp-json/custom-api/v1/ArchiveOrg/'));
   // print(" for site ===> ${response.body.length}");
    var son = Utf8Decoder().convert(response.bodyBytes);
    List songs = json.decode(son);
    print(" output ===> ${son.length}");
    for (var element in songs) {
    try  {table.add(ItemData.itemDataAdding(
      /*   savedIndex: int.parse(element['savedIndex']),
        Category: element['Category'],
        Class: element['Class'], */
        alboumName: element['alboumName'],
        songerName: element['songerName'],
        name: element['name'],
        url: element['url'],
        imageUrl: element['imageUrl'],
        songMP3Url: element['songMP3Url'],
      ));}catch(e){
         print('error===> $e');
      }
     // yield table;
    }
    return table;
  }

 Future<List<ItemData>> loadlMostLestenDataAPI() async {
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
        'https://t3limsmart.com/wp-json/custom-api/v1/most_lesten/'));
    //var son = Utf8Decoder().convert(response.bodyBytes);
    List songs = json.decode(response.body);
    print(" output ===> ${songs.length}");
    for (var element in songs) {
     { try {
        table.add(ItemData.itemDataAdding(
          savedIndex: int.parse(element['savedIndex']),
          Category: element['Category'],
          Class: element['Class'],
          alboumName: element['alboumName'],
          songerName: element['songerName'],
          name: element['name'],
          url: element['url'],
          imageUrl: element['imageUrl'],
          songMP3Url: element['songMP3Url'],
        ));
      }  catch (e) {
       print('error===> $e');
      }
     }
     // yield table;
    }
    return table;
  }

  Future<List<ItemData>> loadlAllSongiersDataAPI() async {
    // AllSingersData  , AllAnashed , lectcures , sounBooks
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
        'https://t3limsmart.com/wp-json/custom-api/v1/AllSingersData/'));
    var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(son);
    for (var element in songs) {
      // table.add(ItemData.fromMap(element));
      table.add(ItemData.itemDataAdding(
        alboumName: element['alboumName'],
        songerName: element['songerName'],
        name: element['name'],
        url: element['url'],
        imageUrl: element['imageUrl'],
        songMP3Url: element['songMP3Url'],
      ));
    }

    return table;
  }

  List<ItemData> getDataList(PagesID pageID, List<ItemData> input) {
    List<ItemData> out = [];
    // List<ItemData> input = [];
    Set<ItemData> outset = {};
    switch (pageID) {
      case PagesID.IslamicSonges:
        input = DataProvider.anasheed;
        break;
      case PagesID.Books:
        input = DataProvider.sounBooks;
        break;
      case PagesID.IslamicShortLeactures:
        input = DataProvider.lectcures;
        break;
      case PagesID.Singers:
        input = DataProvider.allSongersData;
        break;
      case PagesID.ArchiveOrg:
        input = DataProvider.archiveOrg;
        break;
      default:
    }

    if (pageID == PagesID.Singers || pageID == PagesID.ArchiveOrg) {
      Set<String> singers = {};
      input.forEach((element) {
        singers.add(element.songerName);
      });
      singers.forEach((s) {
        ItemData item = input.firstWhere((element) => element.songerName == s);
        item.name = item.songerName;
        out.add(item);
      });

      return out;
    } else {
      input.forEach((element) {
        ItemData item = ItemData();
        item.name = element.songerName;
        if (pageID == PagesID.Books) item.name = element.alboumName;
        item.imageUrl = element.imageUrl;
        outset.add(item);
      });

      out = List.from(outset);

      return out;
    }
  }

}
