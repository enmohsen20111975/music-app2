import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/MP3Player/playerScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:Khotab_Encyclopedia/DataBase/DataBaseHelper.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/IsalmicScrapping.dart';

import 'package:Khotab_Encyclopedia/googleADs/adhelper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class IslamicHome extends GetView<PlayerController> {
  static const route = "IslamicHome";

  String categoryUrl = '';

  List<ItemData> lectcures = DataProvider.lectcures;

  Widget dataList(context) {
    DataProvider.alboum.clear();
    List<Widget> buttons = List.generate(lectcures.length, (index) {
      return TextButton(
        onPressed: () async {
          DataProvider.subCategoryName = 'دروس';
          DataProvider.subCategoryImage = lectcures[index].imageUrl;
          DataProvider.subCategoryUrl = lectcures[index].url;
          if (kDebugMode == false) {
            controller.adhelper.showInterstitialAd();
          }
          await controller.dbHelper
              .futureLoadStorage(TablesId.Alllectcures, lectcures[index].name)
              .then((value) {
            DataProvider.alboum = value;

            controller.alboum.value = DataProvider.alboum;
            controller.playIndex(
                DataProvider.alboum.indexOf(DataProvider.alboum.first));
            controller.fromurl(true);
            Get.to(() => MusicList(), transition: Transition.circularReveal);
            controller.adhelper.showInterstitialAd();
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              radius: 50,
              foregroundImage: NetworkImage(
                lectcures[index].imageUrl,
              ),
            ),
            Text(
              lectcures[index].name,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.yellow),
            ),
          ],
        ),
      );
    });
    return Container(
        height: 150,
        padding: EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            direction: Axis.vertical,
            spacing: 5,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.spaceAround,
            children: buttons,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    lectcures = DataProvider.lectcures;
    DataProvider.alboum.clear();
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(25, 144, 13, 164),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 122, 187, 233),
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
      ),
      height: 200,
      child: Column(
        children: [
          Container(
              child: Center(
            child: Text(
              ' دروس دينية',
              style: TextStyle(color: Colors.white),
            ),
          )),
          dataList(context),
          /*  DataProvider.lectcures.isEmpty
              ? stremData(shortIslamicLeactures)
              : dataList(context), */
        ],
      ),
    );
  }
}
