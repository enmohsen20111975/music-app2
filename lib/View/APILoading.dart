import 'dart:async';
import 'dart:convert';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/View/NewHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class APILoading extends GetView<PlayerController> {
  List<ItemData> allData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            part(controller.allSongersDataAPI, 'allSongersDataAPI'),
            part(controller.shabyatAPI, 'shabyatAPI'),
            part(controller.lastsongesAPI, 'lastsongesAPI'),
            part(controller.anasheedAPI, 'anasheedAPI'),
            part(controller.lecturesAPI, 'lecturesAPI'),
            part(controller.sounBooksAPI, 'sounBooksAPI'),
            TextButton(
                onPressed: () {
                  Timer(Duration(milliseconds: 10), () {
                    Get.offAll(NewHomeScreen(),
                        transition: Transition.leftToRightWithFade);
                  });
                },
                child: Text('Done'))
          ],
        ),
      ),
    );
  }

  Future<List<ItemData>> loadlAllsounBooksDataAPI() async {
    // AllSingersData  , AllAnashed , lectcures , sounBooks
    List<ItemData> table = [];
    http.Response response = await http.get(Uri.parse(
        'https://t3limsmart.com/songes/wp-json/custom-api/v1/sounBooks/'));
    var son = json.decode(Utf8Decoder().convert(response.bodyBytes)).toString();
    List songs = json.decode(son);
    for (var element in songs) {
      // table.add(ItemData.fromMap(element));
      table.add(ItemData.itemDataAdding(
        alboumName: element['alboumName'],
        //  songerName: element['songerName'],
        name: element['name'],
        url: element['url'],
        imageUrl: element['imageUrl'],
        songMP3Url: element['songMP3Url'],
      ));
    }

    return table;
  }

  Widget part(Future<List<ItemData>> item, String tablename) {
    return FutureBuilder(
        future: item,
        builder: (_, snap) {
          if (snap.hasData) {
            switch (tablename) {
              case 'allSongersDataAPI':
                controller.allSongersData.value = snap.data!;
                DataProvider.allSongersData = snap.data!;
                break;
              case 'shabyatAPI':
                controller.shabyatSonges.value = snap.data!;
                DataProvider.shabyatSonges = snap.data!;
                break;
              case 'lastsongesAPI':
                controller.lastsonges.value = snap.data!;
                DataProvider.lastsonges = snap.data!;
                break;
              case 'anasheedAPI':
                controller.anasheed.value = snap.data!;
                DataProvider.anasheed = snap.data!;
                break;
              case 'lecturesAPI':
                controller.lectcures.value = snap.data!;
                DataProvider.lectcures = snap.data!;
                break;
              case 'sounBooksAPI':
                controller.sounBooks.value = snap.data!;
                DataProvider.sounBooks = snap.data!;
                break;

              default:
            }
            return Center(
              child: Text('Loaded data for $tablename = ${snap.data!.length}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget fbody() {
    return FutureBuilder(
        future: loadlAllsounBooksDataAPI(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            allData = snapshot.data!;
            allData.sort(
                (a, b) => a.songerName.length.compareTo(b.songerName.length));
            List<ItemData> table = allData;
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    title: Text(table[i].name),
                    leading: Text(table[i].songerName),
                    subtitle: Text(table[i].alboumName),
                    trailing: table[i].imageUrl.contains('http')
                        ? Image.network(table[i].imageUrl)
                        : Icon(Icons.music_video),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
