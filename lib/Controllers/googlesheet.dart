import 'dart:convert';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:http/http.dart' as http;

class GoogleSheetsAPI {
  var name=[
  'AllAnashed',
  'AllData',
  'Alllectcures',
  'AllShabyat',
  'AllSingersData',
  'allSongers',
  'AllsounBooks',
  'ArchiveOrg',
  'lastsonges',];
  String sheetsURL='https://script.google.com/macros/s/AKfycbz7C538MtUoTerQ8ANeMg1VDKz6_u2PzrzzsPbTNnKW9lghJS6jNExVnj0zfGxL6fKJ/exec';
  
  List<String> urlList=[
'https://script.googleusercontent.com/macros/echo?user_content_key=VspXsOFWN11geaUb-ndJtTQLtfCptbZyc59lsdU8xTitvZElvGYpi5p5b0l7MUhZEgry79qTaXe-EJ222m30s4nN9rQ7UhDYm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnPMvX-wP93K2pHt32NmnnFp_nMQm_7KMjXmf4geYbgaDIknHKLNU1ISQrDe263YZ1Lsngxad6OQ5jsyAoxKTI0JXi4GMuZJ2EmgZCI4g07nZ&lib=MIjFcgJYsq4GXEVIDOvPeFScLaNWq7SCm',
'https://script.googleusercontent.com/macros/echo?user_content_key=2b3qn9jL7c_v1Fu7CsimfnDOxlQG5lUUzHx1G9I-gKyd8ZecYkBoJhpikaXkgaOEC-wk_JQNrty-EJ222m30synoq3OdgYhAm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnPMvX-wP93K2pHt32NmnnFp_nMQm_7KMjXmf4geYbgaDIknHKLNU1ISQrDe263YZ1Lsngxad6OQ5jsyAoxKTI0JXi4GMuZJ2EqqfosrZRzep&lib=MIjFcgJYsq4GXEVIDOvPeFScLaNWq7SCm',
'https://script.googleusercontent.com/macros/echo?user_content_key=9iPU0YxlJrBxBhLGnHO5YcDZajmoHmtWAR_BsX0p1ugGNEiKTptR7LTkH_6hm8rjrZ_w3ITOtx-khroyYbahHetqStAQzXXCm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnPMvX-wP93K2pHt32NmnnFp_nMQm_7KMjXmf4geYbgaDIknHKLNU1ISQrDe263YZ1Lsngxad6OQ5jsyAoxKTI0JXi4GMuZJ2Eop3xsl-jZcA&lib=MIjFcgJYsq4GXEVIDOvPeFScLaNWq7SCm',
'https://script.googleusercontent.com/macros/echo?user_content_key=ydlEws89QwA8sto6vHJez-NvfikRpXPTpCdLw4stoN7nAExI6T3OxCueUy-NIe0l0U7kNlR4-kvOdUk6Ww53XYeuKYfLnSjWm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnPMvX-wP93K2pHt32NmnnFp_nMQm_7KMjXmf4geYbgaDIknHKLNU1ISQrDe263YZ1Lsngxad6OQ5jsyAoxKTI0JXi4GMuZJ2Eob87nio7Vpe&lib=MIjFcgJYsq4GXEVIDOvPeFScLaNWq7SCm'
'https://script.googleusercontent.com/macros/echo?user_content_key=ss1M4dUs25H9XnaP2oYH4_vP_htVfZTN8Jh6DLq2qJWV9f6lY2CbGj2XO5KZ1wy2nHWkpwpTHHXrM-HQ_5EWdnXrdDzbBvECm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnPMvX-wP93K2pHt32NmnnFp_nMQm_7KMjXmf4geYbgaDIknHKLNU1ISQrDe263YZ1Lsngxad6OQ5jsyAoxKTI0JXi4GMuZJ2EqGQ9cwYv3P2&lib=MIjFcgJYsq4GXEVIDOvPeFScLaNWq7SCm'
  
  
  
  ];
  
  List<ItemData> allData = [];
  Future<List<ItemData>> loadlastsongesAPI() async {
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(sheetsURL+'?table=8'));
  //  var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(Utf8Decoder().convert(response.bodyBytes));
    print('data out from ${name[8]} ${songs.length}');
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
         sheetsURL+'?table=3'));
    //  var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(Utf8Decoder().convert(response.bodyBytes));  print('data out from ${name[3]} ${songs.length}');
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
         sheetsURL+'?table=0'));
    //  var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(Utf8Decoder().convert(response.bodyBytes));  print('data out from ${name[0]} ${songs.length}');
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
         sheetsURL+'?table=2'));
    //  var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(Utf8Decoder().convert(response.bodyBytes)); print('data out from ${name[2]} ${songs.length}');
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
         sheetsURL+'?table=6'));
    //  var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(Utf8Decoder().convert(response.bodyBytes)); print('data out from ${name[6]} ${songs.length}');
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
         sheetsURL+'?table=1'));
    //  var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(Utf8Decoder().convert(response.bodyBytes)); print('data out from ${name[1]} ${songs.length}');
    for (var element in songs) {
      // table.add(ItemData.fromMap(element));
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
    }
    return table;
  }

  Future<List<ItemData>> loadlArchiveOrgDataAPI() async {
    // AllSingersData  , AllAnashed , lectcures , sounBooks
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
         sheetsURL+'?table=7'));
    //  var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(Utf8Decoder().convert(response.bodyBytes));  print('data out from ${name[7]} ${songs.length}');
    for (var element in songs) {
      // table.add(ItemData.fromMap(element));
      table.add(ItemData.itemDataAdding(
       // savedIndex: int.parse(element['savedIndex']),
      //  Category: element['Category'],
      //  Class: element['Class'],
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

  Future<List<ItemData>> loadlAllSongiersDataAPI() async {
    // AllSingersData  , AllAnashed , lectcures , sounBooks
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
         sheetsURL+'?table=4'));
    //  var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(Utf8Decoder().convert(response.bodyBytes)); print('data out from ${name[4]} ${songs.length}');
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
