import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/MP3Player/playerScreen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataBase/DataBaseHelper.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/Scraping/ScrappingMP3Songes_Site.dart';
import 'package:Khotab_Encyclopedia/View/newshape/SongerAlboumsView.dart';
import 'package:get/get.dart';

class IslamicSongesListView extends GetView<PlayerController> {
  BuildContext? context;
  List<ItemData> islamicSonges = DataProvider.anasheed;

/*  */

  Widget dataList(context) {
    List<Widget> buttons = List.generate(islamicSonges.length, (index) {
      return TextButton(
        onPressed: () {
          DataProvider.subCategoryName = 'أناشيد';
          DataProvider.subCategoryImage = islamicSonges[index].imageUrl;
          DataProvider.subCategoryUrl = islamicSonges[index].url;
          DataProvider.alboum = islamicSonges;

          DataProvider.alboum = List.from(controller.anasheed.value
              .where((element) => element.name == islamicSonges[index].name));

          /******************************** */
          controller.alboum.value = DataProvider.alboum;
          controller.playIndex(
              DataProvider.alboum.indexOf(DataProvider.alboum.first));
          controller.fromurl(true);
          Get.to(MusicList());

          /* controller.dbHelper
              .futureLoadStorage(TablesId.AllAnashed, islamicSonges[index].name)
              .then((value) {
            DataProvider.alboum = value;
            /******************************** */
            controller.alboum.value = DataProvider.alboum;
            controller.playIndex(
                DataProvider.alboum.indexOf(DataProvider.alboum.first));
            controller.fromurl(true);
            Get.to(MusicList());
            //Navigator.pushNamed(context, PlayerControl.route);;
          }); */
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              radius: 50,
              foregroundImage: NetworkImage(
                islamicSonges[index].imageUrl,
              ),
            ),
            Text(islamicSonges[index].name,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.yellow)),
          ],
        ),
      );
    });
    return Container(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.spaceBetween,
          spacing: 5,
          children: buttons,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    islamicSonges = DataProvider.anasheed;
    return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(47, 6, 99, 91),
          border: Border.all(
            width: 1,
            color: Color.fromARGB(255, 148, 180, 7),
          ),
          borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
        ),
        height: 250,
        child: Column(children: [
          Container(
              child: Center(
            child: Text(
              'الأناشيد الإسلامية  ',
              style: TextStyle(color: Colors.white),
            ),
          )),
          dataList(context),
          /*  DataProvider.anasheed.isEmpty
              ? streamData(ansheedstream)
              : dataList(context), */
        ]));
  }
}
