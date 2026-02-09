import 'dart:async';

import 'package:Khotab_Encyclopedia/Decorations/containerDecorations.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/View/NewHomeScreen.dart';

import 'package:flutter/material.dart';

class UpdateDataScreen extends GetView<PlayerController> {
  static const route = 'Start Loading Screen';
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 0, 0, 0),
        //  decoration: MyDecorations.gradiant2,
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: Image.asset('assets/MEDIA/loading3.gif'),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //  scrollDirection: Axis.horizontal,
                    children: [
                      part(TablesId.allSongers, 'allSongersDataAPI'),
                      part(TablesId.shabyat, 'shabyatAPI'),
                      part(TablesId.lastsonges, 'lastsongesAPI'),
                      part(TablesId.anasheed, 'anasheedAPI'),
                      part(TablesId.lectcures, 'lecturesAPI'),
                      part(TablesId.AllsounBooks, 'sounBooksAPI'),
                      part(TablesId.Alllectcures, 'archiveOrgAPI'),
                    ],
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Timer(Duration(milliseconds: 10), () {
                      Get.offAll(NewHomeScreen(),
                          transition: Transition.leftToRightWithFade);
                    });
                  },
                  child: Text('Cancel'))
            ],
          ),
        ),
      ),
    );
  }

  Widget part(TablesId tableID, String tablename) {
    controller.dbHelper.futureLoadStorage(TablesId.fav_songes, '');
    controller.dbHelper.futureLoadStorage(TablesId.fav_singers, '');
  
    //  Future<List<ItemData>> item=itemData;
      return FutureBuilder(
          future: controller.getData(tableID),
          builder: (_, snap) {
            if (snap.hasData) {
              /*  print('Count==> $count'); */
              if (count == 6) {
                Timer(Duration(milliseconds: 10), () {
                  Get.offAll(NewHomeScreen(),
                      transition: Transition.leftToRightWithFade);
                });
              }
              switch (tablename) {
                case 'allSongersDataAPI':
                  controller.allSongersData.clear();
                  DataProvider.allSongersData = snap.data!;
                  controller.allSongersData.value =
                      controller.myAPI.getDataList(PagesID.Singers, snap.data!);
                  controller.setItemDataToGetxBox(snap.data!, 'allSongersData');
                  count++;
                  break;
                case 'shabyatAPI':
                  DataProvider.shabyatSonges = snap.data!;
                  controller.shabyatSonges.value = snap.data!;
                  controller.setItemDataToGetxBox(snap.data!, 'shabyatSonges');
                  count++;
                  break;
                case 'lastsongesAPI':
                  DataProvider.lastsonges = snap.data!;
                  controller.lastsonges.value = snap.data!;
                  controller.setItemDataToGetxBox(snap.data!, 'lastsonges');
                  count++;
                  break;
                case 'anasheedAPI':
                  DataProvider.anasheed = snap.data!;
                  controller.anasheed.clear();
                  controller.anasheed.value = controller.myAPI
                      .getDataList(PagesID.IslamicSonges, snap.data!);
                  controller.setItemDataToGetxBox(snap.data!, 'anasheed');
                  count++;
                  break;
                case 'lecturesAPI':
                  DataProvider.lectcures = snap.data!;
                  controller.lectcures.clear();
                  controller.lectcures.value = controller.myAPI
                      .getDataList(PagesID.IslamicShortLeactures, snap.data!);
                  controller.setItemDataToGetxBox(snap.data!, 'lectcures');
                  count++;
                  break;
                case 'sounBooksAPI':
                  DataProvider.sounBooks = snap.data!;
                  controller.sounBooks.value =
                      controller.myAPI.getDataList(PagesID.Books, snap.data!);
                  controller.setItemDataToGetxBox(snap.data!, 'sounBooks');
                  count++;
                  break;
                case 'archiveOrgAPI':
                DataProvider.archiveOrg = snap.data!;
                controller.archiveOrg.value = controller.myAPI
                    .getDataList(PagesID.ArchiveOrg, snap.data!);
                controller.setItemDataToGetxBox(snap.data!, 'archiveOrg');
                count++;
                break;
                default:
              }
              return Center(
                child: FadeInUpBig(
                  duration: const Duration(milliseconds: 1800),
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                      //   decoration: MyDecorations.greenCard,
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done_rounded, color: Colors.greenAccent),
                      Text('${snap.data!.length}',
                          style: TextStyle(color: Colors.yellowAccent))
                    ],
                  )
                      /*  */
                      ),
                ),
              );
            } else {
              return Center(
                child: FadeInUpBig(
                    duration: const Duration(milliseconds: 1500),
                    delay: const Duration(milliseconds: 500),
                    child: CircularProgressIndicator(backgroundColor: Colors.yellow,color: Colors.red,)),
              );
            }
          });
    
  }
}
