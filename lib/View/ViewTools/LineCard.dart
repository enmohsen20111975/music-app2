import 'package:Khotab_Encyclopedia/Decorations/containerDecorations.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/globalData.dart';
import 'package:Khotab_Encyclopedia/View/ViewTools/ViewListDetiels.dart';
import 'package:flutter/foundation.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/View/newshape/SongerAlboumsView.dart';

class LineCard extends GetView<PlayerController> {
  List<ItemData> itemData;
  PagesID pageID;
  String title;
  BoxDecoration outDecoration, cardDecoration;
  LineCard(this.pageID, this.itemData, this.title, this.outDecoration,
      this.cardDecoration, this.fav);
  bool fav;
  @override
  Widget build(BuildContext context) {
    return itemData.isNotEmpty
        ? Container(
            // decoration: outDecoration,
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                        () =>
                            ViewListDetails(itemData: itemData, pageID: pageID),
                        transition: Transition.downToUp);
                  },
                  child: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      fav
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 28, 31, 207),
                            ),
                      Text(
                        title,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  )),
                ),
                listbody(),
              ],
            ),
          )
        : Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Card(
                  child: Text(
                    'Comming Soon',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              ],
            ),
          );
  }

  Widget listbody() {
    List<int> imagelocation = [];
    // to adjust image for Archive
    if (pageID == PagesID.ArchiveOrg) {}
    return Container(
      decoration: MyDecorations.greenCard,
      height: 180,
      child: ListView.builder(
          //padding: EdgeInsets.only(left: 50),
          scrollDirection: Axis.horizontal,
          itemCount: itemData.length,
          itemBuilder: ((context, index) {
            Map<String, dynamic> image = {};
            if (pageID == PagesID.ArchiveOrg) {
              try {
                image = GlobalData.imagelocation.firstWhere(
                  (element) =>
                      itemData[index].songerName.contains(element['name']),
                );
              } catch (e) {}
            }

            return Row(
              children: [
                Container(
                  width: 20,
                ),
                InkWell(
                  onLongPress: () {
                    onPressLongAction(index);
                  },
                  onTap: () async {
                    onPressAction(index);
                  },
                  child: itemData[index].name.isNotEmpty
                      ? Container(
                          height: 180,
                          //   decoration: cardDecoration,
                          child: Column(children: [
                            Expanded(
                                flex: 4,
                                child: itemData[index]
                                        .imageUrl
                                        .contains('https')
                                    ? SizedBox(
                                        width: 80,
                                        height: 100,
                                        child: Image.network(
                                          itemData[index].imageUrl.trim(),
                                          //   scale: 1,
                                        ),
                                      )
                                    : pageID == PagesID.ArchiveOrg
                                        ? SizedBox(
                                            width: 80,
                                            height: 100,
                                            child: Image.asset(
                                                'assets/images/${image['image']}.jpg'))
                                        : SizedBox(
                                            width: 80,
                                            height: 100,
                                            child: Image.asset(
                                                'assets/MEDIA/U.jpg'))),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: 80,
                                  child: AutoSizeText(
                                    itemData[index].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 191, 223, 11),
                                        fontSize: 22),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        )
                      : Container(),
                ),
              ],
            );
          })),
    );
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
        DataProvider.singerName = itemData[index].songerName;
        DataProvider.pageID = PagesID.Singers;
        Get.to(() => AllAlboumsForSelectedSonger(),
                transition: Transition.size)!
            .then((value) {
          if (kDebugMode == false) controller.adhelper.showInterstitialAd();
        });
        break;
      case PagesID.ArchiveOrg:
        DataProvider.alboumName = itemData[index].name;
        DataProvider.alboumUrl = itemData[index].url;
        DataProvider.subCategoryUrl = itemData[index].url;
        DataProvider.subCategoryName = itemData[index].name;
        DataProvider.singerName = itemData[index].songerName;
        DataProvider.pageID = PagesID.ArchiveOrg;
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
        controller.setItemDataToGetxBox(DataProvider.alboum, 'alboum');
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
        controller.setItemDataToGetxBox(DataProvider.alboum, 'alboum');
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
        /*  DataProvider.alboum.clear(); */
        /*  DataProvider.alboum.add(itemData[index]); */
        DataProvider.subCategoryName = "شعبيات";
        controller.alboum.clear();

        DataProvider.alboum = itemData;
        controller.setItemDataToGetxBox(DataProvider.alboum, 'alboum');
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
        DataProvider.alboum = itemData;
        controller.setItemDataToGetxBox(DataProvider.alboum, 'alboum');
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

        controller.setItemDataToGetxBox(DataProvider.alboum, 'alboum');
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

        controller.setItemDataToGetxBox(DataProvider.alboum, 'alboum');
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
