import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  // DbHelper.privateConstructor();
//  final DbHelper instance = DbHelper.privateConstructor();
  late Database? db;
  Future<Database> get database async {
    if (db != null) return database;
    // Instantiate db the first time it is accessed
    db = await intDB();
    return db!;
  }

  Future intDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "assets/DBf.db");
    final exist = await databaseExists(path);
    if (exist) {
      db = await openDatabase(path);
      print('data base alardy exist');
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {}
      // for copy then past for data base from assets to database directory
      ByteData data = await rootBundle.load(join("assets", "DBf.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      db = await openDatabase(path);
      print('data base copied and opened ');
    }
  }

  Future<List<ItemData>> getRanatiData()async{
  List<ItemData> temp = [];
    //List<Map<String, Object>> data = [];
 String sql = 'SELECT * FROM RanatiSite';
 var data = await db!.rawQuery(sql);
for (var map in data  ) {
try { temp.add(ItemData.itemDataAdding(
      Category: map['Category'].toString(),
      Class: map['Class'] .toString(),
      savedIndex: map['savedIndex'] as int ,
      alboumName: map['alboumName'] .toString()   ,
      songerName: map['songerName'].toString()  ,
      name: map['name'] as String,
      songUrl: map['songUrl'].toString()  ,
      songMP3Url: map['songMP3Url'] .toString() ,
      imageUrl: map['imageUrl'] .toString() ,
      url: map['url'] .toString() ,
  ));}catch(e){}
}
DataProvider.ranati=temp;
return temp;
 }

  Future<void> addDataToTable(ItemData data, TablesId tableID) async {
    String tableName = '';
    switch (tableID) {
      case TablesId.anasheed:
        tableName = 'anasheed';
        break;
      case TablesId.lectcures:
        tableName = 'lectcures';
        break;
      case TablesId.lastsonges:
        tableName = 'lastsonges';
        break;
      case TablesId.AllsounBooks:
        tableName = 'AllsounBooks';
        break;
      case TablesId.allSongers:
        tableName = 'allSongers';
        break;
      case TablesId.shabyat:
        tableName = 'shabyat';
        break;
      case TablesId.AllAnashed:
        tableName = 'AllAnashed';
        break;
      case TablesId.AllSingersData:
        tableName = 'AllSingersData';
        break;
      case TablesId.Alllectcures:
        tableName = 'Alllectcures';
        break;
      case TablesId.fav_singers:
        tableName = 'fav_singers';
        break;
      case TablesId.fav_songes:
        tableName = 'fav_songes';
        break;
    }
    try {
      await db!.insert('$tableName', {
        //  'savedIndex': DataProvider.savedIndex,
        // 'songerName': data.songerName,
        'songMP3Url': data.songMP3Url,
         'alboumName':data.alboumName.isEmpty?' ': data.alboumName,
        'imageUrl': data.imageUrl,
        'url': data.url,
        'name': data.name,
        'songUrl': data.songUrl,
      });
    } on Exception catch (e) {}
    DataProvider.savedIndex++;
  }

 Future<void> clearTable(TablesId tableID) async {
    String tableName = '';
    switch (tableID) {
      case TablesId.anasheed:
        tableName = 'anasheed';
        break;
      case TablesId.lectcures:
        tableName = 'lectcures';
        break;
      case TablesId.lastsonges:
        tableName = 'lastsonges';
        break;
      case TablesId.AllsounBooks:
        tableName = 'AllsounBooks';
        break;
      case TablesId.allSongers:
        tableName = 'allSongers';
        break;
      case TablesId.shabyat:
        tableName = 'shabyat';
        break;
      case TablesId.AllAnashed:
        tableName = 'AllAnashed';
        break;
      case TablesId.AllSingersData:
        tableName = 'AllSingersData';
        break;
      case TablesId.Alllectcures:
        tableName = 'Alllectcures';
        break;
      case TablesId.fav_singers:
        tableName = 'fav_singers';
        break;
      case TablesId.fav_songes:
        tableName = 'fav_songes';
        break;
    }
    try {
       String sql = 'DELETE * FROM $tableName ';

    } on Exception catch (e) {}
    DataProvider.savedIndex++;
  }
  Stream<List<ItemData>> loadAnasheedStorage() async* {
    DataProvider.anasheed.clear();
    String sql = 'SELECT * FROM anasheed ';
    var data = await db!.rawQuery(sql);
    for (var element in data) {
      element = checkForNull(element);
      DataProvider.anasheed.add(ItemData.fromMap(element));
      yield DataProvider.anasheed;
    }
  }

  Future<List<ItemData>> songesDataSearch(
      String txt, FieldNames fieldID) async {
    List<ItemData> temp = [];
    List<Map<String, Object?>> data = [];
    String sq = '';
    switch (fieldID) {
      case FieldNames.alboumName:
        sq = 'SELECT * FROM AllSingersData Where alboumName Like ?';
        data = await db!.rawQuery(sq, ['%$txt%']);
        break;
      case FieldNames.songerName:
        sq = 'SELECT * FROM AllSingersData Where songerName Like ?';
        data = await db!.rawQuery(sq, ['%$txt%']);
        break;
      case FieldNames.name:
        sq = 'SELECT * FROM AllSingersData Where name Like ?';
        data = await db!.rawQuery(sq, ['%$txt%']);
        break;
    }

    /********************** */
    try {
      List.generate(data.length, (int i) {
        //data[i] = checkForNull(data[i]);
        ItemData item = ItemData.itemDataAdding(
          imageUrl: data[i]['imageUrl'].toString(),
          name: data[i]['name'].toString(),
          songMP3Url: data[i]['songMP3Url'].toString(),
          songUrl: data[i]['songUrl'].toString(),
          //  savedIndex: data[i]['songMP3Url'].toString(),
          alboumName: data[i]['alboumName'].toString(),
          songerName: data[i]['songerName'].toString(),
          url: data[i]['url'].toString(),
        );
        temp.add(item);
      });
    } catch (e) {
      print('Database error =$e');
    }
    temp.toSet().toList();
    temp.sort((a, b) => a.alboumName.length.compareTo(b.alboumName.length));
    return temp;
  }

  Future<List<ItemData>> futureLoadStorage(
      TablesId tableID, String name) async {
    List<ItemData> temp = [];
    List<Map<String, Object?>> data = [];
    String sq = '';
    switch (tableID) {
      case TablesId.anasheed:
        sq = 'SELECT * FROM anasheed ';
        data = await db!.rawQuery(sq);
        break;
      case TablesId.lectcures:
        sq = 'SELECT * FROM lectcures';
        data = await db!.rawQuery(sq);
        break;
      case TablesId.lastsonges:
        sq = 'SELECT * FROM lastsonges';
        data = await db!.rawQuery(sq);
        break;
      case TablesId.AllsounBooks:
        sq = 'SELECT * FROM AllsounBooks';
        data = await db!.rawQuery(sq);
        break;
      case TablesId.allSongers:
        sq = 'SELECT * FROM allSongers';
        data = await db!.rawQuery(sq);
        break;
      case TablesId.shabyat:
        sq = 'SELECT * FROM AllShabyat';
        data = await db!.rawQuery(sq);
        break;
      case TablesId.AllAnashed:
        sq = 'SELECT * FROM AllAnashed Where songerName Like ?';
        data = await db!.rawQuery(sq, ['%$name%']);
        break;
      case TablesId.AllSingersData:
        sq = 'SELECT * FROM AllSingersData Where songerName Like ? ';
        data = await db!.rawQuery(sq, ['%$name%']);
        break;
      case TablesId.Alllectcures:
        sq = 'SELECT * FROM Alllectcures Where songerName Like ?';
        data = await db!.rawQuery(sq, ['%$name%']);
        break;
      case TablesId.fav_singers:
        sq = 'SELECT * FROM fav_singers';
        data = await db!.rawQuery(sq);
        break;
      case TablesId.fav_songes:
        sq = 'SELECT * FROM fav_songes';
        data = await db!.rawQuery(sq);
        break;
    }

    /********************** */
    {
      try {
        List.generate(data.length, (int i) {
          //data[i] = checkForNull(data[i]);
          ItemData item = ItemData.itemDataAdding(
            imageUrl: data[i]['imageUrl'].toString(),
            name: data[i]['name'].toString(),
            songMP3Url: data[i]['songMP3Url'].toString(),
            songUrl: data[i]['songUrl'].toString(),
            //  savedIndex: data[i]['songMP3Url'].toString(),
            alboumName: data[i]['alboumName'].toString(),
            songerName: data[i]['songerName'].toString(),
            url: data[i]['url'].toString(),
          );
          temp.add(item);
        });
      } catch (e) {
        print('Database error =$e');
      }
      temp.toSet().toList();
    }
    ;
    return temp;
  }

  Future<List<ItemData>> getSongerBycontry(String songerName) async {
    List<ItemData> output = [];
    String sql = 'SELECT * FROM AllSingersData Where songerName Like ?';
    var data = await db!.rawQuery(sql, ['$songerName']);

    for (var element in data) {
      output.add(ItemData.fromMap(element));
      // yield DataProvider.allSongers;
    }
    return output;
  }

  Future<String> getImageBySongName(String songName) async {
    String output = '';
    String sql = 'SELECT * FROM AllSingersData Where name Like ?';
    var data = await db!.rawQuery(sql, ['$songName']);
    if (data.isNotEmpty) {
      if (data.length > 1) {
        output = data[0]['imageUrl'].toString();
      } else {
        output = data[0]['imageUrl'].toString();
      }
    }
    print(data[0]['imageUrl']);
    return output;
  }

  Stream<List<ItemData>> loadAllSingersStorage() async* {
    DataProvider.allSongers.clear();
    String sql = 'SELECT * FROM allSongers';
    var data = await db!.rawQuery(sql);
    for (var element in data) {
      element = checkForNull(element);
      DataProvider.allSongers.add(ItemData.fromMap(element));
      yield DataProvider.allSongers;
    }
  }

  Stream<List<ItemData>> loadlectcuresStorage() async* {
    DataProvider.lectcures.clear();

    String sql = 'SELECT * FROM lectcures ';
    var data = await db!.rawQuery(sql);
    for (var element in data) {
      element = checkForNull(element);
      DataProvider.lectcures.add(ItemData.fromMap(element));
      yield DataProvider.lectcures;
    }
  }

  Stream<List<ItemData>> loadlastsongesStorage() async* {
    DataProvider.lastsonges.clear();
    String sql = 'SELECT * FROM lastsonges';
    var data = await db!.rawQuery(sql);
    for (var element in data) {
      element = checkForNull(element);
      DataProvider.lastsonges.add(ItemData.fromMap(element));
      yield DataProvider.lastsonges;
    }
  }

  Stream<List<ItemData>> loadSoundBooksStorage() async* {
    DataProvider.sounBooks.clear();
    String sql = 'SELECT * FROM AllsounBooks ';
    var data = await db!.rawQuery(sql);
    for (var element in data) {
      element = checkForNull(element);
      DataProvider.sounBooks.add(ItemData.fromMap(element));
      yield DataProvider.sounBooks;
    }
  }

  Stream<List<ItemData>> shabyat() async* {
    DataProvider.shabyatSonges.clear();
    String songName = 'مهرجان';
    String sql =
        'SELECT * FROM AllSingersData Where name LIKE "%' + songName + '%"';
    var data = await db!.rawQuery(sql);
    for (var element in data) {
      element = checkForNull(element);
      DataProvider.shabyatSonges.add(ItemData.fromMap(element));
      yield DataProvider.shabyatSonges;
    }
  }
/************************************ */

  Future<List<ItemData>> searchBySingerName(String singerName) async {
    List<ItemData> songes = [];
    String sql = 'SELECT * FROM AllSingersData Where songerName=$singerName';
    var data = await db!.rawQuery(sql);
    List.generate(data.length, (int i) {
      data[i] = checkForNull(data[i]);
      songes.add(ItemData.fromMap(data[i]));
    });

    return songes;
  }

  Future<List<ItemData>> searchBySongName(String songName) async {
    List<ItemData> songes = [];
    String sql = 'SELECT * FROM AllSingersData Where  name=$songName';
    var data = await db!.rawQuery(sql);
    List.generate(data.length, (int i) {
      data[i] = checkForNull(data[i]);
      songes.add(ItemData.fromMap(data[i]));
    });

    return songes;
  }

//////////***********************************/////////////////////////
  Future<void> delete(String name, TablesId tableID) async {
    String sql = '';
    switch (tableID) {
      case TablesId.fav_singers:
        sql = 'DELETE FROM fav_singers WHERE name Like ?';
        break;
      case TablesId.fav_songes:
        sql = 'DELETE FROM fav_songes WHERE Like ?';
        break;
      default:
    }
    // await db!.delete('notes', where: 'index=?', whereArgs: [index]);

    await db!.rawDelete(sql, ['$name']);
  }

/************************************* */
  Map<String, Object?> checkForNull(Map<String, Object?> data) {
    if (data['imageUrl'].toString().isEmpty) data['imageUrl'] = 'No image';

    return data;
  }
}
