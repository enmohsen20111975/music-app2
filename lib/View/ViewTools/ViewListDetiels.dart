// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/Decorations/containerDecorations.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/View/ViewTools/LineCard.dart';
import 'package:Khotab_Encyclopedia/View/newshape/SongerAlboumsView.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ViewListDetails extends GetView<PlayerController> {
  List<ItemData> itemData;
  PagesID pageID;
  ViewListDetails({required this.pageID, required this.itemData});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 82, 78, 78),
        body: ListView.builder(
            itemCount: itemData.length,
            itemBuilder: (_, index) {
              return ListTile(
                autofocus: true,
                focusColor: Color.fromARGB(255, 138, 128, 141),
                selected: controller.playIndex.value == index,
                selectedColor: Color.fromARGB(255, 68, 206, 199),
                selectedTileColor: Color.fromARGB(255, 54, 31, 101),
                shape: BeveledRectangleBorder(
                  side: BorderSide(
                      width: 2, color: Color.fromARGB(255, 149, 221, 14)),
                  borderRadius: BorderRadius.circular(20),
                ),
                title: AutoSizeText(
                  itemData[index].name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 191, 223, 11), fontSize: 22),
                ),
                leading: itemData[index].imageUrl.contains('https')
                    ? Image.network(
                        itemData[index].imageUrl.trim(),
                        // scale: 1,
                        width: 100,
                        height: 100,
                      )
                    : Image.asset('assets/MEDIA/U.jpg'),
                onLongPress: () {
                  onPressLongAction(index);
                },
                onTap: () async {
                  onPressAction(index);
                },
              );
            }));
  }

  onPressLongAction(int index) {
    switch (pageID) {
      case PagesID.Singers:
        break;
      case PagesID.Fav_singers:
        controller.dbHelper
            .delete(
                DataProvider.favouriteSingers[index].name, TablesId.fav_singers)
            .then((value) => Get.snackbar('Delete',
                'Delete Done for ${DataProvider.favouriteSingers[index].name}'));
        break;
      case PagesID.Fav_Songes:
        controller.dbHelper
            .delete(
                DataProvider.favouriteSonges[index].name, TablesId.fav_singers)
            .then((value) => Get.snackbar('Delete',
                'Delete Done for ${DataProvider.favouriteSonges[index].name}'));

        break;
      default:
    }
  }

  onPressAction(int index) async {
    switch (pageID) {
      case PagesID.Singers:
        DataProvider.alboumName = itemData[index].name;
        DataProvider.alboumUrl = itemData[index].url;
        DataProvider.subCategoryUrl = itemData[index].url;
        DataProvider.subCategoryName = itemData[index].name;
        DataProvider.singerName = itemData[index].name;
        Get.to(() => AllAlboumsForSelectedSonger(),
                transition: Transition.size)!
            .then((value) {
          if (kDebugMode == false) controller.adhelper.showInterstitialAd();
        });

        break;

      case PagesID.Fav_singers:
        DataProvider.subCategoryUrl = DataProvider.favouriteSingers[index].url;
        DataProvider.subCategoryName = 'المفضلين';
        DataProvider.singerName = DataProvider.favouriteSingers[index].name;
        Get.to(() => AllAlboumsForSelectedSonger(),
            transition: Transition.zoom);
        break;
      case PagesID.Fav_Songes:
        DataProvider.alboumName = itemData[index].name;
        DataProvider.alboumUrl = itemData[index].url;
        // DataProvider.alboum.clear();
        DataProvider.alboum = itemData;
        controller.alboum.value = itemData;
        controller.playIndex(index);
        DataProvider.subCategoryName = "المفضلة";

        controller.fromurl(true);
        Get.to(() => MusicList())!.then((value) {
          if (kDebugMode == false) controller.adhelper.showInterstitialAd();
        });

        break;
      case PagesID.IslamicSonges:
        DataProvider.subCategoryName = 'أناشيد';
        DataProvider.subCategoryImage = itemData[index].imageUrl;
        DataProvider.subCategoryUrl = itemData[index].url;

        DataProvider.alboum = List.from(DataProvider.anasheed
            .where((element) => element.songerName == itemData[index].name));

        /******************************** */
        controller.alboum.value = DataProvider.alboum;
        controller
            .playIndex(DataProvider.alboum.indexOf(DataProvider.alboum.first));
        controller.fromurl(true);
        Get.to(() => MusicList(), transition: Transition.circularReveal)!
            .then((value) {
          if (kDebugMode == false) controller.adhelper.showInterstitialAd();
        });

        break;
      case PagesID.Shabyat:
        DataProvider.alboumName = itemData[index].name;
        DataProvider.alboumUrl = itemData[index].url;

        DataProvider.subCategoryName = "شعبيات";
        controller.alboum.clear();
        controller.alboum.value = itemData;
        controller.playIndex.value = index;
        controller.fromurl(true);
        Get.to(() => MusicList(), transition: Transition.zoom)!.then((value) {
          if (kDebugMode == false) controller.adhelper.showInterstitialAd();
        });

        break;
      case PagesID.LastSonges:
        DataProvider.alboumName = itemData[index].name;
        DataProvider.alboumUrl = itemData[index].url;
        DataProvider.subCategoryName = "New";
        controller.alboum.clear();
        controller.alboum.value = itemData;
        controller.playIndex.value = index;
        controller.fromurl(true);
        Get.to(() => MusicList(), transition: Transition.fadeIn)!.then((value) {
          if (kDebugMode == false) controller.adhelper.showInterstitialAd();
        });

        break;
      case PagesID.Books:
        DataProvider.alboum.clear();
        DataProvider.fromUrl = false;
        DataProvider.subCategoryName = "كتب";
        print(itemData[index].songMP3Url);
        DataProvider.alboum = List.from(DataProvider.sounBooks
            .where((element) => element.alboumName == itemData[index].name));
        controller.alboum.value = DataProvider.alboum;
        // controller.alboum.value = DataProvider.alboum;
        controller
            .playIndex(DataProvider.alboum.indexOf(DataProvider.alboum.first));
        controller.fromurl(true);
        Get.to(MusicList());
        if (kDebugMode == false) controller.adhelper.showInterstitialAd();

        break;
      case PagesID.IslamicShortLeactures:
        DataProvider.subCategoryName = 'دروس';
        DataProvider.subCategoryImage = itemData[index].imageUrl;
        DataProvider.subCategoryUrl = itemData[index].url;
        if (kDebugMode == false) {
          controller.adhelper.showInterstitialAd();
        }

        DataProvider.alboum = List.from(DataProvider.lectcures
            .where((element) => element.songerName == itemData[index].name));
        controller.alboum.value = DataProvider.alboum;
        controller
            .playIndex(DataProvider.alboum.indexOf(DataProvider.alboum.first));
        controller.fromurl(true);
        Get.to(() => MusicList(), transition: Transition.circularReveal);
        if (kDebugMode == false) {
          controller.adhelper.showInterstitialAd();
        }

        break;
    }
  }
}
